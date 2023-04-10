return {
  dir = neovimSourcesPath .. "/references/plugins/sources/neo-tree",
  config = function()
    local neo_tree = require("neo-tree")
    neo_tree.setup({
      default_component_configs = {
        indent = {
          with_markers = true,
          with_expanders = false
        }
      },
      enable_git_status = true,
      source_selector = {
        winbar = true,
        statusline = false
      },
      add_blank_line_at_top = false,
      hide_root_node = true,
      buffers = {
        window = {
          mappings = {
            ["w"] = "buffer_delete"
          }
        }
      },
      git_status = {
        window = {
          mappings = {
            ["A"] = "git_add_all",
            ["gu"] = "git_unstage_file",
            ["ga"] = "git_add_file",
            ["gr"] = "git_revert_file",
            ["gc"] = "git_commit",
            ["gp"] = "git_push",
            ["gg"] = "git_commit_and_push"
          }
        }
      },
      filesystem = {
        window = {
          mappings = {
            ["l"] = "open",
            ["L"] = "set_root",
            ["J"] = "navigate_up",
            ["j"] = "close_node",
            ["u"] = "close_all_subnodes",
            ["U"] = "close_all_nodes",
            -- ["\"] = "quit"
            ["H"] = "toggle_hidden",
            ["F"] = "fuzzy_sorter",
            ["f"] = "fuzzy_finder",
            ["<C-f>"] = "fuzzy_finder_directory",
            ["<leader>f"] = "filter_on_submit",
            ["<C-x>"] = "clear_filter"
         },
          fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
            ["<C-k>"] = "move_cursor_down",
            ["<C-i>"] = "move_cursor_up"
          }
        }
      },
      window = {
        mapping_options = {
          noremap = true,
          nowait = true
        },
        mappings = {
          ["I"] = "prev_source",
          ["K"] = "next_source",
          ["p"] = {
            "toggle_preview",
            config = {
              use_float = true
            }
          },
          ["P"] = "focus_preview"
        }
      }
    })
    local flags = {
      noremap = true,
      silent = true
    }
    vim.keymap.set("", "\\", "<cmd>Neotree reveal<cr>", flags)
    vim.keymap.set("", "<C-\\>", "<cmd>Neotree close<cr>", flags)
  end
}
