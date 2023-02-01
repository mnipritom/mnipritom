local plugins = {
  managers = {
    ["packer"] = "https://github.com/wbthomason/packer.nvim",
    ["lazy"] = "https://github.com/folke/lazy.nvim"
  },
  browsers = {
    ["nvim-tree"] = "https://github.com/nvim-tree/nvim-tree.lua",
    ["nvim-neo-tree"] = "https://github.com/nvim-neo-tree/neo-tree.nvim"
  },
  interfaces = {
    ["lualine"] = "https://github.com/nvim-lualine/lualine.nvim",
    ["tabline"] = "https://github.com/kdheepak/tabline.nvim",
    ["bufferline"] = "https://github.com/akinsho/bufferline.nvim",
    ["feline"] = "https://github.com/feline-nvim/feline.nvim"
  },
  finders = {
    ["telescope"] = "https://github.com/nvim-telescope/telescope.nvim"
  },
  highlights = {
    ["treesitter"] = "https://github.com/nvim-treesitter/nvim-treesitter",
    ["blankline"] = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  essentials = {
    ["icons"] = "https://github.com/nvim-tree/nvim-web-devicons",
    ["plenary"] = "https://github.com/nvim-lua/plenary.nvim",
    ["popup"] = "https://github.com/nvim-lua/popup.nvim"
  }
}
return plugins