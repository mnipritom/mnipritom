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
                  Percentage = 93
                },
                {
                  Percentage = 7
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

-- [NOTE] set border style to non rounded
xplr.config.general.panel_ui.default.border_type = nil
