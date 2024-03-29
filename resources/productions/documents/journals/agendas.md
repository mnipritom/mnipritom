- bash:
  - [ ] redesign architecture
    - takeaways:
      - interactive shells should only have access to aliases
        - aliases will have access to `requiredEnvironmentParameters` through
        - modify every aliases file to call `setEnvironmentParameters` before and after alias calls
    - [ ] implement `generatePromptScript` from user scripts by reading from plain text files stored in productions/documents
      - format:
        - [1]
          - [source](https://github.com/sdushantha/dotfiles/blob/77c7ee406472c9fa7c2417eb60b981c5b70096be/bin/bin/utils/rofi-askpass)
          ```bash
            rofi \
            -dmenu \
            -password -i \
            -no-fixed-num-lines \
            -p 'Password'
          ```
        - [2]
          - [source](https://github.com/davatorium/rofi/issues/38#issuecomment-456988468)
          ```bash
            local promptCommand="\
              xdotool search \
                --sync \
                --limit 1 \
                --class Rofi keyup \
                --delay 0 Tab key \
                --delay 0 Tab keyup \
                --delay 0 Super_L keydown \
                --delay 0 Super_L &
              rofi \
                -show window \
                -kb-cancel 'Alt+Escape,Escape' \
                -kb-accept-entry '!Alt-Tab,!Alt_L,!Alt+Alt_L,Return' \
                -kb-row-down 'Alt+Tab,Alt+Down' \
                -kb-row-up 'Alt+ISO_Left_Tab,Alt+Shift+Tab,Alt+Up' & \
            "
          ```
    - [ ] implement colored outputs everywhere by reading from plain text files stored in productions/documents
      - format:
        - [1]
          - Black='\e[0;30m'
          - BBlack='\e[1;30m'
          - On_Black='\e[40m'
          - Red='\e[0;31m'
          - BRed='\e[1;31m'
          - On_Red='\e[41m'
          - Green='\e[0;32m'
          - BGreen='\e[1;32m'
          - On_Green='\e[42m'
          - Yellow='\e[0;33m'
          - BYellow='\e[1;33m'
          - On_Yellow='\e[43m'
          - Blue='\e[0;34m'
          - BBlue='\e[1;34m'
          - On_Blue='\e[44m'
          - Purple='\e[0;35m'
          - BPurple='\e[1;35m'
          - On_Purple='\e[45m'
          - Cyan='\e[0;36m'
          - BCyan='\e[1;36m'
          - On_Cyan='\e[46m'
          - White='\e[0;37m'
          - BWhite='\e[1;37m'
          - On_White='\e[47m'
        - [2]
          - tput <arg> {options}
  - [ ] implement `tmpfs` in `/etc/fstab`
    - [ ] fix `fstab` false reporting
  - [ ] implement checks for `init` system
    - [ ] implement `runnit` `init` system service handler
    - [ ] implement `systemd` specific `systemd-firstboot` usage to configure system
  - [ ] `dab`: Distribution Agnostic and/or Assisted Bootstrapper
    - `void` can cross bootstrap as long as the architectures are compatible
      - example: `x86_64` can bootstrap `aarch64`
    - `debian` derivatives can "partially" cross bootstrap
      - `/debootstrap/debootstrap` is created at target where `debootstrap --second-stage` is needed to be run to complete bootstrap
      - `x86_64` is referred to as `amd64` in `debootstrap`
    - `fedora` can not cross bootstrap, needs emulation to target foreign architecture
    - information regarding `arch`, `opensuse` `nix` derivatives are unavailable
- `/etc`:
  - [ ] /etc/rc.local
  - [ ] /etc/sudoers
- xdg-compliance:
  - [ ] implement xdg-compliant environment variables
  - [ ] dex:
    - [ ] generate `.desktop` files from `.xinitrc` entries with `dex`
- resources:
  - [ ] explore audio format `webm`
  - [ ] `stow` tree
    - `$HOME`
      - .dmrc
      - .Xdefaults
      - .Xresources
      - .xinitrc
      - .xprofile
      - .xsession
      - .bash_profile
      - .bashrc
      - .bash_logout
      - .wgetrc
      - .tmux.conf
      - .npmrc
      - .guile
      - .gitconfig
      - .gemrc
      - .cargo/config.toml
    - `.config`
      - [ ] flutter
      - [ ] starship
    - `.config/directory`
      - [ ] neofetch
      - [ ] nixpkgs
      - [ ] ranger
      - [ ] mimeapps.list
      - [ ] user-dirs.dirs
      - [ ] user-dirs.locale
