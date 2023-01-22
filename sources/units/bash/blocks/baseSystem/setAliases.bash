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
