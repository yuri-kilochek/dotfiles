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

local beautiful = require("beautiful")
beautiful.init("~/.config/awesome/theme.lua")

local awful = require("awful")

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

local tag_focus = {}

for i = 1, #awful.tag.gettags(1) do
    root_keys = awful.util.table.join(root_keys,
        awful.key({ META }, tostring(i), function()
            local old = awful.tag.selected(1)
            tag_focus[old] = client.focus

            local new = awful.tag.gettags(1)[i]
            awful.tag.viewonly(new)
            if tag_focus[new] ~= nil then
                client.focus, tag_focus[new] = tag_focus[new], nil
            end
        end),
    {})
    client_keys = awful.util.table.join(client_keys,
        awful.key({ META, ALT }, tostring(i), function(c)
            local old = awful.tag.selected(1)
            tag_focus[old] = old:clients()[1]

            local new = awful.tag.gettags(1)[i]
            awful.tag.viewonly(new)
            awful.client.movetotag(new, c)
            client.focus, tag_focus[new] = c, nil
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
        awful.key({ META, ALT }, key, function(c)
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

client.connect_signal('manage', function(c, startup)
    c.maximized = false
    c.size_hints_honor = false

    c:keys(client_keys)
    c:buttons(client_buttons)

    if awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal('tagged', function(c, t)
    local tcs = t:clients()
    if #tcs == 1 then
        c.border_width = 0
    elseif #tcs == 2 then
        for _, c in ipairs(tcs) do
            c.border_width = beautiful.border_width
        end
    elseif #tcs > 2 then
        c.border_width = beautiful.border_width
    end
end)

client.connect_signal('untagged', function(c, t)
    local tcs = t:clients()

    if #tcs == 1 then
        tcs[1].border_width = 0
    end

    for _, c in ipairs(tcs) do
        if c == client.focus then
            return
        end
    end
    
    -- focus previous client in focus history that is in this tag
    for i = 0, #client.get(1) - 1 do
        local c = awful.client.focus.history.get(1, i)
        for _, cc in ipairs(tcs) do
            if cc == c then
                client.focus = c
                return
            end
        end
    end
end)

client.connect_signal("focus", function(client)
    client.border_color = beautiful.border_focus_color
end)

client.connect_signal("unfocus", function(client)
    client.border_color = beautiful.border_color
end)

