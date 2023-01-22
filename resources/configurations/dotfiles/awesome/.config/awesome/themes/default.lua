--[[
  note: themes define colours, icons, font and wallpapers
--]]
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local function setWallpaper(clientInstance)
  -- Wallpaper
  if beautiful.wallpaper
  then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function"
    then
      wallpaper = wallpaper(clientInstance)
    end
    gears.wallpaper.maximized(wallpaper, clientInstance, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
client.connect_signal(
  "property::geometry",
  setWallpaper
)

local function setWallpaper(clientInstance)
  -- Wallpaper
  if beautiful.wallpaper
  then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function"
    then
      wallpaper = wallpaper(clientInstance)
    end
    gears.wallpaper.maximized(wallpaper, clientInstance, true)
  end
end

awful.screen.connect_for_each_screen(
  function(self)
    client.connect_signal(
      "property::geometry",
      setWallpaper
    )
  end
)
client.connect_signal(
  "focus",
  function(self)
    self.border_color = beautiful.border_focus
  end
)
client.connect_signal(
  "unfocus",
  function(self)
    self.border_color = beautiful.border_normal
  end
)