function unmountPartition {
  local targetPartition="$1"
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  getAdministrativePrivileges
  sudo umount --force $targetPartition &>/dev/null
  local status="$(
    echo "$?"
  )"
  echo "$status"
}
function promptUnmountPartition {
  local targetPartition="$1"
  local status="$(
    unmountPartition "$targetPartition"
  )"
  if [ "$status" != 0 ]
  then
    echo "$failureSymbol Failed to unmount : $targetPartition"
    return 1
  else
    echo "$successSymbol Successfully unmounted : $targetPartition"
  fi
}
