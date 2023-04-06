return {
  dir = neovimSourcesPath .. "references/plugins/sources/feline",
  config = function()
    local blocks = {
      vim_mode = {
        provider = function()
          return require("feline.providers.vi_mode").get_vim_mode()
        end,
        hl = function()
          return {
            fg = "bg",
            bg = require("feline.providers.vi_mode").get_mode_color(),
            style = "bold",
            name = "NeovimModeHLColor"
          }
        end,
        left_sep = "block",
        right_sep = "block"
      }
    }
    local regions = {
      left = {
        blocks.vim_mode
      },
      middle = {},
      right = {}
    }
    local segments = {
      active = {
        regions.left,
        regions.middle,
        regions.right
      }
    }
    local palette = {
      aqua = "#7AB0DF",
      bg = "#1C212A",
      blue = "#5FB0FC",
      cyan = "#70C0BA",
      darkred = "#FB7373",
      fg = "#C7C7CA",
      gray = "#222730",
      green = "#79DCAA",
      lime = "#54CED6",
      orange = "#FFD064",
      pink = "#D997C8",
      purple = "#C397D8",
      red = "#F87070",
      yellow = "#FFE59E"
    }
    require("feline").setup({
      components = segments,
      theme = palette
    })
  end
}