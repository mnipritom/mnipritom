# ---
# source: https://github.com/sdushantha/dotfiles/blob/77c7ee406472c9fa7c2417eb60b981c5b70096be/bin/bin/utils/rofi-askpass
# note: requires SUDO_ASKPASS environment variable to be set
# ---
function generatePasswordPrompt {
  # [TODO] generalize into generatePromptScript `draft`
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
