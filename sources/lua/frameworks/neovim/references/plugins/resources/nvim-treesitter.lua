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
        "nix",
        "python",
        "scheme",
        "go",
        "dart",
        "vim",
        "vimdoc",
        "javascript",
        "json",
        "typescript",
        "ruby",
        "perl",
        "awk"
      },
      sync_install = false,
      auto_install = false,
      highlight = {
        enable = true,
        disable = {
          -- [TODO] fix bash syntax highlighting errors
          "bash",
          "python"
        },
        additional_vim_regex_highlighting = false
      }
    })
  end
}
