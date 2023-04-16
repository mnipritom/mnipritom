version = "0.20.1"

-- [NOTE] added extra `/` to denote root of filesystem
-- [NOTE] `io` output of realpath sometimes strips off preceding `/`
local xplrSourcesEntryPointPath = debug.getinfo(1,"S").source:sub(2)
xplrSourcesEntryPointPath = io.popen("realpath '" .. "/" .. xplrSourcesEntryPointPath .. "'", "r"):read("a")
xplrSourcesEntryPointPath = xplrSourcesEntryPointPath:gsub("[\n\r]*$","")

local xplrSourcesDirectoryPath, xplrEntryPointFileName = xplrSourcesEntryPointPath:match("^(.*/)([^/]-)$")
xplrSourcesDirectoryPath = xplrSourcesDirectoryPath or ""
xplrEntryPointFileName = xplrEntryPointFileName or xplrSourcesEntryPointPath

package.path = xplrSourcesDirectoryPath .. "?.lua;" .. package.path
package.path = xplrSourcesDirectoryPath .. "?/init.lua;" .. package.path

productions = "productions"

require(productions .. "." .. "keybindings")
require(productions .. "." .. "layouts")
