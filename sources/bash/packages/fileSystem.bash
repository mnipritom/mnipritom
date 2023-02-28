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
play() {
  # [TODO] play random list if none specified
  # [TODO] implement https://ch1p.io/youtube-pip-linux/
  (
    source "$blocksDirectory/baseSystem/setStrictExecution.bash"
    setStrictExecution "on" &>/dev/null
    playlists=($(
      find "$producedDocumentsDirectory/playlists" -type f -name "*.m3u" -nowarn
    ))
    selection=$(
      printf "%s\n" "${playlists[@]##$producedDocumentsDirectory/playlists/}" | fzf
    )
    playlist=$(
      printf "%s\n" "${playlists[@]}" | grep --fixed-strings  "$selection"
    )
    echo "$processingSymbol Playing: $selection"
    mpv --playlist="$playlist" &
    setStrictExecution "off" &>/dev/null
  )
}
pdocs() {
  cd "$producedDocumentsDirectory"
}
rdocs() {
  cd "$referencedDocumentsDirectory"
}
repo() {
  cd "$repositoryPath"
}
# [TODO] implement `packs` to list packages installed
# [TODO] implement `dab`
pack() {
  (
    source "$actionsDirectory/baseSystem/installPackage.bash"
    installPackage "$1" "$systemPackageManager"
  )
}
walls() {
  # [TODO] implement setting hosted wallpapers from URL with `feh`
  (
    source "$blocksDirectory/baseSystem/setStrictExecution.bash"
    setStrictExecution "on" &>/dev/null
    wallpaper="/tmp/wallpaper.png"
    if [ "$1" == "list" ]
    then
      wallpapersSources=($(
        find $referencedIllustrationsDirectory/wallpapers -type f
      ))
      wallpaperIdentifier=$(
        printf "%s\n" "${wallpapersSources[@]##$referencedIllustrationsDirectory/wallpapers/}" | fzf
      )
      wallpaperSource=$(
        printf "%s\n" "${wallpapersSources[@]}" | grep "$wallpaperIdentifier"
      )
    else
      source "$blocksDirectory/fileOutput/getRandomFile.bash"
      wallpaperSource="$(
        getRandomFile $referencedIllustrationsDirectory/wallpapers
      )"
    fi
    dwebp "$wallpaperSource" -o "$wallpaper" -mt &>/dev/null
    if [ "$?" == 0 ]
    then
      echo "$processingSymbol Setting wallpaper : ${wallpaperSource##$referencedIllustrationsDirectory/wallpapers}"
      xwallpaper --zoom "$wallpaper"
    else
      echo "$failureSymbol Failed to set wallpaper : $wallpaperSource"
      return 1
    fi
    setStrictExecution "off" &>/dev/null
  )
}
