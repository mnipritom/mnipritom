return {
  dir = neovimSourcesPath .. "/references/plugins/sources/nvim-lspconfig",
  lazy = false,
  config = function()
    local nvim_lspconfig = require("lspconfig")
    local function setKeybindings(client, bufnr)
      local flags = {
        buffer = bufnr,
        remap = false
      }
      vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, flags)
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, flags)
      vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, flags)
      vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, flags)
      vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, flags)
    end

    nvim_lspconfig.pyright.setup({
      on_attach = setKeybindings
    })
    nvim_lspconfig.lua_ls.setup({
      on_attach = setKeybindings
    })
  end
}
