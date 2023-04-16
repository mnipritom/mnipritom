xplr.config.layouts.custom = {
  hierarchy = {
    Horizontal = {
      splits = {
        {
          Vertical = {
            splits = {
              "Table",
              "InputAndLogs"
            },
            config = {
              constraints = {
                {
                  Percentage = 90
                },
                {
                  Percentage = 10
                }
              }
            }
          }
        },
        {
          Vertical = {
            splits = {
              "Selection"
            },
            config = {
              constraints = {
                {
                  Percentage = 100
                }
              }
            }
          }
        }
      },
      config = {
        margin = nil,
        horizontal_margin = nil,
        vertical_margin = nil,
        constraints = {
          { 
            Percentage = 75
          },
          {
            Percentage = 25
          }
        }
      }
    }
  }
}

xplr.config.general.initial_layout = "hierarchy"

xplr.config.general.panel_ui.table.borders = nil
xplr.config.general.panel_ui.default.borders = nil
xplr.config.general.panel_ui.default.border_type = nil
