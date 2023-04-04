-- [LINK] http://lua-users.org/lists/lua-l/2020-01/msg00345.html

local fullpath = debug.getinfo(1,"S").source:sub(2)
fullpath = io.popen("realpath '" .. fullpath .. "'", 'r'):read('a')
fullpath = fullpath:gsub('[\n\r]*$','')
local dirname, filename = fullpath:match('^(.*/)([^/]-)$')
dirname = dirname or ''
filename = filename or fullpath

package.path = dirname .. "?.lua;" .. package.path
package.path = dirname .. "?/init.lua;" .. package.path

require("configurations")