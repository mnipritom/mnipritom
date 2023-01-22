function listInstalledPackages {
  # [TODO] implementation
  local packageManager="$1"
  local packageManagerCommands=(
    ["xbps"]="xbps-query --list-manual-pkgs"
    ["apt"]=""
    ["pacman"]="pacman --query"
  )
  echo "${installedPackages[@]}"
}
