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
