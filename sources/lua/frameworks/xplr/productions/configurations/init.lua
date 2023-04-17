keybindings = configurations .. "." .. "keybindings"
layouts = configurations .. "." .. "layouts"
modifications = configurations .. "." .. "modifications"

require(keybindings)
require(layouts .. "." .. "custom")
require(modifications .. "." .. "preferences")
