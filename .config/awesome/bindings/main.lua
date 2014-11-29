local bindings_m = {}

local awful = require("awful")
local menubar = require("menubar")
local shifty = require("lib/shifty")
local cyclefocus = require("lib/cyclefocus")

function bindings_m:load(mainmenu, promptbox)
  self:common_mouse(awful, mainmenu)
  self.globalkeys = self:common_keyboard(awful, shifty, menubar, promptbox)

  self.clientkeys = self:get_clientkeys(awful)
  self.clientbuttons = self:get_clientbuttons(awful)
end

function bindings_m:get_clientkeys(awful)
  return awful.util.table.join(
      awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
      awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
      awful.key({ "Mod1",           }, "F4",     function (c) c:kill()                         end),
      awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
      awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
      awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
      awful.key({ modkey,           }, "n",
          function (c)
              -- The client currently has the input focus, so it cannot be
              -- minimized, since minimized clients can't have the focus.
              c.minimized = true
          end),
      awful.key({ modkey,           }, "m",
          function (c)
              c.maximized_horizontal = not c.maximized_horizontal
              c.maximized_vertical   = not c.maximized_vertical
          end),
      cyclefocus.key({ "Mod1", }, "Tab", 1, {
        cycle_filters = { cyclefocus.filters.same_screen, cyclefocus.filters.common_tag },
      })
  )
end

function bindings_m:get_clientbuttons(awful)
  return awful.util.table.join(
      awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
      awful.button({ modkey }, 1, awful.mouse.client.move),
      awful.button({ modkey }, 3, awful.mouse.client.resize)
  )
end

function bindings_m:common_mouse(awful, mainmenu)
  root.buttons(awful.util.table.join(
      awful.button({ }, 3, function () mainmenu:toggle() end),
      awful.button({ }, 4, awful.tag.viewnext),
      awful.button({ }, 5, awful.tag.viewprev)
  ))
end

function bindings_m:common_keyboard(awful, shifty, menubar, promptbox)
  globalkeys = awful.util.table.join(
      awful.key({ modkey,           }, "Left",   function () awful.tag.viewprev();        raise_last_client(awful.tag) end),
      awful.key({ modkey,           }, "Right",  function () awful.tag.viewnext();        raise_last_client(awful.tag) end),
      awful.key({ modkey,           }, "Escape", function () awful.tag.history.restore(); raise_last_client(awful.tag) end),
      awful.key({modkey}, "t", function() shifty.add({ rel_index = 1 }) end),
      awful.key({modkey, "Control"},
                  "t",
                  function() shifty.add({ rel_index = 1, nopopup = true }) end
                  ),
      awful.key({modkey, "Shift"}, "r", shifty.rename),
      awful.key({modkey}, "w", shifty.del),

      awful.key({ modkey,           }, "j",
          function ()
              awful.client.focus.byidx( 1)
              if client.focus then client.focus:raise() end
          end),
      awful.key({ modkey,           }, "k",
          function ()
              awful.client.focus.byidx(-1)
              if client.focus then client.focus:raise() end
          end),

      -- Layout manipulation
      awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
      awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
      awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
      awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
      awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
      awful.key({ modkey,           }, "Tab",
          function ()
              awful.client.focus.history.previous()
              if client.focus then
                  client.focus:raise()
              end
          end),

      -- Standard program
      awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
      awful.key({ modkey, "Control" }, "r", awesome.restart),
      awful.key({ modkey, "Shift"   }, "q", awesome.quit),

      awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
      awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
      awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
      awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
      awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
      awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),

      awful.key({ modkey, "Control" }, "n", awful.client.restore),

      -- Prompt
      awful.key({ modkey },            "r",     function () promptbox[mouse.screen]:run() end),

      -- Menubar
      awful.key({ modkey }, "p", function() menubar.show() end),

      awful.key({ }, "Print", function () awful.util.spawn("ksnapshot") end)
  )

  for i=1, (shifty.config.maxtags or 9) do
      globalkeys = awful.util.table.join(
                          globalkeys,
                          awful.key({modkey}, i,
                              function()
                                  tag = shifty.getpos(i)
                                  awful.tag.viewonly(tag)
                                  raise_last_client(tag)
                              end))
      globalkeys = awful.util.table.join(
                          globalkeys,
                          awful.key({modkey, "Control"}, i,
                              function ()
                                  local t = shifty.getpos(i)
                                  t.selected = not t.selected
                              end))
      globalkeys = awful.util.table.join(globalkeys,
                                  awful.key({modkey, "Control", "Shift"}, i,
                  function ()
                      if client.focus then
                          awful.client.toggletag(shifty.getpos(i))
                      end
                  end))
      -- move clients to other tags
      globalkeys = awful.util.table.join(
                      globalkeys,
                      awful.key({modkey, "Shift"}, i,
                          function ()
                              if client.focus then
                                  local t = shifty.getpos(i)
                                  awful.client.movetotag(t)
                                  awful.tag.viewonly(t)
                              end
                          end))
  end

  local ror = require("lib/aweror")
  globalkeys = awful.util.table.join(globalkeys, ror.genkeys(modkey))

  -- Set keys
  root.keys(globalkeys)

  return globalkeys
end

function raise_last_client(tag)
  local last_client = awful.client.focus.history.get(awful.tag.getscreen(tag), 0)
  if last_client then
    client.focus = last_client
    last_client:raise()
  end
end

return bindings_m
