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
      ["${scripts["scriptsPath"]}/bash2048/bash2048.sh"]="bash"
      ["${scripts["scriptsPath"]}/bashtop/bashtop"]="bash"
      ["${scripts["scriptsPath"]}/climate/climate"]="bash"
      ["${scripts["scriptsPath"]}/distrobox/distrobox"]="posix"
      ["${scripts["scriptsPath"]}/deb-get/deb-get"]="bash"
      ["${scripts["scriptsPath"]}/debtap/debtap"]="bash"
      ["${scripts["scriptsPath"]}/fet.sh/fet.sh"]="posix"
      ["${scripts["scriptsPath"]}/fff/fff"]="bash"
      ["${scripts["scriptsPath"]}/git-forgit/bin/git-forgit"]="bash"
      ["${scripts["scriptsPath"]}/git-fuzzy/bin/git-fuzzy"]="bash"
      ["${scripts["scriptsPath"]}/junest/bin/junest"]="bash"
      ["${scripts["scriptsPath"]}/neofetch/neofetch"]="bash"
      ["${scripts["scriptsPath"]}/pacapt/pacapt"]="posix"
      ["${scripts["scriptsPath"]}/pfetch/pfetch"]="posix"
      ["${scripts["scriptsPath"]}/piu/piu"]="bash"
      ["${scripts["scriptsPath"]}/prettyping/prettyping"]="bash"
      ["${scripts["scriptsPath"]}/rxfetch/rxfetch"]="bash"
      ["${scripts["scriptsPath"]}/sysz/sysz"]="bash"
      ["${scripts["scriptsPath"]}/tdrop/tdrop"]="bash"
      ["${scripts["scriptsPath"]}/vpm/vpm"]="bash"
      ["${scripts["scriptsPath"]}/xb/xb"]="posix"
      ["${scripts["scriptsPath"]}/xdeb/xdeb"]="posix"
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

scripts["includeFunctions"]=$(
  function includeFunctions {
    local functions=(
      "${scripts["scriptsPath"]}/goto/goto.sh"
      "${scripts["scriptsPath"]}/up/up.sh"
      "${scripts["scriptsPath"]}/z/z.sh"
    )
    for container in "${functions[@]}"
    do
      source "$container"
    done
    unset functions container
  }
  declare -f includeFunctions
  unset -f includeFunctions
)

scripts["includeCompletions"]=$(
  function includeCompletions {
    local completions=(
      "${scripts["scriptsPath"]}/deb-get/deb-get_completion"
      "${scripts["scriptsPath"]}/git-forgit/completions/git-forgit.bash"
      "${scripts["scriptsPath"]}/vpm/bash-completion/completions/vpm"
      "${scripts["scriptsPath"]}/xb/complete/xb"
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

eval "${scripts["includeFunctions"]}" && includeFunctions && unset includeFunctions

eval "${scripts["includeCompletions"]}" && includeCompletions && unset includeCompletions

unset scripts
