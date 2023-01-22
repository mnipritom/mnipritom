function downloadFromURL {
  local link="$1"
  local method="$2"
  local targetDirectory="$3"
  source "$blocksDirectory/fileOutput/getFileName.bash"
  source "$blocksDirectory/fileSystem/createDirectory.bash"
  local status
  if [ "$targetDirectory" != "" ]
  then
    downloadsDirectory="$targetDirectory"
  fi
  local downloadedFile="$downloadsDirectory/$(
    getFileName "$link"
  )"
  if [ ! -d "$downloadsDirectory" ]
  then
    status="$(
      createDirectory "$downloadsDirectory"
    )"
  else
    status=0
  fi
  if [ "$status" != 0 ]
  then
    echo "$failureSymbol Failed to create directory : $targetDirectory"
    return 1
  else
    if [ "$method" == "wget" ]
    then
      status="$(
        wget "$link" --directory-prefix="$downloadsDirectory"
        echo "$?"
      )"
    elif [ "$method" == "git" ]
    then
      # git will make `downloadedFile` into a directory otherwise will throw error
      status="$(
        git clone "$link" "$downloadedFile"
        echo "$?"
      )"
    elif [ "$method" == "curl" ]
    then
      echo "$failureSymbol Not yet implemented : $method"
      status=1
    else
      echo "$failureSymbol No download method defined : $method"
      echo "$failureSymbol Can not download from : $link"
      status=1
    fi
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to download : $link"
      return "$status"
    else
      echo "$downloadedFile"
    fi
  fi
}
function promptDownloadFromURL {
  local link="$1"
  local method="$2"
  local targetDirectory="$3"
  local downloadedFile="$(
    downloadURL "$link" "$method" "$targetDirectory"
  )"
  if [ ! -f "$downloadedFile" ]
  then
    echo "$failureSymbol Failed to download file"
    return 1
  else
    echo "$successSymbol Successfully downloaded file : $link -> $downloadedFile"
  fi
}
