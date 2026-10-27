local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local bluetooth = {}

local SCRIPT = gears.filesystem.get_configuration_dir() .. "modules/widgets/bluetooth.sh"

local text = wibox.widget({
	align = "center",
	widget = wibox.widget.textbox,
	text = "",
})

bluetooth.widget = wibox.widget({
	text,
	fg = beautiful.colors.white,
	widget = wibox.container.background,
})

function bluetooth.update()
	awful.spawn.easy_async({ SCRIPT, "--status" }, function(stdout)
		text:set_text((stdout:gsub("%s+$", "")))
	end)
end

function bluetooth.show_menu()
	awful.spawn({ SCRIPT }, false)
end

bluetooth.widget:buttons(awful.button({}, 1, bluetooth.show_menu))

gears.timer({ timeout = 10, autostart = true, call_now = true, callback = bluetooth.update })

return bluetooth
