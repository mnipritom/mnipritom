# [TODO] alias every `git` command keywords and check if `PWD` is git repo to perform actions
status() {
  (
    source "$blocksDirectory/fileOutput/checkGitRepositoryStatus.bash"
    status="$(
      checkGitRepositoryStatus
    )"
    if [ "$status" == "repository" ] || [ "$status" == "worktree" ]
    then
      if [ "$PWD" == "$worktreePath" ]
      then
        git --git-dir "$worktreeRepository" --work-tree "$worktreePath" status
      else
        git status
      fi
    elif [ "$status" == "none" ]
    then
      printf "%s\n" "$failureSymbol Failed to find git repository : $PWD"
    fi
  )
}
stats() {
  status
}
sts() {
  stats
}
