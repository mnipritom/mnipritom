functionsLevel0["killRunningProcess"]=$(
  function killRunningProcess {
    # [LINK] https://github.com/junegunn/fzf/blob/master/ADVANCED.md#updating-the-list-of-processes-by-pressing-ctrl-r
    (
      date && ps -ef
    ) | fzf \
      --bind='ctrl-r:reload(date; ps -ef)' \
      --header=$'Press CTRL-R to reload\n\n' --header-lines=2 \
      --preview='echo {}' --preview-window=down,3,wrap \
      --layout=reverse --height=80% | gawk '{
        print $2
      }' | xargs kill -9
  }
  declare -f killRunningProcess
  unset -f killRunningProcess
)
