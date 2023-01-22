function createUser {
  local userName="$1"
  local targetRootFileSystem="$2"
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  source "$modulesDirectory/baseSystem/chrootExecute.bash"
  source "$snippetsDirectory/baseSystem/getBinaryPath.bash"
  local targetBashBinary=$(
    getBinaryPath "bash" "$targetRootFileSystem"
  )
  local commandToExecute="\
    useradd \
    --create-home \
    --system "$userName" \
    --shell "$targetBashBinary" \
  "
  if [ "$targetRootFileSystem" != "" ]
  then
    echo "$processingSymbol Creating user : $userName -> $targetRootFileSystem"
    chrootExecute "command" "$targetRootFileSystem" "$commandToExecute" &>/dev/null
  else
    echo "$processingSymbol Creating user : $userName"
    getAdministrativePrivileges
    eval sudo "$commandToExecute"
  fi
}
