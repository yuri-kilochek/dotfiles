local naughty = require("naughty")

do
    local in_error = false
    awesome.connect_signal("debug::error", function(message)
        if in_error then
            return
        end
        in_error = true
        naughty.notify{
            preset = naughty.config.presets.critical,
            text = message,
        }
        in_error = false
    end)
end

local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.border_width = 3

ALT = "Mod1"
META = "Mod4"
CTRL = "Control"
SHIFT = "Shift"

awful.tag({'1', '2', '3', '4', '5', '6', '7', '8', '9'}, 1, awful.layout.suit.tile)

root_keys = awful.util.table.join(
    awful.key({ META }, "`", function()
        awful.util.spawn("dmenu_run")
    end),
    awful.key({ META }, "l", function()
        awful.util.spawn("xscreensaver-command --lock")
    end),
    awful.key({ META }, "t", function()
        awful.util.spawn("xterm")
    end), 
    awful.key({ META }, "f", function()
        awful.util.spawn("Thunar")
    end),
    awful.key({ META }, "b", function()
        awful.util.spawn("chromium")
    end),
    awful.key({ META, SHIFT }, "b", function()
        awful.util.spawn("chromium --incognito")
    end),
{})

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
{})

for i = 1, #awful.tag.gettags(1) do
    root_keys = awful.util.table.join(root_keys,
        awful.key({ META }, tostring(i), function()
            local t = awful.tag.gettags(1)[i]
            awful.tag.viewonly(t)
        end),
    {})
    client_keys = awful.util.table.join(client_keys,
        awful.key({ META, CTRL }, tostring(i), function(c)
            local t = awful.tag.gettags(1)[i]
            awful.tag.viewonly(t)
            awful.client.movetotag(t, c)
            client.focus = c
        end),
    {})
end

for key, direction in pairs{
    ['Left'] = 'left',
    ['Right'] = 'right',
    ['Up'] = 'up',
    ['Down'] = 'down',
} do
    client_keys = awful.util.table.join(client_keys,
        awful.key({ META }, key, function(c)
            awful.client.focus.bydirection(direction, c)
        end),
        awful.key({ META, CTRL }, key, function(c)
            awful.client.swap.bydirection(direction, c)
        end),
    {})
end
    
client_buttons = awful.util.table.join(
    awful.button({}, 1, function(c)
        client.focus = c
    end),
    awful.button({}, 3, function(c)
        client.focus = c
    end),
    awful.button({ META }, 1, awful.mouse.client.move),
    awful.button({ META }, 3, awful.mouse.client.resize),
{})

root.keys(root_keys)

awful.rules.rules = {
    { 
        rule = {},
        properties = {
            size_hints_honor = false,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = client_keys,
            buttons = client_buttons,
        },
    },
}

do
    local tag_focus = {}
    tag.connect_signal('property::selected', function(t)
        if t.selected then
            if tag_focus[t] then
                client.focus = tag_focus[t]
            else
                local tcs = t:clients()
                if #tcs > 0 then
                    client.focus = tcs[1]
                end
            end
        else
            tag_focus[t] = client.focus
        end
    end)
end

client.connect_signal('tagged', function(c, t)
    local tcs = t:clients()
    if #tcs == 2 then
        for _, c in ipairs(tcs) do
            c.border_width = beautiful.border_width
        end
    elseif #tcs > 2 then
        c.border_width = beautiful.border_width
    end
end)

client.connect_signal('untagged', function(c, t)
    c.border_width = 0
    local tcs = t:clients()
    if #tcs == 1 then
        tcs[1].border_width = 0
    end
    --[[
    local has_focused = false;
    for _, cc in ipairs(tcs) do
        if cc == client.focus then
            has_focused = true
            break
        end
    end
    if not has_focused and #tcs > 0 then
        client.focus = tcs[1]
    end
    --]]
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

