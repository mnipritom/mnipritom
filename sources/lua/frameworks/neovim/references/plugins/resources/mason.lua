return {
  dir = pluginsSourcesPath .. "mason",
  build = ":MasonUpdate",
  lazy = false,
  config = function()
    local mason = require("mason")
    mason.setup({

    })
  end
}
