pack() {
  (
    source "$actionsDirectory/baseSystem/installPackage.bash"
    installPackage "$1" "$systemPackageManager"
  )
}
# [TODO] implement `packs` to list packages installed
# [TODO] implement `dab`
