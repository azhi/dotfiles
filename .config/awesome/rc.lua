-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

package.path = package.path .. ';' .. awful.util.getdir("config") .. '/vendor/?.lua;' ..
  awful.util.getdir("config") .. '/vendor/?/init.lua'

local tyrannical = require("tyrannical")
local conky = require("conky")

local function run_once(spawn_cmd, name)
  name = name or spawn_cmd
  awful.spawn.with_shell("ps -ef | grep -v grep | grep '" .. name .. "' > /dev/null || (" .. spawn_cmd .. ")")
end

hostname = ""
awful.spawn.easy_async("hostname", function(stdout, _stderr, _reason, exit_code)
  if exit_code == 0 then
    hostname = stdout:sub(1, -2)
    naughty.notify { text = hostname }
  end
end)

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal to run.
terminal = "urxvt"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

local rebootintomenu = nil
local rebootintoconffile = io.open(gears.filesystem.get_configuration_dir() .. "rebootinto.conf", "r")
if rebootintoconffile then
  rebootintomenu = {}

  while true do
    local line = rebootintoconffile:read("*line")
    if line == nil then break end
    if line:sub(1, 1) ~= "#" then
      local name, efi_num = line:match("^(.+),(.+)$")
      table.insert(rebootintomenu, { name, "bash -c 'sudo efibootmgr -n " .. efi_num .. " && systemctl reboot'" })
    end
  end
  rebootintoconffile:close()
end

local shutdownmenuitems = { { "shutdown", "systemctl poweroff" },
                            { "reboot", "systemctl reboot" },
                            { "lock", "dm-tool lock" },
                            { "sleep", "systemctl suspend" }
                          }
if rebootintomenu then
  table.insert(shutdownmenuitems, 3, {"reboot into", rebootintomenu})
end

shutdownmenu = awful.menu({ items = shutdownmenuitems })

