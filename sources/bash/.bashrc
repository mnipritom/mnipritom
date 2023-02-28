shopt -s autocd
shopt -s cdspell
shopt -s cdable_vars
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s extglob

declare -A VARIABLES=(
  # [TODO] implement `FZF_DEFAULT_COMMAND`
  # [TODO] implement `BROWSER`
  # [TODO] implement `TERM`
  # [TODO] implement `PAGER`
  ["LANG"]="en_US.UTF-8"
  ["LC_ALL"]="en_US.UTF-8"
  ["EDITOR"]=nvim
  ["VISUAL"]=nvim
  ["GIT_EDITOR"]=nvim
  ["FZF_DEFAULT_OPTS"]="\
    --no-multi \
    --info hidden \
    --layout reverse \
    --height 15 \
    --prompt '❯ ' \
    --pointer '❯ ' \
  "
)
for variableId in "${!VARIABLES[@]}"
do
  export "$variableId=${VARIABLES["$variableId"]}"
done
unset variableId VARIABLES

PATHS=(
  "$HOME/go"
  "$GOPATH/bin"
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "/home/linuxbrew/.linuxbrew/bin"
)
for path in "${PATHS[@]}"
do
  if [ -d "$path" ]
  then
    export "PATH=$PATH:$path"
  fi
done
unset path PATHS

declare -A EVALS=(
  ["pandoc"]="--bash-completion"
  ["wezterm"]="shell-completion --shell bash"
  ["starship"]="init bash"
  ["brew"]="shellenv"
)
for evalCommand in "${!EVALS[@]}"
do
  commandPath=$(
    which "$evalCommand"
  )
  if [ "$commandPath" != "" ]
  then
    eval "$( $commandPath ${EVALS[$evalCommand]} )"
  fi
done
unset evalCommand commandPath EVALS

