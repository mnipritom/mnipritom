shopt -s autocd
shopt -s cdspell
shopt -s cdable_vars
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s extglob

# [TODO] implement `FZF_DEFAULT_COMMAND`
# [TODO] implement `BROWSER`
# [TODO] implement `TERM`
# [TODO] implement `PAGER`
declare -A VARIABLES=(
  ["LANG"]="en_US.UTF-8"
  ["LC_ALL"]="en_US.UTF-8"
  ["EDITOR"]=nvim
  ["VISUAL"]=nvim
  ["GIT_EDITOR"]=nvim
  ["FZF_DEFAULT_OPTS"]="\
    --no-multi \
    --info hidden \
    --layout reverse \
    --height 15 \
    --prompt '❯ ' \
    --pointer '❯ ' \
  "
)

for variableId in "${!VARIABLES[@]}"
do
  export "$variableId=${VARIABLES["$variableId"]}"
done
unset variableId VARIABLES

declare -A PATHS=(
  ["GOPATH"]="$HOME/go"
  ["PATH"]="$GOPATH/bin"
  ["PATH"]="$HOME/.local/bin"
  ["PATH"]="$HOME/.cargo/bin"
  ["PATH"]="/home/linuxbrew/.linuxbrew/bin"
)

for pathId in "${!PATHS[@]}"
do
  if [ -d "${PATHS["$pathId"]}" ]
  then
    export "$pathId=$PATH:${PATHS["$pathId"]}"
  fi
done
unset pathId PATHS

declare -A EVALS=(
  ["pandoc"]="--bash-completion"
  ["wezterm"]="shell-completion --shell bash"
  ["starship"]="init bash"
  ["brew"]="shellenv"
)

for evalCommand in "${!EVALS[@]}"
do
  commandPath=$(
    which "$evalCommand"
  )
  if [ "$commandPath" != "" ]
  then
    eval "$( $commandPath ${EVALS[$evalCommand]} )"
  fi
done
unset evalCommand commandPath EVALS

bashrcDirectory="$(
  dirname $(
    realpath --canonicalize-existing $(
      readlink --canonicalize ${BASH_SOURCE[0]:-$0}
    )
  )
)"

bashHelperScripts="$bashrcDirectory/resources/scripts/helpers"
source "$bashHelperScripts/bash-completion/bash_completion"
source "$bashHelperScripts/fzf-tab-completion/bash/fzf-bash-completion.sh"
bind -x '"\t": fzf_bash_completion'
unset bashHelperScripts

source "$bashrcDirectory/sources/blocks/baseSystem/generatePasswordPrompt.bash"
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
