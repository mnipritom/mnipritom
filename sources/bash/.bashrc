shopt -s autocd cdspell cdable_vars
shopt -s cmdhist histappend histreedit histverify
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s extglob

# [TODO] implement `FZF_DEFAULT_COMMAND`
# [TODO] implement `BROWSER`
# [TODO] implement `TERM`
# [TODO] implement `PAGER`

export FZF_DEFAULT_OPTS="--layout reverse --height 15"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus

export TERM=xterm
export EDITOR="nvim"
export VISUAL="nvim"
export GIT_EDITOR="nvim"

alias paths="printf '%s\n' ${PATH} | tr ':' '\n'"
PATHS=(
  "${HOME}/go"
  "${GOPATH}/bin"
  "${HOME}/.local/bin"
  "${HOME}/.cargo/bin"
  "/home/linuxbrew/.linuxbrew/bin"
)
for path in "${PATHS[@]}"
do
  if [[ -d "${path}" ]]
  then
    export PATH=${PATH}:${path}
  fi
done
unset path PATHS

# [TODO] de-duplicate `PATH` entries

declare -A bashParameters

bashParameters["bashSourcesPath"]="$(
  dirname $(
    realpath --canonicalize-existing $(
      readlink --canonicalize ${BASH_SOURCE[0]:-${0}}
    )
  )
)"

bashParameters["worktreeDataPath"]=$(
  cd "${bashParameters["bashSourcesPath"]}/../../"
  if [[ $( git rev-parse --is-inside-work-tree ) ]]
  then
    printf "%s" "${PWD}"
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
  if [[ "${worktreesDirectoryIdentifier}" == "${worktreeRepositoryIdentifier}" ]]
  then
    printf "${worktreesDirectoryIdentifier}"
  else
    printf "${worktreeRepositoryIdentifier}"
  fi
  unset worktreesDirectoryIdentifier worktreeRepositoryIdentifier
)

source "${bashParameters["bashSourcesPath"]}/references/references.bash"

unset bashParameters
