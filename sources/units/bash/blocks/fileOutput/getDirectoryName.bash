function getDirectoryName {
  local toParse="$1"
  echo "$(
    dirname "$toParse"
  )"
}
