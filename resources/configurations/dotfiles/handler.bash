function handleDotfiles {
  if [ "$gatekeeperStatus" != "available" ]
  then
    local dotfilesDirectory="$(
      cd "$(
        dirname "$(
          readlink --canonicalize "${BASH_SOURCE[0]:-$0}"
        )"
      )" && pwd
    )"
    local sourcesDirectory="$(
      cd "$dotfilesDirectory/../../../sources" && pwd
    )"
    source "$sourcesDirectory/units/bash/gatekeeper.bash"
  fi
  source "$blocksDirectory/baseSystem/setStrictExecution.bash"
  source "$blocksDirectory/baseSystem/checkCommandAvailability.bash"
  local handlingMethod="$1"
  local dotfilesIdentifier="$2"
  local dotfilesDestination="$HOME"
  local dotfilesDirectoryDepth=$(
    setStrictExecution "on" &>/dev/null
    source "$blocksDirectory/baseSystem/setAliases.bash"
    setAliases "on" &>/dev/null
    alias awk=gawk
    echo "$dotfilesDirectory" | awk \
    --field-separator "/" '{
      print NF
    }'
    setAliases "off" &>/dev/null
    setStrictExecution "off" &>/dev/null
  )
  function getPrerequisites {
    local currentUser="$(
      whoami
    )"
    if [ "$currentUser" == "root" ]
    then
      echo "$failureSymbol Can not handle dotfiles as user : $currentUser"
      return 1
    fi
    local stowStatus="$(
      checkCommandAvailability "stow"
    )"
    if [ "$stowStatus" != 0 ]
    then
      source "$actionsDirectory/baseSystem/synchronizeSystemRepositories.bash"
      source "$actionsDirectory/baseSystem/installPackage.bash"
      synchronizeSystemRepositories
      installPackage "stow"
    fi
  }
  function getDotfilesSources {
    local dotfilesIdentifier="$1"
    local availableDotfilesDirectories=($(
      find "$dotfilesDirectory" -maxdepth 1 -type d -not -path "$dotfilesDirectory" -nowarn
    ))
    local availableDotfilesEntries=($(
      printf "%s\n" "${availableDotfilesDirectories[@]##$dotfilesDirectory/}" | sort --unique
    ))
    local supportedDotfilesDirectories
    for directory in "${availableDotfilesEntries[@]}"
    do
      local status=$(
        checkCommandAvailability "$directory"
      )
      if [ "$status" == 0 ]
      then
        supportedDotfilesDirectories+=(
          "$directory"
        )
      fi
    done
    if [ "$dotfilesIdentifier" == "all" ] || [ "$dotfilesIdentifier" == "" ]
    then
      echo "${availableDotfilesEntries[@]}"
    elif [ "$dotfilesIdentifier" == "efficient" ]
    then
      echo "${supportedDotfilesDirectories[@]}"
    else
      printf "%s\n" "${availableDotfilesEntries[@]}" | grep "$dotfilesIdentifier"
    fi
  }
  function getDotfilesTargets {
    local dotfilesIdentifier="$1"
    local dotfilesTargets=($(
      local dotfilesSourcesPaths
      local dotfilesSourcesPathsToUtilize
      local dotfilesTargetsPaths
      # `$HOME/.config/directory`
      dotfilesSourcesPaths+=($(
        find "$dotfilesDirectory" -mindepth 3 -maxdepth 3 -type d -nowarn
      ))
      # `$HOME/.config/files` & `$HOME/.directory/files`
      dotfilesSourcesPaths+=($(
        find "$dotfilesDirectory" -mindepth 3 -maxdepth 3 -type f -nowarn
      ))
      # `$HOME/files`
      dotfilesSourcesPaths+=($(
        find "$dotfilesDirectory" -mindepth 2 -maxdepth 2 -type f -nowarn
      ))
      # `$HOME/directory`
      # dotfilesSourcesPaths+=($(
      #   find "$dotfilesDirectory" -mindepth 2 -maxdepth 2 -type d -not -path "*/.config" -nowarn
      # ))
      if [ "$dotfilesIdentifier" == "all" ] || [ "$dotfilesIdentifier" == "" ]
      then
        dotfilesSourcesPathsToUtilize=(
          "${dotfilesSourcesPaths[@]}"
        )
      else
        dotfilesSourcesPathsToUtilize=($(
          printf "%s\n" "${dotfilesSourcesPaths[@]}" | grep "$dotfilesIdentifier"
        ))
      fi
      for dotfile in "${dotfilesSourcesPathsToUtilize[@]}"
      do
        dotfilesTargetsPaths+=("$(
          echo "$dotfilesDestination/${dotfile#$dotfilesDirectory/*/}"
        )")
      done
      echo "${dotfilesTargetsPaths[@]}"
    ))
    echo "${dotfilesTargets[@]}"
  }
  function getDotfilesStatus {
    # [TODO] implement dotfile status
    local dotfilesIdentifier="$1"
    return 0
  }
  function handleDotfilesTargets {
    local handlingMethod="$1"
    local dotfilesIdentifier="$2"
    local dotfilesTargets=($(
      getDotfilesTargets "$dotfilesIdentifier"
    ))
    for target in "${dotfilesTargets[@]}"
    do
      local status
      if [ "$handlingMethod" == "backup" ]
      then
        if [ -e "$target" ]
        then
          echo "$warningSymbol Dotfiles already exist : $target"
          echo "$processingSymbol Making backup : $target -> $target.stowed"
          status=$(
            mv "$target" "$target.stowed" &>/dev/null
            echo "$?"
          )
          if [ "$status" != 0 ]
          then
            echo "$failureSymbol Failed to make backup : $target"
          else
            echo "$successSymbol Successfully made backup : $target -> $target.stowed"
          fi
        fi
      elif [ "$handlingMethod" == "restore" ]
      then
        if [ -e "$target.stowed" ]
        then
          echo "$warningSymbol Backup found : $target.stowed"
          echo "$processingSymbol Restoring backup : $target.stowed -> $target"
          status=$(
            mv "$target.stowed" "$target" &>/dev/null
            echo "$?"
          )
          if [ "$status" != 0 ]
          then
            echo "$failureSymbol Failed to restore backup : $target.stowed"
          else
            echo "$successSymbol Successfully restored backup : $target.stowed -> $target"
          fi
        fi
      else
        echo "$failureSymbol Failed to determine handling method"
        return 1
      fi
    done
  }
  function handleDotfilesSources {
    local handlingMethod="$1"
    local dotfilesIdentifier="$2"
    local dotfilesSources=($(
      getDotfilesSources "$dotfilesIdentifier"
    ))
    for dotfileEntry in "${dotfilesSources[@]}"
    do
      local status
      if [ "$handlingMethod" == "deploy" ]
      then
        echo "$warningSymbol Deploying dotfiles : $dotfileEntry"
        status=$(
          stow --stow "$dotfileEntry" --dir "$dotfilesDirectory" --target "$dotfilesDestination" &>/dev/null
          echo "$?"
        )
        if [ "$status" != 0 ]
        then
          echo "$failureSymbol Failed to deploy dotfiles : $dotfileEntry"
        else
          echo "$successSymbol Successfully deployed dotfiles : $dotfileEntry"
        fi
      elif [ "$handlingMethod" == "retract" ]
      then
        echo "$warningSymbol Retracting dotfiles : $dotfileEntry"
        status=$(
          stow --delete "$dotfileEntry" --dir "$dotfilesDirectory" --target "$dotfilesDestination" &>/dev/null
          echo "$?"
        )
        if [ "$status" != 0 ]
        then
          echo "$failureSymbol Failed to retract dotfiles : $dotfileEntry"
        else
          echo "$successSymbol Successfully retracted dotfiles : $dotfileEntry"
        fi
      fi
    done
  }
  function summarizeDotfilesStatus {
    # [TODO] implementation
    local dotfilesIdentifier="$1"
    return 0
  }
  setStrictExecution "on"
  getPrerequisites
  setStrictExecution "off"
  if [ "$handlingMethod" == "deploy" ] || [ "$handlingMethod" == "retract" ]
  then
    if [ "$handlingMethod" == "deploy" ]
    then
      if [ "$dotfilesIdentifier" != "efficient" ]
      then
        handleDotfilesTargets "backup" "$dotfilesIdentifier"
        handleDotfilesSources "$handlingMethod" "$dotfilesIdentifier"
      else
        for dotfilesEntry in "${supportedDotfilesDirectories[@]}"
        do
          handleDotfilesTargets "backup" "$dotfilesEntry"
          handleDotfilesSources "$handlingMethod" "$dotfilesEntry"
        done
      fi
    elif [ "$handlingMethod" == "retract" ]
    then
      if [ "$dotfilesIdentifier" != "efficient" ]
      then
        handleDotfilesSources "$handlingMethod" "$dotfilesIdentifier"
        handleDotfilesTargets "restore" "$dotfilesIdentifier"
      else
        for dotfilesEntry in "${supportedDotfilesDirectories[@]}"
        do
          handleDotfilesSources "$handlingMethod" "$dotfilesEntry"
          handleDotfilesTargets "restore" "$dotfilesEntry"
        done
      fi
    fi
  elif [ "$handlingMethod" == "summarize" ]
  then
    summarizeDotfilesStatus "$dotfilesIdentifier"
  else
    echo "$failureSymbol Failed to find handling method : $handlingMethod"
    return 1
  fi
}
# Checking if the function being called exists
if declare -f "$1" &>/dev/null
then
  "$@"
# Ignoring when used with a `source` command
elif [ "$1" == "" ]
then
  return 0
fi
