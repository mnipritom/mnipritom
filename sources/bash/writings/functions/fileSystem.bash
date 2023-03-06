function createDirectory {
  local targetDirectory="$1"
  local directoryType="$2"
  if [ "$directoryType" == "privileged" ]
  then
    eval "sudo mkdir --parents $targetDirectory" &>/dev/null
  elif [ "$directoryType" == "" ]
  then
    mkdir --parents "$targetDirectory" &>/dev/null
  fi
  local status="$(
    echo "$?"
  )"
  echo "$status"
}
function promptCreateDirectory {
  local targetDirectory="$1"
  local directoryType="$2"
  local status="$( createDirectory "$targetDirectory" "$directoryType" )"
  if [ "$status" != 0 ]
  then
    echo "$failureSymbol Failed to create directory : $targetDirectory"
  else
    echo "$successSymbol Successfully created directory : $targetDirectory"
  fi
}
function createSymbolicLink {
  local source="$1"
  local target="$2"
  local sourcePath="$(
    realpath "$source"
  )"
  local targetPath="$(
    realpath "$target"
  )"
  local status=$(
    ln --symbolic "$sourcePath" "$targetPath" &>/dev/null
    printf "%s" "$?"
  )
  printf "%s" "$status"
}
function promptCreateSymbolicLink {
  local source="$1"
  local target="$2"
  local status=$(
    createSymbolicLink "$source" "$target"
  )
  if [ "$status" != 0 ]
  then
    printf "%s\n" "$failureSymbol Failed to create symbolic link : $source -> $target"
  else
    printf "%s\n" "$successSymbol Successfully created symbolic link : $source -> $target"
  fi
}
function deleteDirectory {
  local targetDirectory="$1"
  local directoryType="$2"
  if [ "$directoryType" == "privileged" ]
  then
    eval "sudo rm --recursive --force $targetDirectory" &>/dev/null
  elif [ "$directoryType" == "" ]
  then
    rm --recursive --force "$targetDirectory" &>/dev/null
  fi
  local status="$(
    echo "$?"
  )"
  echo "$status"
}
function promptDeleteDirectory {
  local targetDirectory="$1"
  local directoryType="$2"
  local status="$( deleteDirectory "$targetDirectory" "$directoryType" )"
  if [ "$status" != 0 ]
  then
    echo "$failureSymbol Failed to delete directory : $targetDirectory"
  else
    echo "$successSymbol Successfully deleted directory : $targetDirectory"
  fi
}
function downloadFromURL {
  local link="$1"
  local method="$2"
  local targetDirectory="$3"

  source "$blocksDirectory/fileSystem/createDirectory.bash"
  local status
  if [ "$targetDirectory" != "" ]
  then
    downloadsDirectory="$targetDirectory"
  fi
  local downloadedFile="$downloadsDirectory/$(
    getFileName "$link"
  )"
  if [ ! -d "$downloadsDirectory" ]
  then
    status="$(
      createDirectory "$downloadsDirectory"
    )"
  else
    status=0
  fi
  if [ "$status" != 0 ]
  then
    echo "$failureSymbol Failed to create directory : $targetDirectory"
    return 1
  else
    if [ "$method" == "wget" ]
    then
      status="$(
        wget "$link" --directory-prefix="$downloadsDirectory"
        echo "$?"
      )"
    elif [ "$method" == "git" ]
    then
      # git will make `downloadedFile` into a directory otherwise will throw error
      status="$(
        git clone "$link" "$downloadedFile"
        echo "$?"
      )"
    elif [ "$method" == "curl" ]
    then
      echo "$failureSymbol Not yet implemented : $method"
      status=1
    else
      echo "$failureSymbol No download method defined : $method"
      echo "$failureSymbol Can not download from : $link"
      status=1
    fi
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to download : $link"
      return "$status"
    else
      echo "$downloadedFile"
    fi
  fi
}
function promptDownloadFromURL {
  local link="$1"
  local method="$2"
  local targetDirectory="$3"
  local downloadedFile="$(
    downloadURL "$link" "$method" "$targetDirectory"
  )"
  if [ ! -f "$downloadedFile" ]
  then
    echo "$failureSymbol Failed to download file"
    return 1
  else
    echo "$successSymbol Successfully downloaded file : $link -> $downloadedFile"
  fi
}
function extractArchive {
  local fileToExtract="$1"
  local targetDirectory="$2"

  source "$blocksDirectory/fileSystem/createDirectory.bash"
  local status
  if [ "$targetDirectory" != "" ]
  then
    extractsDirectory="$targetDirectory"
  fi
  local extractedFile="$extractsDirectory/$(
    getFileName "$fileToExtract"
  ).extracted"
  if [ ! -d "$extractsDirectory" ]
  then
    status="$(
      createDirectory "$extractsDirectory"
    )"
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to create directory : $extractsDirectory"
      return 1
    fi
  else
    status=0
  fi
  tar --list --file $fileToExtract &>/dev/null
  status="$(
    echo "$?"
  )"
  if [ "$status" != 0 ]
  then
    echo "$warningSymbol Not an archive file : $fileToExtract"
    return "$status"
  else
    tar --extract --file "$fileToExtract" --directory "$extractsDirectory" --one-top-level="$extractedFile" &>/dev/null
    status="$(
      echo "$?"
    )"
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to extract : $fileToExtract -> $extractsDirectory"
      return "$status"
    else
      echo "$extractedFile"
    fi
  fi
}
function promptExtractArchive {
  local fileToExtract="$1"
  local targetDirectory="$2"
  local extractedFile=$(
    extractArchive "$fileToExtract" "$targetDirectory"
  )
  if [ ! -f "$extractedFile" ]
  then
    echo "$failureSymbol Failed to extract archive"
    return 1
  else
    echo "$successSymbol Successfully extracted archive : $fileToExtract -> $targetDirectory"
  fi
}
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
function getPartitionFileSystemType {
  local targetPartition="$1"
  local fileSystemType=$(
    lsblk "$targetPartition" --output FSTYPE --noheadings
  )
  echo "$fileSystemType"
}
# ---
# note   : `exclude` 7 (loops), 11 (ROMs), 251 (swaps)
# ---
function listAvailableDisks {
  lsblk --paths --nodeps --noheadings --exclude 7,11,251 --output NAME,VENDOR,TYPE,SIZE
}
function copyDirectory {
  local source="$1"
  local destination="$2"
  source "$blocksDirectory/fileSystem/createDirectory.bash"
  local status
  if [ ! -d "$destination" ]
  then
    status="$(
      createDirectory "$destination"
    )"
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to create directory : $destination"
      return 1
    fi
  fi
  cp --recursive "$source" "$destination" &>/dev/null
  status="$(
    echo "$?"
  )"
  echo "$status"
}
function promptCopyDirectory {
  local source="$1"
  local destination="$2"
  local status="$(
    copyDirectory "$source" "$destination"
  )"
  if [ "$status" != 0 ]
  then
    echo "$failureSymbol Failed to copy directory : $source -> $destination"
  else
    echo "$successSymbol Successfully copied directory : $source -> $destination"
  fi
}
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
# ---
# note:
#   - requires `root` privileges
#   - without `wipe-partitions` older file system signatures from previously created filesystems may get picked up alongside newly created partitions
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
function mountToDirectory {
  local toBeMounted="$1"
  local mountTarget="$2"
  local status
  source "$blocksDirectory/fileSystem/createDirectory.bash"
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  function mount {
    getAdministrativePrivileges
    sudo mount "$toBeMounted" "$mountTarget" &>/dev/null
    status="$(
      echo "$?"
    )"
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to mount : $toBeMounted -> $mountTarget"
      return 1
    else
      echo "$successSymbol Successfully mounted : $toBeMounted -> $mountTarget"
      return 0
    fi
  }
  if [ -d "$mountTarget" ]
  then
    mount
  else
    status="$(
      getAdministrativePrivileges
      createDirectory "$mountTarget" "privileged"
    )"
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to create directory : $mountTarget"
      echo "$failureSymbol Can not mount to non-existent directory : $mountTarget"
      return 1
    else
      mount
    fi
  fi
}
function unmountPartition {
  local targetPartition="$1"
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  getAdministrativePrivileges
  sudo umount --force $targetPartition &>/dev/null
  local status="$(
    echo "$?"
  )"
  echo "$status"
}
function promptUnmountPartition {
  local targetPartition="$1"
  local status="$(
    unmountPartition "$targetPartition"
  )"
  if [ "$status" != 0 ]
  then
    echo "$failureSymbol Failed to unmount : $targetPartition"
    return 1
  else
    echo "$successSymbol Successfully unmounted : $targetPartition"
  fi
}
function wipeAllExistingFileSystems {
  local targetDisk="$1"
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  getAdministrativePrivileges
  sudo wipefs --force --all "$targetDisk" &>/dev/null
  local status="$(
    echo "$?"
  )"
  if [ "$status" != 0 ]
  then
    echo "$failureSymbol Failed to wipe file systems : $targetDisk"
  else
    echo "$successSymbol Successfully wiped all file systems : $targetDisk"
  fi
  return "$status"
}
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
function installBootloader {
  local bootloader="$1"
  local targetDisk="$2"
  source "$actionsDirectory/system/getRootFileSystem.bash"
  source "$modulesDirectory/baseSystem/chrootExecute.bash"
  source "$snippetsDirectory/baseSystem/getBinaryPath.bash"
  source "$actionsDirectory/baseSystem/synchronizeSystemRepositories.bash"
  source "$actionsDirectory/baseSystem/installPackage.bash"
  source "$snippetsDirectory/baseSystem/getHostDistribution.bash"
  source "$modulesDirectory/baseSystem/getHostDistributionPackageManager.bash"

  local targetRootFileSystem=$(
    getRootFileSystem "$targetDisk"  "mounted"
  )

  local targetHostDistribution=$(
    getHostDistribution "$targetRootFileSystem"
  )
  local targetPackageManager=$(
    getHostDistributionPackageManager "$targetHostDistribution"
  )

  if [ "$bootloader" == "grub" ]
  then
    # [TODO] consider `update-grub` for `debian` derrivatives
    local GRUBConfigGenerator="grub-mkconfig"
    local GRUBConfigGeneratorExecutable=$(
      getBinaryPath "$GRUBConfigGenerator" "$targetRootFileSystem"
    )
    local GRUBInstaller="grub-install"
    local GRUBInstallerExecutable=$(
      getBinaryPath "$GRUBInstaller" "$targetRootFileSystem"
    )
    # [TODO] implement support for `aarch64`
    local GRUBInstallationCommand="\
      $GRUBInstallerExecutable \
      --bootloader-id=$bootloader \
      --target=x86_64-efi \
      --efi-directory=/boot/efi/EFI \
      --boot-directory=/boot \
      --removable \
    "
    local GRUBConfigGeneratorCommand="\
      $GRUBConfigGeneratorExecutable \
      --output /boot/grub/grub.cfg \
    "
    # [TODO] implement support for `aarch64`
    local targetArchitecture
    if [ "$targetHostDistribution" != "void" ] || [ "$targetHostDistribution" != "opensuse" ]
    then
      targetArchitecture="amd64"
    elif [ "$targetHostDistribution" == "fedora" ]
    then
      targetArchitecture="x64"
    else
      targetArchitecture="x86_64"
    fi
    declare -A distributionGRUBpackages=(
      ["void"]="grub-$targetArchitecture-efi"
      ["artix"]="grub"
      ["arch"]="grub"
      ["devuan"]="grub-efi-$targetArchitecture"
      ["debian"]="grub-efi-$targetArchitecture"
      ["kali"]="grub-efi-$targetArchitecture"
      ["parrot"]="grub-efi-$targetArchitecture"
      ["ubuntu"]="grub-efi-$targetArchitecture"
      # [TODO] fedora: consider `grub2-efi-$targetArchitecture-modules`,`shim`
      ["fedora"]="grub2-efi-$targetArchitecture"
      # [TODO] opensuse: consider `shim`
      ["opensuse"]="grub2-$targetArchitecture-efi"
    )
    local GRUBPackage="${distributionGRUBpackages[$targetHostDistribution]}"

    synchronizeSystemRepositories "$targetRootFileSystem"

    installPackage "$GRUBPackage" "$targetPackageManager" "$targetRootFileSystem"
    installPackage "efibootmgr" "$targetPackageManager" "$targetRootFileSystem"
    installPackage "os-prober" "$targetPackageManager" "$targetRootFileSystem"

    echo "$processingSymbol Installing bootloader : $bootloader -> $targetDisk"
    chrootExecute "command" "$targetRootFileSystem" "$GRUBInstallationCommand"

    echo "$processingSymbol Generating configuration : $bootloader -> $targetDisk"
    chrootExecute "command" "$targetRootFileSystem" "$GRUBConfigGeneratorCommand"

  elif [ "$bootloader" == "refind" ]
  then
    echo "$failureSymbol Not yet implemented : $bootloader"
    return 1
  elif [ "$bootloader" == "clover" ]
  then
    echo "$failureSymbol Not yet implemented : $bootloader"
    return 1
  else
    echo "$failureSymbol Bootloader installation method not defined : $bootloader"
    return 1
  fi

  getRootFileSystem "$targetDisk" "unmounted"

}
function installKernel {
  # [TODO] implement support for GNU `Hurd`
  local kernalName="$1"
  local targetDisk="$2"
  source "$snippetsDirectory/baseSystem/getBinaryPath.bash"
  source "$snippetsDirectory/baseSystem/getHostDistribution.bash"
  source "$modulesDirectory/baseSystem/getHostDistributionPackageManager.bash"
  source "$actionsDirectory/system/getRootFileSystem.bash"
  source "$actionsDirectory/baseSystem/installPackage.bash"

  # [TODO] implement support for `aarch64`
  local targetArchitecture
  if [ "$targetHostDistribution" != "void" ] || [ "$targetHostDistribution" != "opensuse" ]
  then
    targetArchitecture="amd64"
  elif [ "$targetHostDistribution" == "fedora" ]
  then
    targetArchitecture="x64"
  else
    targetArchitecture="x86_64"
  fi
  declare -A distributionLinuxPackageNames=(
    ["void"]="linux"
    ["devuan"]="linux-image-$targetArchitecture"
    ["debian"]="linux-image-$targetArchitecture"
    ["ubuntu"]="linux-image-generic"
    ["artix"]="linux"
    ["arch"]="linux"
    ["fedora"]="kernel"
    ["opensuse"]="kernel-default"
  )
  if [ "$targetDisk" != "" ]
  then
    local targetRootFileSystem=$(
      getRootFileSystem "$targetDisk" "mounted"
    )
    local targetDistribution=$(
      getHostDistribution "$targetRootFileSystem"
    )
    local targetPackageManager=$(
      getHostDistributionPackageManager "$targetDistribution"
    )

    local kernelPackageName="${distributionLinuxPackageNames[$targetDistribution]}"

    installPackage "$kernelPackageName" "$targetPackageManager" "$targetRootFileSystem"

    getRootFileSystem "$targetDisk" "unmounted"
  else
    local targetDistribution=$(
      getHostDistribution
    )
    local kernelPackageName="${distributionLinuxPackageNames[$targetDistribution]}"
    installPackage "$kernelPackageName"
  fi
}
function installDistribution {
  local targetDistribution="$1"
  local targetDisk="$2"
  source "$actionsDirectory/system/getRootFileSystem.bash"
  source "$blocksDirectory/baseSystem/setAliases.bash"
  source "$blocksDirectory/baseSystem/setStrictExecution.bash"
  source "$actionsDirectory/baseSystem/synchronizeSystemRepositories.bash"
  source "$actionsDirectory/baseSystem/installPackage.bash"
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  local hostDistribution=$(
    source "$snippetsDirectory/baseSystem/getHostDistribution.bash"
    getHostDistribution
  )
  function initiateBootstrap {
    local targetRootFileSystem="$1"
    source "$actionsDirectory/baseSystem/setLocale.bash"
    source "$actionsDirectory/baseSystem/setHostname.bash"
    source "$snippetsDirectory/baseSystem/copyHostDNSConfigurations.bash"
    if [ "$targetDistribution" == "" ]
    then
      local targetDistribution=$(
        local availableDistributions=($(
          getAvailableDistributions
        ))
        local selectedDistribution=$(
          local message="$warningSymbol Select distribution to install"
          printf "%s\n" "${availableDistributions[@]}" | fzf --header "$message"
        )
        echo "$selectedDistribution"
      )
    fi
    local bootstrapMode=$(
      local flexibleDistributions=(
        "void"
        "devuan"
        "debian"
      )
      declare -A configuredDistributions=(
        # [TODO] implement `nix` `guix` `hyperbola` `parabola` `trisquel`
        ["assisted"]="artix arch fedora opensuse"
        ["agnostic"]="ubuntu kali parrot"
      )
      for distribution in "${flexibleDistributions[@]}"
      do
        if [ "$targetDistribution" == "$hostDistribution" ]
        then
          local availableAssistedDistributions=(
            "${configuredDistributions["assisted"]}"
          )
          availableAssistedDistributions+=(
            "$targetDistribution"
          )
          configuredDistributions["assisted"]="${availableAssistedDistributions[@]}"
          break
        else
          local availableAgnosticDistributions=(
            "${configuredDistributions["agnostic"]}"
          )
          availableAgnosticDistributions+=(
            "$targetDistribution"
          )
          configuredDistributions["agnostic"]="${availableAgnosticDistributions[@]}"
          break
        fi
      done
      if grep --ignore-case --quiet "$targetDistribution" <<< "${configuredDistributions["assisted"]}"
      then
        echo "assisted"
      elif grep --ignore-case --quiet "$targetDistribution" <<< "${configuredDistributions["agnostic"]}"
      then
        echo "agnostic"
      else
        echo "$failureSymbol Failed to find bootstrap mode : $targetDistribution"
        return 1
      fi
    )
    local targetArchitecture=$(
      # [TODO] implement support for `aarch64`
      local availableArchitecture="x86_64"
      if [ "$targetDistribution" != "void" ]
      then
        availableArchitecture="amd64"
      fi
      echo "$availableArchitecture"
    )
    function initiateDistributionAssistedBootstrap {
      local targetRootFileSystem="$1"
      local targetDistribution="$2"
      local bootstrapHandler=$(
        declare -A bootstrapHandlers=(
          # [TODO] implement `nix` `guix` `hyperbola` `parabola` `trisquel`
          ["void"]="xbps"
          ["artix"]="basestrap"
          ["arch"]="pacstrap"
          ["fedora"]="dnf"
          ["opensuse"]="zypper"
          ["devuan"]="debootstrap"
          ["debian"]="debootstrap"
          ["ubuntu"]="debootstrap"
          ["parrot"]="debootstrap"
          ["kali"]="debootstrap"
        )
        echo "${bootstrapHandlers["$targetDistribution"]}"
      )
      local xbpsRepository="https://repo-default.voidlinux.org/current"
      declare -A bootstrapHandlersCommands=(
        # [TODO] implement `nix` `guix` `hyperbola` `parabola` `trisquel`
        ["xbps"]="XBPS_ARCH=$targetArchitecture xbps-install --sync --yes --repository $xbpsRepository --rootdir $targetRootFileSystem base-system"
        ["basestrap"]="basestrap $targetRootFileSystem base runit elogind-runit"
        ["pacstrap"]="pacstrap $targetRootFileSystem base"
        ["debootstrap"]="debootstrap --arch=$targetArchitecture stable $targetRootFileSystem"
        ["dnf"]="dnf --releasever=/ --installroot=$targetRootFileSystem groupinstall core --assumeyes"
        ["zypper"]="zypper --non-interactive --installroot $targetRootFileSystem --type pattern base"
      )
      local bootstrapHandlerCommand="${bootstrapHandlersCommands["$bootstrapHandler"]}"
      echo "$processingSymbol Configuring bootstrap prerequisites : $bootstrapHandler"
      if [ "$bootstrapHandler" == "xbps" ]
      then
        local xbpsRSAKeysDirectory="var/db/xbps/keys"
        setStrictExecution "on"
        source "$blocksDirectory/fileSystem/createDirectory.bash"
        getAdministrativePrivileges
        promptCreateDirectory "$targetRootFileSystem/var/db/xbps/keys" "privileged"
        eval sudo cp --recursive "/$xbpsRSAKeysDirectory/." "$targetRootFileSystem/$xbpsRSAKeysDirectory/"
        setStrictExecution "off"
      elif [ "$bootstrapHandler" == "debootstrap" ]
      then
        setStrictExecution "on"
        synchronizeSystemRepositories
        installPackage "debootstrap"
        setStrictExecution "off"
      else
        echo "$warningSymbol No prerequisites required : $bootstrapHandler"
      fi
      getAdministrativePrivileges
      eval sudo "$bootstrapHandlerCommand"
      echo "$processingSymbol Configuring post bootstrap procedures : $bootstrapHandler"
      if [ "$bootstrapHandler" == "debootstrap" ]
      then
        local aptSourcesFile="etc/apt/sources.list"
        if [ -f "/$aptSourcesFile" ]
        then
          if [ -d "$targetRootFileSystem/etc/apt" ] && [ -f "$targetRootFileSystem/$aptSourcesFile" ]
          then
            getAdministrativePrivileges
            sudo rm --force "$targetRootFileSystem/$aptSourcesFile"
            echo "$processingSymbol Copying apt sources : $targetRootFileSystem/$aptSourcesFile"
            sudo cp "/$aptSourcesFile" "$targetRootFileSystem/$aptSourcesFile"
          fi
        fi
      else
        echo "$warningSymbol No post bootstrap procedures required : $bootstrapHandler"
      fi
    }
    function initiateDistributionAgnosticBootstrap {
      local targetRootFileSystem="$1"
      local targetDistribution="$2"
      source "$snippetsDirectory/baseSystem/extractArchive.bash"
      source "$blocksDirectory/baseSystem/deleteDirectory.bash"
      local debootstrapDistributions=(
        "devuan"
        "debian"
        "ubuntu"
        "parrot"
        "kali"
      )
      function getDistributionResources {
        local targetDistribution="$1"
        source "$snippetsDirectory/baseSystem/downloadFromURL.bash"
        declare -A resourcesProviders=(
          ["void"]="https://alpha.de.repo.voidlinux.org/live/current/void-$targetArchitecture-ROOTFS-20210930.tar.xz"
          ["devuan"]="https://git.devuan.org/devuan/debootstrap.git"
          ["debian"]="https://salsa.debian.org/installer-team/debootstrap"
          ["ubuntu"]="https://git.launchpad.net/ubuntu/+source/debootstrap"
          ["kali"]="https://gitlab.com/kalilinux/packages/debootstrap"
          ["parrot"]="https://git.parrotsec.org/packages/debian/debootstrap"
        )
        local distributionResourcesProvider="${resourcesProviders["$targetDistribution"]}"
        local distributionResourcesLocation="$downloadsDirectory/$targetDistribution"
        local downloadMethod="wget"
        if [ "$targetDistribution" != "void" ]
        then
          downloadMethod="git"
        fi
        local distributionResources="$(
          downloadFromURL "${resourcesProviders["$targetDistribution"]}" "$downloadMethod" "$distributionResourcesLocation"
        )"
        echo "$distributionResources"
      }
      local targetDistributionResources=$(
        getDistributionResources "$targetDistribution"
      )
      if [ "$targetDistribution" == "void" ]
      then
        # Expecting `targetDistributionResources` to be a root file system tarball
        promptExtractArchive "$targetDistributionResources" "$targetRootFileSystem"
      elif grep --ignore-case --quiet "$targetDistribution" <<< "${debootstrapDistributions[@]}"
      then
        # Expecting `targetDistributionResources` to be a git repository
        local debootstrapCommand="--arch=$targetArchitecture stable $targetRootFileSystem"
        local debootstrapDirectory="$targetDistributionResources"
        export DEBOOTSTRAP_DIR="$debootstrapDirectory"
        getAdministrativePrivileges
        eval sudo chmod +x "$DEBOOTSTRAP_DIR/debootstrap"
        eval "$DEBOOTSTRAP_DIR/debootstrap $debootstrapCommand"
      fi
      getAdministrativePrivileges
      promptDeleteDirectory "$distributionResourcesLocation" "privileged"
    }
    echo "$processingSymbol Initiating bootstrap : $bootstrapMode -> $targetDistribution"
    if [ "$bootstrapMode" == "assisted" ]
    then
      initiateDistributionAssistedBootstrap "$targetRootFileSystem" "$targetDistribution"
    elif [ "$bootstrapMode" == "agnostic" ]
    then
      initiateDistributionAgnosticBootstrap "$targetRootFileSystem" "$targetDistribution"
    fi
    # [TODO] systemd-firstboot --root="$targetRootFileSystem" --setup-machine-id
    local targetHostName="$targetDistribution"
    copyHostDNSConfigurations "$targetRootFileSystem"
    setHostname "$targetHostName" "$targetRootFileSystem"
    setLocale "$targetRootFileSystem"
    echo "$warningSymbol Install kernel and configure bootloader to make system bootable"
  }
  setAliases "on"
  local targetRootFileSystem=$(
    getRootFileSystem "$targetDisk" "mounted"
  )
  alias fzf="\
    fzf \
    --no-multi \
    --info hidden \
    --layout reverse \
    --height 15 \
    --prompt '❯ ' \
    --pointer '❯ ' \
  "
  initiateBootstrap "$targetRootFileSystem"
  setAliases "off"
}
