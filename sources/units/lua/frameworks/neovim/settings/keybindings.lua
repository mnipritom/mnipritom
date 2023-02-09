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
local bind = vim.keymap.set

local modifiers = { noremap = true, silent = true }

local normal = "n"
local insert = "i"
local visual = "x"
local selection = "s"
local visualSelection = "v"
local terminal = "t"
local operatorPending = "o"
local allButInsert = ""

-- disabling visual-block mode
bind(allButInsert,"<C-q>","<Nop>",modifiers)

-- disabling suspend
bind(allButInsert,"<C-z>","<Nop>",modifiers)

-- implementing `ijkl` cursor control
bind(allButInsert,"h","i",modifiers)
bind(allButInsert,"H","I",modifiers)
bind(allButInsert,"I","<Nop>",modifiers)
bind(allButInsert,"j","k",modifiers)
bind(allButInsert,"i","<Up>",modifiers)
bind(allButInsert,"k","<Down>",modifiers)
bind(allButInsert,"j","<Left>",modifiers)

-- implementing `ijkl` window switching
bind(allButInsert,"<C-l>","<C-w>l",modifiers)
bind(allButInsert,"<C-i>","<C-w>k",modifiers)
bind(allButInsert,"<C-k>","<C-w>j",modifiers)
bind(allButInsert,"<C-j>","<C-w>h",modifiers)
bind(allButInsert,"<C-w>l","<Nop>",modifiers)
bind(allButInsert,"<C-w>k","<Nop>",modifiers)
bind(allButInsert,"<C-w>j","<Nop>",modifiers)
bind(allButInsert,"<C-w>h","<Nop>",modifiers)

-- disabling insert mode pressing `gi`
bind(allButInsert,"gi","<Nop>",modifiers)

-- disabling moving up, moving down, one line at a time
bind(allButInsert,"gj","<Nop>",modifiers)
bind(allButInsert,"gk","<Nop>",modifiers)
bind(allButInsert,"<C-p>","<Nop>",modifiers)
bind(allButInsert,"<C-n>","<Nop>",modifiers)

-- disabling page up, page down
bind(allButInsert,"<C-b>","<Nop>",modifiers)
bind(allButInsert,"<C-f>","<Nop>",modifiers)

-- disabling page half up, page half down
bind(allButInsert,"<C-u>","<Nop>",modifiers)
bind(allButInsert,"<C-d>","<Nop>",modifiers)
