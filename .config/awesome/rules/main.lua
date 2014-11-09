local rules_m = {}

local awful = require("awful")
local beautiful = require("beautiful")

function rules_m:load(clientkeys, clientbuttons)
  -- Rules to apply to new clients (through the "manage" signal).
  awful.rules.rules = {
      -- All clients will match this rule.
      { rule = { },
        properties = { border_width = beautiful.border_width,
                       border_color = beautiful.border_normal,
                       focus = awful.client.focus.filter,
                       size_hints_honor = false,
                       raise = true,
                       keys = clientkeys,
                       buttons = clientbuttons } },
  }
end

return rules_m
