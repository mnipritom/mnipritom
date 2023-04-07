return {
  dir = neovimSourcesPath .. "references/plugins/sources/gitsigns",
  config = function()
    local gitsigns = require("gitsigns")
    gitsigns.setup({
      -- [TODO] implement
    })
  end
}
