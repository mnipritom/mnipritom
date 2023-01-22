function checkCommandAvailability {
  local commandToCheck="$1"
  # consider `command -v`
  local status="$(
    which "$commandToCheck" &>/dev/null
    echo "$?"
  )"
  echo "$status"
}
function promptCheckCommandAvailability {
  local commandToCheck="$1"
  local status="$(
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
