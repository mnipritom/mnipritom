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
