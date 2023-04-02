functionsLevel1["promptCheckCommandAvailability"]=$(
  function promptCheckCommandAvailability {
    local commandToCheck="${1}"
    local status="$(
      eval "${functionsLevel0["checkCommandAvailability"]}"
      checkCommandAvailability "${commandToCheck}"
    )"
    if [[ "${status}" != 0 ]]
    then
      printf "%s" "${failureSymbol} Failed to find command : ${commandToCheck}"
      return 1
    else
      printf "%s" "${successSymbol} Found command : ${commandToCheck}"
    fi
  }
  declare -f promptCheckCommandAvailability
  unset -f promptCheckCommandAvailability
)

function promptCreateSymbolicLink {
  local source="${1}"
  local target="${2}"
  local status=$(
    createSymbolicLink "${source}" "${target}"
  )
  if [[ "${status}" != 0 ]]
  then
    printf "%s\n" "${failureSymbol} Failed to create symbolic link : ${source} -> ${target}"
  else
    printf "%s\n" "${successSymbol} Successfully created symbolic link : ${source} -> ${target}"
  fi
}

functionsLevel1["getHostDistribution"]=$(
  function getHostDistribution {
    local targetRootFileSystem="${1}"
    eval "${functionsLevel0["getOperatingSystemName"]}"
    eval "${functionsLevel0["setAliases"]}"
    local osReleaseFile="${targetRootFileSystem}/etc/*-release"
    local fieldToLookUp="ID"
    local hostDistribution
    setAliases "on" &>/dev/null
    alias awk="gawk"
    function parseDistributionID {
      source "${functionsLevel0["readFile"]}"
      local distributionID="$(
        readFile "${osReleaseFile}" | grep "${fieldToLookUp}"
      )"
      local distribution=$(
        printf "%s" "${distributionID}" | awk \
        --field-separator "=" \
        --assign \
        fieldToLookUp="${fieldToLookUp}" '{
          if($1==fieldToLookUp) {
            print $2
          }
        }'
      )
      hostDistribution=$(
        printf "%s" "${distribution}" | tr --delete '"'
      )
      if [[ "$hostDistribution" == "" ]]
      then
        printf "%s" "${failureSymbol} Failed to get host distribution"
        return 1
      else
        printf "%s" "${hostDistribution}"
      fi
    }
    if [[ "$targetRootFileSystem" != "" ]]
    then
      parseDistributionID
    else
      local operatingSystemName="$(
        getOperatingSystemName
      )"
      if grep --ignore-case --quiet "GNU" <<< "${operatingSystemName}"
      then
        parseDistributionID
      else
        printf "%s" "${failureSymbol} Not a distribution of GNU/Linux or GNU/Hurd operating system : ${operatingSystemName}"
        return 1
      fi
    fi
    setAliases "off" &>/dev/null
  }
  declare -f getHostDistribution
  unset -f getHostDistribution
)

function getHostDistributionPackageManager {
  source "$snippetsDirectory/baseSystem/getHostDistribution.bash"
  local hostDistribution="${1}"
  if [[ "${hostDistribution}" == "" ]]
  then
    hostDistribution="$(
      getHostDistribution
    )"
  fi
  declare -A distributionPackageManagers=(
    ["void"]="xbps"
    ["arch"]="pacman"
    ["artix"]="pacman"
    ["hyperbola"]="pacman"
    ["parabola"]="pacman"
    ["debian"]="apt"
    ["devuan"]="apt"
    ["kali"]="apt"
    ["parrot"]="apt"
    ["ubuntu"]="apt"
    ["trisquel"]="apt"
    ["fedora"]="dnf"
    ["opensuse"]="zypper"
    ["nix"]="nix"
    ["guix"]="guix"
  )
  local hostDistributionPackageManager="${distributionPackageManagers[${hostDistribution}]}"
  printf "%s" "${hostDistributionPackageManager}"
}

function setClock {

  function setSystemClock {
    getAdministrativePrivileges
    printf "%s" "${processingSymbol} Setting system clock"
    sudo date --set="${year}-${month}-${day} ${hour}:${minute}:${second} ${offset}"
    local status=$(
      printf "%s" "${?}"
    )
    if [[ "${status}" != 0 ]]
    then
      printf "%s" "${failureSymbol} Failed to set system clock"
      return 1
    else
      printf "%s" "${successSymbol} Successfully set system clock"
    fi
  }

  function setHardwareClock {
    getAdministrativePrivileges
    printf "%s" "${processingSymbol} Setting hardware clock"
    local status=$(
      sudo hwclock --systohc
      printf "%s" "${?}"
    )
    if [[ "${status}" != 0 ]]
    then
      printf "%s" "${failureSymbol} Failed to set hardware clock"
      return 1
    else
      printf "%s" "${successSymbol} Successfully set hardware clock"
    fi
  }
  read -r -p "Enter year: " year
  read -r -p "Enter month: " month
  read -r -p "Enter day: " day
  read -r -p "Enter hour [24h]: " hour
  read -r -p "Enter minute: " minute
  read -r -p "Enter second: " second
  read -r -p "Enter offset [GMT+-] : " offset
  setSystemClock "${year}" "${month}" "${day}" "${hour}" "${minute}" "${second}" "${offset}"
  setHardwareClock
}
