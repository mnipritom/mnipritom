local lazyModule = plugins .. "." .. "sources.lazy.lua.lazy"
local lazySourcesPath = neovimSourcesPath .. "references/plugins/sources/lazy"
local lazyConfigurations = require(plugins .. "." .. "resources.lazy")

lazyConfigurations.spec = {
  require(plugins .. "." .. "resources.onedark"),
  require(plugins .. "." .. "resources.feline")
}

vim.opt.runtimepath:prepend(lazySourcesPath)

require(lazyModule).setup(lazyConfigurations)
