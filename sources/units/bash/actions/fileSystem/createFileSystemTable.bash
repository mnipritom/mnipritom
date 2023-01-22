# ---
# note:
#   - `PARTUUID` won't work with `btrfs` file systems
# ---
function createFileSystemTable {
  local target="$1"
  source "$modulesDirectory/fileSystem/lookUpPartitionOnDisk.bash"
  source "$blocksDirectory/fileSystem/getPartitionFileSystemType.bash"
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  source "$blocksDirectory/fileSystem/deleteDirectory.bash"
  source "$snippetsDirectory/baseSystem/getHostDistribution.bash"
  source "$snippetsDirectory/fileSystem/mountToDirectory.bash"
  source "$snippetsDirectory/fileSystem/unmountPartition.bash"
  source "$blocksDirectory/baseSystem/setAliases.bash"
  setAliases "on" &>/dev/null
  alias awk="gawk"
  local fileSystemTable="$dumpsDirectory/fstab"
  local targetMountingPoint="/tmp/fstab-generation"
  local destination
  local hostDistribution=$(
    getHostDistribution
  )
  local targetStatus="$(
    local targetType=$(
      if [ -d "$target" ]
      then
        echo "directory"
      else
        local targetSpecifications=($(
          lsblk "$target" --output TYPE --noheadings
        ))
        if [ "${targetSpecifications[0]}" == "disk" ]
        then
          echo "disk"
        elif [ "${targetSpecifications[0]}" == "part" ]
        then
          echo "partition"
        fi
      fi
    )
    echo "$targetType"
  )"
  echo "$processingSymbol Creating file system table : $target"
  touch "$fileSystemTable"
  if [ "$targetStatus" == "directory" ] || [ "$targetStatus" == "partition" ]
  then
    if [ "$targetStatus" == "directory" ]
    then
      local targetRootFileSystem="$target"
    elif [ "$targetStatus" == "partition" ]
    then
      mountToDirectory "$target" "$targetMountingPoint"
      local targetRootFileSystem="$targetMountingPoint"
    fi
    getAdministrativePrivileges
    if [ "$hostDistribution" == "arch" ]
    then
      echo "$processingSymbol Utilizing $hostDistribution : genfstab"
      sudo bash -c "genfstab -t PARTUUID $targetRootFileSystem > $fileSystemTable"
    elif [ "$hostDistribution" == "artix" ]
    then
      echo "$processingSymbol Utilizing $hostDistribution : fstabgen"
      sudo bash -c "fstabgen -t PARTUUID $targetRootFileSystem > $fileSystemTable"
    else
      echo "$failureSymbol Failed to find file system table generator : $target"
      echo "$warningSymbol Try changing target type : $targetStatus"
      return 1
    fi
    destination="$targetRootFileSystem/etc/fstab"
  elif [ "$targetStatus" == "disk" ]
  then
    local targetDisk="$target"
    local rootPartition=$(
      lookUpPartitionOnDisk "$targetDisk" "partitionByGPTUUID" "4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709"
    )
    local rootPartitionUUID=$(
      lookUpPartitionOnDisk "$targetDisk" "partitionUUIDbyGPTUUID" "4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709" | awk '{print tolower($0)}'
    )
    local rootPartitionFileSystemType=$(
      getPartitionFileSystemType "$rootPartition"
    )
    local homePartition=$(
      lookUpPartitionOnDisk "$targetDisk" "partitionByGPTUUID" "933AC7E1-2EB4-4F13-B844-0E14E2AEF915"
    )
    local homePartitionUUID=$(
      lookUpPartitionOnDisk "$targetDisk" "partitionUUIDbyGPTUUID" "933AC7E1-2EB4-4F13-B844-0E14E2AEF915" | awk '{print tolower($0)}'
    )
    local homePartitionFileSystemType=$(
      getPartitionFileSystemType "$homePartition"
    )
    local bootPartition=$(
      lookUpPartitionOnDisk "$targetDisk" "partitionByPartitionLabel" "bootloader"
    )
    local bootPartitionUUID=$(
      lookUpPartitionOnDisk "$targetDisk" "partitionUUIDbyPartitionLabel" "bootloader" | awk '{print tolower($0)}'
    )
    local bootPartitionFileSystemType=$(
      getPartitionFileSystemType "$bootPartition"
    )
    local mediaPartition=$(
      lookUpPartitionOnDisk "$targetDisk" "partitionByPartitionLabel" "media"
    )
    local mediaPartitionUUID=$(
      lookUpPartitionOnDisk "$targetDisk" "partitionUUIDbyPartitionLabel" "media" | awk '{print tolower($0)}'
    )
    local mediaPartitionFileSystemType=$(
      getPartitionFileSystemType "$mediaPartition"
    )
    printf "# ---\n" > "$fileSystemTable"
    printf "# author        : $worktreeIdentifier\n" >> "$fileSystemTable"
    printf "# description   : automount partitions of $targetDisk at startup\n" >> "$fileSystemTable"
    printf "# note          : does not support btrfs\n" >> "$fileSystemTable"
    printf "# ---\n" >> "$fileSystemTable"
    printf "PARTUUID=%s\t%s\t%s\n" "$rootPartitionUUID" "/" "$rootPartitionFileSystemType defaults 1" >> "$fileSystemTable"
    printf "PARTUUID=%s\t%s\t%s\n" "$homePartitionUUID" "/home" "$homePartitionFileSystemType defaults 2" >> "$fileSystemTable"
    printf "PARTUUID=%s\t%s\t%s\n" "$mediaPartitionUUID" "/media" "$mediaPartitionFileSystemType defaults 2" >> "$fileSystemTable"
    printf "PARTUUID=%s\t%s\t%s\n" "$bootPartitionUUID" "/boot/efi" "$bootPartitionFileSystemType defaults 2" >> "$fileSystemTable"
    printf "%s\t%s\t%s\n" "tmpfs" "/tmp" "tmpfs defaults,nosuid,nodev 0 0" >> "$fileSystemTable"
    mountToDirectory "$rootPartition" "$targetMountingPoint"
    destination="$targetMountingPoint/etc/fstab"
  else
    echo "$failureSymbol Can not create file system table : $target"
    echo "$warningSymbol Try changing target type : $targetStatus"
    return 1
  fi
  getAdministrativePrivileges
  local status=$(
    sudo mv "$fileSystemTable" "$destination"
    echo "$?"
  )
  if [ "$status" != 0 ] && [ ! -f "$destination" ]
  then
    echo "$failureSymbol Failed to create file system table : $destination"
  else
    echo "$successSymbol Successfully created file system table : $destination"
  fi
  if [ "$targetStatus" == "disk" ]
  then
    promptUnmountPartition "$rootPartition"
    promptDeleteDirectory "$targetMountingPoint" "privileged"
  fi
  setAliases "off" &>/dev/null
  return "$status"
}
