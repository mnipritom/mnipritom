declare -A completions

completions["completionsPath"]="$(
  dirname $(
    realpath --canonicalize-existing $(
      readlink --canonicalize ${BASH_SOURCE[0]:-$0}
    )
  )
)"

completions["includeCompletions"]=$(
  function includeCompletions {
    if [[ -f "/usr/share/bash-completion/bash_completion" ]]
    then
      source "/usr/share/bash-completion/bash_completion"
    fi
    source "${completions["completionsPath"]}/bash-completion/bash_completion"

    source "${completions["completionsPath"]}/fzf-tab-completion/bash/fzf-bash-completion.sh"
    bind -x '"\t": fzf_bash_completion'
  }
  declare -f includeCompletions
  unset -f includeCompletions
)

completions["includeGenerators"]=$(
  function includeGenerators {
    declare -A generators=(
      ["brew"]="shellenv"
      ["flutter"]="bash-completion"
      ["npm"]="completion"
      ["pip"]="completion --bash"
      ["pip3"]="completion --bash"
      ["pandoc"]="--bash-completion"
      ["rustup"]="completions bash"
      ["rustup"]="completions bash cargo"
      ["wezterm"]="shell-completion --shell bash"
    )
    for generatorCommand in "${!generators[@]}"
    do
      local generatorPath=$(
        which "$generatorCommand"
      )
      if [[ "$generatorPath" != "" ]]
      then
        eval "$( $generatorPath ${generators[$generatorCommand]} )"
      fi
    done
    unset generatorCommand generatorPath generators
  }
  declare -f includeGenerators
  unset -f includeGenerators
)

eval "${completions["includeCompletions"]}" && includeCompletions && unset -f includeCompletions

eval "${completions["includeGenerators"]}" && includeGenerators && unset -f includeGenerators

unset completions
