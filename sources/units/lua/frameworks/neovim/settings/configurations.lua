--[[
  ---
  note:
  - `wrap`: avoids breaking lines to fit screen width
  - `clipboard`: enables usage of system clipboard
  ---
--]]

local override = vim.g
local configure = vim.opt

override.loaded_netrw = 1
override.loaded_netrwPlugin = 1

-- searches
configure.hlsearch = true
configure.incsearch = true
configure.ignorecase = true
configure.smartcase = true

-- splits
configure.splitbelow = false
configure.splitright = false

-- wraps
configure.wrap = false

-- clipboards
configure.clipboard = "unnamedplus"

-- hidden characters
configure.list = true
configure.listchars:append "space:."
configure.listchars:append "eol:↴"
configure.listchars:append "tab:>>"
