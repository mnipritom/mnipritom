return {
  dir = neovimSourcesPath .. "references/plugins/sources/nvim-treesitter",
  build = function()
    require("nvim-treesitter.install").update({
      with_sync = true
    })
  end,
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "c",
        "vim",
        "vimdoc",
        "query",
        "bash",
        "lua",
        "vim",
        "vimdoc",
        "javascript",
        "typescript",
        "ruby",
        "perl",
        "awk"
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        disable = {
          -- [TODO] fix bash syntax highlighting errors
          "bash"
        },
        additional_vim_regex_highlighting = false
      }
    })
  end
}
