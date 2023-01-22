# ---
# note:
#   -	requires `root` privileges
#   -	without `wipe-partitions` older file system signatures from previously created filesystems may get picked up alongside newly created partitions
#   - in `debian` family distributions `libfdisk` applications are only available to superuser or under `/sbin`
# ---
function createPartitionTableOnDisk {
  local targetDisk="$1"
  local partitionTableFile="$2"
  local status
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  if [ "$partitionTableFile" == "" ]
  then
    echo "$failureSymbol Failed to find partition table layout template"
    return 1
  else
    getAdministrativePrivileges
    sudo sfdisk --wipe-partitions always --quiet "$targetDisk" < "$partitionTableFile" &>/dev/null
    status="$(
      echo "$?"
    )"
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to create partition table : $targetDisk"
      return 1
    else
      echo "$successSymbol Successfully created partition table : $targetDisk"
    fi
    return "$status"
  fi
}
