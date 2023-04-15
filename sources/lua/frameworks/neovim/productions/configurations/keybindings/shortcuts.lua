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

-- [NOTE] implementing `ijkl` cursor control
vim.keymap.set("", "h", "i", flags)
vim.keymap.set("", "H", "I", flags)
vim.keymap.set("", "I", "<NOP>", flags)
vim.keymap.set("", "j", "k", flags)
vim.keymap.set("", "i", "<Up>", flags)
vim.keymap.set("", "k", "<Down>", flags)
vim.keymap.set("", "j", "<Left>", flags)

-- [NOTE] disabling scrolling with `ctrl+shift+j`
vim.keymap.set("", "<C-S-j>", "<NOP>", flags)
-- [NOTE] disabling going backwords by word with `ctrl-shirt-h`
vim.keymap.set("", "<C-S-h>", "<NOP>", flags)

-- [NOTE] disabling focusing spits with `<C-w>`
-- [NOTE] enabling focusing splits with `ctrl-shift` & `ijkl`
vim.keymap.set("", "<C-S-j>", "<C-w>h", flags)
vim.keymap.set("", "<C-S-l>", "<C-w>l", flags)
vim.keymap.set("", "<C-S-i>", "<C-w>k", flags)
vim.keymap.set("", "<C-S-k>", "<C-w>j", flags)
vim.keymap.set("", "<C-w>", "<NOP>", flags)
vim.keymap.set("", "<C-w>l", "<NOP>", flags)
vim.keymap.set("", "<C-w>k", "<NOP>", flags)
vim.keymap.set("", "<C-w>j", "<NOP>", flags)
vim.keymap.set("", "<C-w>h", "<NOP>", flags)

-- [NOTE] disabling entry of newline with `<C-S-j> in insert mode
vim.keymap.set("i", "<C-S-j>", "<NOP>", flags)


-- [NOTE] disabling insert mode pressing `gi`
vim.keymap.set("", "gi", "<NOP>", flags)

-- [NOTE] disabling moving up, moving down, one line at a time
vim.keymap.set("", "gj", "<NOP>", flags)
vim.keymap.set("", "gk", "<NOP>", flags)
vim.keymap.set("", "<C-h>", "<NOP>", flags)
vim.keymap.set("", "<C-p>", "<NOP>", flags)
vim.keymap.set("", "<C-n>", "<NOP>", flags)

-- [LINK] https://www.youtube.com/@thePrimeagen
-- [LINK] https://github.com/thePrimeagen
vim.keymap.set("", "<C-b>", "<C-b>zz", flags)
vim.keymap.set("", "<C-f>", "<C-f>zz", flags)
vim.keymap.set("", "<C-u>", "<C-u>zz", flags)
vim.keymap.set("", "<C-d>", "<C-d>zz", flags)

-- [NOTE] disabling visual-block mode
vim.keymap.set("", "<C-q>", "<NOP>", flags)

-- [NOTE] disabling suspend
vim.keymap.set("", "<C-z>", "<NOP>", flags)
vim.keymap.set("", "<C-S-z>", "<NOP>", flags)

-- [NOTE] setting tab controls
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

-- [NOTE] setting miscellaneous shortcuts
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", flags)
vim.keymap.set("n", "<leader>q", "<cmd>qa!<cr>", flags)

-- [LINK] https://youtube.com/@devaslife
vim.keymap.set("", "+", "<C-a>", flags)
vim.keymap.set("", "-", "<C-x>", flags)
vim.keymap.set("", "<C-a>", "gg<S-v>G", flags)

-- [NOTE] remapping `escape` key
-- [NOTE] setting `ctrl+h` from backspace to none
vim.keymap.set("i", "<C-h>", "<NOP>", flags)
vim.keymap.set("i", "<C-h>", "<ESC>", flags)
vim.keymap.set("", "<C-h>", "<C-[>", flags)
-- vim.keymap.set("", "<C-[>", "<NOP>", flags)
