return {
  dir = neovimSourcesPath .. "references/plugins/sources/nvim-web-devicons",
  lazy = false,
  config = function()
    require("nvim-web-devicons").setup({
      default = true,
      color_icons = true
    })
  end
}
