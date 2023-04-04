local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath)
then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  require("plugins.entries")
  -- {
  --   name = "feline.nvim",
  --   enabled = true,
  --   url = "https://github.com/freddiehaddad/feline.nvim",
  --   lazy = false
  -- }
  -- "https://github.com/nvim-neo-tree/neo-tree.nvim",
  -- "https://github.com/akinsho/bufferline.nvim",
  
  -- "https://github.com/nvim-telescope/telescope.nvim"
  -- "https://github.com/nvim-treesitter/nvim-treesitter",
  -- "https://github.com/lukas-reineke/indent-blankline.nvim",
  -- "https://github.com/nvim-tree/nvim-web-devicons",
  -- "https://github.com/nvim-lua/plenary.nvim",
  -- "https://github.com/nvim-lua/popup.nvim"
}

local modifiers = {
  ui = {
    border = 1
  },
  -- custom_keys ={

  -- }
}

require("lazy").setup(plugins, modifiers)