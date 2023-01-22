--[[
  ---
  note: `plugins.packer` has to be loaded before other plugin specific files
  ---
--]]
require("settings.configurations")
require("settings.keybindings")
require("settings.preferences")
require("plugins.packer")
require("plugins.lualine")
require("plugins.tabline")
require("plugins.tree")
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.blankline")
