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
