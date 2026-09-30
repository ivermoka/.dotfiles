local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local tray = {}

local tray_widget = wibox.widget {
	widget = wibox.widget.systray(),
	visible = false,
}

tray.widget = wibox.widget {
	tray_widget,
	{
		align = "center",
		text = " < ",
		widget = wibox.widget.textbox,
	},
	layout = wibox.layout.fixed.horizontal
}

function tray.toggle()
	if tray_widget:get_visible() then
        tray_widget:set_visible(false)
        tray.timer:stop()
    else 
        tray_widget:set_visible(true)
        tray.timer:start()
    end
end

tray.timer = gears.timer({
	timeout = 5,
	callback = function()
        -- Get coordinates of the cursor
        -- and hide tray if mouse is far from it
        -- Geometry read here, not at require time, so it follows monitor changes.
        local g = screen.primary.geometry
        local mg = mouse.coords()
        local dist = ((mg.x - g.x - g.width)^2 + (mg.y - g.y)^2)^0.5
        if dist > (g.width^2 + g.height^2)^0.5 / 5 then
            tray_widget:set_visible(false)
            tray.timer:stop()
        end
	end
})

tray.widget:buttons(gears.table.join(
	awful.button({ }, 1, function () 
		tray.toggle()
	end)))

return tray
