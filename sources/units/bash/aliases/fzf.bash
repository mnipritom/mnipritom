killp() {
  (
    source "$blocksDirectory/baseSystem/setStrictExecution.bash"
    source "$dotfilesDirectory/fzf/sources/bash/tasks/killRunningProcess.bash"
    setStrictExecution "on" &>/dev/null
    killRunningProcess
    setStrictExecution "off" &>/dev/null
  )
}
