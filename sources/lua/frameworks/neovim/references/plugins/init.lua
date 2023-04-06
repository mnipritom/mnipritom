local lazyPluginsSourcesDirectoryPath = vim.fn.stdpath("data") .. "/lazy"

local lazySourcesDirectoryPath = lazyPluginsSourcesDirectoryPath .. "/lazy.nvim"

if not vim.loop.fs_stat(lazySourcesDirectoryPath)
then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazySourcesDirectoryPath
  })
end

vim.opt.runtimepath:prepend(lazySourcesDirectoryPath)

require("lazy").setup({
  -- [TODO] populate `spec`
  spec = {
    require(specifications)
  },
  ui = {
    border = 1
  },
  root = lazyPluginsSourcesDirectoryPath,
  lockfile = neovimSourcesPath .. "neovim.lock"
})
