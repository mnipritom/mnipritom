local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen
    }
  },
  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA",  -- Firefox addon DownThemAll.
        "copyq",  -- Includes session name in class.
        "pinentry"
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui",
        "veromix",
        "xtightvncviewer"
      },

      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester"  -- xev.
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "ConfigManager",  -- Thunderbird's about:config.
        "pop-up"       -- e.g. Google Chrome's (detached) Developer Tools.
      }
    },
    properties = {
      floating = true
    }
  },
  -- Add titlebars to normal clients and dialogs
  {
    rule_any = {
      type = {
        "normal",
        "dialog"
      }
    },
    properties = {
      titlebars_enabled = false
    }
  },
  -- Set Firefox to always map on the tag named "2" on screen 1.
  {
    rule_any = {
      class = {
        "Firefox",
        "Navigator",
        "google-chrome",
        "Google-chrome"
      }
    },
    properties = {
      screen = awful.screen.preferred,
      tag = "browsers"
    }
  },
  {
    rule_any = {
      class = {
        "atom" and "Atom",
        "code" and "Code",
        "logseq" and "Logseq",
        "obsidian",
        "marktext"
      }
    },
    properties = {
      screen = awful.screen.preferred,
      tag = "editors"
    }
  },
  {
    rule_any = {
      class = {
        "kitty",
        "org.wezfurlong.wezterm"
      }
    },
    properties = {
      screen = awful.screen.preferred,
      tag = "terminals"
    }
  },
  {
    rule_any = {
      name ={
        "MEGAsync"
      },
      class = {
        "megasync" and "MEGAsync"
      }
    },
    properties = {
      floating = true,
      skip_taskbar = true,
      placement = awful.placement.bottom_right
    }
  }
}
-- source https://www.reddit.com/r/awesomewm/comments/61s020/round_corners_for_every_client/
-- rounded corners
-- client.connect_signal("manage", function (c)
--   c.shape = gears.shape.rounded_rect
-- end)
-- client.connect_signal("manage", function (c)
--   c.shape = function(cr,w,h)
--       gears.shape.rounded_rect(cr,w,h,5)
--   end
-- end)
-- }}}
