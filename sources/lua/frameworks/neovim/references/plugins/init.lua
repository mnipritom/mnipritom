local lazyModule = plugins .. "." .. "sources.lazy.lua.lazy"

local lazySourcesPath = neovimSourcesPath .. "/references/plugins/sources/lazy"

vim.opt.runtimepath:prepend(lazySourcesPath)

require(lazyModule).setup(require(plugins .. "." .. "specifications.lazy"))
