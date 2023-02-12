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
