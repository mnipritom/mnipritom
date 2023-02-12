# ---
# note:
#   - to avoid redundent `source` commands, `gatekeeperStatus` is set here
# ---
function setEnvironmentParameters {
  local state="$1"

  local requiredParametersIdentifiers
  declare -A requiredParametersRecords

  requiredParametersRecords["gatekeeperStatus"]="available" && requiredParametersIdentifiers+=(
    "gatekeeperStatus"
  )

  requiredParametersRecords["gatekeeperDirectory"]=$(
    cd $(
      dirname $(
        readlink --canonicalize "${BASH_SOURCE[0]:-$0}"
      )
    ) && pwd
  ) && requiredParametersIdentifiers+=(
    "gatekeeperDirectory"
  )

  requiredParametersRecords["worktreePath"]=$(
    cd "${requiredParametersRecords["gatekeeperDirectory"]}/../../../"
    if [ $( git rev-parse --is-inside-work-tree ) ]
    then
      printf "%s" "$PWD"
    fi
  ) && requiredParametersIdentifiers+=(
    "worktreePath"
  )

  requiredParametersRecords["worktreeIdentifier"]=$(
    worktreesDirectoryIdentifier=$(
      basename "${requiredParametersRecords["worktreePath"]}"
    )
    worktreeRepositoryIdentifier=$(
      cd "${requiredParametersRecords["worktreePath"]}" && git branch --show-current
    )
    if [ "$worktreesDirectoryIdentifier" == "$worktreeRepositoryIdentifier" ]
    then
      printf "$worktreesDirectoryIdentifier"
    else
      printf "$worktreeRepositoryIdentifier"
    fi
    unset worktreesDirectoryIdentifier
    unset worktreeRepositoryIdentifier
  ) && requiredParametersIdentifiers+=(
    "worktreeIdentifier"
  )

  requiredParametersRecords["worktreeRepository"]=$(
    cd "${requiredParametersRecords["worktreePath"]}" && git rev-parse --absolute-git-dir
  ) && requiredParametersIdentifiers+=(
    "worktreeRepository"
  )

  requiredParametersRecords["repositoryPath"]=$(
    cd "${requiredParametersRecords["worktreePath"]}" && git rev-parse --path-format=absolute --git-common-dir
  ) && requiredParametersIdentifiers+=(
    "repositoryPath"
  )

  requiredParametersRecords["worktreesDirectory"]="${requiredParametersRecords["repositoryPath"]}/states" && requiredParametersIdentifiers+=(
    "worktreesDirectory"
  )

  requiredParametersRecords["processingSymbol"]="[⚙]" && requiredParametersIdentifiers+=(
    "processingSymbol"
  )

  requiredParametersRecords["successSymbol"]="[✔]" && requiredParametersIdentifiers+=(
    "successSymbol"
  )

  requiredParametersRecords["failureSymbol"]="[✘]" && requiredParametersIdentifiers+=(
    "failureSymbol"
  )

  requiredParametersRecords["warningSymbol"]="[!]" && requiredParametersIdentifiers+=(
    "warningSymbol"
  )

  requiredParametersRecords["blocksDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/blocks" && requiredParametersIdentifiers+=(
    "blocksDirectory"
  )

  requiredParametersRecords["snippetsDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/snippets" && requiredParametersIdentifiers+=(
    "snippetsDirectory"
  )

  requiredParametersRecords["modulesDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/modules" && requiredParametersIdentifiers+=(
    "modulesDirectory"
  )

  requiredParametersRecords["actionsDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/actions" && requiredParametersIdentifiers+=(
    "actionsDirectory"
  )

  requiredParametersRecords["chunksDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/chunks" && requiredParametersIdentifiers+=(
    "chunksDirectory"
  )

  requiredParametersRecords["handlersDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/handlers" && requiredParametersIdentifiers+=(
    "handlersDirectory"
  )

  requiredParametersRecords["aliasesDirectory"]="${requiredParametersRecords["gatekeeperDirectory"]}/aliases" && requiredParametersIdentifiers+=(
    "aliasesDirectory"
  )

  requiredParametersRecords["resourcesDirectory"]=$(
    cd "${requiredParametersRecords["gatekeeperDirectory"]}/../../../resources" && pwd
  ) && requiredParametersIdentifiers+=(
    "resourcesDirectory"
  )

  # [TODO] add lacking paths
  requiredParametersRecords["diagnosticsDirectory"]="${requiredParametersRecords["resourcesDirectory"]}/diagnostics" && requiredParametersIdentifiers+=(
    "diagnosticsDirectory"
  )

  requiredParametersRecords["diagnosedDumpsDirectory"]="${requiredParametersRecords["diagnosticsDirectory"]}/dumps" && requiredParametersIdentifiers+=(
    "diagnosedDumpsDirectory"
  )

  requiredParametersRecords["diagnosedReportsDirectory"]="${requiredParametersRecords["diagnosticsDirectory"]}/reports" && requiredParametersIdentifiers+=(
    "diagnosedReportsDirectory"
  )

  requiredParametersRecords["diagnosedExtractsDirectory"]="${requiredParametersRecords["diagnosticsDirectory"]}/extracts" && requiredParametersIdentifiers+=(
    "diagnosedExtractsDirectory"
  )

  requiredParametersRecords["productionsDirectory"]="${requiredParametersRecords["resourcesDirectory"]}/productions" && requiredParametersIdentifiers+=(
    "productionsDirectory"
  )

  requiredParametersRecords["producedDocumentsDirectory"]="${requiredParametersRecords["productionsDirectory"]}/documents" && requiredParametersIdentifiers+=(
    "producedDocumentsDirectory"
  )

  requiredParametersRecords["producedIllustrationsDirectory"]="${requiredParametersRecords["productionsDirectory"]}/illustrations" && requiredParametersIdentifiers+=(
    "producedIllustrationsDirectory"
  )

  requiredParametersRecords["producedRecordingsDirectory"]="${requiredParametersRecords["productionsDirectory"]}/recordings" && requiredParametersIdentifiers+=(
    "producedRecordingsDirectory"
  )

  requiredParametersRecords["referencesDirectory"]="${requiredParametersRecords["resourcesDirectory"]}/references" && requiredParametersIdentifiers+=(
    "referencesDirectory"
  )

  requiredParametersRecords["referencedDocumentsDirectory"]="${requiredParametersRecords["referencesDirectory"]}/documents" && requiredParametersIdentifiers+=(
    "referencedDocumentsDirectory"
  )

  requiredParametersRecords["referencedIllustrationsDirectory"]="${requiredParametersRecords["referencesDirectory"]}/illustrations" && requiredParametersIdentifiers+=(
    "referencedIllustrationsDirectory"
  )

  requiredParametersRecords["referencedUtilitiesDirectory"]="${requiredParametersRecords["referencesDirectory"]}/utilities" && requiredParametersIdentifiers+=(
    "referencedUtilitiesDirectory"
  )

  requiredParametersRecords["releasesDirectory"]="${requiredParametersRecords["resourcesDirectory"]}/releases" && requiredParametersIdentifiers+=(
    "releasesDirectory"
  )

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
    "getSystemPackageManager"
  )

  requiredParametersRecords["workingDistributions"]="$(
    getWorkingDistributions
  )" && requiredParametersIdentifiers+=(
    "workingDistributions"
  )

  function loadExecutableScripts {
    local executableScriptsEntries=($(
      find $requiredParametersRecords["referencedUtilitiesDirectory"] -maxdepth 1 -type d -not -path $requiredParametersRecords["referencedUtilitiesDirectory"] -nowarn
    ))
    local executableScriptsPaths
    for script in "${executableScriptsEntries[@]}"
    do
      local scriptEntry="${script##$requiredParametersRecords["referencedUtilitiesDirectory"]/}"
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
    local availableExecutableScripts=$(
      printf "%s\n" "${executableScriptsPaths[@]}" | tr "\n" ":"
    )
    export PATH="$PATH:$(
      printf "%s" "$availableExecutableScripts"
    )"
  }

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
    unset aliasesEntries
  }

  createRequiredDirectories
  loadAliasesEntries
  loadExecutableScripts

  for parameter in "${requiredParametersIdentifiers[@]}"
  do
    if [ "$state" == "on" ]
    then
      export "$parameter=${requiredParametersRecords["$parameter"]}"
    elif [ "$state" == "off" ]
    then
      unset "$parameter"
    else
      printf "%s\n" "${requiredParametersRecords["failureSymbol"]} Failed to find state : $state"
    fi
  done

  unset parameter
  unset getSystemPackageManager
  unset getWorkingDistributions
  unset getPrerequisites
  unset createRequiredDirectories
  unset loadAliasesEntries
  unset loadExecutableScripts
}
