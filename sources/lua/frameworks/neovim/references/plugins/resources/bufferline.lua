return {
  dir = neovimSourcesPath .. "references/plugins/sources/bufferline",
  config = function()
    local bufferline = require("bufferline")
    bufferline.setup({
      options = {
        numbers = "none",
        truncate_names = true,
        show_tab_indicators = true,
        always_show_bufferline = true,
        separator_style = "thick",
        offsets = {
          {
            filetype = "neo-tree",
            text = "Explorers",
            text_align = "left",
            separator = true
          }
        }
      }
    })
    local flags = {
      noremap = true,
      silent = true
    }
    -- vim.keymap.set("", "t", "<cmd>BufferLinePick<cr>", flags)
    -- vim.keymap.set("", "T", "<cmd>BufferLinePickClose<cr>", flags)
    vim.keymap.set("", "<C-l>", "<cmd>BufferLineCycleNext<cr>", flags)
    vim.keymap.set("", "<C-j>", "<cmd>BufferLineCyclePrev<cr>", flags)
  end
}
