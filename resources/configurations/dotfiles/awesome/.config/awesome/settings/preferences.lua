local awful = require("awful")
-- Enable sloppy focus, so that focus follows mouse.
require("awful.autofocus")
client.connect_signal(
  "mouse::enter",
  function(self)
    self:emit_signal(
      "request::activate",
      "mouse_enter",
      {
        raise = false
      }
    )
  end
)
-- Signal function to execute when a new client appears.
client.connect_signal(
  "manage",
  function(self)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup and not self.size_hints.user_position and not self.size_hints.program_position
    then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(self)
    end
  end
)  