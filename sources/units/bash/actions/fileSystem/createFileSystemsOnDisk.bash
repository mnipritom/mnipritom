function createFileSystemsOnDisk {
  local targetDisk="$1"
  local status
  source "$snippetsDirectory/fileSystem/getFileSystemDataFromDisk.bash"
  source "$blocksDirectory/fileSystem/getFileSystemFormat.bash"
  source "$snippetsDirectory/fileSystem/createFileSystem.bash"
  source "$modulesDirectory/fileSystem/lookUpPartitionOnDisk.bash"
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  # `sort --unique` prevents duplicate GPTUUID entries, which would cause `lookUpPartitionOnDisk` to report the same partition twice
  # `uniq` does not work properly
  getAdministrativePrivileges
  local gptUUIDsOnDisk=($(
    getFileSystemDataFromDisk "$targetDisk" "gptUUIDs" | sort --unique
  ))
  for gptUUID in "${gptUUIDsOnDisk[@]}"
  do
    # Quoting this command substitution returns output as one string, not array items
    local partitionsOnDisk=($(
      lookUpPartitionOnDisk "$targetDisk" "partitionByGPTUUID" "$gptUUID"
    ))
    local fileSystemFormat="$(
      getFileSystemFormat $gptUUID
    )"
    for partition in "${partitionsOnDisk[@]}"
    do
      createFileSystem "$fileSystemFormat" "$partition"
    done
  done
}
