local menu_m = {}

local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")

function menu_m:load()
  -- Create a laucher widget and a main menu
  local awesomemenu = {
     { "manual", terminal .. " -e man awesome" },
     { "edit config", editor_cmd .. " " .. awesome.conffile },
     { "restart", awesome.restart },
     { "quit", awesome.quit }
  }

  self.mainmenu = awful.menu({ items = { { "awesome", awesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

  self.mainlauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                         menu = self.mainmenu })

  -- Menubar configuration
  menubar.utils.terminal = terminal -- Set the terminal for applications that require it
end

return menu_m
