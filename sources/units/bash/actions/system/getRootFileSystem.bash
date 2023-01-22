function getRootFileSystem {
  local targetDisk="$1"
  local state="$2"
  local targetRootFileSystem
  source "$modulesDirectory/fileSystem/lookUpPartitionOnDisk.bash"
  source "$blocksDirectory/fileOutput/getFileName.bash"
  local diskName=$(
    getFileName "$targetDisk"
  )
  local targetMountingPoint="/tmp/$diskName-root-file-system"
  local targetRootPartition=$(
    lookUpPartitionOnDisk "$targetDisk" "partitionByGPTUUID" "4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709"
  )
  local targetESP=$(
    lookUpPartitionOnDisk "$targetDisk" "partitionByPartitionLabel" "bootloader"
  )
  local targetMedia=$(
    lookUpPartitionOnDisk "$targetDisk" "partitionByPartitionLabel" "media"
  )
  if [ "$state" == "mounted" ]
  then
    source "$snippetsDirectory/fileSystem/mountToDirectory.bash"
    source "$blocksDirectory/fileSystem/createDirectory.bash"
    promptCreateDirectory "$targetMountingPoint" &>/dev/null
    mountToDirectory "$targetRootPartition" "$targetMountingPoint" &>/dev/null
    mountToDirectory "$targetESP" "$targetMountingPoint/boot/efi" &>/dev/null
    if [ -d "$targetMountingPoint" ]
    then
      targetRootFileSystem="$targetMountingPoint"
      echo "$targetMountingPoint"
    else
      echo "$failureSymbol Failed to mount root partition : $targetRootPartition -> $targetMountingPoint"
      return 1
    fi
  elif [ "$state" == "unmounted" ]
  then
    source "$snippetsDirectory/fileSystem/unmountPartition.bash"
    source "$blocksDirectory/fileSystem/deleteDirectory.bash"
    promptUnmountPartition "$targetESP" &>/dev/null
    promptUnmountPartition "$targetRootPartition" &>/dev/null
    promptDeleteDirectory "$targetMountingPoint" &>/dev/null
  else
    echo "$failureSymbol Failed to find state : $state"
    return 1
  fi
}
