executionModifiers["setStrictExecution"]=$(
  function setStrictExecution {
    local state="$1"
    if [ "$state" == "on" ]
    then
      echo "$processingSymbol Enabling strict execution"
      set -o errexit
      set -o errtrace
      set -o pipefail
      # set -o nounset
    elif [ "$state" == "off" ]
    then
      echo "$processingSymbol Disabling strict execution"
      set +o errexit
      set +o errtrace
      set +o pipefail
      # set + nounset
    else
      echo "$failureSymbol Failed to find state : $state"
      return 1
    fi
  }
  declare -f setStrictExecution
  unset -f setStrictExecution
)

executionModifiers["setAliases"]=$(
  function setAliases {
    local state="$1"
    if [ "$state" == "on" ]
    then
      echo "$processingSymbol Enabling aliases"
      shopt -s expand_aliases
    elif [ "$state" == "off" ]
    then
      echo "$processingSymbol Disabling aliases"
      shopt -u expand_aliases
    else
      echo "$failureSymbol Failed to find state : $state"
      return 1
    fi
  }
  declare -f setAliases
  unset -f setAliases
)
