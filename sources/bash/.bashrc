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

declare -A VARIABLES=(
  # [TODO] implement `FZF_DEFAULT_COMMAND`
  # [TODO] implement `BROWSER`
  # [TODO] implement `TERM`
  # [TODO] implement `PAGER`
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

PATHS=(
  "$HOME/go"
  "$GOPATH/bin"
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "/home/linuxbrew/.linuxbrew/bin"
)
for path in "${PATHS[@]}"
do
  if [ -d "$path" ]
  then
    export "PATH=$PATH:$path"
  fi
done
unset path PATHS

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

source "$bashrcDirectory/completions/bash-completion/bash_completion"
source "$bashrcDirectory/completions/fzf-tab-completion/bash/fzf-bash-completion.sh"
bind -x '"\t": fzf_bash_completion'

unset bashrcDirectory
