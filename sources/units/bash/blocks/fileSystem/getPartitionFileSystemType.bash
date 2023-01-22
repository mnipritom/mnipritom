function getPartitionFileSystemType {
  local targetPartition="$1"
  local fileSystemType=$(
    lsblk "$targetPartition" --output FSTYPE --noheadings
  )
  echo "$fileSystemType"
}
