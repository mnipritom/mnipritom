return {
  dir = neovimSourcesPath .. "references/plugins/sources/onedark",
  config = function()
    require("onedark").setup({
      style = "warmer",
      code_style = {
        comments = "italic",
        keywords = "bold",
        functions = "bold",
        strings = "none",
        variables = "bold"
      },
      ending_tildes = false
    })
    require("onedark").load()
  end
}