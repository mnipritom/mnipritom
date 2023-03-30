declare -A scripts

scripts["scriptsPath"]="$(
  dirname $(
    realpath --canonicalize-existing $(
      readlink --canonicalize ${BASH_SOURCE[0]:-${0}}
    )
  )
)"

scripts["includeScripts"]=$(
  function includeScripts {
    declare -A executables=(
      ["${scripts["scriptsPath"]}/ani-cli/ani-cli"]="posix"
      ["${scripts["scriptsPath"]}/apk.sh/apk.sh"]="bash"
      ["${scripts["scriptsPath"]}/badown/badown"]="bash"
      ["${scripts["scriptsPath"]}/bash2048/bash2048.sh"]="bash"
      ["${scripts["scriptsPath"]}/bashtop/bashtop"]="bash"
      ["${scripts["scriptsPath"]}/bd/bd"]="bash"
      ["${scripts["scriptsPath"]}/bocker/bocker"]="bash"
      ["${scripts["scriptsPath"]}/climate/climate"]="bash"
      ["${scripts["scriptsPath"]}/create-dmg/create-dmg"]="bash"
      ["${scripts["scriptsPath"]}/distrobox/distrobox"]="posix"
      ["${scripts["scriptsPath"]}/deb-get/deb-get"]="bash"
      ["${scripts["scriptsPath"]}/debtap/debtap"]="bash"
      ["${scripts["scriptsPath"]}/deb2appimage/deb2appimage.sh"]="bash"
      ["${scripts["scriptsPath"]}/fet.sh/fet.sh"]="posix"
      ["${scripts["scriptsPath"]}/fff/fff"]="bash"
      ["${scripts["scriptsPath"]}/git-forgit/bin/git-forgit"]="bash"
      ["${scripts["scriptsPath"]}/git-fuzzy/bin/git-fuzzy"]="bash"
      ["${scripts["scriptsPath"]}/gitflow/git-flow"]="posix"
      ["${scripts["scriptsPath"]}/junest/bin/junest"]="bash"
      ["${scripts["scriptsPath"]}/neofetch/neofetch"]="bash"
      ["${scripts["scriptsPath"]}/pacapt/pacapt"]="posix"
      ["${scripts["scriptsPath"]}/pfetch/pfetch"]="posix"
      ["${scripts["scriptsPath"]}/pipes.sh/pipes.sh"]="bash"
      ["${scripts["scriptsPath"]}/piu/piu"]="bash"
      ["${scripts["scriptsPath"]}/pkg2appimage/pkg2appimage"]="bash"
      ["${scripts["scriptsPath"]}/prettyping/prettyping"]="bash"
      ["${scripts["scriptsPath"]}/run_scaled/run_scaled"]="bash"
      ["${scripts["scriptsPath"]}/rxfetch/rxfetch"]="bash"
      ["${scripts["scriptsPath"]}/stowsh/stowsh"]="bash"
      ["${scripts["scriptsPath"]}/sysz/sysz"]="bash"
      ["${scripts["scriptsPath"]}/tbsm/src/tbsm"]="bash"
      ["${scripts["scriptsPath"]}/tdrop/tdrop"]="bash"
      ["${scripts["scriptsPath"]}/vpm/vpm"]="bash"
      ["${scripts["scriptsPath"]}/x11docker/x11docker"]="bash"
      ["${scripts["scriptsPath"]}/xb/xb"]="posix"
      ["${scripts["scriptsPath"]}/xdeb/xdeb"]="posix"
      ["${scripts["scriptsPath"]}/ytfzf/ytfzf"]="posix"
    )
    for executable in "${!executables[@]}"
    do
      local executableUnit=$(
        basename --suffix ".sh" "${executable}"
      )
      if [[ "${executables["${executable}"]}" == "posix" ]]
      then
        # [TODO] conditionally set script specific options/variables
        # [TODO] `bd` `fet.sh` `bash2048.sh` `apk.sh`
        eval "$executableUnit () {
          (
            bash --norc --noprofile --posix ${executable} \$@
          )
        }"
      elif [[ "${executables["${executable}"]}" == "bash" ]]
      then
        eval "$executableUnit () {
          (
            bash --norc --noprofile ${executable} \$@
          )
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
      "${scripts["scriptsPath"]}/extract/extract.sh"
    )
    for container in "${functions[@]}"
    do
      source "${container}"
    done
    unset functions container
  }
  declare -f includeFunctions
  unset -f includeFunctions
)

scripts["includeCompletions"]=$(
  function includeCompletions {
    local completions=(
      "${scripts["scriptsPath"]}/bd/bash_completion.d/bd"
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
      source "${completion}"
    done
    unset completions completion
  }
  declare -f includeCompletions
  unset -f includeCompletions
)

eval "${scripts["includeScripts"]}" && includeScripts && unset -f includeScripts

eval "${scripts["includeFunctions"]}" && includeFunctions && unset -f includeFunctions

eval "${scripts["includeCompletions"]}" && includeCompletions && unset -f includeCompletions

unset scripts
