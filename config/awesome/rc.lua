-- Awesome rc.conf configuration file.
-- Last change: Thu, 10 Oct 2013 22:44:14 +0200

-- {{{ Libraries
-- Standard awesome library
awful = require('awful')
awful.autofocus = require('awful.autofocus')
awful.rules = require('awful.rules')

-- Widgets and toolbar.
wibox = require('wibox')

-- Theme handling library
beautiful = require('beautiful')

-- Notification library
naughy = require('naughty')

-- Keybinding documentation library (see http://awesome.naquadah.org/wiki/Document_keybindings).
keydoc = require('keydoc')

-- Sharetags library (see http://awesome.naquadah.org/wiki/Shared_tags).
-- sharetags = require('sharetags')

-- Quake-like dropdown terminal.
scratch = require('scratch')
-- }}}

-- {{{ Error handling
-- Startup errors.
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = 'Oops, there were errors during startup!',
                     text = awesome.startup_errors })
end

-- Runtime errors.
do
    local in_error = false
    awesome.connect_signal('debug::error', function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = 'Oops, an error happened!',
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Setup
-- Themes define colours, icons, and wallpapers
beautiful.init('/usr/share/awesome/themes/default/theme.lua')

-- Run the autostart.sh file.
io.popen('bash ' .. awful.util.getdir('config') .. '/autostart.sh')

-- This is used later as the default terminal and editor to run.
terminal = 'urxvt'
terminal_run = terminal .. ' -e '
editor = os.getenv('EDITOR') or 'vim'
editor_cmd = terminal_run .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = 'Mod4'

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tagconfig = {
    'spot',
    'irc',
    {'skype', awful.layout.suit.tile},
    'ts',
    'web',
    1, 2, 3, 4, 5, 6, 7, 8, 9
}
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    local names = {}
    local layouts = {}
    for _, data in pairs(tagconfig)
    do
        if type(data) == 'table' then
            table.insert(names, data[1])
            table.insert(layouts, data[2])
        else
            table.insert(names, data)
            table.insert(layouts, awful.layout.suit.max)
        end
    end
    tags[s] = awful.tag(names, s, layouts)
end
-- }}}

-- {{{ Menu
menu = {}

-- Create the awesome submenu.
menu.awesome = {
    { 'edit config', editor_cmd .. ' ' .. awful.util.getdir('config') .. '/rc.lua' },
    { 'restart', awesome.restart },
    { 'quit', awesome.quit }
}

-- Create the main menu.
menu.main = awful.menu({ 
    items = { 
        { 'awesome', menu.awesome, beautiful.awesome_icon },
        { 'open terminal', function() awful.util.spawn(terminal) end },
        { 'kill X', function() awful.util.spawn('pkill X') end }
    }
})
-- }}}

-- {{{ Widgets
widgets = {}

-- Menu.
widgets.menu = awful.widget.launcher({ image = beautiful.awesome_icon,
                                       menu = menu.main })

-- Tags.
widgets.tags = {}
tagbuttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
)
for s = 1, screen.count() do
    widgets.tags[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, tagbuttons)
end

-- Prompt.
widgets.prompts = {}
for s = 1, screen.count() do
    widgets.prompts[s] = awful.widget.prompt()
end

-- Tasks.
widgets.tasks = {}
taskbuttons = awful.util.table.join(
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
    end)
)
for s = 1, screen.count() do
    widgets.tasks[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, taskbuttons)
end

-- Systray.
widgets.tray = wibox.widget.systray()

-- Clock.
widgets.clock = awful.widget.textclock()

-- Layout.
widgets.layouts = {}
for s = 1, screen.count() do
    widgets.layouts[s] = awful.widget.layoutbox(s)
    widgets.layouts[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    ))
end
-- }}}

