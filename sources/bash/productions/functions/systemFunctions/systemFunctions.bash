systemFunctions["getProcessorArchitecture"]=$(
  function getProcessorArchitecture {
    uname --machine
  }
  declare -f getProcessorArchitecture
  unset -f getProcessorArchitecture
)

systemFunctions["getOperatingSystemName"]=$(
  function getOperatingSystemName {
    uname --operating-system
  }
  declare -f getOperatingSystemName
  unset -f getOperatingSystemName
)

systemFunctions["getKernelName"]=$(
  function getKernelName {
    uname --kernel-name
  }
  declare -f getKernelName
  unset -f getKernelName
)

systemFunctions["getAdministrativePrivileges"]=$(
  function getAdministrativePrivileges {
    sudo --validate
  }
  declare -f getAdministrativePrivileges
  unset -f getAdministrativePrivileges
)

systemFunctions["revokeAdministrativePrivileges"]=$(
  function revokeAdministrativePrivileges {
    sudo --remove-timestamp
  }
  declare -f revokeAdministrativePrivileges
  unset -f revokeAdministrativePrivileges
)

systemFunctions["checkCommandAvailability"]=$(
  function checkCommandAvailability {
    local commandToCheck="$1"
    # consider `command -v`
    local status="$(
      which "$commandToCheck" &>/dev/null
      echo "$?"
    )"
    echo "$status"
  }
  declare -f checkCommandAvailability
  unset -f checkCommandAvailability
)

systemFunctions["promptCheckCommandAvailability"]=$(
  function promptCheckCommandAvailability {
    local commandToCheck="$1"
    local status="$(
      eval "${systemFunctions["checkCommandAvailability"]}"
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

systemFunctions["getHostDistribution"]=$(
  function getHostDistribution {
    local targetRootFileSystem="$1"
    eval "${systemFunctions["getOperatingSystemName"]}"
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
  declare -f getHostDistribution
  unset -f getHostDistribution
)

systemFunctions["getSystemPackageManager"]=$(
  function getSystemPackageManager {
    eval "${systemFunctions[getHostDistribution]}"
    eval "${systemFunctions[getHostDistributionPackageManager]}"
    local hostDistribution=$(
      getHostDistribution
    )
    local hostDistributionPackageManager=$(
      getHostDistributionPackageManager "$hostDistribution"
    )
    printf "%s" "$hostDistributionPackageManager"
    unset -f getHostDistribution
    unset -f getHostDistributionPackageManager
  }
  declare -f getSystemPackageManager
  unset -f getSystemPackageManager
)
