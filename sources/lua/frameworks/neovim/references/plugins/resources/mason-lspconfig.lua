return {
  dir = neovimSourcesPath .. "/references/plugins/sources/mason-lspconfig",
  lazy = false,
  config = function()
    require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls"
        }
    })
  end
}
