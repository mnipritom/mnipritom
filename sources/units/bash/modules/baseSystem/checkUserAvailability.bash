function checkUserAvailability {
  source "$snippetsDirectory/baseSystem/listUsers.bash"
  local targetUser="$1"
  local targetRootFileSystem="$2"
  local usersList=($(
    listUsers "$targetRootFileSystem"
  ))
  local userAvailability="no"
  for user in "${usersList[@]}"
  do
    # [TODO] consider: `if ! grep --word-regexp --quiet "$targetUser" <<< "${usersList[@]}"`
    if [ "$user" == "$targetUser" ]
    then
      userAvailability="yes"
      break
    fi
  done
  echo "$userAvailability"
}
