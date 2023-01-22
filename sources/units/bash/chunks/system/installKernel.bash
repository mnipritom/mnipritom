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
