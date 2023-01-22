function wipeAllExistingFileSystems {
  local targetDisk="$1"
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  getAdministrativePrivileges
  sudo wipefs --force --all "$targetDisk" &>/dev/null
  local status="$(
    echo "$?"
  )"
  if [ "$status" != 0 ]
  then
    echo "$failureSymbol Failed to wipe file systems : $targetDisk"
  else
    echo "$successSymbol Successfully wiped all file systems : $targetDisk"
  fi
  return "$status"
}
