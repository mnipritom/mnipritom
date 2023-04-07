return {
  dir = neovimSourcesPath .. "/references/plugins/sources/nvim-lspconfig",
  lazy = false,
  config = function()
    require("lspconfig").pyright.setup({
      
    })
  end
}
