declare -A _0
declare -A _1
declare -A _2

function functions {
  local state="${1}"

  local functionsPath="$(
    dirname $(
      realpath --canonicalize-existing $(
        readlink --canonicalize ${BASH_SOURCE[0]:-${0}}
      )
    )
  )"

  local functionsContainers=($(
    find "${functionsPath}" -type d -not -path "${functionsPath}"
  ))

  local containerFiles

  for container in "${functionsContainers[@]}"
  do
    containerFiles+=($(
      find "${container}" -type f -name "*.bash"
    ))
  done

  if [[ "${state}" == "on" ]]
  then
    for containerFile in "${containerFiles[@]}"
    do
      source "${containerFile}"
    done
  elif [[ "${state}" == "off" ]]
  then
    unset _0
    unset _1
    unset _2
    unset -f functions
  fi

  unset functionsPath
  unset functionsContainers containerFiles containerFile
  unset state
}

functions "on"
