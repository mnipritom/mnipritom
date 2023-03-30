_0["getAdministrativePrivileges"]=$(
  function getAdministrativePrivileges {
    sudo --validate
  }
  declare -f getAdministrativePrivileges
  unset -f getAdministrativePrivileges
)

_0["revokeAdministrativePrivileges"]=$(
  function revokeAdministrativePrivileges {
    sudo --remove-timestamp
  }
  declare -f revokeAdministrativePrivileges
  unset -f revokeAdministrativePrivileges
)
