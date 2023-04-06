return {
  -- [NOTE] adding `root` in `lazy` setup triggers looped git clone

  lockfile = neovimSourcesPath .. "neovim.lock",

  ui = {
    border = 1
  },

  -- [TODO] populate `spec`
  spec = {}
}
