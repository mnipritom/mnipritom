function getFileSystemFormat {
  # expecting lsblk lowercase UUIDs
  local gptUUID="$( echo "$1" | awk '{ print toupper($0) }' )"
  declare -A definedFileSystemFormatsForGPTUUID=(
    ["C12A7328-F81F-11D2-BA4B-00A0C93EC93B"]="fat" 				# esp
    ["4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709"]="ext4" 			# root-X86-64
    ["B921B045-1DF0-41C3-AF44-4C6F280D3FAE"]="ext4"			  # root-AARCH64
    ["933AC7E1-2EB4-4F13-B844-0E14E2AEF915"]="ext4" 			# home
    ["0FC63DAF-8483-4772-8E79-3D69D8477DE4"]="ext4" 			# data
  )
  local status
  for definedGPTUUID in "${!definedFileSystemFormatsForGPTUUID[@]}"
  do
    local fileSystemFormat="${definedFileSystemFormatsForGPTUUID[$definedGPTUUID]}"
    if [ "$definedGPTUUID" == "$gptUUID" ]
    then
      status=0
      echo "$fileSystemFormat"
      break
    else
      status=1
    fi
  done
  if [ "$status" != 0 ]
  then
    echo "$failureSymbol File system format is not defined for GPT UUID : $gptUUID"
    return "$status"
  fi
}
