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
