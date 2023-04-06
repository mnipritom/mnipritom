local items = {}

items.vim_mode = {
  provider = require("feline.providers.vi_mode").get_vim_mode(),
  hl = function()
    return {
      fg = "bg",
      bg = require("feline.providers.vi_mode").get_mode_color(),
      style = "bold",
      name = "NeovimModeHLColor",
    }
  end,
  left_sep = "block",
  right_sep = "block",
}

items.git_branch = {
  provider = "git_branch",
  hl = {
    fg = "fg",
    bg = "bg",
    style = "bold",
  },
  left_sep = "block",
  right_sep = "",
}

items.git_add = {
  provider = "git_diff_added",
  hl = {
    fg = "green",
    bg = "bg",
  },
  left_sep = "",
  right_sep = "",
}

items.git_delete = {
  provider = "git_diff_removed",
  hl = {
    fg = "red",
    bg = "bg",
  },
  left_sep = "",
  right_sep = "",
}

items.git_change = {
  provider = "git_diff_changed",
  hl = {
    fg = "purple",
    bg = "bg",
  },
  left_sep = "",
  right_sep = "",
}

items.separator = {
  provider = "",
  hl = {
    fg = "bg",
    bg = "bg",
  },
}

items.diagnostic_errors = {
  provider = "diagnostic_errors",
  hl = {
    fg = "red",
  },
}

items.diagnostic_warnings = {
  provider = "diagnostic_warnings",
  hl = {
    fg = "yellow",
  },
}

items.diagnostic_hints = {
  provider = "diagnostic_hints",
  hl = {
    fg = "aqua",
  },
}

items.diagnostic_info = {
  provider = "diagnostic_info",
}

items.file_type = {
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
  right_sep = "block",
}

local left = {
  items.vim_mode,
  items.separator,
  items.file_type,
}

local middle = {}

local right = {
  items.lsp,
  items.git_branch,
  items.git_add,
  items.git_delete,
  items.git_change,
  items.separator,
  items.diagnostic_errors,
  items.diagnostic_warnings,
  items.diagnostic_info,
  items.diagnostic_hints,
  items.scroll_bar,
}

local components = {
  active = {
    left,
    middle,
    right,
  },
}

-- feline.setup({
--   components = components,
--   theme = theme,
--   vi_mode_colors = mode_theme,
-- })
