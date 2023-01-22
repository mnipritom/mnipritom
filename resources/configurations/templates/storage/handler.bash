function handleStorageDisk {
  # [TODO] Implement non-wipe disk approach
  local handlingMethod="$1"
  local targetDisk="$2"
  local confirmationToProceed="$3"
  local workingDirectory="$(
    cd "$(
      dirname "$(
        readlink --canonicalize "${BASH_SOURCE[0]:-$0}"
      )"
    )" && pwd
  )"
  local worktreePath=$(
    cd "$workingDirectory/../../../../../" && pwd
  )
  local sourcesDirectory=$(
    cd "$worktreePath/sources" && pwd
  )
  source "$sourcesDirectory/units/bash/gatekeeper.bash"
  source "$blocksDirectory/baseSystem/setAliases.bash"
  source "$blocksDirectory/baseSystem/setStrictExecution.bash"
  setAliases "on"
  alias awk="gawk"
  alias fzf="\
    fzf \
    --no-multi \
    --info hidden \
    --layout reverse \
    --height 15 \
    --prompt '❯ ' \
    --pointer '❯ ' \
  "
  function applyStoragePartitionTableTemplate {
    # [TODO] Implement non-wipe disk approach
    source "$snippetsDirectory/fileSystem/wipeAllExistingFileSystems.bash"
    source "$snippetsDirectory/fileSystem/createPartitionTableOnDisk.bash"
    source "$actionsDirectory/fileSystem/createFileSystemsOnDisk.bash"
    local partitionTableTemplate="$configuredTemplatesDirectory/storage/partitiontable.sfdisk"
    local targetDisk="$1"
    if [ "$confirmationToProceed" == "" ]
    then
      local confirmationToProceed="$(
        local promptMessage="$warningSymbol Proceeding further will make irreversible changes : $targetDisk"
        local promptOptions=(
          "Yes & Proceed"
          "No & Exit"
        )
        local confirmation=$(
          printf "%s\n" "${promptOptions[@]}" | fzf --header "$promptMessage"
        )
        echo "$confirmation"
      )"
    fi
    echo "$processingSymbol Applying storage partition table template : $partitionTableTemplate"
    if [ "$confirmationToProceed" != "No & Exit" ]
    then
      wipeAllExistingFileSystems "$targetDisk"
      createPartitionTableOnDisk "$targetDisk" "$partitionTableTemplate"
      createFileSystemsOnDisk "$targetDisk"
    else
      echo "$failureSymbol Failed to apply partition table template : $targetDisk"
      return 1
    fi
  }
  if [ "$targetDisk" == "" ]
  then
    setStrictExecution "on"
    local targetDisk="$(
      source "$blocksDirectory/fileSystem/listAvailableDisks.bash"
      local message="$warningSymbol Select storage disk"
      listAvailableDisks | fzf --header "$message" | awk '{
        print $1
      }'
    )"
    setStrictExecution "off"
  fi
  if [ "$handlingMethod" == "wipe" ]
  then
    setStrictExecution "on"
    applyStoragePartitionTableTemplate "$targetDisk"
    setStrictExecution "off"
  else
    echo "$failureSymbol Failed to find storage disk handling method : $handlingMethod"
    return 1
  fi
  setAliases "off"
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
