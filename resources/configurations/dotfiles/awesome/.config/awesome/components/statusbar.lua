local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local tagButtons = gears.table.join(
  awful.button(
    {},
    1,
    function(self)
      self:view_only()
    end
  ),
  awful.button(
    {
      modkey
    },
    1,
    function(self)
      if client.focus
      then
        client.focus:move_to_tag(self)
      end
  end),
  awful.button(
    {},
    3,
    awful.tag.viewtoggle
  ),
  awful.button(
    {
      modkey
    },
    3,
    function(self)
      if client.focus
      then
        client.focus:toggle_tag(self)
      end
    end
  ),
  awful.button(
    {},
    4,
    function(self)
      awful.tag.viewnext(self.screen)
    end
  ),
  awful.button(
    {},
    5,
    function(t)
      awful.tag.viewprev(self.screen)
    end
  )
)

local taskButtons = gears.table.join(
  awful.button(
    {},
    1,
    function (self)
      if self == client.focus
      then
        self.minimized = true
      else
        self:emit_signal(
          "request::activate",
          "tasklist",
          {raise = true}
        )
      end
    end
  ),
  awful.button(
    {},
    3,
    function()
      awful.menu.client_list({
        theme = {
          width = 250
        }
      })
    end
  ),
  awful.button(
    {},
    4,
    function()
      awful.client.focus.byidx(1)
    end
  ),
  awful.button(
    {},
    5,
    function()
      awful.client.focus.byidx(-1)
    end
  )
)

local layoutButtons = gears.table.join(
  awful.button(
    {},
    1,
    function()
      awful.layout.inc(1)
    end
  ),
  awful.button(
    {},
    3,
    function()
      awful.layout.inc(-1)
    end
  ),
  awful.button(
    {},
    4,
    function()
      awful.layout.inc(1)
    end
  ),
  awful.button(
    {},
    5,
    function()
      awful.layout.inc(-1)
    end
  )
)

awful.screen.connect_for_each_screen(
  function(self)
    awful.tag.add("browsers",{
      icon = os.getenv("logosDirectory").."/languages/javascript.svg",
      layout = awful.layout.layouts[1],
      gap_single_client = true,
      screen = self,
      selected = true
    })
    awful.tag.add("editors",{
      icon = os.getenv("logosDirectory").."/languages/typescript.svg",
      layout = awful.layout.layouts[1],
      gap_single_client = true,
      screen = self
    })
    awful.tag.add("terminals",{
      icon = os.getenv("logosDirectory").."/frameworks/electron.svg",
      layout = awful.layout.layouts[1],
      gap_single_client = true,
      screen = self
    })
    self.topStatusbar = awful.wibar{
      position = "top",
      screen = self
    }
    self.topStatusbar : setup {
      layout = wibox.layout.align.horizontal,
      {
        layout = wibox.layout.fixed.horizontal,
        nill
      },
      awful.widget.tasklist {
        screen  = self,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = taskButtons
      },
      {
        layout = wibox.layout.fixed.horizontal,
        nill
      }
    }
    self.bottomStatusbar = awful.wibar{
      position = "bottom",
      screen = self
    }
    self.bottomStatusbar : setup {
      layout = wibox.layout.align.horizontal,
      {
        layout = wibox.layout.fixed.horizontal,
        awful.widget.taglist {
          screen  = self,
          filter  = awful.widget.taglist.filter.all,
          buttons = tagButtons
        }
      },
      {
        -- [TODO] center horizontally
        layout = wibox.layout.fixed.horizontal,
        wibox.widget {
          visible = false,
          format = '%a %b %d, %H:%M',
          widget = wibox.widget.textclock
        }
      },
      {
        layout = wibox.layout.fixed.horizontal,
        wibox.widget.systray()
      }
    }
    -- self.layoutbox = awful.widget.layoutbox{
    --   screen = self,
    --   buttons = layoutButtons
    -- }
    self.promptbox = awful.widget.prompt()
  end
)
