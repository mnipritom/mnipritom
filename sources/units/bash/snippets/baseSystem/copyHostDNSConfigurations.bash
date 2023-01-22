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
