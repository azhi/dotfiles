local styles_m = {}

local gears = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")

function styles_m:load()
  -- Themes define colours, icons, font and wallpapers.
  beautiful.init(awful.util.getdir("config") .. "/theme/theme.lua")

  local wallpapers = require("styles/wallpapers")
  wallpapers:load()
end

return styles_m
