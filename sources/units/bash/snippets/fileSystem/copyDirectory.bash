function copyDirectory {
  local source="$1"
  local destination="$2"
  source "$blocksDirectory/fileSystem/createDirectory.bash"
  local status
  if [ ! -d "$destination" ]
  then
    status="$(
      createDirectory "$destination"
    )"
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to create directory : $destination"
      return 1
    fi
  fi
  cp --recursive "$source" "$destination" &>/dev/null
  status="$(
    echo "$?"
  )"
  echo "$status"
}
function promptCopyDirectory {
  local source="$1"
  local destination="$2"
  local status="$(
    copyDirectory "$source" "$destination"
  )"
  if [ "$status" != 0 ]
  then
    echo "$failureSymbol Failed to copy directory : $source -> $destination"
  else
    echo "$successSymbol Successfully copied directory : $source -> $destination"
  fi
}
