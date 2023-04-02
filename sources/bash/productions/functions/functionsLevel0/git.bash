functionsLevel0["checkGitRepositoryStatus"]=$(
  # [NOTE] - dependent on environment variable `PWD`
  #        - `--is-inside-git-dir` `--is-inside-work-tree` can only report `true`, in `false` cases they print error message to stdout
  function checkGitRepositoryStatus {
    local repositoryStatus=$(
      git rev-parse --is-inside-git-dir &>/dev/null
      printf "%s" "$?"
    )
    local worktreeStatus=$(
      git rev-parse --is-inside-work-tree &>/dev/null
      printf "%s" "$?"
    )
    if [ "$repositoryStatus" == 0 ] || [ "$worktreeStatus" == 0 ]
    then
      if [ "$repositoryStatus" == 0 ]
      then
        printf "%s" "repository"
      elif [ "$worktreeStatus" == 0 ]
      then
        printf "%s" "worktree"
      fi
      return 0
    else
      printf "%s" "none"
      return 1
    fi
  }
  declare -f checkGitRepositoryStatus
  unset -f checkGitRepositoryStatus
)
