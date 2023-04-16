return {
  dir = pluginsSourcesPath .. "diffview",
  config = function()
    local diffview = require("diffview")
    diffview.keymaps = {
      disable_defaults = true
    }
  end
}
