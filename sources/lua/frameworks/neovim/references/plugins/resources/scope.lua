-- [LINK] https://github.com/tiagovla/scope.nvim/issues/1#issuecomment-1488952977
return {
  dir = pluginsSourcesPath .. "scope",
  config = function()
    local scope = require("scope")
    scope.setup()
  end
}
