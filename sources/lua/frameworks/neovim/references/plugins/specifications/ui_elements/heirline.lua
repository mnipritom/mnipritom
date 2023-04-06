return {
  name = "heirline.nvim",
  url = "https://github.com/rebelot/heirline.nvim",
  enabled = true,
  lazy = false,

  config = function()
    local heirline = require("heirline")
    return heirline.setup({
      -- [TODO] implement `heirline`
    })
  end
}
