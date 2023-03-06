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
