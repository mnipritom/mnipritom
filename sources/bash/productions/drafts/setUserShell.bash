function setUserShell {
  local userName="$1"
  local shellToSet="$2"
  local targetRootPartition="$3"
  local commandToExecute="\
  usermod "$userName"
  "
}
