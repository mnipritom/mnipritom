return {
  dir = neovimSourcesPath .. "references/plugins/sources/bufferline",
  config = function()
    local bufferline = require("bufferline")
    bufferline.setup({
      options = {
        numbers = "buffer_id",
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
        },
      } 
    })
    local flags = {
      noremap = true,
      silent = true
    }
    vim.keymap.set("", "t", ":BufferLinePick<cr>", flags)
    vim.keymap.set("", "T", ":BufferLinePickClose<cr>", flags)
    vim.keymap.set("", "<C-l>", ":BufferLineCycleNext<cr>", flags)
    vim.keymap.set("", "<C-j>", ":BufferLineCyclePrev<cr>", flags)
  end
}
