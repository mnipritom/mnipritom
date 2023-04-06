  -- [NOTE] adding `root` in `lazy` setup triggers looped git clone
return {
  lockfile = neovimSourcesPath .. "neovim.lock",
  ui = {
    border = 1
  }
}
