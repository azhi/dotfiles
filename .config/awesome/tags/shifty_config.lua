local shifty_config = {}

local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local shifty = require("lib/shifty")

function shifty_config:load()
  local l = awful.layout.suit
  shifty.config.tags = {
    ["1:term"] = {
        icon_only = true,
        icon = beautiful.tags_term,
        init = true,
        exclusive = true,
        spawn = "run_once urxvt",
        layout = l.fair.horizontal,
        max_clients = 5,
        position = 1,
    },
    ["2:www"] = {
        icon_only = true,
        icon = beautiful.tags_inet,
        exclusive = true,
        spawn = "run_once chromium",
        layout = l.magnifier,
        max_clients = 1,
        position = 2,
    },
    ["3:skype"] = {
        icon_only = true,
        icon = beautiful.tags_skype,
        init = true,
        exclusive = true,
        spawn = "run_once skype",
        layout = l.tile,
        mwfact = 0.5,
        position = 3,
    },
    ["4:fs"] = {
        icon_only = true,
        icon = beautiful.tags_fm,
        spawn = "run_once doublecmd",
        layout = l.magnifier,
        position = 4,
    },
    ["5:gvim"] = {
        icon_only = true,
        icon = beautiful.tags_gvim,
        spawn = "run_once gvim",
        layout = l.magnifier,
        position = 5,
    },
    ["6:docs"] = {
        icon_only = true,
        icon = beautiful.tags_doc,
        layout = l.tile,
        position = 6,
    },
    ["7:vm"] = {
        icon_only = true,
        icon = beautiful.tags_vm,
        spawn = "run_once virtualbox",
        layout = l.tile,
        position = 7,
    },
    ["8:test"] = {
        icon_only = true,
        icon = beautiful.tags_other,
        layout = l.tile,
        position = 8,
    },
    ["music"] = {
        icon_only = true,
        icon = beautiful.tags_music,
        layout = l.magnifier,
    },
    ["torrent"] = {
        icon_only = true,
        icon = beautiful.tags_torrent,
        layout = l.magnifier,
    }
  }

  shifty.config.apps = {
    {match = {"URxvt"}, tag = "1:term"},
    {match = {"Iceweasel.*", "Firefox.*", "Chromium.*", "Chrome.*"}, tag = "2:www"},
    {match = {"Skype"}, tag = "3:skype"},
    -- double commander dialogs
    {match = {class={"Doublecmd"}}, float = true, run = function (c) awful.placement.centered(c,nil) end },
    -- double commander main window
    {match = {name={"Double Commander"}}, float = false, tag = "4:fs"},
    {match = {"Gvim"}, tag = "5:gvim"},
    {match = {"libreoffice", "Okular"}, tag = "6:docs"},
    {match = {"Clementine"}, tag = "music"},
    {match = {"Qbittorrent"}, tag = "torrent"},
    {match = {"Virtualbox"}, tag = "7:vm"},

    { match = {"MPlayer", "Gimp"}, float = true },
    { match = {"Kshutdown", "polkit-kde-authentication-agent-1", "Pinentry-qt4", "Ksnapshot"}, float = true, intrusive = true, run = function (c) awful.placement.centered(c,nil) end },
    { match = {"Keepassx"}, float = true, intrusive = true, run = function (c)
      local g = c:geometry()
      g.width = 700
      g.height = 500
      c:geometry(g)
      awful.placement.centered(c,nil)
    end},
    { match = {"Kmix"}, float = true, intrusive = true, run = function (c)
      local g = c:geometry()
      local w = screen[c.screen].workarea
      g.width = 500
      g.height = 300
      g.x = w.width - g.width + w.x
      g.y = w.y
      c:geometry(g)
    end },
    { rule = { type = "dialog" }, float = true, run = function (c) awful.placement.centered(c,nil) end },
  }

  shifty.config.defaults = {
    layout = l.floating,
    run = function(tag) naughty.notify({text = tag.name}) end,
  }

  shifty.init()
end

return shifty_config
