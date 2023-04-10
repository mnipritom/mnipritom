-- [LINK] https://github.com/tiagovla/scope.nvim/issues/1#issuecomment-1488952977
return {
  dir = neovimSourcesPath .. "references/plugins/sources/scope",
  config = function()
    local scope = require("scope")
    scope.setup()
  end
}
