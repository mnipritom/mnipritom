function createDirectory {
  local targetDirectory="$1"
  local directoryType="$2"
  if [ "$directoryType" == "privileged" ]
  then
    eval "sudo mkdir --parents $targetDirectory" &>/dev/null
  elif [ "$directoryType" == "" ]
  then
    mkdir --parents "$targetDirectory" &>/dev/null
  fi
  local status="$(
    echo "$?"
  )"
  echo "$status"
}
function promptCreateDirectory {
  local targetDirectory="$1"
  local directoryType="$2"
  local status="$( createDirectory "$targetDirectory" "$directoryType" )"
  if [ "$status" != 0 ]
  then
    echo "$failureSymbol Failed to create directory : $targetDirectory"
  else
    echo "$successSymbol Successfully created directory : $targetDirectory"
  fi
}
