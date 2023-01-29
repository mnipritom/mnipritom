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
tree() {
  if [ "$1" == "status" ] || [ "$1" == "stats" ]
  then
    git --git-dir "$repositoryPath/worktrees/$worktreeIdentifier" --work-tree "$worktreePath" "status"
  else
    cd "$worktreePath"
  fi
}
repo() {
  if [ "$1" == "add" ]
  then
    git --git-dir $repositoryPath worktree add "$worktreesDirectory/$2"
    cd "$worktreesDirectory/$2"
  elif [ "$1" == "remove" ]
  then
    git --git-dir $repositoryPath worktree remove "$2"
    git --git-dir $repositoryPath branch --delete "$2"
  elif [ "$1" == "list" ] || [ "$1" == "trees" ]
  then
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
