return {
  dir = neovimSourcesPath .. "/references/plugins/sources/mason",
  build = ":MasonUpdate",
  lazy = false,
  config = function()
    local mason = require("mason")
    mason.setup({
      
    })
  end
}
