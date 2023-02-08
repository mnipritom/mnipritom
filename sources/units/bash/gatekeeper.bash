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
  cd "$gatekeeperDirectory/../../../"
  if [ $( git rev-parse --is-inside-work-tree ) ]
  then
    printf "%s" "$PWD"
  fi
)

export worktreeIdentifier="$(
  basename "$worktreePath"
)"

export worktreeRepository=$(
  cd "$worktreePath" && git rev-parse --absolute-git-dir
)

export repositoryPath=$(
  cd "$worktreePath" && git rev-parse --path-format=absolute --git-common-dir
)

export worktreesDirectory="$repositoryPath/states"

export processingSymbol="[⚙]"
export successSymbol="[✔]"
export failureSymbol="[✘]"
export warningSymbol="[!]"
export blocksDirectory="$gatekeeperDirectory/blocks"
export snippetsDirectory="$gatekeeperDirectory/snippets"
export modulesDirectory="$gatekeeperDirectory/modules"
export actionsDirectory="$gatekeeperDirectory/actions"
export chunksDirectory="$gatekeeperDirectory/chunks"
export handlersDirectory="$gatekeeperDirectory/handlers"
export aliasesDirectory="$gatekeeperDirectory/aliases"

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
export downloadedExecutablesDirectory="$downloadedScriptsDirectory/executables"
export downloadedHelpersDirectory="$downloadedScriptsDirectory/helpers"

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

function getExecutableScripts {
  local availableExecutableScriptsEntries=($(
    # find "$downloadedExecutablesDirectory" -maxdepth 2 -type f -executable -not -path "$downloadedExecutablesDirectory" -nowarn
    find "$downloadedExecutablesDirectory" -maxdepth 1 -type d -not -path "$downloadedExecutablesDirectory" -nowarn
  ))
  for script in "${availableExecutableScriptsEntries[@]}"
  do
    local scriptEntry="${script##$downloadedExecutablesDirectory/}"
    if [ ! -x "$script/$scriptEntry" ]
    then
      echo "$processingSymbol Making executable : $scriptEntry"
      chmod +x "$script/$scriptEntry"
    fi
  done
  local availableExecutableScripts=$(
    printf "%s\n" "${availableExecutableScriptsEntries[@]}" | tr "\n" ":"
  )
  printf "%s" "$availableExecutableScripts"
}

function getWorkingDistributions {
  local hostDistribution=$(
    source "$snippetsDirectory/baseSystem/getHostDistribution.bash"
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

function getPrerequisites {
  # [TODO] implement installation for essential programs `pandoc` `fzf` `zathura` etc
  # [TODO] implement submodules initialization
  # [TODO] utilize `diagnosticsDirectory` for synchronizations by generating and reading generated files
  return 1
}

function createRequiredDirectories {
  (
    source "$blocksDirectory/fileSystem/createDirectory.bash"
    local requiredDirectories=(
      "$diagnosticsDirectory"
      "$reportsDirectory"
      "$dumpsDirectory"
      "$extractsDirectory"
      "$worktreesDirectory"
    )
    for directory in "${requiredDirectories[@]}"
    do
      if [ ! -d "$directory" ]
      then
        promptCreateDirectory "$directory"
      fi
    done
  )
}

export systemPackageManager=$(
  getSystemPackageManager
)
export workingDistributions=($(
  getWorkingDistributions
))
export PATH="$(
  getExecutableScripts
):$PATH"

createRequiredDirectories

unset getSystemPackageManager
unset getExecutableScripts
unset getWorkingDistributions
unset getPrerequisites
unset createRequiredDirectories

source "$blocksDirectory/baseSystem/getUniquePathEntries.bash"
export PATH="$(
  getUniquePathEntries
)"
unset getUniquePathEntries
