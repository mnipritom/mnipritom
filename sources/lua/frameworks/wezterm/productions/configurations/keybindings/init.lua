-- [TODO] fix copy/paste with mod
local wezterm = require("wezterm")
return {
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
  }
  -- [TODO] for loop to create tables 0-9
  -- {
  --   key = "0",
  --   mods = "ALT",
  --   action = wezterm.action.ActivateTab(0)
  -- }
}
