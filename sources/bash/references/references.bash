declare -A references

references["referencesPath"]="$(
  dirname $(
    realpath --canonicalize-existing $(
      readlink --canonicalize ${BASH_SOURCE[0]:-$0}
    )
  )
)"

references["includeReferences"]=$(
  function includeReferences {
    source "${references["referencesPath"]}/completions/completions.bash"
    source "${references["referencesPath"]}/scripts/scripts.bash"
  }
  declare -f includeReferences
  unset -f includeReferences
)

eval "${references["includeReferences"]}" && includeReferences && unset -f includeReferences

unset references
