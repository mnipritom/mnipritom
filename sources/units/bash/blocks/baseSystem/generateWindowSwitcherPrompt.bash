# ---
# source: https://github.com/davatorium/rofi/issues/38#issuecomment-456988468
# ---
function generateWindowSwitcherPrompt {
  # [TODO] generalize into generatePromptScript `draft`
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
