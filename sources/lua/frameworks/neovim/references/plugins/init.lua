local function getPluginSpecifications(plugin)
  return require(plugins .. "." .. "resources" .. "." .. plugin)
end

local lazyConfigurations = getPluginSpecifications("lazy")

lazyConfigurations.spec = {
  getPluginSpecifications("nvim-treesitter"),
  getPluginSpecifications("plenary"),
  getPluginSpecifications("nvim-web-devicons"),
  getPluginSpecifications("telescope"),
  getPluginSpecifications("onedark"),
  getPluginSpecifications("gitsigns"),
  getPluginSpecifications("nui"),
  getPluginSpecifications("neo-tree"),
  getPluginSpecifications("bufferline"),
  getPluginSpecifications("scope"),
  getPluginSpecifications("feline"),
  getPluginSpecifications("mason"),
  getPluginSpecifications("mason-lspconfig"),
  getPluginSpecifications("nvim-lspconfig")
}

local lazySourcesPath = neovimSourcesPath .. "references/plugins/sources/lazy"
vim.opt.runtimepath:prepend(lazySourcesPath)

local lazyModule = plugins .. "." .. "sources.lazy.lua.lazy"
require(lazyModule).setup(lazyConfigurations)
