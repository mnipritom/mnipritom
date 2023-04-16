local minimalLayout = {
  Vertical = {
    splits = {
      "Table"
    },
    config = {
      margin = nil,
      horizontal_margin = 0,
      vertical_margin = 0,
      constraints = {
        { 
          Percentage = 100
        }
      }
    }
  }
}

xplr.config.layouts.custom.minimalLayout = minimalLayout

xplr.config.general.initial_layout = "minimalLayout"
