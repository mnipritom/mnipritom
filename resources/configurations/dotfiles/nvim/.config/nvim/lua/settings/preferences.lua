--[[
  ---
  note:
  - `showtabline`: shows tab line even for one tab
  - `expandtab`: converts tabs to spaces
  - `signcolumn`: combines line number column with signs column
  - `laststatus`: combines multiple status lines into global singular status line
  ---
--]]

local prefer = vim.opt

-- encodings
prefer.fileencoding = 'utf-8'

-- neovim tabs
prefer.showtabline = 2

-- whitespaces, tabs, indents
prefer.expandtab = true
prefer.smarttab = true
prefer.shiftwidth = 2
prefer.tabstop = 2
prefer.autoindent = true

-- lines
prefer.number = true
prefer.relativenumber = true

-- appearances
prefer.termguicolors = true
prefer.background = "dark"
prefer.signcolumn = "number"
prefer.showmode = false
prefer.laststatus = 3
