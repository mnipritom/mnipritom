function copyHostDNSConfigurations {
  local targetRootFileSystem="$1"
  local status

  if [ "$targetRootFileSystem" == "" ]
  then
    echo "$failureSymbol Please specify a target root file system"
    return 1
  elif [ "$targetRootFileSystem" == "/" ]
  then
    echo "$failureSymbol Target root file system can not be the host root file system"
    return 1
  fi
  if [ -f "$targetRootFileSystem/etc/resolv.conf" ]
  then
    echo "$processingSymbol Deleting existing DNS configurations : $targetRootFileSystem/etc/resolv.conf"
    getAdministrativePrivileges
    status=$(
      sudo rm --force "$targetRootFileSystem/etc/resolv.conf"
      echo "$?"
    )
    if [ "$status" != 0 ] && [ -f "$targetRootFileSystem/etc/resolv.conf" ]
    then
      echo "$failureSymbol Failed to delete existing DNS configurations : $targetRootFileSystem/etc/resolv.conf"
      return 1
    else
      echo "$successSymbol Successfully deleted existing DNS configurations : $targetRootFileSystem/etc/resolv.conf"
    fi
  fi
  echo "$processingSymbol Copying host DNS configurations : /etc/resolv.conf -> $targetRootFileSystem/etc/resolv.conf"
  status=$(
    getAdministrativePrivileges
    sudo cp "/etc/resolv.conf" "$targetRootFileSystem/etc/"
    echo "$?"
  )
  if [ "$status" != 0 ] && [ ! -f "$targetRootFileSystem/etc/resolv.conf" ]
  then
    echo "$failureSymbol Failed to copy DNS configurations : /etc/resolv.conf -> $targetRootFileSystem/etc/"
    return 1
  else
    echo "$successSymbol Successfully copied DNS configurations : /etc/resolv.conf -> $targetRootFileSystem/etc/"
  fi
}
function getBinaryPath {
  local targetBinary="$1"
  local targetRootFileSystem="$2"
  if [ "$targetRootFileSystem" == "" ]
  then
    targetRootFileSystem="/"
  fi

  local targetBinaryPath=$(
    local binariesForTargetOnSystem=($(
      getAdministrativePrivileges
      sudo find "$targetRootFileSystem" -name "$targetBinary" -type f -executable
    ))
    local binaryForTarget=$(
      # [TODO] reduce dependency on luck here
      echo "${binariesForTargetOnSystem[0]}"
    )
    if [ "$targetRootFileSystem" != "/" ]
    then
      echo "${binaryForTarget#$targetRootFileSystem}"
    else
      echo "$binaryForTarget"
    fi
  )
  echo "$targetBinaryPath"
}

