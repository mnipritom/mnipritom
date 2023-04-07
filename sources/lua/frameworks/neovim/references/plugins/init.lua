local function loadLazySpecifications(plugin)
  return require(plugins .. "." .. "resources" .. "." .. plugin)
end

local lazyConfigurations = loadLazySpecifications("lazy")

lazyConfigurations.spec = {
  loadLazySpecifications("onedark"),
  loadLazySpecifications("feline"),
  loadLazySpecifications("mason"),
  loadLazySpecifications("mason-lspconfig"),
  loadLazySpecifications("nvim-lspconfig")
}

local lazySourcesPath = neovimSourcesPath .. "references/plugins/sources/lazy"
vim.opt.runtimepath:prepend(lazySourcesPath)

local lazyModule = plugins .. "." .. "sources.lazy.lua.lazy"
require(lazyModule).setup(lazyConfigurations)
