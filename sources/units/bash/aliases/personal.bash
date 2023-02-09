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
pack() {
  (
    source "$actionsDirectory/baseSystem/installPackage.bash"
    installPackage "$1" "$systemPackageManager"
  )
}
# [TODO] implement `packs` to list packages installed