function listUsers {
  local targetRootFileSystem="$1"
  source "$blocksDirectory/baseSystem/setAliases.bash"
  setAliases "on" &>/dev/null
  alias awk="gawk"
  awk \
  --field-separator ":" '{
    print $1
  }' "$targetRootFileSystem/etc/passwd"
  setAliases "off" &>/dev/null
}
function checkUserAvailability {
  source "$snippetsDirectory/baseSystem/listUsers.bash"
  local targetUser="$1"
  local targetRootFileSystem="$2"
  local usersList=($(
    listUsers "$targetRootFileSystem"
  ))
  local userAvailability="no"
  for user in "${usersList[@]}"
  do
    # [TODO] consider: `if ! grep --word-regexp --quiet "$targetUser" <<< "${usersList[@]}"`
    if [ "$user" == "$targetUser" ]
    then
      userAvailability="yes"
      break
    fi
  done
  echo "$userAvailability"
}
# ---
# note:
#   - chroot has an implicit `exit` command
#   - `postCHROOTexecuteUnit` path has to be relative to supplied `targetRootFileSystem`
#   - does not unmount correctly if pseudo filesystems were already mounted
# ---
function chrootExecute {
  local executeUnitType="$1"
  local targetRootFileSystem="$2"
  local postCHROOTexecuteUnit="$3"

  source "$snippetsDirectory/baseSystem/getHostDistribution.bash"
  source "$snippetsDirectory/baseSystem/getBinaryPath.bash"
  local requiredDirectories=(
    "sys"
    "dev"
    "proc"
    "run"
    "tmp"
  )
  local mountStatus
  local unmountStatus
  local targetBashBinary=$(
    getBinaryPath "bash" "$targetRootFileSystem"
  )
  local hostDistribution=$(
    getHostDistribution
  )
  function mountPseudoFileSystems {
    local -n pseudoFileSystems="$1"
    for directory in "${pseudoFileSystems[@]}"
    do
      getAdministrativePrivileges
      mountStatus="$(
        sudo mount --rbind "/$directory" "$targetRootFileSystem/$directory" && sudo mount --make-rslave "$targetRootFileSystem/$directory" &>/dev/null
        echo "$?"
      )"
      if [ "$mountStatus" != 0 ]
      then
        echo "$failureSymbol Failed to mount : /$directory -> $targetRootFileSystem/$directory"
        return 1
      else
        echo "$successSymbol Successfully mounted : /$directory -> $targetRootFileSystem/$directory"
      fi
    done
  }
  function unmountPseudoFileSystems {
    local -n pseudoFileSystems="$1"
    for directory in "${pseudoFileSystems[@]}"
    do
      unmountStatus="$(
        sudo umount --recursive --force "$targetRootFileSystem/$directory" &>/dev/null
        echo "$?"
      )"
      if [ "$unmountStatus" != 0 ]
      then
        echo "$failureSymbol Failed to unmount : $targetRootFileSystem/$directory"
        return 1
      else
        echo "$successSymbol Successfully unmounted : $targetRootFileSystem/$directory"
      fi
    done
  }
  function executeUnit {
    local chrootType="$1"
    local executeUnitType="$2"
    local executionUnit="$3"
    echo "$warningSymbol Entering chroot environment in : $targetRootFileSystem"
    if [ "$executeUnitType" == "command" ]
    then
      echo "$processingSymbol Executing : $executeUnitType -> $targetRootFileSystem"
      getAdministrativePrivileges
      sudo "$chrootType" "$targetRootFileSystem" "$targetBashBinary" -c "$postCHROOTexecuteUnit"
    elif [ "$executeUnitType" == "script" ]
    then
      echo "$processingSymbol Executing : $executeUnitType -> $targetRootFileSystem"
      getAdministrativePrivileges
      sudo "$chrootType" "$targetRootFileSystem" "$targetBashBinary" "$postCHROOTexecuteUnit"
    else
      echo "$failureSymbol Undefined execution unit : $executeUnitType"
      return 1
    fi
    echo "$warningSymbol Exited chroot environment : $targetRootFileSystem"
  }
  if [ $executeUnitType == "command" ] || [ $executeUnitType == "script" ]
  then
    if [ "$hostDistribution" == "arch" ] || [ "$hostDistribution" == "artix" ]
    then
      echo "$processingSymbol Utilizing $hostDistribution : $hostDistribution-chroot"
      executeUnit "$hostDistribution-chroot" "$executeUnitType" "$postCHROOTexecuteUnit"
    else
      mountPseudoFileSystems requiredDirectories
      executeUnit "chroot" "$executeUnitType" "$postCHROOTexecuteUnit"
      unmountPseudoFileSystems requiredDirectories
    fi
  else
    echo "$failureSymbol Missing script/command to execute within chroot environment : $executeUnitType"
    return 1
  fi
}

