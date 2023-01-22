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
