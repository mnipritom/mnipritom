functionsLevel0["checkCommandAvailability"]=$(
  function checkCommandAvailability {
    local commandToCheck="${1}"
    # consider `command -v`
    local status="$(
      which "${commandToCheck}" &>/dev/null
      printf "%s" "${?}"
    )"
    printf "%s" "${status}"
  }
  declare -f checkCommandAvailability
  unset -f checkCommandAvailability
)

functionsLevel0["readFile"]=$(
  function readFile {
    local fileToRead="${1}"
    eval "gawk '{
      print
    }' ${fileToRead}"
  }
  declare -f readFile
  unset -f readFile
)

functionsLevel0["getFileName"]=$(
  function getFileName {
    local toParse="${1}"
    printf "%s" "$(
      basename "${toParse}"
    )"
  }
  declare -f getFileName
  unset -f getFileName
)

functionsLevel0["getRandomFile"]=$(
  function getRandomFile {
    local targetDirectory="${1}"
    if [[ ! -d "${targetDirectory}" ]]
    then
      printf "%s" "${failureSymbol} Failed to find directory : ${targetDirectory}"
      return 1
    fi
    local targetDirectoryFiles=($(
      find "${targetDirectory}" -type f -nowarn
    ))
    local targetDirectoryFilesCount="${#targetDirectoryFiles[@]}"
    local randomizedEntry=$(
      shuf --input-range 0-"$(( ${targetDirectoryFilesCount}-1 ))" --head-count 1
    )
    local randomFile="${targetDirectoryFiles[${randomizedEntry}]}"
    printf "%s" "${randomFile}"
  }
  declare -f getRandomFile
  unset -f getRandomFile
)

functionsLevel0["createSymbolicLink"]=$(
  function createSymbolicLink {
    local source="${1}"
    local target="${2}"
    local sourcePath="$(
      realpath "${source}"
    )"
    local targetPath="$(
      realpath "${target}"
    )"
    local status=$(
      ln --symbolic "${sourcePath}" "${targetPath}" &>/dev/null
      printf "%s" "${?}"
    )
    printf "%s" "${status}"
  }
  declare -f createSymbolicLink
  unset -f createSymbolicLink
)

# [TODO] make level1function with elevatedPrivilages
functionsLevel0["createDirectory"]=$(
  function createDirectory {
    local targetDirectory="${1}"
    local directoryType="${2}"
    if [[ "$directoryType" == "privileged" ]]
    then
      eval "sudo mkdir --parents ${targetDirectory}" &>/dev/null
    elif [[ "${directoryType}" == "" ]]
    then
      mkdir --parents "${targetDirectory}" &>/dev/null
    fi
    local status="$(
      printf "%s" "${?}"
    )"
    printf "%s" "${status}"
  }
  declare -f createDirectory
  unset -f createDirectory
)