function setEnvironmentParameters {
  local state="$1"

  local requiredParametersIdentifiers+=(
    "gatekeeperStatus"
    "gatekeeperDirectory"
    "worktreePath"
    "worktreeIdentifier"
    "worktreeRepository"
    "repositoryPath"
    "worktreesDirectory"
    "processingSymbol"
    "successSymbol"
    "failureSymbol"
    "warningSymbol"
    "blocksDirectory"
    "snippetsDirectory"
    "modulesDirectory"
    "actionsDirectory"
    "chunksDirectory"
    "handlersDirectory"
    "aliasesDirectory"
    "resourcesDirectory"
    "diagnosticsDirectory"
    "diagnosedDumpsDirectory"
    "diagnosedReportsDirectory"
    "diagnosedExtractsDirectory"
    "productionsDirectory"
    "producedDocumentsDirectory"
    "producedIllustrationsDirectory"
    "producedRecordingsDirectory"
    "referencesDirectory"
    "referencedDocumentsDirectory"
    "referencedIllustrationsDirectory"
    "referencedUtilitiesDirectory"
    "releasesDirectory"
  )

  declare -A requiredParametersRecords

  requiredParametersRecords["gatekeeperStatus"]="available"

  requiredParametersRecords["gatekeeperDirectory"]=$(
    dirname $(
      realpath --canonicalize-existing $(
        readlink --canonicalize ${BASH_SOURCE[0]:-$0}
      )
    )
  )

  requiredParametersRecords["worktreePath"]=$(
    cd "${requiredParametersRecords["gatekeeperDirectory"]}/../../../"
    if [ $( git rev-parse --is-inside-work-tree ) ]
    then
      printf "%s" "$PWD"
    fi
  )

  requiredParametersRecords["worktreeIdentifier"]=$(
    worktreesDirectoryIdentifier=$(
      basename "${requiredParametersRecords["worktreePath"]}"
    )
    worktreeRepositoryIdentifier=$(
      cd "${requiredParametersRecords["worktreePath"]}" && \
      git branch --show-current
    )
    if [ "$worktreesDirectoryIdentifier" == "$worktreeRepositoryIdentifier" ]
    then
      printf "$worktreesDirectoryIdentifier"
    else
      printf "$worktreeRepositoryIdentifier"
    fi
    unset worktreesDirectoryIdentifier worktreeRepositoryIdentifier
  )

  requiredParametersRecords["worktreeRepository"]=$(
    cd "${requiredParametersRecords["worktreePath"]}" && \
    git rev-parse --absolute-git-dir
  )

  requiredParametersRecords["repositoryPath"]=$(
    cd "${requiredParametersRecords["worktreePath"]}" && \
    git rev-parse --path-format=absolute --git-common-dir
  )

  requiredParametersRecords["worktreesDirectory"]="${requiredParametersRecords["repositoryPath"]}/states"

  requiredParametersRecords["processingSymbol"]="[⚙]"
  requiredParametersRecords["successSymbol"]="[✔]"
  requiredParametersRecords["failureSymbol"]="[✘]"
  requiredParametersRecords["warningSymbol"]="[!]"

  requiredParametersRecords["blocksDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/blocks"
  requiredParametersRecords["snippetsDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/snippets"
  requiredParametersRecords["modulesDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/modules"
  requiredParametersRecords["actionsDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/actions"
  requiredParametersRecords["chunksDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/chunks"
  requiredParametersRecords["handlersDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/handlers"
  requiredParametersRecords["aliasesDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/aliases"
  requiredParametersRecords["resourcesDirectory"]=$(
    realpath "${requiredParametersRecords["gatekeeperDirectory"]}/../../../resources"
  )

  # [TODO] add lacking paths
  requiredParametersRecords["diagnosticsDirectory"]="${requiredParametersRecords["resourcesDirectory"]}/diagnostics"
  requiredParametersRecords["diagnosedDumpsDirectory"]="${requiredParametersRecords["diagnosticsDirectory"]}/dumps"
  requiredParametersRecords["diagnosedReportsDirectory"]="${requiredParametersRecords["diagnosticsDirectory"]}/reports"
  requiredParametersRecords["diagnosedExtractsDirectory"]="${requiredParametersRecords["diagnosticsDirectory"]}/extracts"
  requiredParametersRecords["productionsDirectory"]="${requiredParametersRecords["resourcesDirectory"]}/productions"
  requiredParametersRecords["producedDocumentsDirectory"]="${requiredParametersRecords["productionsDirectory"]}/documents"
  requiredParametersRecords["producedIllustrationsDirectory"]="${requiredParametersRecords["productionsDirectory"]}/illustrations"
  requiredParametersRecords["producedRecordingsDirectory"]="${requiredParametersRecords["productionsDirectory"]}/recordings"
  requiredParametersRecords["referencesDirectory"]="${requiredParametersRecords["resourcesDirectory"]}/references"
  requiredParametersRecords["referencedDocumentsDirectory"]="${requiredParametersRecords["referencesDirectory"]}/documents"
  requiredParametersRecords["referencedIllustrationsDirectory"]="${requiredParametersRecords["referencesDirectory"]}/illustrations"
  requiredParametersRecords["referencedUtilitiesDirectory"]="${requiredParametersRecords["referencesDirectory"]}/utilities"
  requiredParametersRecords["releasesDirectory"]="${requiredParametersRecords["resourcesDirectory"]}/releases"

  function getSystemPackageManager {
    source "${requiredParametersRecords["snippetsDirectory"]}/baseSystem/getHostDistribution.bash"
    source "${requiredParametersRecords["modulesDirectory"]}/baseSystem/getHostDistributionPackageManager.bash"
    local hostDistribution=$(
      getHostDistribution
    )
    local hostDistributionPackageManager=$(
      getHostDistributionPackageManager "$hostDistribution"
    )
    printf "%s" "$hostDistributionPackageManager"
  }

  function getWorkingDistributions {
    local hostDistribution=$(
      source "${requiredParametersRecords["snippetsDirectory"]}/baseSystem/getHostDistribution.bash"
      getHostDistribution
    )
    local availableDistributionsEntries=(
      "void"
      "devuan"
      "debian"
      "ubuntu"
      "kali"
      "parrot"
    )
    # [TODO] implement support for `nix` `guix` `hyperbola` `parabola` `trisquel`
    local supportedDistributionsEntries=(
      "artix"
      "arch"
      "fedora"
      "opensuse"
    )
    local workingDistributionsEntries+=($(
      printf "%s\n" "${availableDistributionsEntries[@]}"
    ))
    for supportedDistribution in "${supportedDistributionsEntries[@]}"
    do
      if grep --ignore-case --quiet "$supportedDistribution" <<< "$hostDistribution"
      then
        workingDistributionsEntries+=(
          "$supportedDistribution"
        )
        break
      fi
    done
    printf "%s\n" "${workingDistributionsEntries[@]}"
  }

  requiredParametersRecords["systemPackageManager"]="$(
    getSystemPackageManager
  )" && requiredParametersIdentifiers+=(
    "systemPackageManager"
  )

  requiredParametersRecords["workingDistributions"]="$(
    getWorkingDistributions | tr "\n" " "
  )" && requiredParametersIdentifiers+=(
    "workingDistributions"
  )

  function createRequiredDirectories {
    (
      source "${requiredParametersRecords["blocksDirectory"]}/fileSystem/createDirectory.bash"
      local requiredDirectories=(
        "${requiredParametersRecords["diagnosticsDirectory"]}"
        "${requiredParametersRecords["diagnosedReportsDirectory"]}"
        "${requiredParametersRecords["diagnosedDumpsDirectory"]}"
        "${requiredParametersRecords["diagnosedExtractsDirectory"]}"
        "${requiredParametersRecords["worktreesDirectory"]}"
      )
      # [TODO] implement better evaluation to work within `distrobox` containers
      for directory in "${requiredDirectories[@]}"
      do
        if [ ! -d "$directory" ]
        then
          promptCreateDirectory "$directory"
        fi
      done
    )
  }

  createRequiredDirectories

  for parameterIdentifier in "${requiredParametersIdentifiers[@]}"
  do
    if [ "$state" == "on" ]
    then
      export "$parameterIdentifier=${requiredParametersRecords["$parameterIdentifier"]}"
    elif [ "$state" == "off" ]
    then
      unset "$parameterIdentifier"
    else
      printf "%s\n" "${requiredParametersRecords["failureSymbol"]} Failed to find state : $state"
    fi
  done

  unset parameterIdentifier
  unset getSystemPackageManager getWorkingDistributions getPrerequisites
  unset createRequiredDirectories loadAliasesEntries loadExecutableScripts
}
