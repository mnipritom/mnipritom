function readFile {
  local fileToRead="$1"
  eval "gawk '{
    print
  }' $fileToRead"
}
