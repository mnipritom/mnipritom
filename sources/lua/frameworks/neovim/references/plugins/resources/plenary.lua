return {
  dir = neovimSourcesPath .. "references/plugins/sources/plenary",
  config = function()
    -- [LINK] https://github.com/nvim-lua/plenary.nvim#getting-started
    local plenary = require("plenary")
    local async = require("plenary.async")
    return plenary, async
  end
}
