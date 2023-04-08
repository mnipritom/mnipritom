-- [NOTE] avoid adding `root`
return {
  -- [TODO] implement lockfile generation for local git repo/submoduled plugins
  lockfile = neovimSourcesPath .. "neovim.lock",
  ui = {
    border = "none"
  }
}
