# ---
# note:
#   - to avoid redundent `source` commands, `gatekeeperStatus` is set here
#   - global variables that are potentially needed for files in `sources` directory to operate
# ---
export gatekeeperStatus="available"

export gatekeeperDirectory="$(
  cd "$(
    dirname "$(
      readlink --canonicalize "${BASH_SOURCE[0]:-$0}"
    )"
  )" && pwd
)"

export worktreePath=$(
  cd "$gatekeeperDirectory/../../../" && pwd
)

export worktreeIdentifier="$(
  basename "$worktreePath"
)"

export processingSymbol="[⚙]"
export successSymbol="[✔]"
export failureSymbol="[✘]"
export warningSymbol="[!]"
export blocksDirectory="$gatekeeperDirectory/blocks"
export snippetsDirectory="$gatekeeperDirectory/snippets"
export modulesDirectory="$gatekeeperDirectory/modules"
export actionsDirectory="$gatekeeperDirectory/actions"
export chunksDirectory="$gatekeeperDirectory/chunks"
export tasksDirectory="$gatekeeperDirectory/tasks"

export resourcesDirectory="$(
  cd "$gatekeeperDirectory/../../../resources" && pwd
)"

export assetsDirectory="$resourcesDirectory/assets"
export configurationsDirectory="$resourcesDirectory/configurations"
export diagnosticsDirectory="$resourcesDirectory/diagnostics"

export downloadsDirectory="$assetsDirectory/downloads"
export productionsDirectory="$assetsDirectory/productions"
export referencesDirectory="$assetsDirectory/references"
export releasesDirectory="$assetsDirectory/releases"

export configuredUtilitiesDirectory="$configurationsDirectory/utilities"
export configuredTemplatesDirectory="$configurationsDirectory/templates"

export downloadedUtilitiesDirectory="$downloadsDirectory/utilities"
export downloadedScriptsDirectory="$downloadedUtilitiesDirectory/scripts"

export dotfilesDirectory="$configurationsDirectory/dotfiles"
export wallpapersDirectory="$downloadsDirectory/wallpapers"
export logosDirectory="$referencesDirectory/logos"

export producedDocumentsDirectory="$productionsDirectory/documents"

export journalsDirectory="$producedDocumentsDirectory/journals"
export playlistsDirectory="$producedDocumentsDirectory/playlists"

export reportsDirectory="$diagnosticsDirectory/reports"
export dumpsDirectory="$diagnosticsDirectory/dumps"
export extractsDirectory="$diagnosticsDirectory/extracts"

function getSystemPackageManager {
  source "$snippetsDirectory/baseSystem/getHostDistribution.bash"
  source "$modulesDirectory/baseSystem/getHostDistributionPackageManager.bash"
  local hostDistribution=$(
    getHostDistribution
  )
  local hostDistributionPackageManager=$(
    getHostDistributionPackageManager "$hostDistribution"
  )
  echo "$hostDistributionPackageManager"
}

function createDiagnosticsDirectories {
  (
    source "$blocksDirectory/fileSystem/createDirectory.bash"
    local diagnosticsDirectories=(
      "$diagnosticsDirectory"
      "$reportsDirectory"
      "$dumpsDirectory"
      "$extractsDirectory"
    )
    for directory in "${diagnosticsDirectories[@]}"
    do
      if [ ! -d "$directory" ]
      then
        promptCreateDirectory "$directory"
      fi
    done
  )
}

function makeScriptsAvailable {
  (
    local availableScriptsEntries=($(
      # find "$downloadedScriptsDirectory" -maxdepth 2 -type f -executable -not -path "$downloadedScriptsDirectory" -nowarn
      find "$downloadedScriptsDirectory" -maxdepth 1 -type d -not -path "$downloadedScriptsDirectory" -nowarn
    ))
    for script in "${availableScriptsEntries[@]}"
    do
      local scriptEntry="${script##$downloadedScriptsDirectory/}"
      if [ ! -x "$script/$scriptEntry" ]
      then
        echo "$processingSymbol Making executable : $scriptEntry"
        chmod +x "$script/$scriptEntry"
      fi
    done
    local availableScripts=$(
      printf "%s\n" "${availableScriptsEntries[@]}" | tr "\n" ":"
    )
    export PATH="$PATH:$availableScripts"
  )
}

function getAvailableDistributions {
  local hostDistribution=$(
    source "$snippetsDirectory/baseSystem/getHostDistribution.bash"
    getHostDistribution
  )
  local availableDistributions=(
    "void"
    "devuan"
    "debian"
    "ubuntu"
    "kali"
    "parrot"
  )
  # [TODO] implement support for `nix` `guix` `hyperbola` `parabola` `trisquel`
  local supportedDistributions=(
    "artix"
    "arch"
    "fedora"
    "opensuse"
  )
  for supported in "${supportedDistributions[@]}"
  do
    if grep --ignore-case --quiet "$supported" <<< "$hostDistribution"
    then
      availableDistributions+=(
        "$supported"
      )
      break
    fi
  done
  echo "${availableDistributions[@]}"
}

function getPrerequisites {
  # [TODO] implement installation for essential programs `pandoc` `fzf` `zathura` etc
  # [TODO] implement submodules initialization
  # [TODO] utilize `diagnosticsDirectory` for synchronizations by generating and reading generated files
  return 1
}

createDiagnosticsDirectories
makeScriptsAvailable

export systemPackageManager=$(
  getSystemPackageManager
)

unset getSystemPackageManager
unset createDiagnosticsDirectories
unset makeScriptsAvailable
unset getPrerequisites
