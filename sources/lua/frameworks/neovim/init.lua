-- [LINK] http://lua-users.org/lists/lua-l/2020-01/msg00345.html

local neovimSourcesEntryPointPath = debug.getinfo(1,"S").source:sub(2)
neovimSourcesEntryPointPath = io.popen("realpath '" .. neovimSourcesEntryPointPath .. "'", "r"):read("a")
neovimSourcesEntryPointPath = neovimSourcesEntryPointPath:gsub("[\n\r]*$","")

local neovimSourcesDirectoryPath, neovimEntryPointFileName = neovimSourcesEntryPointPath:match("^(.*/)([^/]-)$")
neovimSourcesDirectoryPath = neovimSourcesDirectoryPath or ""
neovimEntryPointFileName = neovimEntryPointFileName or neovimSourcesEntryPointPath

-- [NOTE] `neovimSourcesPath` globally scoped/aliased for further references
neovimSourcesPath = neovimSourcesDirectoryPath

package.path = neovimSourcesDirectoryPath .. "?.lua;" .. package.path
package.path = neovimSourcesDirectoryPath .. "?/init.lua;" .. package.path

vim.opt.runtimepath:prepend(neovimSourcesDirectoryPath)
-- print(vim.inspect(vim.api.nvim_list_runtime_paths()))

-- [NOTE] global `lua` modules are set for conciseness
productions = "productions"
configurations = productions .. "." .. "configurations"

references = "references"
plugins = references .. "." .. "plugins"

require(productions)
require(references)
