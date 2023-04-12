return {
  dir = pluginsSourcesPath .. "gitsigns",
  config = function()
    local gitsigns = require("gitsigns")
    gitsigns.setup({
      current_line_blame = true,
      signcolumn = true,
      numhl = true,
      linehl = true,
      word_diff = false
    })
  end
}
