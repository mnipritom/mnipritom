local colors = {
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

local vim_mode_indicators_colors = {
  ["NORMAL"] = colors.green,
  ["OP"] = colors.cyan,
  ["INSERT"] = colors.aqua,
  ["VISUAL"] = colors.yellow,
  ["LINES"] = colors.darkred,
  ["BLOCK"] = colors.orange,
  ["REPLACE"] = colors.purple,
  ["V-REPLACE"] = colors.pink,
  ["ENTER"] = colors.pink,
  ["MORE"] = colors.pink,
  ["SELECT"] = colors.darkred,
  ["SHELL"] = colors.cyan,
  ["TERM"] = colors.lime,
  ["NONE"] = colors.gray,
  ["COMMAND"] = colors.blue,
}

local blocks = {
  vim_mode = {
    provider = function()
      return feline.configurations.providers.get_vim_mode()
    end,
    hl = function()
      return {
        fg = "bg",
        bg = feline.configurations.providers.get_mode_color(),
        style = "bold",
        name = "NeovimModeHLColor",
      }
    end,
    left_sep = "block",
    right_sep = "block",
  },

  git_branch = {
    provider = "git_branch",
    hl = {
      fg = "fg",
      bg = "bg",
      style = "bold",
    },
    left_sep = "block",
    right_sep = "block"
  },

  git_add = {
    provider = "git_diff_added",
    hl = {
      fg = "green",
      bg = "bg",
    },
    left_sep = "block",
    right_sep = "block"
  },

  git_delete = {
    provider = "git_diff_removed",
    hl = {
      fg = "red",
      bg = "bg",
    },
    left_sep = "block",
    right_sep = "block"
  },

  git_change = {
    provider = "git_diff_changed",
    hl = {
      fg = "purple",
      bg = "bg",
    },
    left_sep = "block",
    right_sep = "block"
  },

  separator = {
    provider = "",
    hl = {
      fg = "bg",
      bg = "bg",
    },
  },

  diagnostic_errors = {
    provider = "diagnostic_errors",
    hl = {
      fg = "red",
    },
  },

  diagnostic_warnings = {
    provider = "diagnostic_warnings",
    hl = {
      fg = "yellow",
    },
  },

  diagnostic_hints = {
    provider = "diagnostic_hints",
    hl = {
      fg = "aqua",
    },
  },

  diagnostic_info = {
    provider = "diagnostic_info",
  },

  file_type = {
    provider = {
      name = "file_type",
      opts = {
        filetype_icon = true,
      },
    },
    hl = {
      fg = "fg",
      bg = "gray",
    },
    left_sep = "block",
    right_sep = "block"
  },

  file_info = {
    provider = "file_info",
    left_sep = "block",
    right_sep = "block",
  },

  scroll_bar = {
    provider = "scroll_bar",
    left_sep = "block",
    right_sep = "block",
  }
}

local left = {
  blocks.vim_mode,
  blocks.git_branch,
  blocks.file_info
}
local middle = {}
local right = {
  blocks.file_type,
  blocks.git_add,
  blocks.git_delete,
  blocks.git_change,
  blocks.lsp,
  blocks.separator,
  blocks.diagnostic_errors,
  blocks.diagnostic_warnings,
  blocks.diagnostic_info,
  blocks.diagnostic_hints,
  blocks.scroll_bar
}

local components = {
  active = {
    left,
    middle,
    right
  }
}

require("feline").core.setup({
  components = components,
  colors = colors,
  vi_mode_colors = vim_mode_indicators_colors,
})
