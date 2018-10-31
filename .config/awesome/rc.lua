-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
--MyChanges
local lain = require("lain")

--MyChanges Offtopic:
-- If I need to debug something: naughty.notify { text = debug.traceback(), timeout = 0 }

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
--beautiful.init(awful.util.get_themes_dir() .. "default/theme.lua")
beautiful.init("~/.config/awesome/themes/zenburn/theme.lua")  --MyChanges

-- This is used later as the default terminal and editor to run.
if gears.filesystem.file_readable("/usr/bin/sakura") then --MyChanges
   terminal = "sakura"
else
   terminal = "xterm"
end
editor = os.getenv("EDITOR") or "emacsclient -c -n --alternate-editor=\"\"" --MyChanges
editor_cmd = terminal .. " -e " .. editor
homedir = os.getenv("HOME") --MyChanges

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
    lain.layout.monitor, --MyChanges
    lain.layout.centerwork.horizontal,  --MyChanges
    lain.layout.centerwork, -- lain.layout.centerworkd,  --MyChanges
    lain.layout.termfair,    --MyChanges
    lain.layout.chat --MyChanges
}
lain.layout.termfair.nmaster = 3 --MyChanges
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
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end }
}

--MyChanges -- TODO only add entry if executable exists
mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                             { "open terminal", terminal },
                             { "Filebrowser", "pcmanfm", "/usr/share/icons/hicolor/48x48/devices/blueman-desktop.png" },
			     { "Emacs", editor, "/usr/share/icons/hicolor/48x48/apps/emacs.png" },
			     { "Firefox", "firefox", "/usr/share/icons/hicolor/48x48/apps/firefox.png" },
			     { "Thunderbird", "thunderbird", "/usr/share/icons/hicolor/48x48/apps/thunderbird.png" },
                             { "WhatsApp", "whatsapp-web-desktop", "/opt/whatsapp-web/resources/app/icon.png" },
                             { "Signal", "signal-desktop", "/usr/share/icons/hicolor/48x48/apps/signal-desktop.png" },
			     { "Teamspeak", "teamspeak3", "/usr/share/icons/hicolor/48x48/devices/blueman-headset.png" },
                             { "Music Player", "quodlibet", "/usr/share/icons/hicolor/48x48/apps/quodlibet.png"},
                             { "Chromium", "chromium", "/usr/share/icons/hicolor/48x48/apps/chromium.png"},
			     { "Bluetooth", "blueman-applet", "/usr/share/icons/hicolor/48x48/apps/blueman.png"},
			     { "Soundcontrol", "pavucontrol"},
			     { "cancel", "" },
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
app_folders = { "/usr/share/applications/", "~/.local/share/applications/" } --MyChanges (*.desktop files require a valid "Categories=[...]" entry (see https://standards.freedesktop.org/menu-spec/latest/apa.html).)
-- }}}

