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
  "
)
for variableEntry in "${!VARIABLES[@]}"
do
  export "$variableEntry=${VARIABLES["$variableEntry"]}"
done
unset variableEntry VARIABLES

PATHS=(
  "$HOME/go"
  "$GOPATH/bin"
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "/home/linuxbrew/.linuxbrew/bin"
)
for path in "${PATHS[@]}"
do
  if [[ -d "$path" ]]
  then
    export "PATH=$PATH:$path"
  fi
done
unset path PATHS


declare -A bashParameters

bashParameters["bashSourcesPath"]="$(
  dirname $(
    realpath --canonicalize-existing $(
      readlink --canonicalize ${BASH_SOURCE[0]:-$0}
    )
  )
)"

bashParameters["worktreeDataPath"]=$(
  cd "${bashParameters["bashSourcesPath"]}/../../"
  if [[ $( git rev-parse --is-inside-work-tree ) ]]
  then
    printf "%s" "$PWD"
  fi
)

bashParameters["worktreeInformationPath"]=$(
  cd "${bashParameters["worktreeDataPath"]}" && \
  git rev-parse --absolute-git-dir
)

bashParameters["repositoryInformationPath"]=$(
  cd "${bashParameters["worktreeDataPath"]}" && \
  git rev-parse --path-format=absolute --git-common-dir
)

bashParameters["worktreeIdentifier"]=$(
  worktreesDirectoryIdentifier=$(
    basename "${bashParameters["worktreeDataPath"]}"
  )
  worktreeRepositoryIdentifier=$(
    cd "${bashParameters["worktreeDataPath"]}" && \
    git branch --show-current
  )
  if [[ "$worktreesDirectoryIdentifier" == "$worktreeRepositoryIdentifier" ]]
  then
    printf "$worktreesDirectoryIdentifier"
  else
    printf "$worktreeRepositoryIdentifier"
  fi
  unset worktreesDirectoryIdentifier worktreeRepositoryIdentifier
)

source "${bashParameters["bashSourcesPath"]}/completions/completions.bash"

source "${bashParameters["bashSourcesPath"]}/scripts/scripts.bash"

unset bashParameters
