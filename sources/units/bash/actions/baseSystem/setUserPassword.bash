function setUserPassword {
  local userName="$1"
  local targetRootFileSystem="$2"
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  source "$modulesDirectory/baseSystem/chrootExecute.bash"
  local commandToExecute="\
  passwd --delete $userName && \
  passwd $userName \
  "
  echo "$warningSymbol Set password for user : $userName"
  if [ "$targetRootFileSystem" != "" ]
  then
    chrootExecute "command" "$targetRootFileSystem" "$commandToExecute"
  else
    getAdministrativePrivileges
    local bashBinaryOnSystem=$(
      which bash
    )
    eval sudo "$bashBinaryOnSystem" -c "$commandToExecute"
  fi
}