-- Keyboard map indicator and switcher
--mykeyboardlayout = awful.widget.keyboardlayout() --MyChanges (commented out, didn't work)
--MyChanges
kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
-- Special Settings
kbdcfg.iso_key_to_multi = ";xmodmap -e \"keycode 94 = Multi_key Multi_key Multi_key Multi_key Multi_key Multi_key\""
kbdcfg.swap_plus_grave  = ";xmodmap -e \"keycode 49 = equal plus equal plus multiply division\";xmodmap -e \"keycode 21 = grave asciitilde grave asciitilde dead_tilde asciitilde\""
kbdcfg.menu_to_alt      = ";xmodmap -e \"keycode 135 = Alt_L\""
kbdcfg.ivrit            = ";xmodmap ~/.dotfiles/miqledet_ivrit_xmodemap"
if os.getenv("DESKTOP") then
   kbdcfg.post_apply_function = kbdcfg.iso_key_to_multi
elseif os.getenv("LAPTOP") then
   kbdcfg.post_apply_function = kbdcfg.iso_key_to_multi .. kbdcfg.swap_plus_grave .. kbdcfg.menu_to_alt
else -- os.getenv("DESKTOP_WORK")
   kbdcfg.post_apply_function = kbdcfg.iso_key_to_multi .. kbdcfg.swap_plus_grave
end
-- {keymap, variante, GUI-Name, POST-Settings},
kbdcfg.keymap = {
   { "us", "altgr-intl", "USA",                       kbdcfg.post_apply_function},
   { "us", "colemak" , "Colemak",           kbdcfg.post_apply_function},
   { "us", "colemak" , "Hebrew (Colemak)",  kbdcfg.post_apply_function .. kbdcfg.ivrit},
   { "de", "", "Deutsch", "", ""}
}
kbdcfg.current = 1
kbdcfg.widget = wibox.widget.textbox()
kbdcfg.widget:set_text(" " .. kbdcfg.keymap[kbdcfg.current][3] .. " ")
kbdcfg.switch = function (increment)
  kbdcfg.current = (kbdcfg.current + increment - 1) % #(kbdcfg.keymap) + 1
  
  if kbdcfg.current <= 0 then
     kbdcfg.current = #(kbdcfg.keymap)
  end
  
  local t = kbdcfg.keymap[kbdcfg.current]
  kbdcfg.widget:set_text(" " .. t[3] .. " ")
  os.execute( kbdcfg.cmd .. " " .. t[1] .. " " .. t[2] .. ";setxkbmap -option ctrl:nocaps" .. t[4] )
end

kbdcfg.widget:buttons(
   awful.util.table.join(awful.button({ }, 1, function () kbdcfg.switch(1) end),
                         awful.button({ }, 3, function () kbdcfg.switch(-1) end))
)

--MyChanges
-- A very stupid way to have a simple button to close emacs.
emacsd = {}
emacsd.emacs = "emacsclient -c -n --alternate-editor=\"\""
emacsd.commands = { function () awful.util.spawn_with_shell(emacsd.emacs .. " -e \"(org-agenda nil \\\"a\\\")\"") end,
   function () awful.util.spawn_with_shell(emacsd.emacs .. " -e \"(org-agenda nil \\\"u\\\")\"") end,  -- 'u' is a custom command for unfinished unscheduled tasks (that also have no deadline). In other words, show stuff I want to do when I have time
   function () awful.util.spawn_with_shell("emacsclient -c -e \"(save-buffers-kill-emacs)\"") end
}
emacsd.sync = {}
emacsd.sync.ip   = "192.168."
emacsd.sync.port = "2222"
emacsd.menu = awful.menu({ items = {
                              { "Show Agenda", emacsd.commands[1] },
                              { "Unscheduled TODOs", emacsd.commands[2] },
                              { "Stop Emacs server", emacsd.commands[3] },
                              { "Sync with ...",
                                {
                                   { "Android", terminal .. " -e " .. homedir .. "/Documents/org/0sync_with_android.sh" },
                                   { "home computers", terminal .. " -e " .. homedir .. "/Documents/org/0sync_with_home_computers.sh" },
                                   { "ip",
                                     function()
                                        awful.prompt.run {
                                           prompt       = '<b>IP: </b>',
                                           text         = emacsd.sync.ip,
                                           bg_cursor    = '#ff0000',
                                           textbox      = mouse.screen.mypromptbox.widget,
                                           exe_callback = function(input)
                                              if not input or #input == 0 then return end
                                              emacsd.sync.ip = input

                                              awful.prompt.run {
                                                 prompt       = '<b>Port: </b>',
                                                 text         = emacsd.sync.port,
                                                 bg_cursor    = '#ff0000',
                                                 textbox      = mouse.screen.mypromptbox.widget,
                                                 exe_callback = function(input)
                                                    if not input or #input == 0 then return end
                                                    emacsd.sync.port = input
                                                    awful.util.spawn_with_shell(terminal .. " -e env syncAddress=" .. emacsd.sync.ip .. " syncPort=" .. emacsd.sync.port .. " " .. homedir .. "/Documents/org/0sync_with_android.sh")
                                                 end
                                              }
                                           end
                                        }
                                     end
                                   }
                                   -- { "workplace computer", terminal .. " -e " .. homedir .. "/Documents/org/0sync_with_workplace_computer.sh" },
                                }, "/usr/share/icons/hicolor/48x48/apps/knetattach.png"
                              },
                              { "cancel", "" }}, theme = {width=150}})
emacsd.widget = awful.widget.launcher({ image = "/usr/share/icons/hicolor/16x16/apps/emacs.png",
                                        menu = emacsd.menu})


-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

--MyChanges Logic
-- http://stackoverflow.com/questions/11117440/is-it-possible-to-emulate-bind-in-lua
function bind(f,...)
   local args={...}
   return function(...) return f(unpack(args),...) end
end

--MyChanges
myTitlebarToggleFunction = function(toggle)
   if toggle then
      myTitlebarToggle.checkbox.checked = not myTitlebarToggle.checkbox.checked
   end
   
   for _, c in ipairs(client.get()) do
      c.titlebars_enabled = myTitlebarToggle.checkbox.checked
      if c.titlebars_enabled then
         c:emit_signal("request::titlebars")
      else
         --awful.titlebar.toggle(c)
         awful.titlebar.hide(c)
      end
   end
end

myTitlebarToggle = wibox.layout {
   {
      id      = "checkbox",
      checked = false,
      widget  = wibox.widget.checkbox
   },
   {
      id      = "textbox",
      text    = "Titlebar",
      widget  = wibox.widget.textbox
   },
   layout     = wibox.layout.fixed.horizontal
}
myTitlebarToggle:buttons(awful.util.table.join(awful.button({ }, 1, bind(myTitlebarToggleFunction, true))))


-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
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

local tasklist_buttons = awful.util.table.join(
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

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
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
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            --mykeyboardlayout, --MyChanges
            wibox.widget.systray(),
            emacsd.widget, --MyChanges
            mytextclock,
            myTitlebarToggle, --MyChanges
            kbdcfg.widget, --MyChanges
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

--    awful.key({ modkey,           }, "e", --MyChanges Colemak
    awful.key({ modkey,           }, "k", --MyChanges
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
--    awful.key({ modkey,           }, "u", --MyChanges Colemak
    awful.key({ modkey,           }, "i", --MyChanges
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
--    awful.key({ modkey, "Shift"   }, "e", function () awful.client.swap.byidx(  1)    end, --MyChanges Colemak
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx(  1)    end, --MyChanges
              {description = "swap with next client by index", group = "client"}),
--    awful.key({ modkey, "Shift"   }, "u", function () awful.client.swap.byidx( -1)    end, --MyChanges Colemak
    awful.key({ modkey, "Shift"   }, "i", function () awful.client.swap.byidx( -1)    end, --MyChanges
              {description = "swap with previous client by index", group = "client"}),
--    awful.key({ modkey, "Control" }, "e", function () awful.screen.focus_relative( 1) end, --MyChanges Colemak
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative( 1) end, --MyChanges
              {description = "focus the next screen", group = "screen"}),
--    awful.key({ modkey, "Control" }, "u", function () awful.screen.focus_relative(-1) end, --MyChanges Colemak
    awful.key({ modkey, "Control" }, "i", function () awful.screen.focus_relative(-1) end, --MyChanges
              {description = "focus the previous screen", group = "screen"}),
--    awful.key({ modkey,           }, "l", awful.client.urgent.jumpto, --MyChanges Colemak
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto, --MyChanges
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

--    awful.key({ modkey,           }, "i",     function () awful.tag.incmwfact( 0.05)          end, --MyChanges Colemak
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end, --MyChanges
              {description = "increase master width factor", group = "layout"}),
--    awful.key({ modkey,           }, "n",     function () awful.tag.incmwfact(-0.05)          end, --MyChanges Colemak
    awful.key({ modkey,           }, "j",     function () awful.tag.incmwfact(-0.05)          end, --MyChanges
              {description = "decrease master width factor", group = "layout"}),
--    awful.key({ modkey, "Shift"   }, "n",     function () awful.tag.incnmaster( 1, nil, true) end, --MyChanges Colemak
    awful.key({ modkey, "Shift"   }, "j",     function () awful.tag.incnmaster( 1, nil, true) end, --MyChanges
              {description = "increase the number of master clients", group = "layout"}),
--    awful.key({ modkey, "Shift"   }, "i",     function () awful.tag.incnmaster(-1, nil, true) end, --MyChanges Colemak
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end, --MyChanges
              {description = "decrease the number of master clients", group = "layout"}),
--    awful.key({ modkey, "Control" }, "n",     function () awful.tag.incncol( 1, nil, true)    end, --MyChanges Colemak
    awful.key({ modkey, "Control" }, "j",     function () awful.tag.incncol( 1, nil, true)    end, --MyChanges
              {description = "increase the number of columns", group = "layout"}),
--    awful.key({ modkey, "Control" }, "i",     function () awful.tag.incncol(-1, nil, true)    end, --MyChanges Colemak
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end, --MyChanges
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "b", --MyChanges
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
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
       {description = "show the menubar", group = "launcher"}),

    --MyChanges Custom Stuff
    --MyChanges (Multimedia Keys)
    awful.key({ }, "XF86AudioRaiseVolume",     function () awful.util.spawn_with_shell("~/Applications/Scripts/pa_change_stream_volume.sh 5 +") end, {description = "Raise Volume", group = "Sound Control"}),
    awful.key({ }, "XF86AudioLowerVolume",     function () awful.util.spawn_with_shell("~/Applications/Scripts/pa_change_stream_volume.sh 5 -") end, {description = "Lower Volume", group = "Sound Control"}),
    awful.key({ }, "XF86AudioMute",            function () awful.util.spawn_with_shell("amixer -D pulse set Master Playback Switch toggle") end, {description = "Mute Sound", group = "Sound Control"}),
    awful.key({ }, "XF86Tools",                function () awful.util.spawn_with_shell("~/Applications/Scripts/runOnce.sh quodlibet") end, {description = "Start Mediaplayer", group = "Sound Control"}),
    awful.key({ modkey,         }, "XF86AudioPlay",     function () awful.util.spawn_with_shell("pactl set-default-sink webstream_sink") end, {description = "Set default soundcard output to game recording.", group = "Sound Control"}),
    awful.key({ modkey, "Shift" }, "XF86AudioPlay",     function () awful.util.spawn_with_shell("pactl set-default-sink combined") end, {description = "Set default soundcard output to default.", group = "Sound Control"}),
    
    --MyChanges (Special Keys)
    awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'") end, {description = "Make Screenshot", group = "Utility"}),
    awful.key({ modkey, }, "Print", function () awful.util.spawn("scrot -u -e 'mv $f ~/screenshots/ 2>/dev/null'") end, {description = "Make Screenshot of current window", group = "Utility"}),
    awful.key({ }, "XF86MonBrightnessUp",     function () awful.util.spawn_with_shell("xbacklight -inc 10")    end, {description = "Increase Background Light", group = "Utility"}),
    awful.key({ }, "XF86MonBrightnessDown",   function () awful.util.spawn_with_shell("xbacklight -dec 10")    end, {description = "Decrease Background Light", group = "Utility"}),
    awful.key({ modkey, "Control", "Shift" }, "l",     function () awful.util.spawn_with_shell("xscreensaver-command -lock")    end, {description = "Lock system", group = "Utility"}),

    --MyChanges (Keycombos)
    awful.key({ modkey,           }, ".",     function () kbdcfg.switch(1)  end, {description = "Next Keyboard Layout", group = "Utility"}),
    awful.key({ modkey, "Shift"   }, ".",     function () kbdcfg.switch(-1) end, {description = "Previous Keyboard Layout", group = "Utility"})
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to next screen", group = "client"}), --MyChanges (Description)
    awful.key({ modkey, "Shift"   }, "o",      function(c) c:move_to_screen(c.screen.index-1)end,  --MyChanges
              {description = "move to other screen", group = "client"}), --MyChanges (Description)
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "b",  --MyChanges
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
        {description = "maximize", group = "client"}),
    --MyChanges
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "maximize vertical", group = "client"}),
    --MyChanges
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "maximize horizontal", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

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

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
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
           "Ediff",
           "urn",
           "xsensors"
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, callback = bind(myTitlebarToggleFunction, false) --MyChanges (no longer a property)
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },

    { rule = { name = "Steam Keyboard" }, --MyChanges
      properties = { floating = true,
                     ontop = true,
                     focus = false,
                     focusable = false} },
    { rule = { class = "Emacs" },
     properties = { size_hints_honor = false } }, --MyChanges
}
-- }}}

-- {{{ Signals
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
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if not myTitlebarToggle.checkbox.checked then --MyChanges
       if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
          and awful.client.focus.filter(c) then
          client.focus = c
       end
    end --MyChanges

    --MyChanges
    if (c.name=="Steam Keyboard") then
       c:connect_signal("focus",function(c)
			   local otherClient = awful.client.focus.history.get(mouse.screen,0)
			   if otherClient ~= nil then
			      if otherClient.name ~= "Steam Keyboard" then
				 client.focus = otherClient
				 otherClient:raise()
			      else
				 local anotherClient = awful.client.focus.history.get(mouse.screen,1)
				 if anotherClient ~= nil then
				    if anotherClient.name ~= "Steam Keyboard" then
				       client.focus = anotherClient
				       anotherClient:raise()
				    end
				 end
			      end
			   end
       end)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

--MyChanges
-- Apply correct keyboad layout
kbdcfg.switch(0)
awful.util.spawn_with_shell("numlockx on")

-- Settings
-- Font
if os.getenv("DESKTOP") or os.getenv("DESKTOP") or true then -- high dpi systems.
   awful.util.spawn_with_shell("xrdb -merge ~/.Xresources")
end

-- Autorun/Autostart
awful.util.spawn_with_shell("~/Applications/Scripts/runOnceSearchTerm.sh emojione-picker ~/Applications/emojione-picker-ubuntu-master/emojione-picker")
awful.util.spawn_with_shell("~/Applications/Scripts/runOnceSearchTerm.sh multiload-ng multiload-ng-systray")
awful.util.spawn_with_shell("~/Applications/Scripts/runOnce.sh parcellite") -- alternative clipit
awful.util.spawn_with_shell("~/Applications/Scripts/runOnce.sh nm-applet")
awful.util.spawn_with_shell("~/Applications/Scripts/runOnceSearchTerm.sh alarm-clock alarm-clock-applet --hidden")
if os.getenv("LAPTOP") then
   awful.util.spawn_with_shell("~/Applications/Scripts/runOnce.sh cbatticon")
end
if os.getenv("LAPTOP") or os.getenv("DESKTOP_WORK") then
   awful.util.spawn_with_shell("~/Applications/Scripts/runOnce.sh xscreensaver")
end
if os.getenv("LAPTOP") or os.getenv("DESKTOP") then
   awful.util.spawn_with_shell("~/Applications/Scripts/runOnceSearchTerm.sh emacs emacs --daemon")
end
-- Audio Output as Input / "Virtual Audio Cable"
if os.getenv("PA_SINKNAME") and os.getenv("PA_SINKRATE") then  -- pactl list | grep Sink -A 5
   local pa_sinkname = os.getenv("PA_SINKNAME")
   pa_sinkname = pa_sinkname:gsub("\n", "")
   pa_sinkname = pa_sinkname:gsub("\\", "")
   pa_sinkname = pa_sinkname:gsub(";", "")
   
   local pa_sinkrate = os.getenv("PA_SINKRATE")
   pa_sinkrate = pa_sinkrate:gsub("\n", "")
   pa_sinkrate = pa_sinkrate:gsub("\\", "")
   pa_sinkrate = pa_sinkrate:gsub(";", "")

   awful.util.spawn_with_shell("(pactl list | grep web_stream) || (pactl load-module module-null-sink sink_name=\"webstream_sink\" sink_properties=device.description=\"web_stream\" && pactl load-module module-loopback source=webstream_sink.monitor sink=" .. pa_sinkname .. " rate=" .. pa_sinkrate .. ")")
   awful.util.spawn_with_shell("(pactl list | grep soundboard_stream) || (pactl load-module module-null-sink sink_name=\"soundboardstream_sink\" sink_properties=device.description=\"soundboard_stream\" && pactl load-module module-loopback source=soundboardstream_sink.monitor sink=" .. pa_sinkname .. " rate=" .. pa_sinkrate .. ")")

   if os.getenv("PA_MICROPHONE") then
      local pa_microphone = os.getenv("PA_MICROPHONE")
      pa_sinkrate = pa_sinkrate:gsub("\n", "")
      pa_sinkrate = pa_sinkrate:gsub("\\", "")
      pa_sinkrate = pa_sinkrate:gsub(";", "")

      awful.util.spawn_with_shell("(pactl list | grep mixed_audio) || (pactl load-module module-null-sink sink_name=\"mixed_audio\" sink_properties=device.description=\"mixed_audio_stream\" &&\
                                                                       pactl load-module module-loopback source=soundboardstream_sink.monitor sink=mixed_audio &&\
                                                                       pactl load-module module-loopback source=" .. pa_microphone .. " sink=mixed_audio)")
   end
end