function addUserToGroups {
  local userName="$1"
  local targetRootFileSystem="$2"

  source "$modulesDirectory/baseSystem/chrootExecute.bash"
  local commandToExecute
  local userGroups=(
    "kvm"         # QEMU requirement
    "libvirt"     # Better virt-manager integration
    "wheel"       # Root/Sudo access
    "root"        # Root/Sudo access [redundent for distribution variety]
    "sudo"        # Root/Sudo access [if wheel fails]
    "system"      # Run sudo required commands like "mkfs"
    "audio"       # Audio peripherals
    "video"       # Video devices
    "input"       # Access to input devices: /dev/mouse*, /dev/event*
    "plugdev"     # Access to pluggable devices
    "disk"        # Raw access to /dev/sd* and /dev/loop*
    "lp"          # Access to printers
    "scanner"     # Access to scanners
    "cdrom"       # Access to CD devices
    "optical"     # Access to DVD/CD-RW devices
    "tty"         # Access to TTY-like devices
    "daemon"      # System daemons that need to write to files on disk
    "storage"     # Access to removable storage devices
  )
  local sudoersEntries=(
    "$userName ALL=(ALL:ALL) ALL"
    "%sudo ALL=(ALL:ALL) ALL"
    "%wheel ALL=(ALL:ALL) ALL"
  )
  getAdministrativePrivileges
  for group in "${userGroups[@]}"
  do
    commandToExecute="\
      usermod $userName \
      --append \
      --groups "$group" \
    "
    if [ "$targetRootFileSystem" != "" ]
    then
      echo "$processingSymbol Adding user to group : $userName -> $group -> $targetRootFileSystem"
      chrootExecute "command" "$targetRootFileSystem" "$commandToExecute" &>/dev/null
    else
      echo "$processingSymbol Adding user to group : $userName -> $group"
      eval sudo $commandToExecute
    fi
  done
  echo "$processingSymbol Adding sudoers entry : $userName -> $targetRootFileSystem/etc/sudoers"
  local status
  for entry in "${sudoersEntries[@]}"
  do
    status=$(
      # sudoers is not directly accessible by `sudo`
      sudo bash -c "echo \"$entry\" >> $targetRootFileSystem/etc/sudoers"
      echo "$?"
    )
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to add entry : $targetRootFileSystem/etc/sudoers"
      return 1
    else
      echo "$successSymbol Successfully added entry : $targetRootFileSystem/etc/sudoers"
    fi
  done
}
function createUser {
  local userName="$1"
  local targetRootFileSystem="$2"

  source "$modulesDirectory/baseSystem/chrootExecute.bash"
  source "$snippetsDirectory/baseSystem/getBinaryPath.bash"
  local targetBashBinary=$(
    getBinaryPath "bash" "$targetRootFileSystem"
  )
  local commandToExecute="\
    useradd \
    --create-home \
    --system "$userName" \
    --shell "$targetBashBinary" \
  "
  if [ "$targetRootFileSystem" != "" ]
  then
    echo "$processingSymbol Creating user : $userName -> $targetRootFileSystem"
    chrootExecute "command" "$targetRootFileSystem" "$commandToExecute" &>/dev/null
  else
    echo "$processingSymbol Creating user : $userName"
    getAdministrativePrivileges
    eval sudo "$commandToExecute"
  fi
}
function installPackage {
  local packageToInstall="$1"
  local packageManager="$2"
  local targetRootFileSystem="$3"
  source "$snippetsDirectory/baseSystem/getHostDistribution.bash"
  source "$modulesDirectory/baseSystem/getHostDistributionPackageManager.bash"

  source "$modulesDirectory/baseSystem/chrootExecute.bash"
  if [ "$packageManager" == "" ]
  then
    if [ "$systemPackageManager" == "" ]
    then
      packageManager="$(
        getHostDistributionPackageManager
      )"
    else
      packageManager="$systemPackageManager"
    fi
  fi
  local administrativePackageManagers=(
    "xbps"
    "apt"
    "pacman"
    "yum"
    "dnf"
    "zypper"
    "nix"
    "guix"
    "flatpak"
    "snap"
    "pnpm"
    "npm"
  )
  local administrativePrivilegesRequired="no"
  if grep --word-regexp --quiet "$packageManager" <<< "${administrativePackageManagers[@]}"
  then
    administrativePrivilegesRequired="yes"
  fi
  # [TODO] implement `guix` `rubygems` `luarocks` `yarn` `winget` `bower` etc
  # [TODO] differentiate between `nix-env` parameters nixpkgs, nixos
  declare -A packageManagerInstallCommands=(
    ["xbps"]="xbps-install --sync --yes"
    ["apt"]="apt install --assume-yes"
    ["pacman"]="pacman --sync --refresh --noconfirm"
    ["yum"]="yum install --assumeyes"
    ["dnf"]="dnf install --assumeyes"
    ["zypper"]="zypper install --no-confirm"
    ["brew"]="brew install"
    ["apm"]="apm install"
    ["nix"]="nix-env --install --attr"
    ["flatpak"]="flatpak --system install --noninteractive --assumeyes"
    ["cargo"]="cargo install"
    ["pip"]="pip install --no-input"
    ["conda"]="conda install --yes"
    ["npm"]="npm install --location=global"
    ["pnpm"]="pnpm install --global"
  )
  local installCommand="${packageManagerInstallCommands[$packageManager]}"
  if [ "$targetRootFileSystem" != "" ]
  then
    echo "$processingSymbol Installing package : $packageToInstall -> $packageManager -> $targetRootFileSystem"
    chrootExecute "command" "$targetRootFileSystem" "$installCommand $packageToInstall"
  else
    if [ "$administrativePrivilegesRequired" == "yes" ]
    then
      getAdministrativePrivileges
      echo "$processingSymbol Installing package with administrative privileges : $packageToInstall -> $packageManager"
      eval sudo "$installCommand $packageToInstall"
    else
      echo "$processingSymbol Installing package : $packageToInstall -> $packageManager"
      eval "$installCommand $packageToInstall"
    fi
  fi
}
function setHostname {
  local hostnameToSet="$1"
  local targetRootFileSystem="$2"

  source "$modulesDirectory/baseSystem/chrootExecute.bash"
  source "$snippetsDirectory/baseSystem/getBinaryPath.bash"
  local targetBashBinary=$(
    getBinaryPath "bash" "$targetRootFileSystem"
  )
  local hostnameFile="$dumpsDirectory/hostname"
  local localHostIPAddress="127.0.0.1"
  # `hostname` binary is part of GNU coreutils
  local commandToExecute="hostname $hostnameToSet"
  touch "$hostnameFile"
  echo "$hostnameToSet" > "$hostnameFile"
  getAdministrativePrivileges
  if [ "$targetRootFileSystem" != "" ]
  then
    echo "$processingSymbol Setting static hostname : $hostnameToSet -> $targetRootFileSystem"
    sudo mv --force "$hostnameFile" "$targetRootFileSystem/etc/hostname"
    echo "$processingSymbol Setting transient hostname : $hostnameToSet -> $targetRootFileSystem"
    chrootExecute "command" "$targetRootFileSystem" "$commandToExecute" &>/dev/null
    echo "$processingSymbol Adding entry : $hostnameToSet -> $targetRootFileSystem/etc/hosts"
    sudo "$targetBashBinary" -c "echo $localHostIPAddress	$hostnameToSet >> $targetRootFileSystem/etc/hosts"
  else
    echo "$processingSymbol Setting static hostname : $hostnameToSet"
    sudo mv --force "$hostnameFile" "/etc/hostname"
    echo "$processingSymbol Setting transient hostname : $hostnameToSet"
    eval sudo "$commandToExecute"
    echo "$processingSymbol Adding entry : $hostnameToSet -> /etc/hosts"
    sudo "$targetBashBinary" -c "echo $localHostIPAddress	$hostnameToSet >> /etc/hosts"
  fi
}
function setLocale {
  local targetRootFileSystem="$1"


  source "$modulesDirectory/baseSystem/chrootExecute.bash"

  local locale="en_US.UTF-8"

  local status

  # /etc/default/locale       : "LANG=en_US.UTF-8"
  # /etc/locale.conf          : "LANG=en_US.UTF-8"
  # /etc/default/libc-locale  : "en_US.UTF-8 UTF-8"
  # /etc/locale.gen           : "en_US.UTF-8 UTF-8"
  # /etc/environment          : "LC_ALL=en_US.UTF-8"

  local defaultLocaleFile="$dumpsDirectory/locale"
  local defaultLibcLocaleFile="$dumpsDirectory/libc-locales"
  local localeGenFile="$dumpsDirectory/locale.gen"
  local localeConfFile="$dumpsDirectory/locale.conf"
  local environmentFile="$dumpsDirectory/environment"

  local targetDefaultLocaleFile="$targetRootFileSystem/etc/default/locale"
  local targetDefaultLibcLocaleFile="$targetRootFileSystem/etc/default/libc-locales"
  local targetLocaleGenFile="$targetRootFileSystem/etc/locale.gen"
  local targetLocaleConfFile="$targetRootFileSystem/etc/locale.conf"
  local targetEnvironmentFile="$targetRootFileSystem/etc/environment"

  declare -A systemLocaleFilesTargets=(
    ["$defaultLocaleFile"]="$targetDefaultLocaleFile"
    ["$defaultLibcLocaleFile"]="$targetDefaultLibcLocaleFile"
    ["$localeGenFile"]="$targetLocaleGenFile"
    ["$localeConfFile"]="$targetLocaleConfFile"
    ["$environmentFile"]="$targetEnvironmentFile"
  )

  for file in "${!systemLocaleFilesTargets[@]}"
  do
    echo "$processingSymbol Creating file containing locale value : ${file#$dumpsDirectory}"
    touch "$file"
  done

  echo "LANG=$locale" > "$defaultLocaleFile"
  echo "LANG=$locale" > "$localeConfFile"
  echo "$locale UTF-8" > "$defaultLibcLocaleFile"
  echo "$locale UTF-8" > "$localeGenFile"
  echo "LC_ALL=$locale" > "$environmentFile"

  for systemFile in "${!systemLocaleFilesTargets[@]}"
  do
    local target="${systemLocaleFilesTargets[$systemFile]}"

    echo "$processingSymbol Deleting existing system locale file : $target"

    getAdministrativePrivileges

    status=$(
      sudo rm --force "$target"
      echo "$?"
    )

    if [ "$status" != 0 ] && [ -f "$target" ]
    then
      echo "$failureSymbol Failed to delete existing system locale file : $target"
    else
      echo "$successSymbol Successfully deleted existing system locale file : $target"
    fi

    echo "$processingSymbol Setting locale values in possible system files : $target"

    getAdministrativePrivileges

    status=$(
      sudo mv --force "$systemFile" "$target"
      echo "$?"
    )

    if [ "$status" != 0 ] && [ ! -f "$target" ]
    then
      echo "$failureSymbol Failed to set locale value in system file : $target"
    else
      echo "$successSymbol Successfully set locale value in system file : $target"
    fi
  done

  if [ "$targetRootFileSystem" != "" ]
  then
    chrootExecute "command" "$targetRootFileSystem" "eval locale-gen $locale" &>/dev/null
  else
    eval locale-gen $locale
  fi
}
function setUserPassword {
  local userName="$1"
  local targetRootFileSystem="$2"

  source "$modulesDirectory/baseSystem/chrootExecute.bash"
  local commandToExecute="\
  passwd --delete $userName && \
  passwd $userName \
  "
  echo "$warningSymbol Set password for user : $userName"
  if [ "$targetRootFileSystem" != "" ]
  then
    chrootExecute "command" "$targetRootFileSystem" "$commandToExecute"
  else
    getAdministrativePrivileges
    local bashBinaryOnSystem=$(
      which bash
    )
    eval sudo "$bashBinaryOnSystem" -c "$commandToExecute"
  fi
}
function synchronizeSystemRepositories {
  local targetRootFileSystem="$1"
  source "$blocksDirectory/baseSystem/checkCommandAvailability.bash"

  source "$snippetsDirectory/baseSystem/getHostDistribution.bash"
  source "$modulesDirectory/baseSystem/getHostDistributionPackageManager.bash"
  source "$modulesDirectory/baseSystem/chrootExecute.bash"
  declare -A packageManagerCommands=(
    ["xbps-install"]="xbps-install --sync --yes"
    ["pacman"]="pacman --sync --refresh --noconfirm"
    ["apt"]="apt update --assume-yes"
    ["yum"]="yum check-update --assumeyes"
    ["dnf"]="dnf check-update --assumeyes"
    ["zypper"]="zypper refresh --force"
  )
  if [ "$targetRootFileSystem" != "" ]
  then
    local targetHostDistribution=$(
      getHostDistribution "$targetRootFileSystem"
    )
    local targetPackageManager=$(
      getHostDistributionPackageManager "$targetHostDistribution"
    )
    local targetUpdateCommand
    echo "$processingSymbol Synchronizing system repositories : $targetPackageManager -> $targetRootFileSystem"
    if [ "$targetPackageManager" == "xbps" ]
    then
      chrootExecute "command" "$targetRootFileSystem" "xbps-install --update xbps --yes"
      targetUpdateCommand="${packageManagerCommands["$targetPackageManager-install"]}"
      chrootExecute "command" "$targetRootFileSystem" "$targetUpdateCommand"
    else
      targetUpdateCommand="${packageManagerCommands["$targetPackageManager"]}"
      chrootExecute "command" "$targetRootFileSystem" "$targetUpdateCommand"
    fi
  else
    local status
    local updateCommand
    local hostPackageManager
    for packageManger in "${!packageManagerCommands[@]}"
    do
      status="$(
        checkCommandAvailability "$packageManger"
      )"
      if [ "$status" == 0 ]
      then
        hostPackageManager="$packageManger"
        updateCommand="${packageManagerCommands[$packageManger]}"
        break
      fi
    done
    echo "$processingSymbol Synchronizing system repositories : $hostPackageManager"
    getAdministrativePrivileges
    if [ "$hostPackageManager" == "xbps-install" ]
    then
      eval "sudo $updateCommand"
      eval "sudo xbps-install --update xbps --yes"
    fi
    eval "sudo $updateCommand"
  fi
}
