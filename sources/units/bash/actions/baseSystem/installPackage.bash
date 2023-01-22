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
