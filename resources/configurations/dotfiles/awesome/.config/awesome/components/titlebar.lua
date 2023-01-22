local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
  "request::titlebars",
  function(self)
    -- buttons for the titlebar
    local buttons = gears.table.join(
      awful.button(
        {},
        1,
        function()
          self:emit_signal(
            "request::activate",
            "titlebar",
            {
              raise = true
            }
          )
          awful.mouse.client.move(self)
        end
      ),
      awful.button(
        {},
        3,
        function()
          self:emit_signal(
            "request::activate",
            "titlebar",
            {
              raise = true
            }
          )
          awful.mouse.client.resize(self)
        end
      )
    )
    awful.titlebar(self) : setup {
      { -- Left
        awful.titlebar.widget.iconwidget(self),
        buttons = buttons,
        layout  = wibox.layout.fixed.horizontal
      },
      { -- Middle
        { -- Title
          align  = "center",
          widget = awful.titlebar.widget.titlewidget(self)
        },
        buttons = buttons,
        layout  = wibox.layout.flex.horizontal
      },
      { -- Right
        awful.titlebar.widget.floatingbutton(self),
        awful.titlebar.widget.maximizedbutton(self),
        awful.titlebar.widget.stickybutton(self),
        awful.titlebar.widget.ontopbutton(self),
        awful.titlebar.widget.closebutton(self),
        layout = wibox.layout.fixed.horizontal
      },
      layout = wibox.layout.align.horizontal
    }
  end
)