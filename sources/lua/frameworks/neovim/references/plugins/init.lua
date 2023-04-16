local function getPluginSpecifications(plugin)
  return require(plugins .. "." .. "resources" .. "." .. plugin)
end

pluginsSourcesPath = neovimSourcesPath .. "references/plugins/sources/"

local lazyConfigurations = getPluginSpecifications("lazy")

lazyConfigurations.spec = {
  getPluginSpecifications("nvim-treesitter"),
  getPluginSpecifications("onedark"),
  getPluginSpecifications("plenary"),
  getPluginSpecifications("gitsigns"),
  getPluginSpecifications("nvim-web-devicons"),
  getPluginSpecifications("diffview"),
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

local lazySourcesPath = pluginsSourcesPath .. "lazy"
vim.opt.runtimepath:prepend(lazySourcesPath)

local lazyModule = plugins .. "." .. "sources.lazy.lua.lazy"
require(lazyModule).setup(lazyConfigurations)
