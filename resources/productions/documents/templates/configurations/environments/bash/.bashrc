export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR=nvim
export VISUAL=nvim

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"

export GIT_EDITOR=nvim

# [TODO] implement `FZF_DEFAULT_COMMAND`
export FZF_DEFAULT_OPTS="\
  --no-multi \
  --info hidden \
  --layout reverse \
  --height 15 \
  --prompt '❯ ' \
  --pointer '❯ ' \
"

# [TODO] implement `BROWSER`
# [TODO] implement `TERM`
# [TODO] implement `PAGER`

eval "$( pandoc --bash-completion )"
eval "$( wezterm shell-completion --shell bash )"

eval "$( starship init bash )"
eval "$( /home/linuxbrew/.linuxbrew/bin/brew shellenv )"

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

bashHelperScripts="$bashrcDirectory/resources/scripts/helpers"
source "$bashHelperScripts/bash-completion/bash_completion"
source "$bashHelperScripts/fzf-tab-completion/bash/fzf-bash-completion.sh"
bind -x '"\t": fzf_bash_completion'
unset bashHelperScripts

source "$bashrcDirectory/sources/blocks/baseSystem/getUniquePathEntries.bash"
source "$bashrcDirectory/sources/blocks/baseSystem/generatePasswordPrompt.bash"
export PATH="$(
  getUniquePathEntries
)"
unset getUniquePathEntries
SUDO_ASKPASS_PROMPT="$(
  generatePasswordPrompt
)"
export SUDO_ASKPASS="$SUDO_ASKPASS_PROMPT"
unset generatePasswordPrompt
unset SUDO_ASKPASS_PROMPT

source "$bashrcDirectory/sources/gatekeeper.bash"
setEnvironmentParameters "on"
unset setEnvironmentParameters
unset bashrcDirectory
