-- Awesome rc.conf configuration file.
-- Last change: Thu, 03 Mar 2011 21:27:08 +0100
--
-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")

-- Theme handling library
require("beautiful")

-- Notification library
require("naughty")

-- Keybinding documentation library (see http://awesome.naquadah.org/wiki/Document_keybindings).
require("keydoc")

-- Quake-like dropdown terminal.
scratch = require("scratch")
function dropdown(c)
  scratch.drop(c)
  root.fake_input('motion_notify', false, 500, 150)
end

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/default/theme.lua")
--theme.font = "sans 8"

-- Run the autostart.sh file.
io.popen("bash " .. awful.util.getdir("config") .. "/autostart.sh")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
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
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
  names =  {'main',    'im',       'vim',      'www',       'office',
            6,          7,          8,          9,          10,
            11,         12,         13,         14,         15},
  layout = {layouts[2], layouts[2], layouts[2], layouts[2], layouts[2],
            layouts[2], layouts[2], layouts[2], layouts[2], layouts[2],
            layouts[2], layouts[2], layouts[2], layouts[2], layouts[2]}
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
  { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
  { "restart", awesome.restart },
  { "quit", awesome.quit }
}

mymainmenu = awful.menu({ 
  items = { 
    { "awesome", myawesomemenu, beautiful.awesome_icon },
  }
})

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
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
    keydoc.group("Global"),
    awful.key({ modkey,           }, "F1",     keydoc.display,
              "This screen"),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end,
              "Show main menu"),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              "Restart awesome"),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              "Quit awesome"),

    keydoc.group("Windows"),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              "Focus urgent"),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end,
        "Focus next"),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end,
        "Focus previous"),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              "Swap with next"),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              "Swap with previous"),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end,
              "Grow current"),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end,
              "Shrink current"),

    keydoc.group("Tags"),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              "View next"),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              "View previous"),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              "View last visited"),

    keydoc.group("Screens"),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              "Focus to the left"),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              "Focus to the right"),

    keydoc.group("Layout"),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end,
              "Next"),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end,
              "Previous"),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end,
              "???"),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end,
              "???"),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end,
              "???"),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end,
              "???"),

    keydoc.group("Programs"),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end,
              "Open terminal"),
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end,
              "Run program"),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end,
              "Run lua code"),

    -- Quake terminal.
    awful.key({ modkey }, "`",                function() dropdown(terminal .. ' -w "screen -xRR top"') end,
              "Toggle dropdown terminal"),

    -- Android keyboard.
    awful.key({ modkey }, "Tab",              function() dropdown('xterm -e android-type') end,
              "Toggle android-type")

    -- Multimedia keys.
    --awful.key({}, "XF86AudioRaiseVolume",     function() 
    --awful.key({}, "XF86AudioLowerVolume",     function()
    --awful.key({}, "XF86AudioPrev",            function()
    --awful.key({}, "XF86AudioNext",            function()
    --awful.key({}, "XF86AudioStop",            function()
)

clientkeys = awful.util.table.join(
    keydoc.group("Windows"),
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end,
              "Full screen"),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
              "Floating"),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              "On top"),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end,
              "Minimize"),
    awful.key({ modkey,           }, "m",
        function (c)
            c.mDaximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end,
        "MaximizDe"),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              "Kill"),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              "Make master window"),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen,
              "MovDe to next screen"),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end,
              "Redraw")
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    --{ rule_any = { class = { "MPlayer", "gimp", "transmission", "pidgin", "openoffice.org" } },
    --  properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
