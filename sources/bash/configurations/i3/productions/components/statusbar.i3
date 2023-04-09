bar {
  colors {
    background $base00
    separator  $base01
    statusline $base04

    # state             border    background  text
    focused_workspace   $base05   $base0D     $base00
    active_workspace    $base05   $base03     $base00
    inactive_workspace  $base03   $base01     $base05
    urgent_workspace    $base08   $base08     $base00
    binding_mode        $base00   $base0A     $base00
  }
  position bottom
  workspace_buttons yes
  strip_workspace_name yes
  strip_workspace_numbers no
  # tray_output none
  # modifier none
  # mode invisible
}
