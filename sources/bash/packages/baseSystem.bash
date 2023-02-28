paths() {
  printf "%s\n" "$PATH" | tr ":" "\n"
}
envs() {
  (
    source "$blocksDirectory/baseSystem/setStrictExecution.bash"
    setStrictExecution "on" &>/dev/null
    key="$(
      env | gawk --field-separator "=" '{
        print $1
      }' | fzf
    )"
    value="$(
      printenv $key
    )"
    echo "$processingSymbol Fetching values: $key"
    if [ "$key" == "PATH" ]
    then
      paths
    else
      echo "$value"
    fi
    setStrictExecution "off" &>/dev/null
  )
}
linc() {
  (
    source "$blocksDirectory/fileSystem/createSymbolicLink.bash"
    promptCreateSymbolicLink "$1" "$2"
  )
}
killp() {
  (
    source "$blocksDirectory/baseSystem/setStrictExecution.bash"
    source "$blocksDirectory/baseSystem/killRunningProcess.bash"
    setStrictExecution "on" &>/dev/null
    killRunningProcess
    setStrictExecution "off" &>/dev/null
  )
}
