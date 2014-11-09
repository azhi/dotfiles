local wallpapers_m = {}

local gears = require("gears")
local beautiful = require("beautiful")

function wallpapers_m:scanDir(directory)
  local i, fileList, popen = 0, {}, io.popen
  for filename in popen([[find "]] ..directory.. [[" -type f]]):lines() do
    i = i + 1
    fileList[i] = filename
  end
  return fileList
end

function wallpapers_m:load()
  wallpaperList = self:scanDir(os.getenv("HOME") .. "/.wallpapers")

  gears.wallpaper.maximized(wallpaperList[math.random(1, #wallpaperList)], s, true)

  changeTime = 1800
  wallpaperTimer = timer { timeout = changeTime }
  wallpaperTimer:connect_signal("timeout", function()
    gears.wallpaper.maximized(wallpaperList[math.random(1, #wallpaperList)], s, true)

    -- stop the timer (we don't need multiple instances running at the same time)
    wallpaperTimer:stop()

    --restart the timer
    wallpaperTimer.timeout = changeTime
    wallpaperTimer:start()
  end)

  wallpaperTimer:start()
end

return wallpapers_m
