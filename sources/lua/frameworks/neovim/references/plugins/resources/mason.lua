return {
  dir = neovimSourcesPath .. "/references/plugins/sources/mason",
  build = ":MasonUpdate",
  lazy = false,
  config = function()
    require("mason").setup({
      
    })
  end
}
