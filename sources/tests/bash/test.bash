workingDirectory="$(
  cd "$(
    dirname "$(
      readlink --canonicalize "${BASH_SOURCE[0]:-$0}"
    )"
  )" && pwd
)"
worktree=$(
  cd "$workingDirectory/../../../" && pwd
)
source "$worktree/sources/units/bash/gatekeeper.bash"
