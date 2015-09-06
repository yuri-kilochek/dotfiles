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

local controller_pids = {}

root_keys = awful.util.table.join(
    awful.key({ META }, "r", function()
        local pid = awful.util.spawn('xterm -e ' .. awful.util.getdir('config') .. '/run')
        controller_pids[pid] = true
    end),
    awful.key({ META }, "l", function()
        awful.util.spawn("xscreensaver-command --lock")
    end),
    awful.key({ META }, "t", function()
        local pid = awful.util.spawn('xterm -e ' .. awful.util.getdir('config') .. '/time')
        controller_pids[pid] = true
    end), 
    awful.key({ META }, "b", function()
        local pid = awful.util.spawn('xterm -e ' .. awful.util.getdir('config') .. '/battery')
        controller_pids[pid] = true
    end),
{})

local function get_backlight()
    return tonumber(awful.util.pread(awful.util.getdir('config') .. '/backlight.sh'))
end

local function set_backlight(value)
    awful.util.spawn(awful.util.getdir('config') .. '/backlight.sh '.. value)
end

root_keys = awful.util.table.join(root_keys,
    awful.key({ META, SHIFT }, 'F9', function()
        set_backlight(0)
    end),
    awful.key({ META }, 'F9', function()
        local new = get_backlight() - 10
        if new < 0 then
            new = 0
        end
        set_backlight(new)
    end),
    awful.key({ META }, 'F10', function()
        local new = get_backlight() + 10
        if new > 100 then
            new = 100
        end
        set_backlight(new)
    end),
    awful.key({ META, SHIFT }, 'F10', function()
        set_backlight(100)
    end),
{})

client_keys = awful.util.table.join(
    awful.key({ META }, "Escape", function(c)
        if c.class == 'Chromium' then
            awful.util.pread('xvkbd -xsendevent -text "\\Cw"')
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
            local i = 0
            while true do
                local c = awful.client.focus.history.get(1, i)
                if c == nil then
                    return
                end
                for _, tt in ipairs(c:tags()) do
                    if t == tt then
                        client.focus = c
                        return
                    end
                end
                i = i + 1
            end
        end),
    {})
    client_keys = awful.util.table.join(client_keys,
        awful.key({ META, ALT }, tostring(i), function(c)
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
    local keys = client_keys
    local buttons = client_buttons

    if controller_pids[c.pid] then
        controller_pids[c.pid] = nil
        
        local function fix_geometry()
            local g = c:geometry()
            c:geometry{
                width = g.width,
                height = g.height,
                x = screen[c.screen].geometry.width/2 - g.width/2,
                y = screen[c.screen].geometry.height/2 - g.height/2,
            }
        end
        c:connect_signal('property::geometry', fix_geometry)
        c:connect_signal('property::screen', fix_geometry)

        c:connect_signal('unfocus', function()
            c:kill()
        end)

        keys = awful.util.table.join(keys,
            awful.key({}, 'Escape', function(c)
                c:kill()
            end),
        {})
    else
        c.size_hints_honor = false
    end

    c:keys(keys)
    c:buttons(buttons)

    if awful.client.focus.filter(c) then
        client.focus = c
    end
end)

local function remove_floating(cs)
    local i = 1
    while i <= #cs do
        if awful.client.floating.get(cs[i]) or controller_pids[cs[i].pid] then
            table.remove(cs, i)
        else
            i = i + 1
        end
    end
end

client.connect_signal('tagged', function(c, t)
    if controller_pids[c.pid] then
        c.maximized = false
        awful.client.floating.set(c, true)
        c.ontop = true
        c.border_width = beautiful.border_width
    end

    local tcs = t:clients()

    remove_floating(tcs)

    if #tcs == 1 then
        tcs[1].border_width = 0
    else
        for _, c in ipairs(tcs) do
            c.border_width = beautiful.border_width
        end
    end
end)

client.connect_signal('untagged', function(c, t)
    local tcs = t:clients()

    for _, c in ipairs(tcs) do
        if c == client.focus then
            return
        end
    end
    
    remove_floating(tcs)

    if #tcs == 1 then
        tcs[1].border_width = 0
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

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus_color
end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_color
end)

