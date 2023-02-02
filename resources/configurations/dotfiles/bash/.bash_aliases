# [TODO] alias every `git` command keywords and check if `PWD` is git repo to perform actions
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
docs() {
  cd "$producedDocumentsDirectory"
}
dots() {
  cd "$dotfilesDirectory"
}
refs() {
  cd "$referencesDirectory"
}
utils() {
  cd "$configuredUtilitiesDirectory"
}
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
repo() {
  if [ "$1" == "trees" ]
  then
    trees
  else
    cd "$repositoryPath"
  fi
}
ddots() {
  (
    source "$dotfilesDirectory/handler.bash"
    handleDotfiles "deploy" "$1"
  )
}
rdots() {
  (
    source "$dotfilesDirectory/handler.bash"
    handleDotfiles "retract" "$1"
  )
}
list() {
  (
    source "$configuredUtilitiesDirectory/handler.bash"
    if [ "$1" != "" ]
    then
      handleUtilities "parse" "packages" "$1"
    else
      handleUtilities "parse" "packages" "$systemPackageManager"
    fi
  )
}
pack() {
  (
    source "$actionsDirectory/baseSystem/installPackage.bash"
    installPackage "$1" "$systemPackageManager"
  )
}
tasks() {
  # [TODO] implement [source](https://www.youtube.com/watch?v=zB_3FIGRWRU)
  (
    source "$blocksDirectory/fileOutput/readFile.bash"
    readFile "$journalsDirectory/agendas.md" | less
  )
}
ideas() {
  # [TODO] implement [source](https://www.youtube.com/watch?v=zB_3FIGRWRU)
  (
    source "$blocksDirectory/fileOutput/readFile.bash"
    readFile "$journalsDirectory/ideas.md" | less
  )
}
walls() {
  (
    source "$blocksDirectory/baseSystem/setStrictExecution.bash"
    setStrictExecution "on" &>/dev/null
    wallpaper="/tmp/wallpaper.png"
    if [ "$1" == "list" ]
    then
      wallpapersSources=($(
        find $wallpapersDirectory -type f
      ))
      wallpaperIdentifier=$(
        printf "%s\n" "${wallpapersSources[@]##$wallpapersDirectory/}" | fzf
      )
      wallpaperSource=$(
        printf "%s\n" "${wallpapersSources[@]}" | grep "$wallpaperIdentifier"
      )
    else
      source "$blocksDirectory/fileOutput/getRandomFile.bash"
      wallpaperSource="$(
        getRandomFile $wallpapersDirectory
      )"
    fi
    dwebp "$wallpaperSource" -o "$wallpaper" -mt &>/dev/null
    if [ "$?" == 0 ]
    then
      echo "$processingSymbol Setting wallpaper : ${wallpaperSource##$wallpapersDirectory/}"
      xwallpaper --zoom "$wallpaper"
    else
      echo "$failureSymbol Failed to set wallpaper : $wallpaperSource"
      return 1
    fi
    setStrictExecution "off" &>/dev/null
  )
}
play() {
  (
    source "$blocksDirectory/baseSystem/setStrictExecution.bash"
    setStrictExecution "on" &>/dev/null
    playlists=($(
      find "$playlistsDirectory" -type f -name "*.m3u" -nowarn
    ))
    selection=$(
      printf "%s\n" "${playlists[@]##$playlistsDirectory/}" | fzf
    )
    playlist=$(
      printf "%s\n" "${playlists[@]}" | grep --fixed-strings  "$selection"
    )
    echo "$processingSymbol Playing: $selection"
    mpv --playlist="$playlist" --no-resume-playback
    setStrictExecution "off" &>/dev/null
  )
}
