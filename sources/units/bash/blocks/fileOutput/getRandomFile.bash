function getRandomFile {
  local targetDirectory="$1"
  if [ ! -d "$targetDirectory" ]
  then
    echo "$failureSymbol Failed to find directory : $targetDirectory"
    return 1
  fi
  local targetDirectoryFiles=($(
    find "$targetDirectory" -type f -nowarn
  ))
  local targetDirectoryFilesCount="${#targetDirectoryFiles[@]}"
  local randomizedEntry=$(
    shuf --input-range 0-"$(( $targetDirectoryFilesCount-1 ))" --head-count 1
  )
  local randomFile="${targetDirectoryFiles[$randomizedEntry]}"
  echo "$randomFile"
}
