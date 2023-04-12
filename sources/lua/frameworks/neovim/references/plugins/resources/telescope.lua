return {
  dir = pluginsSourcesPath .. "telescope",
  config = function()
    local telescope = require("telescope")
    local telescope_builtin = require("telescope.builtin")
    local telescope_actions = require("telescope.actions")
    local telescope_actions_layout = require("telescope.actions.layout")
    telescope.setup({
      defaults = {
        mappings = {
          ["i"] = {
            ["<C-i>"] = telescope_actions.move_selection_previous,
            ["<C-k>"] = telescope_actions.move_selection_next,
            ["<C-j>"] = telescope_actions.move_to_top,
            ["<C-l>"] = telescope_actions.move_to_bottom,
            ["<C-p>"] = telescope_actions_layout.toggle_preview
          },
          ["n"] = {
            ["i"] = telescope_actions.move_selection_previous,
            ["k"] = telescope_actions.move_selection_next,
            ["j"] = telescope_actions.move_to_top,
            ["l"] = telescope_actions.move_to_bottom,
            ["p"] = telescope_actions_layout.toggle_preview
          }
        }
      }
    })
    vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, {})
    vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, {})
    vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, {})

    vim.keymap.set("n", "<leader>gf", telescope_builtin.git_files, {})
    vim.keymap.set("n", "<leader>gc", telescope_builtin.git_commits, {})
    vim.keymap.set("n", "<leader>gbc", telescope_builtin.git_bcommits, {})
    vim.keymap.set("n", "<leader>gb", telescope_builtin.git_branches, {})
    vim.keymap.set("n", "<leader>gss", telescope_builtin.git_status, {})
    vim.keymap.set("n", "<leader>gsa", telescope_builtin.git_stash, {})

    vim.keymap.set("n", "<leader>lr", telescope_builtin.lsp_references, {})
  end
}
