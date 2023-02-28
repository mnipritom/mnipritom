function setAliases {
  local state="$1"
  if [ "$state" == "on" ]
  then
    echo "$processingSymbol Enabling aliases"
    shopt -s expand_aliases
  elif [ "$state" == "off" ]
  then
    echo "$processingSymbol Disabling aliases"
    shopt -u expand_aliases
  else
    echo "$failureSymbol Failed to find state : $state"
    return 1
  fi
}
function setStrictExecution {
  local state="$1"
  if [ "$state" == "on" ]
  then
    echo "$processingSymbol Enabling strict execution"
    set -o errexit
    set -o errtrace
    set -o pipefail
    # set -o nounset
  elif [ "$state" == "off" ]
  then
    echo "$processingSymbol Disabling strict execution"
    set +o errexit
    set +o errtrace
    set +o pipefail
    # set + nounset
  else
    echo "$failureSymbol Failed to find state : $state"
    return 1
  fi
}
function getProcessorArchitecture {
  uname --machine
}
function getOperatingSystemName {
  uname --operating-system
}
function getKernelName {
  uname --kernel-name
}
function getAdministrativePrivileges {
  sudo --validate
}
function revokeAdministrativePrivileges {
  sudo --remove-timestamp
}
function checkCommandAvailability {
  local commandToCheck="$1"
  # consider `command -v`
  local status="$(
    which "$commandToCheck" &>/dev/null
    echo "$?"
  )"
  echo "$status"
}
function promptCheckCommandAvailability {
  local commandToCheck="$1"
  local status="$(
    checkCommandAvailability "$commandToCheck"
  )"
  if [ "$status" != 0 ]
  then
    echo "$failureSymbol Failed to find command : $commandToCheck"
    return 1
  else
    echo "$successSymbol Found command : $commandToCheck"
  fi
}
# ---
# source: https://github.com/sdushantha/dotfiles/blob/77c7ee406472c9fa7c2417eb60b981c5b70096be/bin/bin/utils/rofi-askpass
# note: requires SUDO_ASKPASS environment variable to be set
# ---
function generatePasswordPrompt {
  # [TODO] generalize into generatePromptScript `draft`
  local bash="$(
    which bash
  )"
  local rofi="$(
    which rofi
  )"
  local promptCommand="$rofi -dmenu -password -i -no-fixed-num-lines -p 'Password'"
  local promptScript="$HOME/.local/bin/SUDO_ASKPASS_PROMPT"
  touch "$promptScript"
  printf "%s\n%s" "#!$bash" "$promptCommand" > "$promptScript"
  chmod +x "$promptScript"
  printf "%s" "$promptScript"
}
# ---
# source: https://github.com/davatorium/rofi/issues/38#issuecomment-456988468
# ---
function generateWindowSwitcherPrompt {
  # [TODO] generalize into generatePromptScript `draft`
  local bash="$(
    which bash
  )"
  local xdotools="$(
    which xdotool
  )"
  local rofi="$(
    which rofi
  )"
  local promptCommand="\
    $xdotool search \
      --sync \
      --limit 1 \
      --class Rofi keyup \
      --delay 0 Tab key \
      --delay 0 Tab keyup \
      --delay 0 Super_L keydown \
      --delay 0 Super_L &
    $rofi \
      -show window \
      -kb-cancel 'Alt+Escape,Escape' \
      -kb-accept-entry '!Alt-Tab,!Alt_L,!Alt+Alt_L,Return' \
      -kb-row-down 'Alt+Tab,Alt+Down' \
      -kb-row-up 'Alt+ISO_Left_Tab,Alt+Shift+Tab,Alt+Up' & \
  "
  local promptScript="$HOME/.local/bin/window_switcher_prompt"
  touch "$promptScript"
  printf "%s\n%s" "#!$bash" "$promptCommand" > $promptScript
  chmod +x "$promptScript"
  printf "%s" "$promptScript"
}
# ---
# source: https://github.com/junegunn/fzf/blob/master/ADVANCED.md#updating-the-list-of-processes-by-pressing-ctrl-r
# ---
function killRunningProcess {
  (date; ps -ef) | fzf \
    --bind='ctrl-r:reload(date; ps -ef)' \
    --header=$'Press CTRL-R to reload\n\n' --header-lines=2 \
    --preview='echo {}' --preview-window=down,3,wrap \
    --layout=reverse --height=80% | gawk '{
      print $2
    }' | xargs kill -9
}
function getUniquePathEntries {
  local uniquePathEntries="$(
    printf "%s" "$PATH" \
    | tr ":" "\n" \
    | sort --unique \
    | tr "\n" ":"
  )"
  printf "%s" "$uniquePathEntries"
}
function copyHostDNSConfigurations {
  local targetRootFileSystem="$1"
  local status
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
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
function downloadFromURL {
  local link="$1"
  local method="$2"
  local targetDirectory="$3"
  source "$blocksDirectory/fileOutput/getFileName.bash"
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
  source "$blocksDirectory/fileOutput/getFileName.bash"
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
function getBinaryPath {
  local targetBinary="$1"
  local targetRootFileSystem="$2"
  if [ "$targetRootFileSystem" == "" ]
  then
    targetRootFileSystem="/"
  fi
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
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
function getHostDistribution {
  local targetRootFileSystem="$1"
  source "$blocksDirectory/baseSystem/getOperatingSystemName.bash"
  source "$blocksDirectory/baseSystem/setAliases.bash"
  local osReleaseFile="$targetRootFileSystem/etc/*-release"
  local fieldToLookUp="ID"
  local hostDistribution
  setAliases "on" &>/dev/null
  alias awk="gawk"
  function parseDistributionID {
    source "$blocksDirectory/fileOutput/readFile.bash"
    local distributionID="$(
      readFile "$osReleaseFile" | grep "$fieldToLookUp"
    )"
    local distribution=$(
      echo "$distributionID" | awk \
      --field-separator "=" \
      --assign \
      fieldToLookUp="$fieldToLookUp" '{
        if($1==fieldToLookUp) {
          print $2
        }
      }'
    )
    hostDistribution=$(
      echo "$distribution" | tr --delete '"'
    )
    if [ "$hostDistribution" == "" ]
    then
      echo "$failureSymbol Failed to get host distribution"
      return 1
    else
      echo "$hostDistribution"
    fi
  }
  if [ "$targetRootFileSystem" != "" ]
  then
    parseDistributionID
  else
    local operatingSystemName="$(
      getOperatingSystemName
    )"
    if grep --ignore-case --quiet "GNU" <<< "$operatingSystemName"
    then
      parseDistributionID
    else
      echo "$failureSymbol Not a distribution of GNU/Linux or GNU/Hurd operating system : $operatingSystemName"
      return 1
    fi
  fi
  setAliases "off" &>/dev/null
}
function setClock {
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  function setSystemClock {
    getAdministrativePrivileges
    echo "$processingSymbol Setting system clock"
    sudo date --set="$year-$month-$day $hour:$minute:$second $offset"
    local status=$(
      echo "$?"
    )
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to set system clock"
      return 1
    else
      echo "$successSymbol Successfully set system clock"
    fi
  }
  function setHardwareClock {
    getAdministrativePrivileges
    echo "$processingSymbol Setting hardware clock"
    local status=$(
      sudo hwclock --systohc
      echo "$?"
    )
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to set hardware clock"
      return 1
    else
      echo "$successSymbol Successfully set hardware clock"
    fi
  }
  read -r -p "Enter year: " year
  read -r -p "Enter month: " month
  read -r -p "Enter day: " day
  read -r -p "Enter hour [24h]: " hour
  read -r -p "Enter minute: " minute
  read -r -p "Enter second: " second
  read -r -p "Enter offset [GMT+-] : " offset
  setSystemClock "$year" "$month" "$day" "$hour" "$minute" "$second" "$offset"
  setHardwareClock
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
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
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
function getHostDistributionPackageManager {
  source "$snippetsDirectory/baseSystem/getHostDistribution.bash"
  local hostDistribution="$1"
  if [ "$hostDistribution" == "" ]
  then
    hostDistribution="$(
      getHostDistribution
    )"
  fi
  declare -A distributionPackageManagers=(
    ["void"]="xbps"
    ["arch"]="pacman"
    ["artix"]="pacman"
    ["hyperbola"]="pacman"
    ["parabola"]="pacman"
    ["debian"]="apt"
    ["devuan"]="apt"
    ["kali"]="apt"
    ["parrot"]="apt"
    ["ubuntu"]="apt"
    ["trisquel"]="apt"
    ["fedora"]="dnf"
    ["opensuse"]="zypper"
    ["nix"]="nix"
    ["guix"]="guix"
  )
  local hostDistributionPackageManager="${distributionPackageManagers[$hostDistribution]}"
  echo "$hostDistributionPackageManager"
}
function addUserToGroups {
  local userName="$1"
  local targetRootFileSystem="$2"
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
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
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
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
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
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
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
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

  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
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
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
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
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
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
# ---
# note:
#   - dependent on environment variable `PWD`
#   - `--is-inside-git-dir` `--is-inside-work-tree` can only report `true`
#   - in `false` cases they print error message to stdout
# ---
function checkGitRepositoryStatus {
  local repositoryStatus=$(
    git rev-parse --is-inside-git-dir &>/dev/null
    printf "%s" "$?"
  )
  local worktreeStatus=$(
    git rev-parse --is-inside-work-tree &>/dev/null
    printf "%s" "$?"
  )
  if [ "$repositoryStatus" == 0 ] || [ "$worktreeStatus" == 0 ]
  then
    if [ "$repositoryStatus" == 0 ]
    then
      printf "%s" "repository"
    elif [ "$worktreeStatus" == 0 ]
    then
      printf "%s" "worktree"
    fi
    return 0
  else
    printf "%s" "none"
    return 1
  fi
}
function getRandomFile {
  local targetDirectory="$1"
  if [ ! -d "$targetDirectory" ]
  then
    echo "$failureSymbol Failed to find directory : $targetDirectory"
    return 1
  fi
  local targetDirectoryFiles=($(
    find "$targetDirectory" -type f -nowarn
  ))
  local targetDirectoryFilesCount="${#targetDirectoryFiles[@]}"
  local randomizedEntry=$(
    shuf --input-range 0-"$(( $targetDirectoryFilesCount-1 ))" --head-count 1
  )
  local randomFile="${targetDirectoryFiles[$randomizedEntry]}"
  echo "$randomFile"
}
