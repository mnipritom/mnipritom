local isTreesitterAvailable, treesitterInstance = pcall(require, "nvim-treesitter")
if not isTreesitterAvailable
then
  return
end

-- [TODO] explore conciseness
require("nvim-treesitter.install").prefer_git = true

require("nvim-treesitter.install").update({
  with_sync = true
})

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "lua",
    "typescript",
    "javascript",
    "java"
  },
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  },
  sync_install = false
})
