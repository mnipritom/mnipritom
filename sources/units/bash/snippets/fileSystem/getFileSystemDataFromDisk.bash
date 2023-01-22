# ---
# note:
#   - returns (a list of) all existing partitions or partitionUUIDs or gptUUIDs on a target disk
#   - `set -o nounset` gets triggered here because `data` is set to be a variable, but is initialized as an associative array or normal array later
#   - `sfdisk` won't return labels if the partitions are already mounted or being used
# ---
function getFileSystemDataFromDisk {
  local targetDisk="$1"
  local fieldToGet="$2"
  # Quoting this command substitution returns output as one string, not array items
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  getAdministrativePrivileges
  local partitionsOnDisk=($(
    sudo sfdisk --list $targetDisk --output Device --force --quiet | grep $targetDisk
  ))
  local data
  if [ "$fieldToGet" == "gptUUIDs" ]
  then
    for partitionIndex in "${!partitionsOnDisk[@]}"
    do
      data[$partitionIndex]="$(
        sudo sfdisk --part-type $targetDisk $(( $partitionIndex + 1 ))
      )"
    done
  elif [ "$fieldToGet" == "partitionUUIDs" ]
  then
    for partitionIndex in "${!partitionsOnDisk[@]}"
    do
      data[$partitionIndex]="$(
        sudo sfdisk --part-uuid $targetDisk $(( $partitionIndex + 1 ))
      )"
    done
  elif [ "$fieldToGet" == "partitionLabels" ]
  then
    for partitionIndex in "${!partitionsOnDisk[@]}"
    do
      # [TODO] Fix multi-word labels output
      data[$partitionIndex]="$(
        sudo sfdisk --part-label $targetDisk $(( $partitionIndex + 1 ))
      )"
    done
  elif [ "$fieldToGet" == "partitions" ]
  then
    data=(
      ${partitionsOnDisk[@]}
    )
  else
    echo "$failureSymbol Specified field is not defined : $fieldToGet"
    return 1
  fi
  if [ "${#data[@]}" != 0 ]
  then
    for entry in "${data[@]}"
    do
      echo "$entry"
    done
  else
    echo "$failureSymbol No data present for specified entry : $fieldToGet"
    return 1
  fi
}
