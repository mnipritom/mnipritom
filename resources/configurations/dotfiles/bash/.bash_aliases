# [TODO] alias every `git` command keywords and check if `PWD` is git repo to perform actions
alias fzf="\
  fzf \
  --no-multi \
  --info hidden \
  --layout reverse \
  --height 15 \
  --prompt '❯ ' \
  --pointer '❯ ' \
"
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
  # `--is-inside-git-dir` `--is-inside-work-tree` can only report `true`
  # in `false` cases they print error message to stdout
  (
    repository=$(
      git rev-parse --is-inside-git-dir &>/dev/null
      printf "%s" "$?"
    )
    worktree=$(
      git rev-parse --is-inside-work-tree &>/dev/null
      printf "%s" "$?"
    )
    if [ "$repository" != 0 ] || [ "$worktree" != 0 ]
    then
      git --git-dir "$worktreeRepository" --work-tree "$worktreePath" status
    else
      git status
    fi
  )
}
stats() {
  status
}
trees() {
  worktreesPaths=($(
    git --git-dir $repositoryPath worktree list | gawk '{
      print $1
    }'
  ))
  worktree=$(
    printf "%s\n" "${worktreesPaths[@]##$repositoryPath}" | fzf
  )
  cd $(
    printf "%s\n" "${worktreesPaths[@]}" | grep "$worktree"
  )
  unset worktreesPaths
  unset worktree
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
   # || [ "$1" == "trees" ]
  cd "$repositoryPath"
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
