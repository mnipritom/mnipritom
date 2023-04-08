-- [LINK] https://github.com/dharmx/nvim-colo/blob/main/lua/colo/extensions/feline.lua
return {
  dir = neovimSourcesPath .. "references/plugins/sources/feline",
  config = function()
    local feline = require("feline")
    -- local feline_providers = require("feline.providers")
    local feline_vi_mode = require("feline.providers.vi_mode")
    local feline_cursor = require("feline.providers.cursor")
    local feline_file = require("feline.providers.file")
    local feline_git = require("feline.providers.git")
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
            fg = "paste",
            bg = "gray"
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
            fg = "cyan",
            bg = "black"
          },
          left_sep = "block",
          right_sep = "block"
        },
        git = {
          additions = {
            provider = "git_diff_added",
            hl = {
              fg = "green",
              bg = "bg"
            },
            left_sep = "block",
            right_sep = "block"
          },
          deletions = {
            provider = "git_diff_removed",
            hl = {
              fg = "red",
              bg = "bg"
            },
            left_sep = "block",
            right_sep = "block"
          },
          modifications = {
            provider = "git_diff_changed",
            hl = {
              fg = "purple",
              bg = "bg"
            },
            left_sep = "block",
            right_sep = "block"
          }
        }
      },
      directories = {
        worktree = {
          provider = function()
            local branch, icon = feline_git.git_branch()
            icon = ""
            return icon .. branch
          end,
          hl = {
            fg = "paste",
            bg = "black"
          },
          left_sep = "block",
          right_sep = "block"
        }
      }
    }
    local regions = {
      left = {
        blocks.modes,
        blocks.directories.worktree,
        blocks.levels.depth,
        blocks.levels.coverage
      },
      middle = {},
      right = {
        blocks.files.type,
        blocks.files.size,
        blocks.files.git.additions,
        blocks.files.git.deletions,
        blocks.files.git.modifications
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