-- {{{ Wibox.
wiboxes = {}

for s = 1, screen.count() do
    -- Create the wibox.
    wiboxes[s] = awful.wibox({ position = 'top', screen = s })

    -- Left side.
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(widgets.menu)
    left_layout:add(widgets.tags[s])
    left_layout:add(widgets.prompts[s])

    -- Right side.
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then
        right_layout:add(widgets.tray)
    end
    right_layout:add(widgets.clock)
    right_layout:add(widgets.layouts[s])

    -- Bring it together
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(widgets.tasks[s])
    layout:set_right(right_layout)

    wiboxes[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () menu.main:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    keydoc.group('Global'),
    awful.key({ modkey,           }, 'F1',     keydoc.display,
              'This screen'),
    awful.key({ modkey,           }, 'w', function () menu.main:show({keygrabber=true}) end,
              'Show main menu'),
    awful.key({ modkey, 'Control' }, 'r', awesome.restart,
              'Restart awesome'),
    awful.key({ modkey, 'Shift'   }, 'q', awesome.quit,
              'Quit awesome'),

    keydoc.group('Windows'),
    awful.key({ modkey,           }, 'u', awful.client.urgent.jumpto,
              'Focus urgent'),
    awful.key({ modkey,           }, 'j',
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end,
        'Focus next'),
    awful.key({ modkey,           }, 'k',
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end,
        'Focus previous'),
    awful.key({ modkey, 'Shift'   }, 'j', function () awful.client.swap.byidx(  1)    end,
              'Swap with next'),
    awful.key({ modkey, 'Shift'   }, 'k', function () awful.client.swap.byidx( -1)    end,
              'Swap with previous'),
    awful.key({ modkey,           }, 'l',     function () awful.tag.incmwfact( 0.05)    end,
              'Grow current'),
    awful.key({ modkey,           }, 'h',     function () awful.tag.incmwfact(-0.05)    end,
              'Shrink current'),

    keydoc.group('Tags'),
    awful.key({ modkey,           }, 'Left',   awful.tag.viewprev,
              'View next'),
    awful.key({ modkey,           }, 'Right',  awful.tag.viewnext,
              'View previous'),
    awful.key({ modkey,           }, 'Escape', awful.tag.history.restore,
              'View last visited'),

    keydoc.group('Screens'),
    awful.key({ modkey, 'Control' }, 'j', function () awful.screen.focus_relative( 1) end,
              'Focus to the left'),
    awful.key({ modkey, 'Control' }, 'k', function () awful.screen.focus_relative(-1) end,
              'Focus to the right'),

    keydoc.group('Layout'),
    awful.key({ modkey,           }, 'space', function () awful.layout.inc(layouts,  1) end,
              'Next'),
    awful.key({ modkey, 'Shift'   }, 'space', function () awful.layout.inc(layouts, -1) end,
              'Previous'),
    awful.key({ modkey, 'Shift'   }, 'h',     function () awful.tag.incnmaster( 1)      end,
              '???'),
    awful.key({ modkey, 'Shift'   }, 'l',     function () awful.tag.incnmaster(-1)      end,
              '???'),
    awful.key({ modkey, 'Control' }, 'h',     function () awful.tag.incncol( 1)         end,
              '???'),
    awful.key({ modkey, 'Control' }, 'l',     function () awful.tag.incncol(-1)         end,
              '???'),

    keydoc.group('Programs'),
    awful.key({ modkey,           }, 'Return', function () awful.util.spawn(terminal) end,
              'Open terminal'),
    awful.key({ modkey },            'r',     function () widgets.prompts[mouse.screen]:run() end,
              'Run program'),
    awful.key({ modkey }, 'x',
              function ()
                  awful.prompt.run({ prompt = 'Run Lua code: ' },
                  widgets.prompts[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir('cache') .. '/history_eval')
              end,
              'Run lua code'),

    -- Quake terminal.
    awful.key({ modkey }, '`',                function() scratch.drop(terminal) end,
              'Toggle dropdown terminal'),

    -- Android keyboard.
    awful.key({ modkey }, 'Tab',              function() scratch.drop(terminal_run .. 'android-type') end,
              'Toggle android-type'),

    -- Volume control.
    awful.key({ modkey }, 'v',                function() scratch.drop('pavucontrol', 'top', 'right', 0.3, 1) end,
              'Toggle volume control')
)

clientkeys = awful.util.table.join(
    keydoc.group('Windows'),
    awful.key({ modkey,           }, 'f',      function (c) c.fullscreen = not c.fullscreen  end,
              'Full screen'),
    awful.key({ modkey, 'Control' }, 'space',  awful.client.floating.toggle,
              'Floating'),
    awful.key({ modkey,           }, 't',      function (c) c.ontop = not c.ontop            end,
              'On top'),
    awful.key({ modkey,           }, 'n',      function (c) c.minimized = not c.minimized    end,
              'Minimize'),
    awful.key({ modkey,           }, 'm',
        function (c)
            c.mDaximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end,
        'MaximizDe'),
    awful.key({ modkey, 'Shift'   }, 'c',      function (c) c:kill()                         end,
              'Kill'),
    awful.key({ modkey, 'Control' }, 'Return', function (c) c:swap(awful.client.getmaster()) end,
              'Make master window'),
    awful.key({ modkey,           }, 'o',      awful.client.movetoscreen,
              'MovDe to next screen'),
    awful.key({ modkey, 'Shift'   }, 'r',      function (c) c:redraw()                       end,
              'Redraw')
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, '#' .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, 'Control' }, '#' .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, 'Shift' }, '#' .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, 'Control', 'Shift' }, '#' .. i + 9,
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
                     focus = false,
                     floating = false,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    --{ rule_any = { class = { 'MPlayer', 'gimp', 'transmission', 'pidgin', 'openoffice.org' } },
    --  properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = 'Firefox' },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal('manage', function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:connect_signal('mouse::enter', function(c)
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

client.connect_signal('focus', function(c) c.border_color = beautiful.border_focus end)
client.connect_signal('unfocus', function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- vi:et:ts=4:sts=4:sw=4
