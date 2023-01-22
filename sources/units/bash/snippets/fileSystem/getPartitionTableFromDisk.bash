function getPartitionTableFromDisk {
  local targetDisk="$1"
  local dumpFileTargetDirectory="$2"
  source "$blocksDirectory/fileOutput/getFileName.bash"
  if [ "$dumpFileDirectory" != "" ]
  then
    dumpsDirectory="$dumpFileTargetDirectory"
  fi
  local partitionTableFromDisk="$(
    lsblk $targetDisk --paths --list --output NAME,SIZE,FSTYPE,PARTTYPENAME
  )"
  local diskName="$(
    getFileName $targetDisk
  )"
  local partitionTableFromDiskFile=$dumpsDirectory/[$diskName]partitionTable
  echo "$partitionTableFromDisk" > $partitionTableFromDiskFile
  echo "$partitionTableFromDiskFile"
}
