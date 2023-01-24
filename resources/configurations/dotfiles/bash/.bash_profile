export bash_profileDirectory="$(
  cd "$(
    dirname "$(
      readlink --canonicalize "${BASH_SOURCE[0]:-$0}"
    )"
  )" && pwd
)"
source "$bash_profileDirectory/.bashrc"
unset bash_profileDirectory
