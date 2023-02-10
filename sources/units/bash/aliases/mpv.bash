play() {
  # [TODO] implement https://ch1p.io/youtube-pip-linux/
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
    mpv --playlist="$playlist" &
    setStrictExecution "off" &>/dev/null
  )
}
