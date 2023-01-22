function mountToDirectory {
  local toBeMounted="$1"
  local mountTarget="$2"
  local status
  source "$blocksDirectory/fileSystem/createDirectory.bash"
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  function mount {
    getAdministrativePrivileges
    sudo mount "$toBeMounted" "$mountTarget" &>/dev/null
    status="$(
      echo "$?"
    )"
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to mount : $toBeMounted -> $mountTarget"
      return 1
    else
      echo "$successSymbol Successfully mounted : $toBeMounted -> $mountTarget"
      return 0
    fi
  }
  if [ -d "$mountTarget" ]
  then
    mount
  else
    status="$(
      getAdministrativePrivileges
      createDirectory "$mountTarget" "privileged"
    )"
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to create directory : $mountTarget"
      echo "$failureSymbol Can not mount to non-existent directory : $mountTarget"
      return 1
    else
      mount
    fi
  fi
}
