declare -A scripts

scripts["scriptsPath"]="$(
  dirname $(
    realpath --canonicalize-existing $(
      readlink --canonicalize ${BASH_SOURCE[0]:-$0}
    )
  )
)"

scripts["includeScripts"]=$(
  function includeScripts {
    declare -A executables=(
      ["${scripts["scriptsPath"]}/ani-cli/ani-cli"]="posix"
      ["${scripts["scriptsPath"]}/distrobox/distrobox"]="posix"
      ["${scripts["scriptsPath"]}/xdeb/xdeb"]="posix"
      ["${scripts["scriptsPath"]}/deb-get/deb-get"]="bash"
      ["${scripts["scriptsPath"]}/debtap/debtap"]="bash"
      ["${scripts["scriptsPath"]}/fff/fff"]="bash"
      ["${scripts["scriptsPath"]}/git-forgit/bin/git-forgit"]="bash"
      ["${scripts["scriptsPath"]}/git-fuzzy/bin/git-fuzzy"]="bash"
      ["${scripts["scriptsPath"]}/neofetch/neofetch"]="bash"
      ["${scripts["scriptsPath"]}/tdrop/tdrop"]="bash"
      ["${scripts["scriptsPath"]}/ytfzf/ytfzf"]="posix"
    )
    for executable in "${!executables[@]}"
    do
      local executableUnit=$(
        basename "$executable"
      )
      if [[ "${executables["$executable"]}" == "posix" ]]
      then
        eval "$executableUnit () {
          bash --norc --noprofile --posix $executable \$@
        }"
      elif [[ "${executables["$executable"]}" == "bash" ]]
      then
        eval "$executableUnit () {
          bash --norc --noprofile $executable \$@
        }"
      fi
      unset executableUnit executable
    done
    unset executables
  }
  declare -f includeScripts
  unset -f includeScripts
)

scripts["includeCompletions"]=$(
  function includeCompletions {
    local completions=(
      "${scripts["scriptsPath"]}/deb-get/deb-get_completion"
      "${scripts["scriptsPath"]}/git-forgit/completions/git-forgit.bash"
    )
    completions+=($(
      find "${scripts["scriptsPath"]}/distrobox/completions" -type f
    ))
    for completion in "${completions[@]}"
    do
      source "$completion"
    done
    unset completions completion
  }
  declare -f includeCompletions
  unset -f includeCompletions
)

eval "${scripts["includeScripts"]}" && includeScripts && unset includeScripts

eval "${scripts["includeCompletions"]}" && includeCompletions && unset includeCompletions

unset scripts
