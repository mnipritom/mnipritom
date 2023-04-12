return {
  dir = pluginsSourcesPath .. "mason-lspconfig",
  lazy = false,
  config = function()
    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
        ensure_installed = {
          "awk_ls",
          "bashls",
          "pylsp",
          "lua_ls",
          "html",
          "cssls",
          "ruby_ls",
          "jsonls",
          "yamlls"
        }
    })
  end
}
