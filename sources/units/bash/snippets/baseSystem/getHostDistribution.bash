function getHostDistribution {
  local targetRootFileSystem="$1"
  source "$blocksDirectory/baseSystem/getOperatingSystemName.bash"
  source "$blocksDirectory/baseSystem/setAliases.bash"
  local osReleaseFile="$targetRootFileSystem/etc/*-release"
  local fieldToLookUp="ID"
  local hostDistribution
  setAliases "on" &>/dev/null
  alias awk="gawk"
  function parseDistributionID {
    source "$blocksDirectory/fileOutput/readFile.bash"
    local distributionID="$(
      readFile "$osReleaseFile" | grep "$fieldToLookUp"
    )"
    local distribution=$(
      echo "$distributionID" | awk \
      --field-separator "=" \
      --assign \
      fieldToLookUp="$fieldToLookUp" '{
        if($1==fieldToLookUp) {
          print $2
        }
      }'
    )
    hostDistribution=$(
      echo "$distribution" | tr --delete '"'
    )
    if [ "$hostDistribution" == "" ]
    then
      echo "$failureSymbol Failed to get host distribution"
      return 1
    else
      echo "$hostDistribution"
    fi
  }
  if [ "$targetRootFileSystem" != "" ]
  then
    parseDistributionID
  else
    local operatingSystemName="$(
      getOperatingSystemName
    )"
    if grep --ignore-case --quiet "GNU" <<< "$operatingSystemName"
    then
      parseDistributionID
    else
      echo "$failureSymbol Not a distribution of GNU/Linux or GNU/Hurd operating system : $operatingSystemName"
      return 1
    fi
  fi
  setAliases "off" &>/dev/null
}
