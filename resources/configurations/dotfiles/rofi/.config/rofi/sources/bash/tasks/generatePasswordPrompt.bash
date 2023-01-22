# ---
# source: https://github.com/sdushantha/dotfiles/blob/77c7ee406472c9fa7c2417eb60b981c5b70096be/bin/bin/utils/rofi-askpass
# note: requires SUDO_ASKPASS environment variable to be set
# ---
function generatePasswordPrompt {
  local bash="$(
    which bash
  )"
  local rofi="$(
    which rofi
  )"
  local promptCommand="$rofi -dmenu -password -i -no-fixed-num-lines -p 'Password'"
  local promptScript="$HOME/.SUDO_ASKPASS_PROMPT"
  touch "$promptScript"
  printf "%s\n%s" "#!$bash" "$promptCommand" > "$promptScript"
  chmod +x "$promptScript"
  echo "$promptScript"
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
