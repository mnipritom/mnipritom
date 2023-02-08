export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR=nvim
export VISUAL=nvim

# [TODO] implement `BROWSER`
# [TODO] implement `TERM`
# [TODO] implement `PAGER`

shopt -s autocd
shopt -s cdspell
shopt -s cmdhist
shopt -s histappend

bashrcDirectory="$(
  cd "$(
    dirname "$(
      readlink --canonicalize "${BASH_SOURCE[0]:-$0}"
    )"
  )" && pwd
)"
source "$bashrcDirectory/sources/gatekeeper.bash"
bashHelperScripts="$bashrcDirectory/resources/scripts/helpers"

if [ -f "$bashHelperScripts/bash-completion/bash_completion" ]
then
  source "$bashHelperScripts/bash-completion/bash_completion"
else
  printf "%s\n" "$failureSymbol Failed to find bash completion script"
fi

if [ -f "$bashHelperScripts/fzf-tab-completion/bash/fzf-bash-completion.sh" ]
then
  source "$bashHelperScripts/fzf-tab-completion/bash/fzf-bash-completion.sh"
  bind -x '"\t": fzf_bash_completion'
  # export FZF_COMPLETION_AUTO_COMMON_PREFIX=true
  # export FZF_COMPLETION_AUTO_COMMON_PREFIX_PART=true
else
  printf "%s\n" "$failureSymbol Failed to find fzf bash completion wrapper script"
fi

unset bashrcDirectory
unset bashHelperScripts

eval "$( pandoc --bash-completion )"
eval "$( wezterm shell-completion --shell bash )"

function getExecutableScripts {
  local executableScriptsEntries=($(
    find "$downloadedExecutablesDirectory" -maxdepth 1 -type d -not -path "$downloadedExecutablesDirectory" -nowarn
  ))
  local executableScriptsPaths
  for script in "${executableScriptsEntries[@]}"
  do
    local scriptEntry="${script##$downloadedExecutablesDirectory/}"
    if [ -f "$script/$scriptEntry" ]
    then
      if [ ! -x "$script/$scriptEntry" ]
      then
        chmod +x "$script/$scriptEntry"
      else
        executableScriptsPaths+=(
          "$script"
        )
      fi
    elif [ -f "$script/bin/$scriptEntry" ]
    then
      if [ ! -x "$script/bin/$scriptEntry" ]
      then
        chmod +x "$script/bin/$scriptEntry"
      else
        executableScriptsPaths+=(
          "$script/bin"
        )
      fi
    fi
  done
  local availableExecutableScripts=$(
    printf "%s\n" "${executableScriptsPaths[@]}" | tr "\n" ":"
  )
  printf "%s" "$availableExecutableScripts"
}

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"

export PATH="$(
  getExecutableScripts
):$PATH"

source "$blocksDirectory/baseSystem/getUniquePathEntries.bash"

export PATH="$(
  getUniquePathEntries
)"

unset getExecutableScripts
unset getUniquePathEntries

aliases=($(
  find "$aliasesDirectory" -type f
))
for aliasesEntry in "${aliases[@]}"
do
  source "$aliasesEntry"
  if [ "$?" != 0 ]
  then
    printf "%s\n $failureSymbol Failed to load alias file : $aliasesEntry"
  fi
done

unset aliasesEntry
unset aliases

source "$blocksDirectory/baseSystem/generatePasswordPrompt.bash"
SUDO_ASKPASS_PROMPT="$(
  generatePasswordPrompt
)"
unset generatePasswordPrompt
export SUDO_ASKPASS="$SUDO_ASKPASS_PROMPT"
unset SUDO_ASKPASS_PROMPT

eval "$( starship init bash )"
eval "$( /home/linuxbrew/.linuxbrew/bin/brew shellenv )"

# [TODO] implement `FZF_DEFAULT_COMMAND`
export FZF_DEFAULT_OPTS="\
  --no-multi \
  --info hidden \
  --layout reverse \
  --height 15 \
  --prompt '❯ ' \
  --pointer '❯ ' \
"
