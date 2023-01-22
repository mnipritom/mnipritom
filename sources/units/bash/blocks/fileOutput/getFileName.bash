function getFileName {
  local toParse="$1"
  echo "$(
    basename "$toParse"
  )"
}
