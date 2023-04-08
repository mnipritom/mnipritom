return {
  dir = neovimSourcesPath .. "/references/plugins/sources/neo-tree",
  config = function()
    local neo_tree = require("neo-tree")
    neo_tree.setup({
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
            -- ["."] = "set_root",
            -- ["<bs>"] = "navigate_up",
            ["bd"] = "buffer_delete"
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
            -- ["."] = "set_root",
            -- ["<bs>"] = "navigate_up",
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
            ["D"] = "fuzzy_finder_directory",
            --["/"] = "filter_as_you_type", -- this was the default until v1.28
            ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
            -- ["D"] = "fuzzy_sorter_directory",
            ["f"] = "filter_on_submit",
            ["<C-x>"] = "clear_filter",
            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified"
          },
          fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
            ["<down>"] = "move_cursor_down",
            ["<C-n>"] = "move_cursor_down",
            ["<up>"] = "move_cursor_up",
            ["<C-p>"] = "move_cursor_up"
          }
        }
      },
      window = {
        mappings = {
          ["l"] = "open",
          ["L"] = "set_root",
          ["J"] = "navigate_up",
          ["j"] = "close_node",
          ["I"] = "prev_source",
          ["K"] = "next_source"
          -- ["\"] = "quit"
        }
      }
    })
    vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
  end
}
