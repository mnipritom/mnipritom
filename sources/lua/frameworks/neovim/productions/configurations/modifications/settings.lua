--[[
  ---
  note:
  - `wrap`: avoids breaking lines to fit screen width
  - `clipboard`: enables usage of system clipboard
  - `showtabline`: shows tab line even for one tab
  - `expandtab`: converts tabs to spaces
  - `signcolumn`: combines line number column with signs column
  - `laststatus`: combines multiple status lines into global singular status line
  ---
--]]

vim.opt.shell = "bash"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- searches
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- splits
vim.opt.splitbelow = false
vim.opt.splitright = false

-- wraps
vim.opt.wrap = false

-- clipboards
vim.opt.clipboard = "unnamedplus"

-- hidden characters
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "tab:>>"

-- encodings
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- neovim tabs
vim.opt.showtabline = 2

-- whitespaces, tabs, indents
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.autoindent = true
vim.opt.smartindent = true

-- undos
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

-- lines
vim.opt.number = true
vim.opt.relativenumber = true

-- appearances
vim.opt.showcmd = true
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "number"
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.wo.signcolumn = "yes"
