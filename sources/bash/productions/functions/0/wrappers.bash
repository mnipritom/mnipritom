_0["readFile"]=$(
  function readFile {
    local fileToRead="$1"
    eval "gawk '{
      print
    }' $fileToRead"
  }
  declare -f readFile
  unset -f readFile
)

_0["getFileName"]=$(
  function getFileName {
    local toParse="$1"
    echo "$(
    basename "$toParse"
    )"
  }
  declare -f getFileName
  unset -f getFileName
)

_0["checkCommandAvailability"]=$(
  function checkCommandAvailability {
    local commandToCheck="$1"
    # consider `command -v`
    local status="$(
      which "$commandToCheck" &>/dev/null
      echo "$?"
    )"
    echo "$status"
  }
  declare -f checkCommandAvailability
  unset -f checkCommandAvailability
)
