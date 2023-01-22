function deleteDirectory {
  local targetDirectory="$1"
  local directoryType="$2"
  if [ "$directoryType" == "privileged" ]
  then
    eval "sudo rm --recursive --force $targetDirectory" &>/dev/null
  elif [ "$directoryType" == "" ]
  then
    rm --recursive --force "$targetDirectory" &>/dev/null
  fi
  local status="$(
    echo "$?"
  )"
  echo "$status"
}
function promptDeleteDirectory {
  local targetDirectory="$1"
  local directoryType="$2"
  local status="$( deleteDirectory "$targetDirectory" "$directoryType" )"
  if [ "$status" != 0 ]
  then
    echo "$failureSymbol Failed to delete directory : $targetDirectory"
  else
    echo "$successSymbol Successfully deleted directory : $targetDirectory"
  fi
}
