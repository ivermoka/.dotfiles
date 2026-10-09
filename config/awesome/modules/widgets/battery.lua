local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local settings = require("settings")

local battery = {}
local notification
function battery.create()
	return battery_widget(settings.battery)
end

function battery.show_status()
    awful.spawn.easy_async({ "bash", "-c", 'acpi; echo "Brightness: $("$0" get)"', gears.filesystem.get_configuration_dir() .. "scripts/brightness.sh" },
        function(stdout, _, _, _)
			if notification then 
				naughty.destroy(notification)
			end
			notification = naughty.notify({
				text = stdout
			})
        end)
end

return battery
