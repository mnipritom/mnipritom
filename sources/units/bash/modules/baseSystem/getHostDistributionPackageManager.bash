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
