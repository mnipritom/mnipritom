walls() {
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
