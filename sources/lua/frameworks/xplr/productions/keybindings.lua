xplr.config.general.global_key_bindings = {
  on_key = {
    ["esc"] = nil,
    ["ctrl-h"] = {
      messages = {
        "PopMode"
      }
    },
    ["ctrl-c"] = nil,
    ["H"] = {
      messages = {
        {
          ToggleNodeFilter = {
            filter = "RelativePathDoesNotStartWith",
            input = "."
          }
        },
        "ExplorePwdAsync"
      }
    },
    [":"] = {
      messages = {
        "PopMode",
        {
          SwitchModeBuiltin = "action"
        }
      }
    },
    ["G"] = {
      messages = {
        "PopMode",
        "FocusLast"
      }
    },
    ["gg"] = {
      messages = {
        "PopMode",
        "FocusFirst"
      }
    },
    ["ctrl-a"] = {
      messages = {
        "ToggleSelectAll"
      }
    },
    ["ctrl-f"] = {
      messages = {
        "PopMode",
        {
          SwitchModeBuiltin = "search"
        },
        {
          SetInputBuffer = ""
        }
      }
    },
    ["f"] = {
      messages = {
        "PopMode",
        {
          SwitchModeBuiltin = "filter"
        }
      }
    },
    ["s"] = {
      messages = {
        "PopMode",
        {
          SwitchModeBuiltin = "sort"
        }
      }
    },
    ["ctrl-r"] = {
      messages = {
        "ClearScreen"
      }
    },
    ["ctrl-e"] = {
      messages = {
        {
          SwitchModeBuiltin = "switch_layout"
        }
      }
    },
    ["g"] = {
      messages = {
        "PopMode",
        {
          SwitchModeBuiltin = "go_to"
        }
      }
    },
    ["q"] = {
      help = "quit",
      messages = {
        "Quit",
      },
    },
    ["v"] = {
      messages = {
        "ToggleSelection",
        "FocusNext"
      }
    },
    ["V"] = {
      messages = {
        "ClearSelection"
      }
    },
    ["ctrl-u"] = {
      messages = {
        "ScrollUpHalf"
      }
    },
    ["ctrl-d"] = {
      messages = {
        "ScrollDownHalf"
      }
    }
  },
  on_number = {
    messages = {
      "PopMode",
      {
        SwitchModeBuiltin = "number"
      },
      "BufferInputFromKey"
    }
  }
}

-- [NOTE] disabling some defaults
xplr.config.modes.builtin.default.key_bindings.on_key["ctrl-d"] = nil
xplr.config.modes.builtin.default.key_bindings.on_key["ctrl-u"] = nil
xplr.config.modes.builtin.default.key_bindings.on_key["h"] = nil
xplr.config.modes.builtin.default.key_bindings.on_key["V"] = nil

-- [NOTE] remapping some defaults
xplr.config.modes.builtin.default.key_bindings.on_key["i"] =
xplr.config.modes.builtin.default.key_bindings.on_key["up"]
xplr.config.modes.builtin.default.key_bindings.on_key["j"] =
xplr.config.modes.builtin.default.key_bindings.on_key["left"]
xplr.config.modes.builtin.default.key_bindings.on_key["k"] =
xplr.config.modes.builtin.default.key_bindings.on_key["down"]
xplr.config.modes.builtin.default.key_bindings.on_key["l"] =
xplr.config.modes.builtin.default.key_bindings.on_key["right"]

xplr.config.modes.builtin.number.key_bindings.on_key["k"] =
xplr.config.modes.builtin.number.key_bindings.on_key["down"]
xplr.config.modes.builtin.number.key_bindings.on_key["i"] =
xplr.config.modes.builtin.number.key_bindings.on_key["up"]


