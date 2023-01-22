function getBinaryPath {
  local targetBinary="$1"
  local targetRootFileSystem="$2"
  if [ "$targetRootFileSystem" == "" ]
  then
    targetRootFileSystem="/"
  fi
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  local targetBinaryPath=$(
    local binariesForTargetOnSystem=($(
      getAdministrativePrivileges
      sudo find "$targetRootFileSystem" -name "$targetBinary" -type f -executable
    ))
    local binaryForTarget=$(
      # [TODO] reduce dependency on luck here
      echo "${binariesForTargetOnSystem[0]}"
    )
    if [ "$targetRootFileSystem" != "/" ]
    then
      echo "${binaryForTarget#$targetRootFileSystem}"
    else
      echo "$binaryForTarget"
    fi
  )
  echo "$targetBinaryPath"
}
