function setLocale {
  local targetRootFileSystem="$1"

  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  source "$modulesDirectory/baseSystem/chrootExecute.bash"

  local locale="en_US.UTF-8"

  local status

  # /etc/default/locale       : "LANG=en_US.UTF-8"
  # /etc/locale.conf          : "LANG=en_US.UTF-8"
  # /etc/default/libc-locale  : "en_US.UTF-8 UTF-8"
  # /etc/locale.gen           : "en_US.UTF-8 UTF-8"
  # /etc/environment          : "LC_ALL=en_US.UTF-8"

  local defaultLocaleFile="$dumpsDirectory/locale"
  local defaultLibcLocaleFile="$dumpsDirectory/libc-locales"
  local localeGenFile="$dumpsDirectory/locale.gen"
  local localeConfFile="$dumpsDirectory/locale.conf"
  local environmentFile="$dumpsDirectory/environment"

  local targetDefaultLocaleFile="$targetRootFileSystem/etc/default/locale"
  local targetDefaultLibcLocaleFile="$targetRootFileSystem/etc/default/libc-locales"
  local targetLocaleGenFile="$targetRootFileSystem/etc/locale.gen"
  local targetLocaleConfFile="$targetRootFileSystem/etc/locale.conf"
  local targetEnvironmentFile="$targetRootFileSystem/etc/environment"

  declare -A systemLocaleFilesTargets=(
    ["$defaultLocaleFile"]="$targetDefaultLocaleFile"
    ["$defaultLibcLocaleFile"]="$targetDefaultLibcLocaleFile"
    ["$localeGenFile"]="$targetLocaleGenFile"
    ["$localeConfFile"]="$targetLocaleConfFile"
    ["$environmentFile"]="$targetEnvironmentFile"
  )

  for file in "${!systemLocaleFilesTargets[@]}"
  do
    echo "$processingSymbol Creating file containing locale value : ${file#$dumpsDirectory}"
    touch "$file"
  done

  echo "LANG=$locale" > "$defaultLocaleFile"
  echo "LANG=$locale" > "$localeConfFile"
  echo "$locale UTF-8" > "$defaultLibcLocaleFile"
  echo "$locale UTF-8" > "$localeGenFile"
  echo "LC_ALL=$locale" > "$environmentFile"

  for systemFile in "${!systemLocaleFilesTargets[@]}"
  do
    local target="${systemLocaleFilesTargets[$systemFile]}"

    echo "$processingSymbol Deleting existing system locale file : $target"

    getAdministrativePrivileges

    status=$(
      sudo rm --force "$target"
      echo "$?"
    )

    if [ "$status" != 0 ] && [ -f "$target" ]
    then
      echo "$failureSymbol Failed to delete existing system locale file : $target"
    else
      echo "$successSymbol Successfully deleted existing system locale file : $target"
    fi

    echo "$processingSymbol Setting locale values in possible system files : $target"

    getAdministrativePrivileges

    status=$(
      sudo mv --force "$systemFile" "$target"
      echo "$?"
    )

    if [ "$status" != 0 ] && [ ! -f "$target" ]
    then
      echo "$failureSymbol Failed to set locale value in system file : $target"
    else
      echo "$successSymbol Successfully set locale value in system file : $target"
    fi
  done

  if [ "$targetRootFileSystem" != "" ]
  then
    chrootExecute "command" "$targetRootFileSystem" "eval locale-gen $locale" &>/dev/null
  else
    eval locale-gen $locale
  fi
}
