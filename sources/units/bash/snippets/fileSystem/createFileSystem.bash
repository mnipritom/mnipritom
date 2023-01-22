function createFileSystem {
  local fileSystemFormat="$1"
  local targetPartition="$2"
  declare -A makeFileSystemCommands=(
    ["fat"]="mkfs.fat -F 32"
    ["ext4"]="mkfs.ext4"
    ["ext3"]="mkfs.ext3"
  )
  local commandToExecute
  local fileFormatStatus
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  for definedFileSystemFormat in "${!makeFileSystemCommands[@]}"
  do
    if [ "$definedFileSystemFormat" == "$fileSystemFormat" ]
    then
      fileFormatStatus=0
      commandToExecute="${makeFileSystemCommands["$fileSystemFormat"]}"
      break
    else
      fileFormatStatus=1
    fi
  done
  if [ "$fileFormatStatus" != 0 ]
  then
    echo "$failureSymbol FileSystem is not yet implemented : $fileSystemFormat"
    return 1
  else
    getAdministrativePrivileges
    eval sudo $commandToExecute $targetPartition &>/dev/null
    local status="$(
      echo "$?"
    )"
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to create file system : $fileSystemFormat -> $targetPartition"
    else
      echo "$successSymbol Successfully created file system : $fileSystemFormat -> $targetPartition"
    fi
    return "$status"
  fi
}
