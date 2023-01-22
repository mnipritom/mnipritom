paths() {
  echo "$PATH" | tr ":" "\n"
}
envs() {
  (
    source "$blocksDirectory/baseSystem/setStrictExecution.bash"
    setStrictExecution "on" &>/dev/null
    key="$(
      env | gawk --field-separator "=" '{
        print $1
      }' | fzf --layout reverse --height 20
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
repo() {
  cd "$worktreePath"
}
utils() {
  cd "$configuredUtilitiesDirectory"
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
  (
    source "$blocksDirectory/fileOutput/readFile.bash"
    readFile "$journalsDirectory/agendas.md" | less
  )
}
ideas() {
  (
    source "$blocksDirectory/fileOutput/readFile.bash"
    readFile "$journalsDirectory/ideas.md" | less
  )
}
walls() {
  (
    source "$blocksDirectory/fileOutput/getRandomFile.bash"
    wallpaperSource="$(
      getRandomFile $wallpapersDirectory
    )"
    wallpaper="/tmp/wallpaper.png"
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
      printf "%s\n" "${playlists[@]##$playlistsDirectory/}" | fzf --layout reverse --height 20
    )
    playlist=$(
      printf "%s\n" "${playlists[@]}" | grep --fixed-strings  "$selection"
    )
    echo "$processingSymbol Playing: $selection"
    mpv --playlist="$playlist" --no-resume-playback
    setStrictExecution "off" &>/dev/null
  )
}
