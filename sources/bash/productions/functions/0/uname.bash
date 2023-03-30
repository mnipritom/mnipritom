_0["getProcessorArchitecture"]=$(
  function getProcessorArchitecture {
    uname --machine
  }
  declare -f getProcessorArchitecture
  unset -f getProcessorArchitecture
)

_0["getOperatingSystemName"]=$(
  function getOperatingSystemName {
    uname --operating-system
  }
  declare -f getOperatingSystemName
  unset -f getOperatingSystemName
)

_0["getKernelName"]=$(
  function getKernelName {
    uname --kernel-name
  }
  declare -f getKernelName
  unset -f getKernelName
)