shutdownlauncher = awful.widget.launcher({ image = gears.filesystem.get_configuration_dir() .. "icons/widgets/shutdown.png",
                                           menu = shutdownmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

memwarntooltip = awful.tooltip({ })

function rgb_to_hsv(hex_color)
  local r, g, b = hex_color:match("^#(%x%x)(%x%x)(%x%x)$")
  r = tonumber(r, 16) / 255
  g = tonumber(g, 16) / 255
  b = tonumber(b, 16) / 255

  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, v

  if max == min then
    h = 0
  elseif max == r then
    h = 0 + (g - b) / (max - min)
  elseif max == g then
    h = 2 + (b - r) / (max - min)
  elseif max == b then
    h = 4 + (r - g) / (max - min)
  end
  h = h * 60
  if h < 0 then
    h = h + 360
  end

  if max == 0 then
    s = 0
  else
    s = (max - min) / max
  end

  v = max

  return h, s, v
end

function hsv_to_rgb(h, s, v)
  local r, g, b
  if s == 0 then
    r, g, b = v, v, v
  else
    local hh = math.floor( h / 60 )
    local hh_offset = ( h / 60 ) - hh

    local p = v * (1 - s)
    local q = v * (1 - s * hh_offset)
    local t = v * (1 - s * (1 - hh_offset))

    if hh == 0 then
      r, g, b = v, t, p
    elseif hh == 1 then
      r, g, b = q, v, p
    elseif hh == 2 then
      r, g, b = p, v, t
    elseif hh == 3 then
      r, g, b = p, q, v
    elseif hh == 4 then
      r, g, b = t, p, v
    elseif hh == 5 then
      r, g, b = v, p, q
    end
  end

  local result = "#"
  for _, comp in ipairs({r, g, b}) do
    comp = math.floor(comp * 255)
    comp_str = string.format("%x", comp)
    if comp_str:len() == 1 then
      comp_str = "0" .. comp_str
    end
    result = result .. comp_str
  end

  return result
end

function blend_colors(color1, color2, part)
  local h1, s1, v1 = rgb_to_hsv(color1)
  local h2, s2, v2 = rgb_to_hsv(color2)

  local dh
  if h1 == 0 and (v1 == 0 or s1 == 0) then
    h1 = h2
    dh = 0
  else
    local dh_candidates = {
      h2 - h1,
      360 + h2 - h1,
      h2 - h1 - 360,
    }
    for _i, c in ipairs(dh_candidates) do
      if not dh or math.abs(c) < math.abs(dh) then
        dh = c
      end
    end
  end

  local h, s, v
  h = h1 + part * dh
  if h > 360 then
    h = h - 360
  end
  if h < 0 then
    h = h + 360
  end

  s = s1 + (s2 - s1) * part
  v = v1 + (v2 - v1) * part

  ret = hsv_to_rgb(h, s, v)

  return ret
end

memwarn = conky.widget({
  icon = gears.filesystem.get_configuration_dir() .. "icons/widgets/ram.png",
  conky = "${memeasyfree}",
  background = { bg = beautiful.bg_systray },

  updater = function(conky_update, conky_wibox, _, _, background)
    warn_color = "#c4b813"
    critical_color = "#ef000b"
    memwarntooltip:set_markup("<span size='x-large'>" .. conky_update .. "</span>")
    local freemem, suffix = conky_update:match("^([%d\\.]+)(.+)$")
    freemem = tonumber(freemem)

    -- convert freemem to megabytes
    if suffix == "G" or suffix == "GB" or suffix == "GiB" then
      freemem = freemem * 1024
    elseif suffix == "M" or suffix == "MB" or suffix == "MiB" then
      -- do nothing
    elseif suffix == "K" or suffix == "KB" or suffix == "KiB" then
      freemem = freemem / 1024
    elseif suffix == "B" then
      freemem = freemem / 1024 / 1024
    else
      naughty.notify({ preset = naughty.config.presets.critical,
                       title = "Error in conky mem widget",
                       text = "Unknown memory size suffix: " .. tostring(suffix) })
      return
    end

    local text = nil
    if freemem > 8192 then
      text = ">8G"
    elseif freemem > 5120 then
      text = ">4G"
    elseif freemem > 2048 then
      text = ">2G"
    elseif freemem > 1024 then
      text = ">1G"
    elseif freemem > 512 then
      text = ">0.5G"
    else
      log = math.log(freemem, 2)
      if log > 0 then
        lower = math.floor(2 ^ math.floor(log))
        upper = math.floor(2 ^ (math.floor(log) + 1))
        if (freemem - lower) < (upper - freemem) then
          text = tostring(lower) .. "M"
        else
          text = tostring(upper) .. "M"
        end
      else
        text = tostring(math.floor(freemem)) .. "M"
      end
    end
    conky_wibox:set_markup("<span color='white'>".. text .. "</span>")

    if freemem >= 512 and freemem < 1024 then
      background.bg = blend_colors(beautiful.bg_systray, warn_color, 1 - (freemem - 512) / 512)
    elseif freemem >= 128 and freemem < 512 then
      background.bg = blend_colors(warn_color, critical_color, 1 - (freemem - 128) / 384)
    elseif freemem < 128 then
      background.bg = critical_color
    else
      background.bg = beautiful.bg_systray
    end
  end
})

memwarntooltip:add_to_object(memwarn)

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%a %b %d, %H:%M", 10)
local month_calendar = awful.widget.calendar_popup.month({
  style_weekday = { border_width = 0 },
  style_normal = { border_width = 0 }
})
month_calendar:attach( mytextclock, "tr" )

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

function scanDir(directory)
  local i, fileList, popen = 0, {}, io.popen
  for filename in popen([[find "]] ..directory.. [[" -type f]]):lines() do
    i = i + 1
    fileList[i] = filename
  end
  return fileList
end

if os.getenv("XDG_CONFIG_HOME") then
  xdg_config_home = os.getenv("XDG_CONFIG_HOME")
else
  xdg_config_home = os.getenv("HOME") .. "/.config"
end

wallpaperList = scanDir(xdg_config_home .. "/wallpapers")
math.randomseed(os.time())
beautiful.wallpaper = wallpaperList[math.random(1, #wallpaperList)]

gears.timer {
    timeout   = 1800, -- 30 min
    autostart = true,
    callback  = function()
      beautiful.wallpaper = wallpaperList[math.random(1, #wallpaperList)]
      for s in screen do
        set_wallpaper(s)
      end
    end
}

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local tyrannical_tags = {
  {
    position    = 1,
    name        = "term",
    icon        = gears.filesystem.get_configuration_dir() .. "icons/tags/term.png",
    icon_only   = true,
    init        = false,
    exclusive   = true,
    layout      = awful.layout.suit.fair.horizontal,
    max_clients = 5,
    exec_once   = "urxvt",
    class       = { "xterm", "urxvt", "URxvt", "XTerm" },
    tyrannical  = true
  },
  {
    position    = 2,
    name        = "www",
    icon        = gears.filesystem.get_configuration_dir() .. "icons/tags/inet.png",
    icon_only   = true,
    init        = false,
    exclusive   = true,
    layout      = awful.layout.suit.max,
    exec_once   = "firefox",
    max_clients = 1,
    class       = { "Opera", "Firefox", "Chromium", "Chrome" },
    tyrannical  = true
  },
  {
    position    = 3,
    name        = "im",
    icon        = gears.filesystem.get_configuration_dir() .. "icons/tags/im.png",
    icon_only   = true,
    init        = false,
    exclusive   = true,
    layout      = awful.layout.suit.tile,
    class       = { "telegram-desktop", "TelegramDesktop", "Slack", "Weechat", "Skype" },
    tyrannical  = true
  },
  {
    position    = 4,
    name        = "fs",
    icon        = gears.filesystem.get_configuration_dir() .. "icons/tags/fm.png",
    icon_only   = true,
    init        = false,
    exclusive   = true,
    layout      = awful.layout.suit.max,
    exec_once   = "doublecmd",
    class       = { "Double Commander" },
    tyrannical  = true
  },
  {
    position    = 5,
    name        = "vim",
    icon        = gears.filesystem.get_configuration_dir() .. "icons/tags/vim.png",
    icon_only   = true,
    init        = false,
    exclusive   = true,
    layout      = awful.layout.suit.max,
    exec_once   = "nvim-gtk",
    class       = { "NeovimGtk" },
    tyrannical  = true
  },
  {
    position    = 6,
    name        = "docs",
    icon        = gears.filesystem.get_configuration_dir() .. "icons/tags/doc.png",
    icon_only   = true,
    init        = false,
    exclusive   = false,
    layout      = awful.layout.suit.max,
    instance    = { "libreoffice" },
    class       = { "Evince" },
    tyrannical  = true
  },
  {
    position    = 7,
    name        = "fallback",
    icon        = gears.filesystem.get_configuration_dir() .. "icons/tags/other.png",
    icon_only   = true,
    init        = true,
    exclusive   = false,
    layout      = awful.layout.suit.tile,
    fallback    = true,
    tyrannical  = true
  },
  {
    position    = 8,
    name        = "other",
    icon        = gears.filesystem.get_configuration_dir() .. "icons/tags/other.png",
    icon_only   = true,
    init        = false,
    exclusive   = false,
    layout      = awful.layout.suit.tile,
    tyrannical  = true
  },
  {
    position    = 9,
    keyname     = "'e'",
    keycode     = 26,
    name        = "music",
    icon        = gears.filesystem.get_configuration_dir() .. "icons/tags/music.png",
    icon_only   = true,
    init        = false,
    exclusive   = true,
    layout      = awful.layout.suit.max,
    exec_once   = "clementine",
    class       = { "Clementine" },
    tyrannical  = true
  },
  {
    position    = 10,
    keyname     = "'z'",
    keycode     = 52,
    name        = "email",
    icon        = gears.filesystem.get_configuration_dir() .. "icons/tags/email.png",
    icon_only   = true,
    init        = false,
    exclusive   = true,
    layout      = awful.layout.suit.max,
    exec_once   = "trojita",
    class       = { "trojita" },
    tyrannical  = true
  },
  {
    position    = 11,
    keyname     = "'q'",
    keycode     = 24,
    name        = "torrent",
    icon        = gears.filesystem.get_configuration_dir() .. "icons/tags/torrent.png",
    icon_only   = true,
    layout      = awful.layout.suit.max,
    init        = false,
    exclusive   = true,
    exec_once   = "qbittorrent",
    class       = { "Qbittorrent" },
    tyrannical  = true
  },
  {
    position    = 12,
    keyname     = "'d'",
    keycode     = 40,
    name        = "stats",
    icon        = gears.filesystem.get_configuration_dir() .. "icons/tags/stats.png",
    icon_only   = true,
    layout      = awful.layout.suit.max,
    init        = true,
    exclusive   = true,
    class       = { "Conky" },
    tyrannical  = true
  },
}

tyrannical.tags = tyrannical_tags

-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = { "pinentry", "Paste Special", "Xephyr", "keepassxc" }

-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = { "MPlayer", "pinentry", "Paste Special", "keepassxc" }

-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = { "Xephyr", "keepassxc" }

-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.placement = {
  keepassxc = awful.placement.centered
}

-- tyrannical.settings.block_children_focus_stealing = true
tyrannical.settings.group_children = true --Force popups/dialogs to have the same tags as the parent client

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            memwarn,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            shutdownlauncher
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ modkey }, 4, function () awful.layout.inc( 1) end),
    awful.button({ modkey }, 5, function () awful.layout.inc(-1) end)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    awful.key({ modkey,           }, "w", function() awful.screen.focused().selected_tag:delete() end,
              {description = "remove", group = "tag"}),
    awful.key({ modkey,           }, "a",
        function ()
          awful.prompt.run {
            prompt       = "New tag name: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = function(new_name)
              if not new_name or #new_name == 0 then
                return
              else
                props = {selected = true}
                if tyrannical.tags_by_name[new_name] then
                  props = tyrannical.tags_by_name[new_name]
                end
                t = awful.tag.add(new_name, props)
                t:view_only()
              end
            end
          }
        end,
        {description = "add", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    -- TODO: switch to new keygrabber when awesome 4.3 is out
    -- awful.keygrabber({
    --     keybindings = {
    --         {{'Mod1'         }, 'Tab', awful.client.focus.history.select_previous},
    --         {{'Mod1', 'Shift'}, 'Tab', awful.client.focus.history.select_next    },
    --     },
    --     -- Note that it is using the key name and not the modifier name.
    --     stop_key           = 'Alt_L',
    --     stop_event         = 'release',
    --     start_callback     = awful.client.focus.history.disable_tracking,
    --     stop_callback      = awful.client.focus.history.enable_tracking,
    --     export_keybindings = true,
    -- }),
    awful.key({ "Mod1",           }, "Tab",
        function ()
          awful.client.focus.history.disable_tracking()
          client_index = 1
          history_client = awful.client.focus.history.get(awful.screen.focused(), client_index)
          if history_client then
            client_index = client_index + 1
          else
            history_client = awful.client.focus.history.get(awful.screen.focused(), 0)
            client_index = 1
          end
          client.focus = history_client
          client.focus:raise()

          grabber = awful.keygrabber.run(function(mod, key, event)
            if key == "Alt_L" and event == "release" then
              awful.client.focus.history.add(client.focus)
              awful.client.focus.history.enable_tracking()
              awful.keygrabber.stop(grabber)
              return
            end

            if key == 'Tab' and event == "press" then
              history_client = awful.client.focus.history.get(awful.screen.focused(), client_index)
              if history_client then
                client_index = client_index + 1
              else
                history_client = awful.client.focus.history.get(awful.screen.focused(), 0)
                client_index = 1
              end
              client.focus = history_client
              client.focus:raise()
            end
          end)
        end,
        {description = "cycle clients", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = gears.filesystem.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    awful.key({ }, "Print", function () awful.spawn("flameshot gui") end),
    conky.show_key("F12")
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ "Mod1",           }, "F4",     function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey,           }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.

local function find_or_create_tyrannical_tag(name, position)
  local screen = awful.screen.focused()
  local tag = nil

  if screen.tyrannical_index then
    tags = screen.tyrannical_index[position]
    if tags and #tags > 0 then
      tag = tags[1]
      if screen.tyrannical_selected and screen.tyrannical_selected.position == position then
        screen.tyrannical_selected.relindex = screen.tyrannical_selected.relindex + 1
        if screen.tyrannical_selected.relindex > #tags then
          screen.tyrannical_selected.relindex = 1
        end

        tag = tags[screen.tyrannical_selected.relindex]
      else
        screen.tyrannical_selected.position = position
        screen.tyrannical_selected.relindex = 1
      end
    end
  end

  if not tag then
    props = tyrannical.tags_by_name[name]
    tag = awful.tag.add(props.name, props)
  end

  return tag
end

local function bind_tag_hotkeys(name, position, keyname, keycode)
  globalkeys = gears.table.join(globalkeys,
      -- View tag only.
      awful.key({ modkey }, "#" .. keycode,
                function ()
                  local tag = find_or_create_tyrannical_tag(name, position)
                  tag:view_only()
                end,
                {description = "view tag "..keyname, group = "tag"}),
      -- Move client to tag.
      awful.key({ modkey, "Control" }, "#" .. keycode,
                function ()
                  if client.focus then
                    local tag = find_or_create_tyrannical_tag(name, position)
                    client.focus:move_to_tag(tag)
                  end
                end,
                {description = "move focused client to tag "..keyname, group = "tag"}),
      -- Move client to tag and switch to his tag.
      awful.key({ modkey, "Shift" }, "#" .. keycode,
                function ()
                  if client.focus then
                    local tag = find_or_create_tyrannical_tag(name, position)
                    client.focus:move_to_tag(tag)
                    tag:view_only()
                  end
                end,
                {description = "move focused client and switch to tag "..keyname, group = "tag"}),
      -- Toggle tag on focused client.
      awful.key({ modkey, "Control", "Shift" }, "#" .. keycode,
                function ()
                  if client.focus then
                    local tag = find_or_create_tyrannical_tag(name, position)
                    client.focus:toggle_tag(tag)
                  end
                end,
                {description = "toggle focused client on tag " .. keyname, group = "tag"})
  )
end

for _, tyrannical_tag in pairs(tyrannical_tags) do
    if tyrannical_tag.position then
      bind_tag_hotkeys(tyrannical_tag.name, tyrannical_tag.position, "#" .. tyrannical_tag.position, tyrannical_tag.position + 9)
    end
    if tyrannical_tag.keycode then
      bind_tag_hotkeys(tyrannical_tag.name, tyrannical_tag.position, tyrannical_tag.keyname, tyrannical_tag.keycode)
    end
end

-- Quick run hotkeys
quick_run = {
  -- keycode, spawn_cmd, grep_name, wm_class
  {39, "keepassxc", "keepassxc", "keepassxc"} -- "s"
}
for _i, run_spec in pairs(quick_run) do
  keycode = run_spec[1]
  spawn_cmd = run_spec[2]
  grep_name = run_spec[3]
  wm_class = run_spec[4]

  globalkeys = gears.table.join(globalkeys,
    awful.key({ modkey }, "#" .. keycode,
              function ()
                local matched_client = nil
                for _, c in ipairs(client.get()) do
                  if c.class == wm_class then
                    matched_client = c
                    break
                  end
                end

                if matched_client then
                  matched_client:move_to_tag(awful.screen.focused().selected_tag)
                  client.focus = matched_client
                  matched_client:raise()
                else
                  run_once(spawn_cmd, grep_name)
                end
              end,
              {description = "spawn "..grep_name, group = "client"})
  )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

local function set_default_client_colors(c)
  if not c.colors then
    c.colors = { focus = beautiful.border_focus, unfocus = beautiful.border_normal }
  end
end

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Disable size hints for URxvt
    -- Track URxvt name (title) to change appearance when ssh'ing to something
    {
      rule = { class = "URxvt" },
      properties = { size_hints_honor = false },
      callback = function(c)
        c:connect_signal("property::name", function(c)
          matched_title = c.name:match("%w+@[%w_-]+")
          if matched_title then
            ind = matched_title:find("@")
            client_hostname = matched_title:sub(ind + 1, -1)
            if client_hostname == hostname then
              c.colors = { focus = beautiful.border_focus, unfocus = beautiful.border_normal }
              awful.titlebar(c, {titlebar_bg_focus = beautiful.bg_focus, titlebar_bg_normal = beautiful.bg_normal,
                                 titlebar_fg_focus = beautiful.fg_focus, titlebar_fg_normal = beautiful.fg_normal})
              c.border_width = beautiful.border_width
            else
              if client_hostname:find("dev") or client_hostname:find("staging") or client_hostname:find("uat") then
                c.colors = { focus = "#fce600", unfocus = "#ad9f0a" }
                awful.titlebar(c, {titlebar_bg_focus = "#fce600", titlebar_bg_normal = "#ad9f0a",
                                   titlebar_fg_focus = "#000000", titlebar_fg_normal = "#222222"})
                c.border_width = xresources.apply_dpi(3)
              else
                c.colors = { focus = "#f91313", unfocus = "#960d0d" }
                awful.titlebar(c, {titlebar_bg_focus = "#f91313", titlebar_bg_normal = "#960d0d",
                                   titlebar_fg_focus = beautiful.fg_focus, titlebar_fg_normal = beautiful.fg_normal})
                c.border_width = xresources.apply_dpi(3)
              end
            end

            if client.focus == c then
              c.border_color = c.colors.focus
            else
              c.border_color = c.colors.unfocus
            end
          end
        end)
      end
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "keepassxc",
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
    conky.rules()
}
-- }}}

-- {{{ Signals
awful.tag.attached_connect_signal(nil, "property::selected", function (t)
  if t.tyrannical and t.selected then
    t.screen.tyrannical_index = t.screen.tyrannical_index or {}
    t.screen.tyrannical_index[t.position] = t.screen.tyrannical_index[t.position] or {}
    t.screen.tyrannical_selected = t.screen.tyrannical_selected or {}
    t.screen.tyrannical_selected.position = t.position
    if not t.tyrannical_indexed then
      table.insert(t.screen.tyrannical_index[t.position], t)
      t.screen.tyrannical_selected.relindex = #t.screen.tyrannical_index[t.position]

      local index = 0
      local position = nil
      repeat
        index = index + 1
        position = t.screen.tags and t.screen.tags[index] and t.screen.tags[index].position or 999
      until position >= t.position
      while position == t.position do
        index = index + 1
        position = t.screen.tags and t.screen.tags[index] and t.screen.tags[index].position or 999
      end
      t.index = index

      t.tyrannical_screen = t.screen
      t.tyrannical_indexed = true
    else
      local relindex = 1
      for ind, tag in pairs(t.screen.tyrannical_index[t.position]) do
        if tag == t then
          relindex = ind
          break
        end
      end
      t.screen.tyrannical_selected.relindex = relindex
    end
  end
end)

local function filter_inplace(arr, func)
  local new_index = 1
  local size_orig = #arr
  for old_index, v in ipairs(arr) do
    if func(v, old_index) then
      arr[new_index] = v
      new_index = new_index + 1
    end
  end
  for i = new_index, size_orig do arr[i] = nil end
end

awful.tag.attached_connect_signal(nil, "property::activated", function (t)
  if t.tyrannical_indexed and not t.activated then
    filter_inplace(t.tyrannical_screen.tyrannical_index[t.position], function(tag, _ind)
      return tag ~= t
    end)
  end
end)


-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
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

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.minimizebutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

client.connect_signal("focus", function(c) set_default_client_colors(c); c.border_color = c.colors.focus end)
client.connect_signal("unfocus", function(c) set_default_client_colors(c); c.border_color = c.colors.unfocus end)
-- }}}
