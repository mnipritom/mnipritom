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
repo() {
  if [ "$1" == "trees" ]
  then
    trees
  else
    cd "$repositoryPath"
  fi
}
