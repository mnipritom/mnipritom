# ---
# note:
#   - to avoid redundent `source` commands, `gatekeeperStatus` is set here
# ---
function setEnvironmentParameters {
  local state="$1"

  local requiredParametersIdentifiers
  declare -A requiredParametersRecords

  requiredParametersIdentifiers+=( "gatekeeperStatus" )
  requiredParametersRecords["gatekeeperStatus"]="available"

  requiredParametersIdentifiers+=( "gatekeeperDirectory" )
  requiredParametersRecords["gatekeeperDirectory"]=$(
    dirname $(
      realpath --canonicalize-existing $(
        readlink --canonicalize ${BASH_SOURCE[0]:-$0}
      )
    )
  )

  requiredParametersIdentifiers+=( "worktreePath" )
  requiredParametersRecords["worktreePath"]=$(
    cd "${requiredParametersRecords["gatekeeperDirectory"]}/../../../"
    if [ $( git rev-parse --is-inside-work-tree ) ]
    then
      printf "%s" "$PWD"
    fi
  )

  requiredParametersIdentifiers+=( "worktreeIdentifier" )
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
    unset worktreesDirectoryIdentifier
    unset worktreeRepositoryIdentifier
  )

  requiredParametersIdentifiers+=( "worktreeRepository" )
  requiredParametersRecords["worktreeRepository"]=$(
    cd "${requiredParametersRecords["worktreePath"]}" && \
    git rev-parse --absolute-git-dir
  )

  requiredParametersIdentifiers+=( "repositoryPath" )
  requiredParametersRecords["repositoryPath"]=$(
    cd "${requiredParametersRecords["worktreePath"]}" && \
    git rev-parse --path-format=absolute --git-common-dir
  )

  requiredParametersIdentifiers+=( "worktreesDirectory" )
  requiredParametersRecords["worktreesDirectory"]="${requiredParametersRecords["repositoryPath"]}/states"

  requiredParametersIdentifiers+=( "processingSymbol" )
  requiredParametersRecords["processingSymbol"]="[⚙]"

  requiredParametersIdentifiers+=( "successSymbol" )
  requiredParametersRecords["successSymbol"]="[✔]"

  requiredParametersIdentifiers+=( "failureSymbol" )
  requiredParametersRecords["failureSymbol"]="[✘]"

  requiredParametersIdentifiers+=( "warningSymbol" )
  requiredParametersRecords["warningSymbol"]="[!]"

  requiredParametersIdentifiers+=( "blocksDirectory" )
  requiredParametersRecords["blocksDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/blocks"

  requiredParametersIdentifiers+=( "snippetsDirectory" )
  requiredParametersRecords["snippetsDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/snippets"

  requiredParametersIdentifiers+=( "modulesDirectory" )
  requiredParametersRecords["modulesDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/modules"

  requiredParametersIdentifiers+=( "actionsDirectory" )
  requiredParametersRecords["actionsDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/actions"

  requiredParametersIdentifiers+=( "chunksDirectory" )
  requiredParametersRecords["chunksDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/chunks"

  requiredParametersIdentifiers+=( "handlersDirectory" )
  requiredParametersRecords["handlersDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/handlers"

  requiredParametersIdentifiers+=( "aliasesDirectory" )
  requiredParametersRecords["aliasesDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/aliases"

  requiredParametersIdentifiers+=( "resourcesDirectory" )
  requiredParametersRecords["resourcesDirectory"]=$(
    realpath "${requiredParametersRecords["gatekeeperDirectory"]}/../../../resources"
  )

  # [TODO] add lacking paths
  requiredParametersIdentifiers+=( "diagnosticsDirectory" )
  requiredParametersRecords["diagnosticsDirectory"]="${requiredParametersRecords["resourcesDirectory"]}/diagnostics"

  requiredParametersIdentifiers+=( "diagnosedDumpsDirectory" )
  requiredParametersRecords["diagnosedDumpsDirectory"]="${requiredParametersRecords["diagnosticsDirectory"]}/dumps"

  requiredParametersIdentifiers+=( "diagnosedReportsDirectory" )
  requiredParametersRecords["diagnosedReportsDirectory"]="${requiredParametersRecords["diagnosticsDirectory"]}/reports"

  requiredParametersIdentifiers+=( "diagnosedExtractsDirectory" )
  requiredParametersRecords["diagnosedExtractsDirectory"]="${requiredParametersRecords["diagnosticsDirectory"]}/extracts"

  requiredParametersIdentifiers+=( "productionsDirectory" )
  requiredParametersRecords["productionsDirectory"]="${requiredParametersRecords["resourcesDirectory"]}/productions"

  requiredParametersIdentifiers+=( "producedDocumentsDirectory" )
  requiredParametersRecords["producedDocumentsDirectory"]="${requiredParametersRecords["productionsDirectory"]}/documents"

  requiredParametersIdentifiers+=( "producedIllustrationsDirectory" )
  requiredParametersRecords["producedIllustrationsDirectory"]="${requiredParametersRecords["productionsDirectory"]}/illustrations"

  requiredParametersIdentifiers+=( "producedRecordingsDirectory" )
  requiredParametersRecords["producedRecordingsDirectory"]="${requiredParametersRecords["productionsDirectory"]}/recordings"

  requiredParametersIdentifiers+=( "referencesDirectory" )
  requiredParametersRecords["referencesDirectory"]="${requiredParametersRecords["resourcesDirectory"]}/references"

  requiredParametersIdentifiers+=( "referencedDocumentsDirectory" )
  requiredParametersRecords["referencedDocumentsDirectory"]="${requiredParametersRecords["referencesDirectory"]}/documents"

  requiredParametersIdentifiers+=( "referencedIllustrationsDirectory" )
  requiredParametersRecords["referencedIllustrationsDirectory"]="${requiredParametersRecords["referencesDirectory"]}/illustrations"

  requiredParametersIdentifiers+=( "referencedUtilitiesDirectory" )
  requiredParametersRecords["referencedUtilitiesDirectory"]="${requiredParametersRecords["referencesDirectory"]}/utilities"

  requiredParametersIdentifiers+=( "releasesDirectory" )
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

  # [TODO] set status `requiredParametersRecords["executablesStatus"]`
  function loadExecutableScripts {
    source "${requiredParametersRecords["blocksDirectory"]}/baseSystem/getUniquePathEntries.bash"
    local executableScriptsDirectory="${requiredParametersRecords["referencedUtilitiesDirectory"]}/scripts/bash/executables"
    local executableScriptsEntries=($(
      find "$executableScriptsDirectory" -maxdepth 1 -type d -not -path "$executableScriptsDirectory" -nowarn
    ))
    local executableScriptsPaths
    for script in "${executableScriptsEntries[@]}"
    do
      local scriptEntry="${script##$executableScriptsDirectory/}"
      if [ -f "$script/$scriptEntry" ]
      then
        if [ ! -x "$script/$scriptEntry" ]
        then
          chmod +x "$script/$scriptEntry"
        else
          executableScriptsPaths+=(
            "$script"
          )
        fi
      elif [ -f "$script/bin/$scriptEntry" ]
      then
        if [ ! -x "$script/bin/$scriptEntry" ]
        then
          chmod +x "$script/bin/$scriptEntry"
        else
          executableScriptsPaths+=(
            "$script/bin"
          )
        fi
      fi
    done
    unset script
    local availableExecutableScripts=$(
      printf "%s\n" "${executableScriptsPaths[@]}" | tr "\n" ":"
    )
    export PATH="$PATH:$(
      printf "%s" "$availableExecutableScripts"
    )"
    export PATH="$(
      getUniquePathEntries
    )"
    unset getUniquePathEntries
  }

  # [TODO] set status `requiredParametersRecords["aliasesStatus"]`
  function loadAliasesEntries {
    local aliasesEntries=($(
      find "${requiredParametersRecords["aliasesDirectory"]}" -type f
    ))
    for aliasesEntry in "${aliasesEntries[@]}"
    do
      source "$aliasesEntry"
      if [ "$?" != 0 ]
      then
        printf "%s\n ${requiredParametersRecords["failureSymbol"]} Failed to load alias file : $aliasesEntry"
      fi
    done
    unset aliasesEntry
  }

  createRequiredDirectories
  loadAliasesEntries
  loadExecutableScripts

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
  unset getSystemPackageManager
  unset getWorkingDistributions
  unset getPrerequisites
  unset createRequiredDirectories
  unset loadAliasesEntries
  unset loadExecutableScripts
}
