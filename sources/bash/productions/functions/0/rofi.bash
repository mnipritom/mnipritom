_0["generateRofiPromptScript"]=$(
  function generateRofiPromptScript {
    # [TODO] implement
    return 1
  }
  declare -f generatePromptScript
  unset -f generatePromptScript
)
_0["generatePasswordPrompt"]=$(
  # [TODO] generalize into generatePromptScript `draft`
  # [NOTE] requires SUDO_ASKPASS environment variable to be set
  # [LINK] https://github.com/sdushantha/dotfiles/blob/77c7ee406472c9fa7c2417eb60b981c5b70096be/bin/bin/utils/rofi-askpass
  function generatePasswordPrompt {
    local bash="$(
      which bash
    )"
    local rofi="$(
      which rofi
    )"
    local promptCommand="$rofi -dmenu -password -i -no-fixed-num-lines -p 'Password'"
    local promptScript="$HOME/.local/bin/SUDO_ASKPASS_PROMPT"
    touch "$promptScript"
    printf "%s\n%s" "#!$bash" "$promptCommand" > "$promptScript"
    chmod +x "$promptScript"
    printf "%s" "$promptScript"
  }
  declare -f generatePasswordPrompt
  unset -f generatePasswordPrompt
)
_0["generateWindowSwitcherPrompt"]=$(
  # [TODO] generalize into generatePromptScript `draft`
  # [LINK] https://github.com/davatorium/rofi/issues/38#issuecomment-456988468
  function generateWindowSwitcherPrompt {
    local bash="$(
      which bash
    )"
    local xdotools="$(
      which xdotool
    )"
    local rofi="$(
      which rofi
    )"
    local promptCommand="\
      $xdotool search \
        --sync \
        --limit 1 \
        --class Rofi keyup \
        --delay 0 Tab key \
        --delay 0 Tab keyup \
        --delay 0 Super_L keydown \
        --delay 0 Super_L &
      $rofi \
        -show window \
        -kb-cancel 'Alt+Escape,Escape' \
        -kb-accept-entry '!Alt-Tab,!Alt_L,!Alt+Alt_L,Return' \
        -kb-row-down 'Alt+Tab,Alt+Down' \
        -kb-row-up 'Alt+ISO_Left_Tab,Alt+Shift+Tab,Alt+Up' & \
    "
    local promptScript="$HOME/.local/bin/window_switcher_prompt"
    touch "$promptScript"
    printf "%s\n%s" "#!$bash" "$promptCommand" > $promptScript
    chmod +x "$promptScript"
    printf "%s" "$promptScript"
  }
  declare -f generateWindowSwitcherPrompt
  unset -f generateWindowSwitcherPrompt
)
