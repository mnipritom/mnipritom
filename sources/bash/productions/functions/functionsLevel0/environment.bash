functionsLevel0["setStrictExecution"]=$(
  function setStrictExecution {
    local state="${1}"
    if [ "${state}" == "on" ]
    then
      printf "%s" "${processingSymbol} Enabling strict execution"
      set -o errexit
      set -o errtrace
      set -o pipefail
      # set -o nounset
    elif [ "${state}" == "off" ]
    then
      printf "%s" "${processingSymbol} Disabling strict execution"
      set +o errexit
      set +o errtrace
      set +o pipefail
      # set + nounset
    else
      printf "%s" "${failureSymbol} Failed to find state : $state"
      return 1
    fi
  }
  declare -f setStrictExecution
  unset -f setStrictExecution
)

functionsLevel0["setAliases"]=$(
  function setAliases {
    local state="${1}"
    if [[ "${state}" == "on" ]]
    then
      printf "%s" "${processingSymbol} Enabling aliases"
      shopt -s expand_aliases
    elif [[ "${state}" == "off" ]]
    then
      printf "%s" "${processingSymbol} Disabling aliases"
      shopt -u expand_aliases
    else
      printf "%s" "${failureSymbol} Failed to find state : $state"
      return 1
    fi
  }
  declare -f setAliases
  unset -f setAliases
)

functionsLevel0["getUniquePathEntries"]=$(
  function getUniquePathEntries {
    local uniquePathEntries="$(
    printf "%s" "${PATH}" \
    | tr ":" "\n" \
    | sort --unique \
    | tr "\n" ":"
    )"
    printf "%s" "${uniquePathEntries}"
  }
  declare -f getUniquePathEntries
  unset -f getUniquePathEntries
)

functionsLevel0["getAvailableDisks"]=$(
  function getAvailableDisks {
    # [NOTE] `exclude` 7 (loops), 11 (ROMs), 251 (swaps)
    lsblk --paths --nodeps --noheadings --exclude 7,11,251 --output NAME,VENDOR,TYPE,SIZE
  }
  declare -f getAvailableDisks
  unset -f getAvailableDisks
)
