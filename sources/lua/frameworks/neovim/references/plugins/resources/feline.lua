return {
  dir = neovimSourcesPath .. "references/plugins/sources/feline",
  config = function()
    -- [LINK] https://github.com/dharmx
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
    local blocks = {
      modes = {
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
      },
      lines = {
        provider = function()
          local linesInBuffer = tostring(vim.api.nvim_buf_line_count(0))
          local cursorPositionPercentage = require("feline.providers.cursor").line_percentage()
          local progressBar = require("feline.providers.cursor").scroll_bar(self,{
            opts = {
              reverse = true
            }
          })
          return progressBar .. " " .. cursorPositionPercentage .. "/" .. linesInBuffer
        end,
        left_sep = "block",
        right_sep = "block"
      },

    }
    local regions = {
      left = {
        blocks.modes,
        blocks.lines
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
    require("feline").setup({
      components = segments,
      theme = palette
    })
  end
}
