local isBlanklineAvailable, blanklineInstance = pcall(require, "blankline")
if not isBlanklineAvailable
then
  return
end

blanklineInstance.setup({
  buftype_exclude = {
    "terminal"
  },
  filetype_exclude = {
    "NvimTree",
    "packer"
  },
  show_end_of_line = true,
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true
})
