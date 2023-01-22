local naughty = require("naughty")
client.connect_signal(
  "request::display_error",
  function(message, startup)
    naughty.notification {
      title = "Error occurred" .. (startup and " during startup!" or "!"),
      urgency = "critical",
      message = message
    }
  end
)
client.connect_signal(
  "debug::deprecation",
  function(hint, see, args)
    naughty.notification {
      urgency = "critical",
      title = "Deprecated configurations detected" .. (see and args),
      text = hint,
    }
end)