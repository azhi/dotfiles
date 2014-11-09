local signals_m = {}

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

function signals_m:load()
  -- Signal function to execute when a new client appears.
  client.connect_signal("manage", function (c, startup)
      if not startup then
          -- Set the windows at the slave,
          -- i.e. put it at the end of others instead of setting it master.
          -- awful.client.setslave(c)

          -- Put windows in a smart way, only if they does not set an initial position.
          if not c.size_hints.user_position and not c.size_hints.program_position then
              awful.placement.no_overlap(c)
              awful.placement.no_offscreen(c)
          end
      end

      local titlebars_enabled = true
      if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
          local layout = self:build_titlebar(awful, wibox, c)
          awful.titlebar(c):set_widget(layout)
      end
  end)

  client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
  client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
end

function signals_m:build_titlebar(awful, wibox, c)
  -- buttons for the titlebar
  local buttons = awful.util.table.join(
          awful.button({ }, 1, function()
              client.focus = c
              c:raise()
              awful.mouse.client.move(c)
          end),
          awful.button({ }, 3, function()
              client.focus = c
              c:raise()
              awful.mouse.client.resize(c)
          end)
          )

  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(awful.titlebar.widget.iconwidget(c))
  left_layout:buttons(buttons)

  local minimize_button = awful.titlebar.widget.button(c, "minimize", function() return "" end, function(c) c.minimized = not c.minimized end)
  c:connect_signal("property::minimized", minimize_button.update)

  local right_layout = wibox.layout.fixed.horizontal()
  right_layout:add(awful.titlebar.widget.floatingbutton(c))
  right_layout:add(minimize_button)
  right_layout:add(awful.titlebar.widget.maximizedbutton(c))
  right_layout:add(awful.titlebar.widget.closebutton(c))

  -- The title goes in the middle
  local middle_layout = wibox.layout.flex.horizontal()
  local title = awful.titlebar.widget.titlewidget(c)
  title:set_align("center")
  middle_layout:add(title)
  middle_layout:buttons(buttons)

  -- Now bring it all together
  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_right(right_layout)
  layout:set_middle(middle_layout)

  return layout
end

return signals_m
