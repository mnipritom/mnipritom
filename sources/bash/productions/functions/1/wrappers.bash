_1["promptCheckCommandAvailability"]=$(
  function promptCheckCommandAvailability {
    local commandToCheck="${1}"
    local status="$(
      eval "${_0["checkCommandAvailability"]}"
      checkCommandAvailability "$commandToCheck"
    )"
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to find command : $commandToCheck"
      return 1
    else
      echo "$successSymbol Found command : $commandToCheck"
    fi
  }
  declare -f promptCheckCommandAvailability
  unset -f promptCheckCommandAvailability
)

_1["getHostDistribution"]=$(
  function getHostDistribution {
    local targetRootFileSystem="$1"
    eval "${_0["getOperatingSystemName"]}"
    eval "${_0["setAliases"]}"
    local osReleaseFile="$targetRootFileSystem/etc/*-release"
    local fieldToLookUp="ID"
    local hostDistribution
    setAliases "on" &>/dev/null
    alias awk="gawk"
    function parseDistributionID {
      source "${_0["readFile"]}"
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
  declare -f getHostDistribution
  unset -f getHostDistribution
)
