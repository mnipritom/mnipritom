killp() {
  (
    source "$blocksDirectory/baseSystem/setStrictExecution.bash"
    source "$blocksDirectory/baseSystem/killRunningProcess.bash"
    setStrictExecution "on" &>/dev/null
    killRunningProcess
    setStrictExecution "off" &>/dev/null
  )
}
