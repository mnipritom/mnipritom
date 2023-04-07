return {
  dir = neovimSourcesPath .. "/references/plugins/sources/nvim-lspconfig",
  lazy = false,
  config = function()
    local nvim_lspconfig = require("lspconfig")
    nvim_lspconfig.pyright.setup({
      
    })
  end
}
