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
# [TODO] make `trees` `tree` context aware like `status` `stats` to work with any `git` repo
trees() {
  source "$blocksDirectory/baseSystem/setStrictExecution.bash"
  setStrictExecution "on" &>/dev/null
  worktreesPaths=($(
    git --git-dir $repositoryPath worktree list | gawk '{
      print $1
    }'
  ))
  worktreePathsWithoutBare=($(
    printf "%s\n" "${worktreesPaths[@]##$repositoryPath}"
  ))
  worktree=$(
    printf "%s\n" "${worktreePathsWithoutBare[@]##${worktreesDirectory##$repositoryPath}/}" | fzf
  )
  printf "%s\n" "$processingSymbol Switching to worktree : $worktree"
  cd $(
    printf "%s\n" "${worktreesPaths[@]}" | grep "$worktree"
  )
  unset worktreesPaths
  unset worktreePathsWithoutBare
  unset worktree
  setStrictExecution "off" &>/dev/null
}
tree() {
  if [ "$1" == "status" ] || [ "$1" == "stats" ]
  then
    status
  elif [ "$1" == "add" ]
  then
    git --git-dir $repositoryPath worktree add "$worktreesDirectory/$2"
    cd "$worktreesDirectory/$2"
  elif [ "$1" == "remove" ]
  then
    # [TODO] implementation
    return 0
  elif [ "$1" == "list" ]
  then
    trees
  elif [ "$1" != "" ] && [ -d "$worktreesDirectory/$1/." ]
  then
    printf "%s\n" "$processingSymbol Switching to worktree : $1"
    cd "$worktreesDirectory/$1"
  elif [ "$1" == "" ]
  then
    printf "%s\n" "$processingSymbol Switching to default worktree : $worktreePath"
    cd "$worktreePath"
  else
    printf "%s\n" "$failureSymbol Failed to find worktree : $1"
  fi
}
