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
