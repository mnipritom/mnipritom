function setClock {
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  function setSystemClock {
    getAdministrativePrivileges
    echo "$processingSymbol Setting system clock"
    sudo date --set="$year-$month-$day $hour:$minute:$second $offset"
    local status=$(
      echo "$?"
    )
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to set system clock"
      return 1
    else
      echo "$successSymbol Successfully set system clock"
    fi
  }
  function setHardwareClock {
    getAdministrativePrivileges
    echo "$processingSymbol Setting hardware clock"
    local status=$(
      sudo hwclock --systohc
      echo "$?"
    )
    if [ "$status" != 0 ]
    then
      echo "$failureSymbol Failed to set hardware clock"
      return 1
    else
      echo "$successSymbol Successfully set hardware clock"
    fi
  }
  read -r -p "Enter year: " year
  read -r -p "Enter month: " month
  read -r -p "Enter day: " day
  read -r -p "Enter hour [24h]: " hour
  read -r -p "Enter minute: " minute
  read -r -p "Enter second: " second
  read -r -p "Enter offset [GMT+-] : " offset
  setSystemClock "$year" "$month" "$day" "$hour" "$minute" "$second" "$offset"
  setHardwareClock
}
