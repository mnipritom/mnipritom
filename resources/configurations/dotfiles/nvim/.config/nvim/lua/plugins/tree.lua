local isTreeAvailable, treeInstance = pcall(require, "nvim-tree")
if not isTreeAvailable
then
  return
end

treeInstance.setup({
  open_on_setup = true,
  sort_by = "case_sensitive",
  view = {
    centralize_selection = true,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
    adaptive_size = true,
    mappings = {
      list = {
        { key = "j", action = "dir_left" },
        { key = "l", action = "dir_right" },
        { key = "J", action = "dir_up" },
        { key = "L", action = "cd" },
        { key = "I", action = "collapse_all" },
        { key = "K", action = "expand_all" }
      }
    }
  },
  renderer = {
    add_trailing = true,
    group_empty = true,
    highlight_git = true,
    indent_width = 2,
    indent_markers = {
      enable = true,
      inline_arrows = true
    }
  },
  filters = {
    dotfiles = false
  }
})
