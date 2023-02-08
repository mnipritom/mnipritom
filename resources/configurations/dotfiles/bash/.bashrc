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

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
export PATH=$(
  printf "%s" "$PATH" | tr ":" "\n" | sort --unique | tr "\n" ":"
)

export bashrcDirectory="$(
  cd "$(
    dirname "$(
      readlink --canonicalize "${BASH_SOURCE[0]:-$0}"
    )"
  )" && pwd
)"

source "$bashrcDirectory/sources/gatekeeper.bash"

aliases=($(
  find "$bashrcDirectory/sources/aliases" -type f
))
for aliasFile in "${aliases[@]}"
do
  source "$aliasFile"
  if [ "$?" != 0 ]
  then
    printf "%s\n $failureSymbol Failed to load alias file : $aliasFile"
  fi
done

unset aliasFile
unset aliases

source "$bashrcDirectory/sources/blocks/baseSystem/generatePasswordPrompt.bash"
SUDO_ASKPASS_PROMPT="$(
  generatePasswordPrompt
)"
unset generatePasswordPrompt
export SUDO_ASKPASS="$SUDO_ASKPASS_PROMPT"
unset SUDO_ASKPASS_PROMPT

unset bashrcDirectory

eval "$( starship init bash )"
eval "$( /home/linuxbrew/.linuxbrew/bin/brew shellenv )"
eval "$( pandoc --bash-completion )"
eval "$( wezterm shell-completion --shell bash )"

if [ -f "$downloadedHelpersDirectory/bash-completion/bash_completion" ]
then
  source "$downloadedHelpersDirectory/bash-completion/bash_completion"
else
  printf "%s\n" "$failureSymbol Failed to find bash completion script"
fi

if [ -f "$downloadedHelpersDirectory/fzf-tab-completion/bash/fzf-bash-completion.sh" ]
then
  source "$downloadedHelpersDirectory/fzf-tab-completion/bash/fzf-bash-completion.sh"
  bind -x '"\t": fzf_bash_completion'
  # export FZF_COMPLETION_AUTO_COMMON_PREFIX=true
  # export FZF_COMPLETION_AUTO_COMMON_PREFIX_PART=true
else
  printf "%s\n" "$failureSymbol Failed to find fzf bash completion wrapper script"
fi

# [TODO] implement `FZF_DEFAULT_COMMAND`
export FZF_DEFAULT_OPTS="\
  --no-multi \
  --info hidden \
  --layout reverse \
  --height 15 \
  --prompt '❯ ' \
  --pointer '❯ ' \
"
