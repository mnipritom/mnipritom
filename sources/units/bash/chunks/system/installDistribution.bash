function installDistribution {
  local targetDistribution="$1"
  local targetDisk="$2"
  source "$actionsDirectory/system/getRootFileSystem.bash"
  source "$blocksDirectory/baseSystem/setAliases.bash"
  source "$blocksDirectory/baseSystem/setStrictExecution.bash"
  source "$actionsDirectory/baseSystem/synchronizeSystemRepositories.bash"
  source "$actionsDirectory/baseSystem/installPackage.bash"
  source "$blocksDirectory/baseSystem/getAdministrativePrivileges.bash"
  local hostDistribution=$(
    source "$snippetsDirectory/baseSystem/getHostDistribution.bash"
    getHostDistribution
  )
  function initiateBootstrap {
    local targetRootFileSystem="$1"
    source "$actionsDirectory/baseSystem/setLocale.bash"
    source "$actionsDirectory/baseSystem/setHostname.bash"
    source "$snippetsDirectory/baseSystem/copyHostDNSConfigurations.bash"
    if [ "$targetDistribution" == "" ]
    then
      local targetDistribution=$(
        local availableDistributions=($(
          getAvailableDistributions
        ))
        local selectedDistribution=$(
          local message="$warningSymbol Select distribution to install"
          printf "%s\n" "${availableDistributions[@]}" | fzf --header "$message"
        )
        echo "$selectedDistribution"
      )
    fi
    local bootstrapMode=$(
      local flexibleDistributions=(
        "void"
        "devuan"
        "debian"
      )
      declare -A configuredDistributions=(
        # [TODO] implement `nix` `guix` `hyperbola` `parabola` `trisquel`
        ["assisted"]="artix arch fedora opensuse"
        ["agnostic"]="ubuntu kali parrot"
      )
      for distribution in "${flexibleDistributions[@]}"
      do
        if [ "$targetDistribution" == "$hostDistribution" ]
        then
          local availableAssistedDistributions=(
            "${configuredDistributions["assisted"]}"
          )
          availableAssistedDistributions+=(
            "$targetDistribution"
          )
          configuredDistributions["assisted"]="${availableAssistedDistributions[@]}"
          break
        else
          local availableAgnosticDistributions=(
            "${configuredDistributions["agnostic"]}"
          )
          availableAgnosticDistributions+=(
            "$targetDistribution"
          )
          configuredDistributions["agnostic"]="${availableAgnosticDistributions[@]}"
          break
        fi
      done
      if grep --ignore-case --quiet "$targetDistribution" <<< "${configuredDistributions["assisted"]}"
      then
        echo "assisted"
      elif grep --ignore-case --quiet "$targetDistribution" <<< "${configuredDistributions["agnostic"]}"
      then
        echo "agnostic"
      else
        echo "$failureSymbol Failed to find bootstrap mode : $targetDistribution"
        return 1
      fi
    )
    local targetArchitecture=$(
      # [TODO] implement support for `aarch64`
      local availableArchitecture="x86_64"
      if [ "$targetDistribution" != "void" ]
      then
        availableArchitecture="amd64"
      fi
      echo "$availableArchitecture"
    )
    function initiateDistributionAssistedBootstrap {
      local targetRootFileSystem="$1"
      local targetDistribution="$2"
      local bootstrapHandler=$(
        declare -A bootstrapHandlers=(
          # [TODO] implement `nix` `guix` `hyperbola` `parabola` `trisquel`
          ["void"]="xbps"
          ["artix"]="basestrap"
          ["arch"]="pacstrap"
          ["fedora"]="dnf"
          ["opensuse"]="zypper"
          ["devuan"]="debootstrap"
          ["debian"]="debootstrap"
          ["ubuntu"]="debootstrap"
          ["parrot"]="debootstrap"
          ["kali"]="debootstrap"
        )
        echo "${bootstrapHandlers["$targetDistribution"]}"
      )
      local xbpsRepository="https://repo-default.voidlinux.org/current"
      declare -A bootstrapHandlersCommands=(
        # [TODO] implement `nix` `guix` `hyperbola` `parabola` `trisquel`
        ["xbps"]="XBPS_ARCH=$targetArchitecture xbps-install --sync --yes --repository $xbpsRepository --rootdir $targetRootFileSystem base-system"
        ["basestrap"]="basestrap $targetRootFileSystem base runit elogind-runit"
        ["pacstrap"]="pacstrap $targetRootFileSystem base"
        ["debootstrap"]="debootstrap --arch=$targetArchitecture stable $targetRootFileSystem"
        ["dnf"]="dnf --releasever=/ --installroot=$targetRootFileSystem groupinstall core --assumeyes"
        ["zypper"]="zypper --non-interactive --installroot $targetRootFileSystem --type pattern base"
      )
      local bootstrapHandlerCommand="${bootstrapHandlersCommands["$bootstrapHandler"]}"
      echo "$processingSymbol Configuring bootstrap prerequisites : $bootstrapHandler"
      if [ "$bootstrapHandler" == "xbps" ]
      then
        local xbpsRSAKeysDirectory="var/db/xbps/keys"
        setStrictExecution "on"
        source "$blocksDirectory/fileSystem/createDirectory.bash"
        getAdministrativePrivileges
        promptCreateDirectory "$targetRootFileSystem/var/db/xbps/keys" "privileged"
        eval sudo cp --recursive "/$xbpsRSAKeysDirectory/." "$targetRootFileSystem/$xbpsRSAKeysDirectory/"
        setStrictExecution "off"
      elif [ "$bootstrapHandler" == "debootstrap" ]
      then
        setStrictExecution "on"
        synchronizeSystemRepositories
        installPackage "debootstrap"
        setStrictExecution "off"
      else
        echo "$warningSymbol No prerequisites required : $bootstrapHandler"
      fi
      getAdministrativePrivileges
      eval sudo "$bootstrapHandlerCommand"
      echo "$processingSymbol Configuring post bootstrap procedures : $bootstrapHandler"
      if [ "$bootstrapHandler" == "debootstrap" ]
      then
        local aptSourcesFile="etc/apt/sources.list"
        if [ -f "/$aptSourcesFile" ]
        then
          if [ -d "$targetRootFileSystem/etc/apt" ] && [ -f "$targetRootFileSystem/$aptSourcesFile" ]
          then
            getAdministrativePrivileges
            sudo rm --force "$targetRootFileSystem/$aptSourcesFile"
            echo "$processingSymbol Copying apt sources : $targetRootFileSystem/$aptSourcesFile"
            sudo cp "/$aptSourcesFile" "$targetRootFileSystem/$aptSourcesFile"
          fi
        fi
      else
        echo "$warningSymbol No post bootstrap procedures required : $bootstrapHandler"
      fi
    }
    function initiateDistributionAgnosticBootstrap {
      local targetRootFileSystem="$1"
      local targetDistribution="$2"
      source "$snippetsDirectory/baseSystem/extractArchive.bash"
      source "$blocksDirectory/baseSystem/deleteDirectory.bash"
      local debootstrapDistributions=(
        "devuan"
        "debian"
        "ubuntu"
        "parrot"
        "kali"
      )
      function getDistributionResources {
        local targetDistribution="$1"
        source "$snippetsDirectory/baseSystem/downloadFromURL.bash"
        declare -A resourcesProviders=(
          ["void"]="https://alpha.de.repo.voidlinux.org/live/current/void-$targetArchitecture-ROOTFS-20210930.tar.xz"
          ["devuan"]="https://git.devuan.org/devuan/debootstrap.git"
          ["debian"]="https://salsa.debian.org/installer-team/debootstrap"
          ["ubuntu"]="https://git.launchpad.net/ubuntu/+source/debootstrap"
          ["kali"]="https://gitlab.com/kalilinux/packages/debootstrap"
          ["parrot"]="https://git.parrotsec.org/packages/debian/debootstrap"
        )
        local distributionResourcesProvider="${resourcesProviders["$targetDistribution"]}"
        local distributionResourcesLocation="$downloadsDirectory/$targetDistribution"
        local downloadMethod="wget"
        if [ "$targetDistribution" != "void" ]
        then
          downloadMethod="git"
        fi
        local distributionResources="$(
          downloadFromURL "${resourcesProviders["$targetDistribution"]}" "$downloadMethod" "$distributionResourcesLocation"
        )"
        echo "$distributionResources"
      }
      local targetDistributionResources=$(
        getDistributionResources "$targetDistribution"
      )
      if [ "$targetDistribution" == "void" ]
      then
        # Expecting `targetDistributionResources` to be a root file system tarball
        promptExtractArchive "$targetDistributionResources" "$targetRootFileSystem"
      elif grep --ignore-case --quiet "$targetDistribution" <<< "${debootstrapDistributions[@]}"
      then
        # Expecting `targetDistributionResources` to be a git repository
        local debootstrapCommand="--arch=$targetArchitecture stable $targetRootFileSystem"
        local debootstrapDirectory="$targetDistributionResources"
        export DEBOOTSTRAP_DIR="$debootstrapDirectory"
        getAdministrativePrivileges
        eval sudo chmod +x "$DEBOOTSTRAP_DIR/debootstrap"
        eval "$DEBOOTSTRAP_DIR/debootstrap $debootstrapCommand"
      fi
      getAdministrativePrivileges
      promptDeleteDirectory "$distributionResourcesLocation" "privileged"
    }
    echo "$processingSymbol Initiating bootstrap : $bootstrapMode -> $targetDistribution"
    if [ "$bootstrapMode" == "assisted" ]
    then
      initiateDistributionAssistedBootstrap "$targetRootFileSystem" "$targetDistribution"
    elif [ "$bootstrapMode" == "agnostic" ]
    then
      initiateDistributionAgnosticBootstrap "$targetRootFileSystem" "$targetDistribution"
    fi
    # [TODO] systemd-firstboot --root="$targetRootFileSystem" --setup-machine-id
    local targetHostName="$targetDistribution"
    copyHostDNSConfigurations "$targetRootFileSystem"
    setHostname "$targetHostName" "$targetRootFileSystem"
    setLocale "$targetRootFileSystem"
    echo "$warningSymbol Install kernel and configure bootloader to make system bootable"
  }
  setAliases "on"
  local targetRootFileSystem=$(
    getRootFileSystem "$targetDisk" "mounted"
  )
  alias fzf="\
    fzf \
    --no-multi \
    --info hidden \
    --layout reverse \
    --height 15 \
    --prompt '❯ ' \
    --pointer '❯ ' \
  "
  initiateBootstrap "$targetRootFileSystem"
  setAliases "off"
}
