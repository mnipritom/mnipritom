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
  silent = true,
  nowait = true
}

-- implementing `ijkl` cursor control
vim.keymap.set("", "h", "i", flags)
vim.keymap.set("", "H", "I", flags)
vim.keymap.set("", "I", "<Nop>", flags)
vim.keymap.set("", "j", "k", flags)
vim.keymap.set("", "i", "<Up>", flags)
vim.keymap.set("", "k", "<Down>", flags)
vim.keymap.set("", "j", "<Left>", flags)

-- disabling focusing spits with `<C-w>`
vim.keymap.set("", "<C-w>", "<NOP>", flags)
vim.keymap.set("", "<C-w>l", "<Nop>", flags)
vim.keymap.set("", "<C-w>k", "<Nop>", flags)
vim.keymap.set("", "<C-w>j", "<Nop>", flags)
vim.keymap.set("", "<C-w>h", "<Nop>", flags)

-- disabling insert mode pressing `gi`
vim.keymap.set("", "gi", "<Nop>", flags)

-- disabling moving up, moving down, one line at a time
vim.keymap.set("", "gj", "<Nop>", flags)
vim.keymap.set("", "gk", "<Nop>", flags)
vim.keymap.set("", "<C-h>", "<Nop>", flags)
vim.keymap.set("", "<C-p>", "<Nop>", flags)
vim.keymap.set("", "<C-n>", "<Nop>", flags)

-- disabling page up, page down
vim.keymap.set("", "<C-b>", "<C-b>zz", flags)
vim.keymap.set("", "<C-f>", "<C-f>zz", flags)

-- disabling page half up, page half down
vim.keymap.set("", "<C-u>", "<C-u>zz", flags)
vim.keymap.set("", "<C-d>", "<C-d>zz", flags)

-- disabling visual-block mode
vim.keymap.set("", "<C-q>", "<Nop>", flags)

-- disabling suspend
vim.keymap.set("", "<C-z>", "<Nop>", flags)

-- tab controls
vim.keymap.set("n", "<C-w>", "<cmd>bn<bar>bd#<cr>",flags)
vim.keymap.set("n", "<C-n>", "<cmd>tabnew<cr>",flags)
vim.keymap.set("n", "<C-q>", "<cmd>tabclose<cr>",flags)
vim.keymap.set("", "<C-1>", "1gt", flags)
vim.keymap.set("", "<C-2>", "2gt", flags)
vim.keymap.set("", "<C-3>", "3gt", flags)
vim.keymap.set("", "<C-4>", "4gt", flags)
vim.keymap.set("", "<C-5>", "5gt", flags)
vim.keymap.set("", "<C-6>", "6gt", flags)
vim.keymap.set("", "<C-7>", "7gt", flags)
vim.keymap.set("", "<C-8>", "8gt", flags)
vim.keymap.set("", "<C-9>", "9gt", flags)

-- reload configuration without restarting nvim
vim.keymap.set("n", "<leader>r", "<cmd>so %<cr>", flags)

-- fast saving with <leader> and s
vim.keymap.set("n", "<leader>s", "<cmd>w<cr>", flags)

-- Close all windows and exit
vim.keymap.set("n", "<leader>q", "<cmd>qa!<cr>", flags)

