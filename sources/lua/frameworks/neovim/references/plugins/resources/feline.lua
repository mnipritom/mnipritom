-- [LINK] https://github.com/dharmx/nvim-colo/blob/main/lua/colo/extensions/feline.lua
return {
  dir = neovimSourcesPath .. "references/plugins/sources/feline",
  config = function()
    local feline = require("feline")
    -- local feline_providers = require("feline.providers")
    local feline_vi_mode = require("feline.providers.vi_mode")
    local feline_cursor = require("feline.providers.cursor")
    local feline_file = require("feline.providers.file")
    local palette = {
      aqua = "#7AB0DF",
      black = "#1C212A",
      blue = "#5FB0FC",
      cyan = "#70C0BA",
      darkred = "#FB7373",
      paste = "#C7C7CA",
      gray = "#222730",
      green = "#79DCAA",
      lime = "#54CED6",
      orange = "#FFD064",
      pink = "#D997C8",
      purple = "#C397D8",
      red = "#F87070",
      yellow = "#FFE59E",
      navy = "#000020",
      bg = "#1C212A",
      fg = "#C7C7CA"
    }
    local blocks = {
      modes = {
        provider = {
          name = "vi_mode",
          opts = {
            show_mode_name = true,
          }
        },
        icon = "",
        left_sep = "block",
        right_sep = "block",
        hl = function()
          return {
            fg = "black",
            bg = feline_vi_mode.get_mode_color(),
            style = "bold"
          }
        end
      },
      levels = {
        depth = {
          provider = {
            name = "scroll_bar",
            opts = {
              reverse = false
            }
          },
          hl = {
            fg = "orange",
            bg = "navy"
          },
          left_sep = "block",
          right_sep = "block"
        },
        coverage = {
          provider = function()
            return feline_cursor.line_percentage() .. "/" .. tostring(vim.api.nvim_buf_line_count(0))
          end,
          hl = {
            fg = "paste",
            bg = "black"
          },
          left_sep = "block",
          right_sep = "block"
        }
      },
      files = {
        type = {
          provider = {
            name ="file_type",
            opts = {
              case = "titlecase"
            }
          },
          hl = {
            fg = "paste",
            bg = "gray"
          },
          left_sep = "block",
          right_sep = "block"
        },
        size = {
          provider = function()
            return feline_file.file_size()
          end,
          hl = {
            fg = "grey",
            bg = "black",
          },
          left_sep = "block",
          right_sep = "block" 
        }
      }
    }
    local regions = {
      left = {
        blocks.modes,
        blocks.levels.depth,
        blocks.levels.coverage
      },
      middle = {},
      right = {
        blocks.files.type,
        blocks.files.size
      }
    }
    local segments = {
      active = {
        regions.left,
        regions.middle,
        regions.right
      }
    }
    feline.setup({
      theme = palette,
      components = segments
    })
  end
}
