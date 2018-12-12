package.path = package.path .. ';' .. os.getenv("HOME") .. '/.config/awesome/vendor/conky/?.lua;'

require("conky-dbus")
