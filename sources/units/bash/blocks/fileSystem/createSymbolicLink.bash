function createSymbolicLink {
  local source="$1"
  local target="$2"
  local sourcePath="$(
    realpath "$source"
  )"
  local targetPath="$(
    realpath "$target"
  )"
  local status=$(
    ln --symbolic "$sourcePath" "$targetPath" &>/dev/null
    printf "%s" "$?"
  )
  printf "%s" "$status"
}
function promptCreateSymbolicLink {
  local source="$1"
  local target="$2"
  local status=$(
    createSymbolicLink "$source" "$target"
  )
  if [ "$status" != 0 ]
  then
    printf "%s\n" "$failureSymbol Failed to create symbolic link : $source -> $target"
  else
    printf "%s\n" "$successSymbol Successfully created symbolic link : $source -> $target"
  fi
}
