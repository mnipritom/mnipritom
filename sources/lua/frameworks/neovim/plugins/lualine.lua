local isLualineAvailable, lualineInstance = pcall(require, "lualine")
if not isLualineAvailable
then
  return
end

lualineInstance.setup({
  options = {
    icons_enabled = true,
    theme = "16color",
    section_separators = "",
    component_separators = "",
    globalstatus = true
  },
  extensions = {
    "nvim-tree"
  }
})
