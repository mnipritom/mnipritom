local config = wezterm.config_builder()
config = {
-- [NOTE] legacy tab bar configurations, subject to change
  use_fancy_tab_bar = false,
  enable_tab_bar = true,
  tab_bar_at_bottom = true,
  tab_max_width = 999999,
  hide_tab_bar_if_only_one_tab = false,
  show_tab_index_in_tab_bar = true,
  colors = {
    tab_bar = {
      active_tab = {
        bg_color = "#585858",
        fg_color = "#ffffff",
        intensity = "Bold",
        underline = "None",
        italic = false,
        strikethrough = false
      },
      inactive_tab = {
        fg_color = "#686868",
        bg_color = "#464646"
      },
      new_tab = {
        fg_color = "#aaaaaa",
        bg_color = "#686868"
      },
      inactive_tab_hover = {
        bg_color = "#6e6e6e",
        fg_color = "#a0a0a0",
        italic = true,
        underline = "None"
      },
      new_tab_hover = {
        bg_color = "#8c8c8c",
        fg_color = "#ffffff",
        italic=false,
        underline="None"
      }
    }
  },
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
  },
  keys = {
    {
      key = "p",
      mods = "ALT",
      action = wezterm.action.ActivateCommandPalette
    },
    {
      key = "t",
      mods = "ALT",
      action = wezterm.action.SpawnTab("DefaultDomain")
    },
    {
      key = "w",
      mods = "ALT",
      action = wezterm.action.CloseCurrentTab({
        confirm = false
      })
    },
    {
      key = "j",
      mods = "ALT",
      action = wezterm.action.ActivateTabRelative(-1)
    },
    {
      key = "l",
      mods = "ALT",
      action = wezterm.action.ActivateTabRelative(1)
    },
    color_scheme = "One Dark (Gogh)",
    disable_default_key_bindings = true
    -- [TODO] for loop to create tables 0-9
    -- {
    --   key = "0",
    --   mods = "ALT",
    --   action = wezterm.action.ActivateTab(0)
    -- }
  }
}



return config
