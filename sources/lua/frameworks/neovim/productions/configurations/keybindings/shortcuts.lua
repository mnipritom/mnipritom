--[[
  ---
  note:
    - sources:
      - https://vim.fandom.com/wiki/Use_ijkl_to_move_the_cursor_and_h_to_insert
      - https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim
      - https://hea-www.harvard.edu/~fine/Tech/vi.html
    - modes:
      - n : Normal mode
      - i : Insert mode
      - x : Visual mode
      - s : Selection mode
      - v : Visual + Selection
      - t : Terminal mode
      - o : Operator-pending
      - "": n + v + o
    - `vim.api.nvim_set_keymap` has added overhead of going through VimL
  ---
--]]
vim.g.mapleader = " "

local flags = {
  noremap = true,
  silent = true
}

-- implementing `ijkl` cursor control
vim.keymap.set("", "h", "i", flags)
vim.keymap.set("", "H", "I", flags)
vim.keymap.set("", "I", "<Nop>", flags)
vim.keymap.set("", "j", "k", flags)
vim.keymap.set("", "i", "<Up>", flags)
vim.keymap.set("", "k", "<Down>", flags)
vim.keymap.set("", "j", "<Left>", flags)

-- implementing `ijkl` window switching
vim.keymap.set("", "<C-l>", "<C-w>l", flags)
vim.keymap.set("", "<C-i>", "<C-w>k", flags)
vim.keymap.set("", "<C-k>", "<C-w>j", flags)
vim.keymap.set("", "<C-j>", "<C-w>h", flags)
vim.keymap.set("", "<C-w>", "<NOP>", flags)
vim.keymap.set("", "<C-w>l", "<Nop>", flags)
vim.keymap.set("", "<C-w>k", "<Nop>", flags)
vim.keymap.set("", "<C-w>j", "<Nop>", flags)
vim.keymap.set("", "<C-w>h", "<Nop>", flags)
vim.keymap.set("", "<C-h>", "<Nop>", flags)

-- disabling insert mode pressing `gi`
vim.keymap.set("", "gi", "<Nop>", flags)

-- disabling moving up, moving down, one line at a time
vim.keymap.set("", "gj", "<Nop>", flags)
vim.keymap.set("", "gk", "<Nop>", flags)
vim.keymap.set("", "<C-p>", "<Nop>", flags)
vim.keymap.set("", "<C-n>", "<Nop>", flags)

-- disabling page up, page down
vim.keymap.set("", "<C-b>", "<Nop>", flags)
vim.keymap.set("", "<C-f>", "<Nop>", flags)

-- disabling page half up, page half down
vim.keymap.set("", "<C-u>", "<Nop>", flags)
vim.keymap.set("", "<C-d>", "<Nop>", flags)

-- disabling visual-block mode
vim.keymap.set("", "<C-q>", "<Nop>", flags)

-- disabling suspend
vim.keymap.set("", "<C-z>", "<Nop>", flags)

-- buffer switching
vim.keymap.set("", "<C-1>", ":b1<cr>", flags)
vim.keymap.set("", "<C-2>", ":b2<cr>", flags)
vim.keymap.set("", "<C-3>", ":b3<cr>", flags)
vim.keymap.set("", "<C-4>", ":b4<cr>", flags)
vim.keymap.set("", "<C-5>", ":b5<cr>", flags)
vim.keymap.set("", "<C-6>", ":b6<cr>", flags)
vim.keymap.set("", "<C-7>", ":b7<cr>", flags)
vim.keymap.set("", "<C-8>", ":b8<cr>", flags)
vim.keymap.set("", "<C-9>", ":b9<cr>", flags)
