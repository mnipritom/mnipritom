declare -A executionModifiers
declare -A systemFunctions
declare -A rofiFunctions
declare -A fzfFunctions

functions="$(
  dirname $(
    realpath --canonicalize-existing $(
      readlink --canonicalize ${BASH_SOURCE[0]:-$0}
    )
  )
)"
