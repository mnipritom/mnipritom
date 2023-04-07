return {
  dir = neovimSourcesPath .. "references/plugins/sources/nvim-web-devicons",
  lazy = false,
  config = function()
    local nvim_web_devicons = require("nvim-web-devicons")
    nvim_web_devicons.setup({
      default = true,
      color_icons = true
    })
  end
}
