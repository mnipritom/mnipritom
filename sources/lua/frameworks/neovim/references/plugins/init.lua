local function getPluginSpecifications(plugin)
  return require(plugins .. "." .. "resources" .. "." .. plugin)
end

local lazyConfigurations = getPluginSpecifications("lazy")

lazyConfigurations.spec = {
  getPluginSpecifications("nvim-treesitter"),
  getPluginSpecifications("onedark"),
  getPluginSpecifications("plenary"),
  getPluginSpecifications("gitsigns"),
  getPluginSpecifications("nvim-web-devicons"),
  getPluginSpecifications("nui"),
  getPluginSpecifications("neo-tree"),
  getPluginSpecifications("bufferline"),
  getPluginSpecifications("scope"),
  getPluginSpecifications("feline"),
  getPluginSpecifications("mason"),
  getPluginSpecifications("mason-lspconfig"),
  getPluginSpecifications("nvim-lspconfig"),
  getPluginSpecifications("telescope")
}

local lazySourcesPath = neovimSourcesPath .. "references/plugins/sources/lazy"
vim.opt.runtimepath:prepend(lazySourcesPath)

local lazyModule = plugins .. "." .. "sources.lazy.lua.lazy"
require(lazyModule).setup(lazyConfigurations)
