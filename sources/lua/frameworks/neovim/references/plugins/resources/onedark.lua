return {
  dir = neovimSourcesPath .. "references/plugins/sources/onedark",
  config = function()
    local onedark = require("onedark")
    onedark.setup({
      style = "darker",
      code_style = {
        comments = "italic",
        keywords = "bold",
        functions = "bold",
        strings = "none",
        variables = "bold"
      },
      ending_tildes = false
    })
    onedark.load()
  end
}
