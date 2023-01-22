function handleUtilities {
  if [ "$gatekeeperStatus" != "available" ]
  then
    local configuredUtilitiesDirectory="$(
      cd "$(
        dirname "$(
          readlink --canonicalize "${BASH_SOURCE[0]:-$0}"
        )"
      )" && pwd
    )"
    local sourcesDirectory="$(
      cd "$configuredUtilitiesDirectory/../../../sources" && pwd
    )"
    source "$sourcesDirectory/units/bash/gatekeeper.bash"
  fi
  source "$blocksDirectory/baseSystem/setAliases.bash"
  source "$modulesDirectory/baseSystem/getHostDistributionPackageManager.bash"
  setAliases "on" &>/dev/null
  alias awk="gawk"
  local handlingMethod="$1"
  function parseUtilityFiles {
    local filesToParse="$1"
    local dataParser="$configuredUtilitiesDirectory/parser.gawk"
    function parseLinks {
      local linkType="$1"
      local fieldToGet="$2"
      local fieldToLookUp="$3"
      local dataSource
      local parsedData
      if [ "$linkType" == "downloadables" ]
      then
        dataSource="$configuredUtilitiesDirectory/links/$linkType/*.csv"
      elif [ "$linkType" == "executables" ]
      then
        dataSource="$configuredUtilitiesDirectory/links/$linkType/*.csv"
      else
        echo "$failureSymbol Failed to find utility type : $linkType"
        return 1
      fi
      if [ "$fieldToGet" == "URL" ] || [ "$fieldToGet" == "Method" ] || [ "$fieldToGet" == "Command" ]
      then
        parsedData="$(
          awk --file $dataParser \
          --assign \
          filesToParse=$linkType \
          fieldToGet=$fieldToGet \
          fieldToLookUp=$fieldToLookUp \
          $dataSource
        )"
        echo "$parsedData"
      elif [ "$fieldToGet" == "Entries" ]
      then
        parsedData=("$(
          awk --file $dataParser \
          --assign \
          filesToParse=$linkType \
          fieldToGet=$fieldToGet \
          $dataSource
        )")
        echo "${parsedData[@]}"
      else
        echo "$failureSymbol Failed to find field : $linkType -> $fieldToGet"
        return 1
      fi
    }
    function parsePackages {
      local filesToParse="$1"
      local packageManager="$2"
      local packageName="$3"
      local dataSource="$configuredUtilitiesDirectory/packages/managers/$packageManager/*.csv"
      local parsedData
      if [ "$packageName" != "" ]
      then
        parsedData="$(
          awk --file $dataParser \
          --assign \
          filesToParse=$filesToParse \
          packageName=$packageName \
          $dataSource
        )"
        echo "$parsedData"
      else
        parsedData=("$(
          awk --file $dataParser \
          --assign \
          filesToParse=$filesToParse \
          packageName=all \
          $dataSource
        )")
        echo "${parsedData[@]}"
      fi
    }
    if [ "$filesToParse" == "links" ]
    then
      local linkType="$2"
      local fieldToGet="$3"
      local fieldToLookUp="$4"
      parseLinks "$linkType" "$fieldToGet" "$fieldToLookUp"
    elif [ "$filesToParse" == "packages" ]
    then
      local packageManager="$2"
      local packageName="$3"
      parsePackages "$filesToParse" "$packageManager" "$packageName"
    else
      echo "$failureSymbol Failed to find utility files : $filesToParse"
      return 1
    fi
  }
  function utilizeUtilityFiles {
    local utilityFilesType="$1"
    function downloadDownloadables {
      # [TODO] milestone: 2.0.0
      local -n entries="$1"
      source "$snippetsDirectory/baseSystem/downloadFromURL.bash"
      for entry in "${entries[@]}"
      do
        local downloadableMethod=$(
          parseUtilityFiles "links" "downloadables" "Method" "$entry"
        )
        local downloadableURL=$(
          parseUtilityFiles "links" "downloadables" "URL" "$entry"
        )
        # [TODO] detect if `downloadMethod` is `git` and intervene to initialize as `submodule`
        # [TODO] differentiate among various types of downloadables and download `targetDirectory`
        local downloadableFile="$(
          promptDownloadFromURL "$downloadableURL" "$downloadableMethod" "$downloadedUtilitiesDirectory"
        )"
        echo "$successSymbol Downloaded utility : $downloadableFile"
      done
    }
    function executeExecutables {
      local -n entries="$1"
      for entry in "${entries[@]}"
      do
        local executableCommand=$(
          parseUtilityFiles "links" "executables" "Command" "$entry"
        )
        echo "$processingSymbol Executing command for utility : $entry"
        eval "$executableCommand"
      done
    }
    function installPackages {
      local -n entries="$1"
      local packageManager="$2"
      local systemDependentPackageManagers=(
        "xbps"
        "apt"
        "pacman"
        "dnf"
        "yum"
        "zypper"
      )
      source "$actionsDirectory/baseSystem/installPackage.bash"
      source "$snippetsDirectory/baseSystem/getHostDistribution.bash"
      local hostDistribution="$(
        getHostDistribution
      )"
      for package in "${entries[@]}"
      do
        if grep --ignore-case --quiet "$packageManager" <<< "${systemDependentPackageManagers[@]}"
        then
          local packageHostingDistributions=("$(
            parseUtilityFiles "packages" "$packageManager" "$package"
          )")
          if grep --ignore-case --quiet "$hostDistribution" <<< "${packageHostingDistributions[@]}"
          then
            installPackage "$package" "$packageManager"
          else
            echo "$failureSymbol Package is not available for host distribution : $package -> $hostDistribution"
          fi
        else
          installPackage "$package" "$packageManager"
        fi
      done
    }
    if [ "$utilityFilesType" == "links" ]
    then
      local linkType="$2"
      local fieldToGet="$3"
      if [ "$linkType" == "downloadables" ] || [ "$linkType" == "executables" ]
      then
        if [ "$fieldToGet" != "" ]
        then
          if [ "$linkType" == "downloadables" ]
          then
            source "$snippetsDirectory/baseSystem/downloadFromURL.bash"
            local downloadURL=$(
              parseUtilityFiles "$utilityFilesType" "$linkType" "URL" "$fieldToGet"
            )
            local downloadMethod=$(
              parseUtilityFiles "$utilityFilesType" "$linkType" "Method" "$fieldToGet"
            )
            local downloadedFile="$(
              downloadFromURL "$downloadURL" "$downloadMethod"
            )"
            echo "$successSymbol Downloaded utility : $downloadedFile"
          elif [ "$linkType" == "executables" ]
          then
            local commandToExecute=$(
              parseUtilityFiles "$utilityFilesType" "$linkType" "Command" "$fieldToGet"
            )
            echo "$processingSymbol Executing command for utility : $fieldToGet"
            eval "$commandToExecute"
          fi
        else
          local entriesToUtilize=($(
            parseUtilityFiles "$utilityFilesType" "$linkType" "Entries"
          ))
          if [ "$linkType" == "downloadables" ]
          then
            downloadDownloadables entriesToUtilize
          elif [ "$linkType" == "executables" ]
          then
            executeExecutables entriesToUtilize
          fi
        fi
      elif [ "$linkType" == "" ]
      then
        local downloadablesToDownload=($(
          parseUtilityFiles "$utilityFilesType" "downloadables" "Entries"
        ))
        local executablesToExecute=($(
          parseUtilityFiles "$utilityFilesType" "executables" "Entries"
        ))
        downloadDownloadables downloadablesToDownload
        executeExecutables executablesToExecute
      fi
    elif [ "$utilityFilesType" == "packages" ]
    then
      local packageManager="$2"
      local packagesToInstall=($(
        parseUtilityFiles "$utilityFilesType" "$packageManager"
      ))
      installPackages packagesToInstall "$packageManager"
    fi
  }
  if [ "$handlingMethod" == "parse" ] || [ "$handlingMethod" == "utilize" ]
  then
    local utilityFilesType="$2"
    if [ "$utilityFilesType" == "links" ] || [ "$utilityFilesType" == "packages" ]
    then
      if [ "$utilityFilesType" == "links" ]
      then
        local linkType="$3"
        local fieldToGet="$4"
        local fieldToLookUp="$5"
      elif [ "$utilityFilesType" == "packages" ]
      then
        local packageManager="$3"
        local packageName="$4"
        if [ "$packageManager" == "" ]
        then
          packageManager="$(
            getHostDistributionPackageManager
          )"
        fi
      fi
      if [ "$handlingMethod" == "parse" ]
      then
        if [ "$utilityFilesType" == "links" ]
        then
          parseUtilityFiles "$utilityFilesType" "$linkType" "$fieldToGet" "$fieldToLookUp"
        elif [ "$utilityFilesType" == "packages" ]
        then
          parseUtilityFiles "$utilityFilesType" "$packageManager" "$packageName"
        fi
      elif [ "$handlingMethod" == "utilize" ]
      then
        if [ "$utilityFilesType" == "links" ]
        then
          utilizeUtilityFiles "$utilityFilesType" "$linkType" "$fieldToGet"
        elif [ "$utilityFilesType" == "packages" ]
        then
          utilizeUtilityFiles "$utilityFilesType" "$packageManager"
        fi
      fi
    else
      echo "$failureSymbol Failed to find utility files : $utilityFilesType"
      return 1
    fi
  else
    echo "$failureSymbol Failed to find handling method : $handlingMethod"
    return 1
  fi
  setAliases "off" &>/dev/null
}
# Checking if the function being called exists
if declare -f "$1" &>/dev/null
then
  "$@"
# Ignoring when used with a `source` command
elif [ "$1" == "" ]
then
  return 0
fi
