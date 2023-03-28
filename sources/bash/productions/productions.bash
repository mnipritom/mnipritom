declare -A writings
declare -A colors
declare -A prompts
declare -A symbols

colors["black"]='\e[0;30m'
colors["red"]='\e[0;31m'
colors["green"]='\e[0;32m'
colors["yellow"]='\e[0;33m'
colors["blue"]='\e[0;34m'
colors["purple"]='\e[0;35m'
colors["cyan"]='\e[0;36m'
colors["white"]='\e[0;37m'

prompts["success"]="Successfully evaluated"
prompts["failure"]="Failed to evaluate"
prompts["promptSymbol"]=$(
  function promptSymbol {
    local symbolToPrompt="$1"
    local promptColor="$2"
    printf "$promptColor%s\n" "$symbolToPrompt"
  }
)

symbols["processing"]="[*]"
symbols["success"]="[~]"
symbols["failure"]="[X]"
symbols["warning"]="[!]"


readOnlyValuesOrder=(
  "writingsStatus"
  "writingsDirectory"
  "worktreeIdentifier"
  "worktreeRepository"
  "repositoryPath"
  "worktreesDirectory"
  "aliasesDirectory"
  "resourcesDirectory"
  "diagnosticsDirectory"
  "diagnosedDumpsDirectory"
  "diagnosedReportsDirectory"
  "diagnosedExtractsDirectory"
  "productionsDirectory"
  "producedDocumentsDirectory"
  "producedIllustrationsDirectory"
  "producedRecordingsDirectory"
  "referencesDirectory"
  "referencedDocumentsDirectory"
  "referencedIllustrationsDirectory"
  "referencedUtilitiesDirectory"
  "releasesDirectory"
)

writings["writingsDirectory"]="$(
  dirname $(
    realpath --canonicalize-existing $(
      readlink --canonicalize ${BASH_SOURCE[0]:-$0}
    )
  )
)"

writings["writingsStatus"]="available"

writings["functionsDirectory"]="${writings["writingsDirectory"]}/functions"
writings["aliasesDirectory"]="${writings["writingsDirectory"]}/aliases"

writings["resourcesDirectory"]=$(
  realpath "${writings["writingsDirectory"]}/../../../resources"
)

writings["diagnosticsDirectory"]="${writings["resourcesDirectory"]}/diagnostics"
writings["diagnosedDumpsDirectory"]="${writings["diagnosticsDirectory"]}/dumps"
writings["diagnosedExtractsDirectory"]="${writings["diagnosticsDirectory"]}/extracts"
writings["diagnosedReportsDirectory"]="${writings["diagnosticsDirectory"]}/reports"

writings["productionsDirectory"]="${writings["resourcesDirectory"]}/productions"
writings["producedDocumentsDirectory"]="${writings["productionsDirectory"]}/documents"
writings["producedIllustrationsDirectory"]="${writings["productionsDirectory"]}/illustrations"
writings["producedRecordingsDirectory"]="${writings["productionsDirectory"]}/recordings"

writings["referencesDirectory"]="${writings["resourcesDirectory"]}/references"
writings["referencedDocumentsDirectory"]="${writings["referencesDirectory"]}/documents"
writings["referencedIllustrationsDirectory"]="${writings["referencesDirectory"]}/illustrations"

writings["releasesDirectory"]="${writings["resourcesDirectory"]}/releases"

writings["systemPackageManager"]="$(
  getSystemPackageManager
)" && readOnlyValuesOrder+=(
  "systemPackageManager"
)

writings["workingDistributions"]=$(
  function getWorkingDistributions {
    local hostDistribution=$(
      eval "${functions["getHostDistribution"]}"
      getHostDistribution
      unset -f getHostDistribution
    )
    local availableDistributionsEntries=(
      "void"
      "devuan"
      "debian"
      "ubuntu"
      "kali"
      "parrot"
    )
    # [TODO] implement support for `nix` `guix` `hyperbola` `parabola` `trisquel`
    local supportedDistributionsEntries=(
      "artix"
      "arch"
      "fedora"
      "opensuse"
    )
    local workingDistributionsEntries+=($(
      printf "%s\n" "${availableDistributionsEntries[@]}"
    ))
    for supportedDistribution in "${supportedDistributionsEntries[@]}"
    do
      if grep --ignore-case --quiet "$supportedDistribution" <<< "$hostDistribution"
      then
        workingDistributionsEntries+=(
          "$supportedDistribution"
        )
        break
      fi
    done
    printf "%s\n" "${workingDistributionsEntries[@]}"
  }
  getWorkingDistributions | tr "\n" " "
  unset -f getWorkingDistributions
) && readOnlyValuesOrder+=(
  "workingDistributions"
)

unset readOnlyValuesOrder
