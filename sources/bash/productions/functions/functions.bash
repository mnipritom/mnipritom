declare -A functionsLevel0
declare -A functionsLevel1
declare -A functionsLevel2

functions {
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
    unset functionsLevel0
    unset functionsLevel1
    unset functionsLevel2
    unset -f functions
  fi

  unset functionsPath
  unset functionsContainers containerFiles containerFile
  unset state
}

functions "on"
