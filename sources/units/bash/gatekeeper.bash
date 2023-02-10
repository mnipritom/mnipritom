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
    cd "${requiredParametersRecords[gatekeeperDirectory]}/../../../"
    if [ $( git rev-parse --is-inside-work-tree ) ]
    then
      printf "%s" "$PWD"
    fi
  ) && requiredParametersIdentifiers+=(
    "worktreePath"
  )

  requiredParametersRecords["worktreeIdentifier"]=$(
    basename "${requiredParametersRecords[worktreePath]}"
  ) && requiredParametersIdentifiers+=(
    "worktreeIdentifier"
  )

  requiredParametersRecords["worktreeRepository"]=$(
    cd "${requiredParametersRecords[worktreePath]}" && git rev-parse --absolute-git-dir
  ) && requiredParametersIdentifiers+=(
    "worktreeRepository"
  )

  requiredParametersRecords["repositoryPath"]=$(
    cd "${requiredParametersRecords[worktreePath]}" && git rev-parse --path-format=absolute --git-common-dir
  ) && requiredParametersIdentifiers+=(
    "repositoryPath"
  )

  requiredParametersRecords["worktreesDirectory"]="${requiredParametersRecords[repositoryPath]}/states" && requiredParametersIdentifiers+=(
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

  requiredParametersRecords["blocksDirectory"]="${requiredParametersRecords[gatekeeperDirectory]}/blocks" && requiredParametersIdentifiers+=(
    "blocksDirectory"
  )

  requiredParametersRecords["snippetsDirectory"]="${requiredParametersRecords[gatekeeperDirectory]}/snippets" && requiredParametersIdentifiers+=(
    "snippetsDirectory"
  )

  requiredParametersRecords["modulesDirectory"]="${requiredParametersRecords[gatekeeperDirectory]}/modules" && requiredParametersIdentifiers+=(
    "modulesDirectory"
  )

  requiredParametersRecords["actionsDirectory"]="${requiredParametersRecords[gatekeeperDirectory]}/actions" && requiredParametersIdentifiers+=(
    "actionsDirectory"
  )

  requiredParametersRecords["chunksDirectory"]="${requiredParametersRecords[gatekeeperDirectory]}/chunks" && requiredParametersIdentifiers+=(
    "chunksDirectory"
  )

  requiredParametersRecords["handlersDirectory"]="${requiredParametersRecords[gatekeeperDirectory]}/handlers" && requiredParametersIdentifiers+=(
    "handlersDirectory"
  )

  requiredParametersRecords["aliasesDirectory"]="${requiredParametersRecords[gatekeeperDirectory]}/aliases" && requiredParametersIdentifiers+=(
    "aliasesDirectory"
  )

  requiredParametersRecords["resourcesDirectory"]=$(
    cd "${requiredParametersRecords[gatekeeperDirectory]}/../../../resources" && pwd
  ) && requiredParametersIdentifiers+=(
    "resourcesDirectory"
  )

  requiredParametersRecords["assetsDirectory"]="${requiredParametersRecords[resourcesDirectory]}/assets" && requiredParametersIdentifiers+=(
    "assetsDirectory"
  )

  requiredParametersRecords["configurationsDirectory"]="${requiredParametersRecords[resourcesDirectory]}/configurations" && requiredParametersIdentifiers+=(
    "configurationsDirectory"
  )

  requiredParametersRecords["diagnosticsDirectory"]="${requiredParametersRecords[resourcesDirectory]}/diagnostics" && requiredParametersIdentifiers+=(
    "diagnosticsDirectory"
  )

  requiredParametersRecords["downloadsDirectory"]="${requiredParametersRecords[assetsDirectory]}/downloads" && requiredParametersIdentifiers+=(
    "downloadsDirectory"
  )

  requiredParametersRecords["productionsDirectory"]="${requiredParametersRecords[assetsDirectory]}/productions" && requiredParametersIdentifiers+=(
    "productionsDirectory"
  )

  requiredParametersRecords["referencesDirectory"]="${requiredParametersRecords[assetsDirectory]}/references" && requiredParametersIdentifiers+=(
    "referencesDirectory"
  )

  requiredParametersRecords["releasesDirectory"]="${requiredParametersRecords[assetsDirectory]}/releases" && requiredParametersIdentifiers+=(
    "releasesDirectory"
  )

  requiredParametersRecords["configuredTemplatesDirectory"]="${requiredParametersRecords[configurationsDirectory]}/templates" && requiredParametersIdentifiers+=(
    "configuredTemplatesDirectory"
  )

  requiredParametersRecords["downloadedUtilitiesDirectory"]="${requiredParametersRecords[downloadsDirectory]}/utilities" && requiredParametersIdentifiers+=(
    "downloadedUtilitiesDirectory"
  )

  requiredParametersRecords["downloadedScriptsDirectory"]="${requiredParametersRecords[downloadedUtilitiesDirectory]}/scripts/bash" && requiredParametersIdentifiers+=(
    "downloadedScriptsDirectory"
  )

  requiredParametersRecords["downloadedExecutablesDirectory"]="${requiredParametersRecords[downloadedScriptsDirectory]}/executables" && requiredParametersIdentifiers+=(
    "downloadedExecutablesDirectory"
  )

  requiredParametersRecords["downloadedHelpersDirectory"]="${requiredParametersRecords[downloadedScriptsDirectory]}/helpers" && requiredParametersIdentifiers+=(
    "downloadedHelpersDirectory"
  )

  requiredParametersRecords["dotfilesDirectory"]="${requiredParametersRecords[configurationsDirectory]}/dotfiles" && requiredParametersIdentifiers+=(
    "dotfilesDirectory"
  )

  requiredParametersRecords["wallpapersDirectory"]="${requiredParametersRecords[downloadsDirectory]}/wallpapers" && requiredParametersIdentifiers+=(
    "wallpapersDirectory"
  )

  requiredParametersRecords["logosDirectory"]="${requiredParametersRecords[referencesDirectory]}/logos" && requiredParametersIdentifiers+=(
    "logosDirectory"
  )

  requiredParametersRecords["producedDocumentsDirectory"]="${requiredParametersRecords[productionsDirectory]}/documents" && requiredParametersIdentifiers+=(
    "producedDocumentsDirectory"
  )

  requiredParametersRecords["journalsDirectory"]="${requiredParametersRecords[producedDocumentsDirectory]}/journals" && requiredParametersIdentifiers+=(
    "journalsDirectory"
  )

  requiredParametersRecords["playlistsDirectory"]="${requiredParametersRecords[producedDocumentsDirectory]}/playlists" && requiredParametersIdentifiers+=(
    "playlistsDirectory"
  )

  requiredParametersRecords["reportsDirectory"]="${requiredParametersRecords[diagnosticsDirectory]}/reports" && requiredParametersIdentifiers+=(
    "reportsDirectory"
  )

  requiredParametersRecords["dumpsDirectory"]="${requiredParametersRecords[diagnosticsDirectory]}/dumps" && requiredParametersIdentifiers+=(
    "dumpsDirectory"
  )

  requiredParametersRecords["extractsDirectory"]="${requiredParametersRecords[diagnosticsDirectory]}/extracts" && requiredParametersIdentifiers+=(
    "extractsDirectory"
  )

  function getSystemPackageManager {
    source "${requiredParametersRecords[snippetsDirectory]}/baseSystem/getHostDistribution.bash"
    source "${requiredParametersRecords[modulesDirectory]}/baseSystem/getHostDistributionPackageManager.bash"
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
      source "${requiredParametersRecords[snippetsDirectory]}/baseSystem/getHostDistribution.bash"
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

  function createRequiredDirectories {
    (
      source "${requiredParametersRecords[blocksDirectory]}/fileSystem/createDirectory.bash"
      local requiredDirectories=(
        "${requiredParametersRecords[diagnosticsDirectory]}"
        "${requiredParametersRecords[reportsDirectory]}"
        "${requiredParametersRecords[dumpsDirectory]}"
        "${requiredParametersRecords[extractsDirectory]}"
        "${requiredParametersRecords[worktreesDirectory]}"
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

  for parameter in "${requiredParametersIdentifiers[@]}"
  do
    if [ "$state" == "on" ]
    then
      export "$parameter=${requiredParametersRecords[$parameter]}"
    elif [ "$state" == "off" ]
    then
      unset "$parameter"
    else
      printf "%s\n" "${requiredParametersRecords[failureSymbol]} Failed to find state : $state"
    fi
  done

  unset parameter
  unset getSystemPackageManager
  unset getWorkingDistributions
  unset getPrerequisites
  unset createRequiredDirectories
}
