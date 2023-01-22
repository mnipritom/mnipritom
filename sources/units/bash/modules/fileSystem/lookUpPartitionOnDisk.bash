# ---
# note: returns (a list of) Partitions, PartitionUUIDs etc associated with GPTUUIDs, PartitionUUIDs etc of partitions from `targetDisk`
# ---
function lookUpPartitionOnDisk {
  source "$snippetsDirectory/fileSystem/getFileSystemDataFromDisk.bash"
  local targetDisk="$1"
  local entryType="$2"
  local entryToLookUp="$3"
  local entryToReturn
  # Quoting these command substitution returns output as one string, not array items
  local gptUUIDList=($(
    getFileSystemDataFromDisk "$targetDisk" "gptUUIDs"
  ))
  local partitions=($(
    getFileSystemDataFromDisk "$targetDisk" "partitions"
  ))
  local partitionLabels=($(
    getFileSystemDataFromDisk "$targetDisk" "partitionLabels"
  ))
  local partitionUUIDList=($(
    getFileSystemDataFromDisk "$targetDisk" "partitionUUIDs"
  ))
  declare -A partitionDictionary
  for partitionIndex in "${!partitions[@]}"
  do
    local gptUUID="${gptUUIDList[$partitionIndex]}"
    local partition="${partitions[$partitionIndex]}"
    local partitionUUID="${partitionUUIDList[$partitionIndex]}"
    local partitionLabel="${partitionLabels[$partitionIndex]}"
    if [ "$entryType" == "partitionUUIDbyGPTUUID" ]
    then
      partitionDictionary["$partitionUUID"]="$gptUUID"
    elif [ "$entryType" == "partitionUUIDbyPartition" ]
    then
      partitionDictionary["$partitionUUID"]="$partition"
    elif [ "$entryType" == "partitionUUIDbyPartitionLabel" ]
    then
      partitionDictionary["$partitionUUID"]="$partitionLabel"
    elif [ "$entryType" == "partitionByGPTUUID" ]
    then
      partitionDictionary["$partition"]="$gptUUID"
    elif [ "$entryType" == "partitionByPartitionLabel" ]
    then
      partitionDictionary["$partition"]="$partitionLabel"
    else
      continue
    fi
  done
  if [ "${#partitionDictionary[@]}" == 0 ]
  then
    echo "$failureSymbol Please specify the fields of the partition table to look up"
    return 1
  else
    for entry in "${!partitionDictionary[@]}"
    do
      local partitionEntry="$entry"
      local entryToCompare="${partitionDictionary[$entry]}"
      if [ "$entryToCompare" == "$entryToLookUp" ]
      then
        entryToReturn="$partitionEntry"
        echo "$entryToReturn"
      fi
    done
    if [ "$entryToReturn" == "" ]
    then
      echo "$failureSymbol File system does not exist for entry : $entryToLookUp $targetDisk"
      return 1
    fi
  fi
}
