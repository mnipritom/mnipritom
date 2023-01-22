--[[
  ---
  note:
    source: https://www.reddit.com/r/neovim/comments/q25rrv/comment/hfkgqur
  ---
--]]

local isTelescopeAvailable, telescopeInstance = pcall(require, "telescope")
if not isTelescopeAvailable
then
  return
end

telescopeInstance.setup({
  defaults = {
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
    -- [TODO]
  },
  extensions = {
    -- [TODO] switch to `fzf` backend for telescope
  }
})
