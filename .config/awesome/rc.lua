local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (text)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true
        naughty.notify{
            preset = naughty.config.presets.critical,
            text = text,
        }
        in_error = false
    end)
end
--]]

-- Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/usr/share/awesome/themes/default/theme.lua")

-- Default META.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
ALT = "Mod1"
META = "Mod4"
CTRL = "Control"
SHIFT = "Shift"

awful.tag({'1', '2', '3', '4', '5', '6', '7', '8', '9'}, 1, awful.layout.suit.tile)

root_keys = awful.util.table.join(
    awful.key({ META }, "`", function ()
        awful.util.spawn("dmenu_run")
    end),
    awful.key({ META }, "l", function ()
        awful.util.spawn("xscreensaver-command --lock")
    end),
    awful.key({ META }, "t", function ()
        awful.util.spawn("xterm")
    end), 
    awful.key({ META }, "f", function ()
        awful.util.spawn("Thunar")
    end),
    awful.key({ META }, "b", function ()
        awful.util.spawn("chromium")
    end) 
)

for i = 1, 9 do
    root_keys = awful.util.table.join(root_keys,
        awful.key({ META }, tostring(i), function()
            local tags = awful.tag.gettags(1)
            awful.tag.viewonly(tags[i])
        end)
    )
end

root.keys(root_keys)


client_buttons = awful.util.table.join(
    awful.button({}, 1, function (c)
        client.focus = c
        c:raise()
    end),
    awful.button({}, 3, function (c)
        client.focus = c
        c:raise()
    end),
    awful.button({ META }, 1, awful.mouse.client.move),
    awful.button({ META }, 3, awful.mouse.client.resize)
)


client_keys = awful.util.table.join(
    awful.key({ META }, "Escape", function(c)
        if c.class == 'Chromium' then
            awful.util.pread('xdotool keydown --window 0 --clearmodifiers ctrl')
            awful.util.pread('sleep 0.1')
            awful.util.pread('xdotool key --window 0 w')
            awful.util.pread('sleep 0.1')
            awful.util.pread('xdotool keyup --window 0 ctrl')
            return
        end

        c:kill()
    end),
    awful.key({ META }, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical = not c.maximized_vertical
    end)
)

for _, key in ipairs{'Left', 'Right', 'Up', 'Down'} do
    local direction = key:lower()
    client_keys = awful.util.table.join(client_keys,
        awful.key({ META }, key, function(c)
            awful.client.focus.bydirection(direction, c)
            client.focus:raise()
        end),
        awful.key({ META, CTRL }, key, function(c)
            awful.client.swap.bydirection(direction, c)
        end)
    )
end
    
for i = 1, 9 do
    client_keys = awful.util.table.join(client_keys,
        awful.key({ META, CTRL }, tostring(i), function(c)
            local tags = awful.tag.gettags(1)
            awful.client.movetotag(tags[i], c)
            awful.tag.viewonly(tags[i])
        end)
    )
end

awful.rules.rules = {
    { 
        rule = {},
        properties = {
            size_hints_honor = false,
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = client_keys,
            buttons = client_buttons,
        },
    },
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c, startup)
    if not startup then
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
--]]
