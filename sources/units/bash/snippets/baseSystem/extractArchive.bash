function extractArchive {
  local fileToExtract="$1"
  local targetDirectory="$2"
  source "$blocksDirectory/fileOutput/getFileName.bash"
  source "$blocksDirectory/fileSystem/createDirectory.bash"
  local status
  if [ "$targetDirectory" != "" ]
  then
    extractsDirectory="$targetDirectory"
  fi
  local extractedFile="$extractsDirectory/$(
    getFileName "$fileToExtract"
  ).extracted"
  if [ ! -d "$extractsDirectory" ]
  then
    status="$(
      createDirectory "$extractsDirectory"
    )"
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to create directory : $extractsDirectory"
      return 1
    fi
  else
    status=0
  fi
  tar --list --file $fileToExtract &>/dev/null
  status="$(
    echo "$?"
  )"
  if [ "$status" != 0 ]
  then
    echo "$warningSymbol Not an archive file : $fileToExtract"
    return "$status"
  else
    tar --extract --file "$fileToExtract" --directory "$extractsDirectory" --one-top-level="$extractedFile" &>/dev/null
    status="$(
      echo "$?"
    )"
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to extract : $fileToExtract -> $extractsDirectory"
      return "$status"
    else
      echo "$extractedFile"
    fi
  fi
}
function promptExtractArchive {
  local fileToExtract="$1"
  local targetDirectory="$2"
  local extractedFile=$(
    extractArchive "$fileToExtract" "$targetDirectory"
  )
  if [ ! -f "$extractedFile" ]
  then
    echo "$failureSymbol Failed to extract archive"
    return 1
  else
    echo "$successSymbol Successfully extracted archive : $fileToExtract -> $targetDirectory"
  fi
}
