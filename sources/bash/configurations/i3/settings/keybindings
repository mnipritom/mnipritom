# Keybindings

# Workspaces
bindsym        $mod+1         workspace        number        $terminals; exec --no-startup-id # xwallpaper --stretch [wallpaper](linkToWallpaper)
bindsym        $mod+2         workspace        number        $browsers; exec --no-startup-id # xwallpaper --stretch [wallpaper](linkToWallpaper)
bindsym        $mod+3         workspace        number        $previews; exec --no-startup-id # xwallpaper --stretch [wallpaper](linkToWallpaper)
bindsym        $mod+4         workspace        number        $randoms1;
bindsym        $mod+5         workspace        number        $randoms2;
bindsym        $mod+6         workspace        number        $randoms3;
bindsym        $mod+7         workspace        number        $randoms4;
bindsym        $mod+8         workspace        number        $editors;
bindsym        $mod+9         workspace        number        $popups;

# Moving windows to a workspace
bindsym        $mod+Shift+1        move        container to workspace     number        $terminals
bindsym        $mod+Shift+2        move        container to workspace     number        $browsers
bindsym        $mod+Shift+3        move        container to workspace     number        $previews
bindsym        $mod+Shift+4        move        container to workspace     number        $randoms1
bindsym        $mod+Shift+5        move        container to workspace     number        $randoms2
bindsym        $mod+Shift+6        move        container to workspace     number        $randoms3
bindsym        $mod+Shift+7        move        container to workspace     number        $randoms4
bindsym        $mod+Shift+8        move        container to workspace     number        $editors
bindsym        $mod+Shift+9        move        container to workspace     number        $popups

# Layout switching
bindsym        $mod+s             layout       stacking
bindsym        $mod+Tab           layout       tabbed
bindsym        $mod+e             layout       toggle       split

# Terminal
# bindsym      $mod+t             exec i3-sensible-terminal
# bindsym      $mod+t             exec --no-startup-id $terminal

# Change focus
bindsym        $mod+j             focus        left
bindsym        $mod+k             focus        down
bindsym        $mod+i             focus        up
bindsym        $mod+l             focus        right

# Alternatives
bindsym        $mod+Left          focus        left
bindsym        $mod+Down          focus        down
bindsym        $mod+Up            focus        up
bindsym        $mod+Right         focus        right

# Move focused window
bindsym        $mod+Shift+j       move         left
bindsym        $mod+Shift+k       move         down
bindsym        $mod+Shift+i       move         up
bindsym        $mod+Shift+l       move         right

# Alternatives
bindsym        $mod+Shift+Left    move         left
bindsym        $mod+Shift+Down    move         down
bindsym        $mod+Shift+Up      move         up
bindsym        $mod+Shift+Right   move         right

# Fullscreen
# bindsym        Mod1+f             fullscreen   toggle
# bindsym        $mod+Mod1+f        exec --no-startup-id skippy-xd

# resize window
mode "resize" {
  bindsym      j                  resize       shrink width 10 px or 10 ppt
  bindsym      k                  resize       grow height 10 px or 10 ppt
  bindsym      i                  resize       shrink height 10 px or 10 ppt
  bindsym      l                  resize       grow width 10 px or 10 ppt

  # same bindings, but for the arrow keys
  bindsym      Left               resize       shrink width 10 px or 10 ppt
  bindsym      Down               resize       grow height 10 px or 10 ppt
  bindsym      Up                 resize       shrink height 10 px or 10 ppt
  bindsym      Right              resize       grow width 10 px or 10 ppt

  # back to normal: Enter or Escape or $mod+r
  bindsym      Return             mode         "default"
  bindsym      Escape             mode         "default"
  bindsym      $mod+r             mode         "default"
}

bindsym        $mod+Shift+r       mode         "resize"

# focus the parent container
bindsym        $mod+a             focus        parent

# focus the child container
# bindsym      $mod+d             focus        child

# reload the configuration file
bindsym        $mod+Shift+c       reload
# restart i3 inplace
bindsym        $mod+Control+r     restart
# exit i3
bindsym        $mod+Shift+e       exec "i3-nagbar -t warning -m 'Do you really want to exit i3?' -B 'Yes, exit i3' 'i3-msg exit'"

# Spliting

# Horizontal
bindsym        $mod+h             split h

# Vertical
bindsym        $mod+v             split v

# Toggle tiling/floating
bindsym        $mod+Shift+space   floating     toggle

# Change focus between tiling/floating windows
bindsym        $mod+space         focus        mode_toggle

# Use pactl to adjust volume in PulseAudio.
#set $refresh_i3status killall -SIGUSR1 i3status
bindsym        XF86AudioRaiseVolume           exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status
bindsym        XF86AudioLowerVolume           exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status
bindsym        XF86AudioMute                  exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
bindsym        XF86AudioMicMute               exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status
