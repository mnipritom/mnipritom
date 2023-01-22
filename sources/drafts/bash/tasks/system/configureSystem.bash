function configureSystem {
  # [TODO] configuration type `bootstrap`, `personalize` etc
  source "$blocksDirectory/baseSystem/setAliases.bash"
  source "$blocksDirectory/baseSystem/setStrictExecution.bash"
  source "$blocksDirectory/baseSystem/checkCommandAvailability.bash"
  source "$chunksDirectory/system/installDistribution.bash"
  source "$chunksDirectory/system/installBootloader.bash"
  source "$chunksDirectory/system/installKernel.bash"
  source "$actionsDirectory/fileSystem/createFileSystemTable.bash"
  source "$actionsDirectory/baseSystem/createUser.bash"
  source "$actionsDirectory/baseSystem/addUserToGroups.bash"
  source "$actionsDirectory/baseSystem/setUserPassword.bash"
  source "$actionsDirectory/system/getRootFileSystem.bash"
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  source "$blocksDirectory/fileSystem/createDirectory.bash"
  source "$snippetsDirectory/fileSystem/copyDirectory.bash"
  source "$modulesDirectory/baseSystem/chrootExecute.bash"
  local dependencyStatus=$(
    checkCommandAvailability "gawk"
  )
  if [ "$dependencyStatus" != 0 ]
  then
    echo "$failureSymbol Failed to find dependency : gawk"
    echo "$failureSymbol Can not proceed further"
    exit 1
  fi
  setAliases "on"
  alias awk="gawk"
  setStrictExecution "on"
  alias fzf="\
    fzf \
    --no-multi \
    --info hidden \
    --layout reverse \
    --height 15 \
    --prompt '❯ ' \
    --pointer '❯ ' \
  "
  setStrictExecution "off"
  local targetDisk="$(
    source "$blocksDirectory/fileSystem/listAvailableDisks.bash"
    local message="$warningSymbol Select installation disk"
    listAvailableDisks | fzf --header "$message" | awk '{
      print $1
    }'
  )"
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
  local confirmationToProceed="$(
    local promptMessage="$warningSymbol Proceeding further will make irreversible changes : $targetDisk"
    local promptOptions=(
      "Yes & Proceed"
      "No & Exit"
    )
    local confirmation=$(
      printf "%s\n" "${promptOptions[@]}" | fzf --header "$promptMessage"
    )
    echo "$confirmation"
  )"
  handleStorageDisk "wipe" "$targetDisk" "$confirmationToProceed"
  installDistribution "$targetDistribution" "$targetDisk"
  installKernel "linux" "$targetDisk"
  installBootloader "grub" "$targetDisk"
  createFileSystemTable "$targetDisk"
  local targetRootFileSystem=$(
    getRootFileSystem "$targetDisk" "mounted"
  )
  # [TODO] programmatically configure required paths using bash string manipulators
  local targetExecutablesHandlerCommand=#"$..../hanlder.bash handleUtilities utilize links executables"
  local targetPackagesHandlerCommand=#"$..../hanlder.bash handleUtilities utilize packages"
  local targetDotfilesHandlerCommand=#"$..../hanlder.bash handleDotfiles deploy all"
  getAdministrativePrivileges
  promptCreateDirectory #"$targetRootFileSystem/...." "privileged"
  promptCopyDirectory #"$worktreePath" "$targetRootFileSystem/...."
  chrootExecute "script" "$targetRootFileSystem" "$targetExecutablesHandlerCommand"
  chrootExecute "script" "$targetRootFileSystem" "$targetPackagesHandlerCommand"
  chrootExecute "script" "$targetRootFileSystem" "$targetDotfilesHandlerCommand"
  createUser "$worktreeIdentifier" "$targetRootFileSystem"
  addUserToGroups "$worktreeIdentifier" "$targetRootFileSystem"
  setUserPassword "$worktreeIdentifier" "$targetRootFileSystem"
  getRootFileSystem "$targetDisk" "unmounted"
  echo "$warningSymbol Restart system and boot : $targetDisk"
  setAliases "off"
}
