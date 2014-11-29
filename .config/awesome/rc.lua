local awful = require("awful")
awful.rules = require("awful.rules")

package.path = package.path .. ';' .. awful.util.getdir("config") .. '/lib/?.lua;' ..
  awful.util.getdir("config") .. '/lib/?/init.lua'

local shifty = require("shifty")
shifty.config.sloppy = false

error_handling = require("error_handling")
error_handling:load()

global_variables = require("global_variables")

styles_m = require("styles/main")
styles_m:load()

signals_m = require("signals/main")
signals_m:load()

shifty_config = require("tags/shifty_config")
shifty_config:load()

menu_m = require("menus/main")
menu_m:load()

panels_m = require("panels/main")
panels_m:load(global_variables.layouts, menu_m.mainlauncher)
shifty.taglist = panels_m.taglist

bindings_m = require("bindings/main")
bindings_m:load(menu_m.mainmenu, panels_m.promptbox)
shifty.config.globalkeys = bindings_m.globalkeys
shifty.config.clientkeys = bindings_m.clientkeys

rules_m = require("rules/main")
rules_m:load(bindings_m.clientkeys, bindings_m.clientbuttons)

awful.util.spawn_with_shell("run_once nm-applet")
awful.util.spawn_with_shell("run_once udisks-glue")
