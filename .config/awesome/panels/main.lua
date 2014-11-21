local panels_m = {}

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local blingbling = require("blingbling")
local assault = require("lib/assault")

function panels_m:load(layouts, mainlauncher)
  self:set_common_params()
  self:create_wiboxes(layouts, mainlauncher)
end

function panels_m:set_common_params()
  self.wibox = {}
  self.promptbox = {}
  self.layoutbox = {}
  self.taglist = {}
  self.taglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
  )
  self.tasklist = {}
  self.tasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
                             if c == client.focus then
                                 c.minimized = true
                             else
                                 -- Without this, the following
                                 -- :isvisible() makes no sense
                                 c.minimized = false
                                 if not c:isvisible() then
                                     awful.tag.viewonly(c:tags()[1])
                                 end
                                 -- This will also un-minimize
                                 -- the client, if needed
                                 client.focus = c
                                 c:raise()
                             end
                         end),
    awful.button({ }, 3, function ()
                             if instance then
                                 instance:hide()
                                 instance = nil
                             else
                                 instance = awful.menu.clients({
                                     theme = { width = 250 }
                                 })
                             end
                         end),
    awful.button({ }, 4, function ()
                             awful.client.focus.byidx(1)
                             if client.focus then client.focus:raise() end
                         end),
    awful.button({ }, 5, function ()
                             awful.client.focus.byidx(-1)
                             if client.focus then client.focus:raise() end
                         end)
  )
end

function panels_m:create_wiboxes(layouts, mainlauncher)
  self.udisks_glue = blingbling.udisks_glue.new({ menu_icon = beautiful.widgets_usb})

  -- Create a wibox for each screen and add it
  for s = 1, screen.count() do
      -- Create a promptbox for each screen
      self.promptbox[s] = awful.widget.prompt()
      -- Create an imagebox widget which will contains an icon indicating which layout we're using.
      -- We need one layoutbox per screen.
      self.layoutbox[s] = awful.widget.layoutbox(s)
      self.layoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end))
      )
      -- Create a taglist widget
      self.taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, self.taglist.buttons)
      -- Create a tasklist widget
      self.tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, self.tasklist.buttons)
      -- Create the wibox
      self.wibox[s] = awful.wibox({ position = "top", height = "20", screen = s })

      -- volume_master = blingbling.volume({height = 20, width = 40, bar =true})
      -- volume_master:update_master()
      -- volume_master:set_master_control()

      local calendar = blingbling.calendar.new({type = "imagebox", image = beautiful.calendar_icon})

      local shutdown = awful.widget.launcher({image = beautiful.widgets_shutdown, command = "run_once kshutdown"})

      -- enable_battery_widget = true
      enable_battery_widget = false
      if enable_battery_widget then
        local battery = assault({
          critical_level = 0.15,
          critical_color = "#ff0000",
          charging_color = "#00ff00"
        })
      end

      -- Widgets that are aligned to the left
      local left_layout = wibox.layout.fixed.horizontal()
      left_layout:add(mainlauncher)
      left_layout:add(self.taglist[s])
      left_layout:add(self.promptbox[s])

      -- Widgets that are aligned to the right
      local right_layout = wibox.layout.fixed.horizontal()
      if s == 1 then right_layout:add(wibox.widget.systray()) end
      right_layout:add(self.udisks_glue)
      -- right_layout:add(volume_master)
      if battery then right_layout:add(battery) end
      right_layout:add(calendar)
      right_layout:add(self.layoutbox[s])
      right_layout:add(shutdown)

      -- Now bring it all together (with the tasklist in the middle)
      local layout = wibox.layout.align.horizontal()
      layout:set_left(left_layout)
      layout:set_middle(self.tasklist[s])
      layout:set_right(right_layout)

      self.wibox[s]:set_widget(layout)
  end
end

return panels_m
