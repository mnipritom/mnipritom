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
