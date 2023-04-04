--[[
  ---
  note:
    source: https://github.com/wbthomason/packer.nvim#bootstrapping
    source: https://github.com/LunarVim/Neovim-from-scratch/blob/03-plugins/lua/user/plugins.lua
    source: https://github.com/wbthomason/packer.nvim/issues/858#issuecomment-1172869552
  ---
--]]

local packer = "https://github.com/wbthomason/packer.nvim"

local lualine = "https://github.com/nvim-lualine/lualine.nvim"
local tabline = "https://github.com/kdheepak/tabline.nvim"

local icons = "https://github.com/nvim-tree/nvim-web-devicons"
local tree = "https://github.com/nvim-tree/nvim-tree.lua"

local telescope = "https://github.com/nvim-telescope/telescope.nvim"
local plenary = "https://github.com/nvim-lua/plenary.nvim"
local popup = "https://github.com/nvim-lua/popup.nvim"

local treesitter = "https://github.com/nvim-treesitter/nvim-treesitter"

local blankline = "https://github.com/lukas-reineke/indent-blankline.nvim"

local isPackerFreshInstallation

local function installPacker()
  local packerInitializer = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if vim.fn.empty(vim.fn.glob(packerInitializer)) > 0
  then
    vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      packer,
      packerInitializer
    })
    vim.cmd("packadd packer.nvim")
    isPackerFreshInstallation = true
  else
    isPackerFreshInstallation = false
  end
end

local isPackerAvailable, packerInstance = pcall(require, "packer")
if not isPackerAvailable
then
  installPacker()
  packerInstance = require("packer")
end

packerInstance.init({
  display = {
    non_interactive = false,
    compact = false,
    open_fn  = nil,
    open_cmd = "65vnew \\[packer\\]",
    working_sym = "⟳",
    error_sym = "✗",
    done_sym = "✓",
    removed_sym = "-",
    moved_sym = "→",
    header_sym = "━",
    show_all_info = true,
    prompt_border = "single",
    keybindings = {
      quit = "q",
      toggle_update = "u",
      continue = "c",
      toggle_info = "<CR>",
      diff = "d",
      prompt_revert = "r"
    }
  }
})

packerInstance.startup({{
  packer,
  icons,
  {
    lualine,
    requires = {
      tabline
    }
  },
  {
    telescope,
    requires = {
      plenary,
      popup
    }
  },
  tree,
  treesitter,
  blankline
}})

if isPackerFreshInstallation
then
  packerInstance.sync()
end
