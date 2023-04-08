return {
  dir = neovimSourcesPath .. "references/plugins/sources/bufferline",
  config = function()
    local bufferline = require("bufferline")
    bufferline.setup({
      options = {
        numbers = "ordinal",
        truncate_names = true,
        show_tab_indicators = true,
        always_show_bufferline = true,
        separator_style = "thick",
        offsets = {
          {
            filetype = "neo-tree",
            text = "Explorer",
            text_align = "left",
            separator = true
          }
        },
      } 
    })
  end
}
