local isTablineAvailable, tablineInstance = pcall(require, "tabline")
if not isTablineAvailable
then
  return
end

tablineInstance.setup({
  enable = true,
  options = {
    max_bufferline_percent = 66,
    show_tabs_always = true,
    show_devicons = true,
    show_bufnr = false,
    show_filename_only = true,
    modified_icon = " + ",
    modified_italic = false,
    show_tabs_only = false
  }
})
