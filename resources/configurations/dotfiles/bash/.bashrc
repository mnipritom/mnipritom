export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR=nvim
export VISUAL=nvim

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

export currentWorktree="$(
  cd "$bashrcDirectory/../../../../" && pwd
)"

source "$currentWorktree/sources/units/bash/gatekeeper.bash"
source "$bashrcDirectory/.bash_aliases"

unset bashrcDirectory
unset currentWorktree

source "$dotfilesDirectory/rofi/.config/rofi/scripts/bash/tasks/generatePasswordPrompt.bash"
SUDO_ASKPASS_PROMPT="$(
  generatePasswordPrompt
)"
unset generatePasswordPrompt
export SUDO_ASKPASS="$SUDO_ASKPASS_PROMPT"
unset SUDO_ASKPASS_PROMPT

eval "$( starship init bash )"
eval "$( /home/linuxbrew/.linuxbrew/bin/brew shellenv )"
eval "$( pandoc --bash-completion )"
eval "$( wezterm shell-completion --shell bash )"

if [ -f "$dotfilesDirectory/bash/bash-completion/bash_completion" ]
then
  source "$dotfilesDirectory/bash/bash-completion/bash_completion"
else
  printf "%s\n" "$failureSymbol Failed to find bash completion script"
fi

if [ -f "$dotfilesDirectory/fzf/fzf-tab-completion/bash/fzf-bash-completion.sh" ]
then
  source "$dotfilesDirectory/fzf/fzf-tab-completion/bash/fzf-bash-completion.sh"
  bind -x '"\t": fzf_bash_completion'
else
  printf "%s\n" "$failureSymbol Failed to find fzf bash completion wrapper script"
fi
