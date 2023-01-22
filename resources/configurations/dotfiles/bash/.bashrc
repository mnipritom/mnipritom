export LANG="en_US.utf8"
export EDITOR=nvim
export VISUAL=nvim
# [TODO] implement `PAGER`
shopt -s autocd
shopt -s cdspell
bind "set completion-ignore-case on"
shopt -s cmdhist
shopt -s histappend

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"

eval "$( starship init bash )"
eval "$( /home/linuxbrew/.linuxbrew/bin/brew shellenv )"
eval "$( pandoc --bash-completion )"

export bashrcDirectory="$(
  cd "$(
    dirname "$(
      readlink --canonicalize "${BASH_SOURCE[0]:-$0}"
    )"
  )" && pwd
)"

export worktree="$(
  cd "$bashrcDirectory/../../../../" && pwd
)"

source "$worktree/sources/units/bash/gatekeeper.bash"
source "$bashrcDirectory/.bash_aliases"

unset bashrcDirectory
unset worktree

source "$dotfilesDirectory/rofi/.config/rofi/sources/bash/tasks/generatePasswordPrompt.bash"
SUDO_ASKPASS_PROMPT="$(
  generatePasswordPrompt
)"
unset generatePasswordPrompt
export SUDO_ASKPASS="$SUDO_ASKPASS_PROMPT"
unset SUDO_ASKPASS_PROMPT

if [ -f "$dotfilesDirectory/bash/bash-completion/bash_completion" ]
then
  source "$dotfilesDirectory/bash/bash-completion/bash_completion"
fi

if [ -f "$dotfilesDirectory/fzf/fzf-tab-completion/bash/fzf-bash-completion.sh" ]
then
  source "$dotfilesDirectory/fzf/fzf-tab-completion/bash/fzf-bash-completion.sh"
  bind -x '"\t": fzf_bash_completion'
fi
