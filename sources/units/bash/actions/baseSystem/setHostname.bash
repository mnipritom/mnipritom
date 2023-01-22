function setHostname {
  local hostnameToSet="$1"
  local targetRootFileSystem="$2"
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  source "$modulesDirectory/baseSystem/chrootExecute.bash"
  source "$snippetsDirectory/baseSystem/getBinaryPath.bash"
  local targetBashBinary=$(
    getBinaryPath "bash" "$targetRootFileSystem"
  )
  local hostnameFile="$dumpsDirectory/hostname"
  local localHostIPAddress="127.0.0.1"
  # `hostname` binary is part of GNU coreutils
  local commandToExecute="hostname $hostnameToSet"
  touch "$hostnameFile"
  echo "$hostnameToSet" > "$hostnameFile"
  getAdministrativePrivileges
  if [ "$targetRootFileSystem" != "" ]
  then
    echo "$processingSymbol Setting static hostname : $hostnameToSet -> $targetRootFileSystem"
    sudo mv --force "$hostnameFile" "$targetRootFileSystem/etc/hostname"
    echo "$processingSymbol Setting transient hostname : $hostnameToSet -> $targetRootFileSystem"
    chrootExecute "command" "$targetRootFileSystem" "$commandToExecute" &>/dev/null
    echo "$processingSymbol Adding entry : $hostnameToSet -> $targetRootFileSystem/etc/hosts"
    sudo "$targetBashBinary" -c "echo $localHostIPAddress	$hostnameToSet >> $targetRootFileSystem/etc/hosts"
  else
    echo "$processingSymbol Setting static hostname : $hostnameToSet"
    sudo mv --force "$hostnameFile" "/etc/hostname"
    echo "$processingSymbol Setting transient hostname : $hostnameToSet"
    eval sudo "$commandToExecute"
    echo "$processingSymbol Adding entry : $hostnameToSet -> /etc/hosts"
    sudo "$targetBashBinary" -c "echo $localHostIPAddress	$hostnameToSet >> /etc/hosts"
  fi
}
