# ---
# source: https://github.com/davatorium/rofi/issues/38#issuecomment-456988468
# ---
xdotool="$(
  which xdotool
)"
rofi="$(
  which rofi
)"
"$xdotool" search \
  --sync \
  --syncsleep 50 \
  --limit 1 \
  --class Rofi keyup \
  --delay 0 Tab key \
  --delay 0 Tab keyup \
  --delay 0 Super_L keydown \
  --delay 0 Super_L &
"$rofi" \
    -show window  \
    -kb-cancel "Alt+Escape,Escape" \
    -kb-accept-entry "!Alt-Tab,!Alt_L,!Alt+Alt_L,Return"\
    -kb-row-down "Alt+Tab,Alt+Down" \
    -kb-row-up "Alt+ISO_Left_Tab,Alt+Shift+Tab,Alt+Up" &
