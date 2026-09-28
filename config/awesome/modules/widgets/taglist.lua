local awful = require("awful")

local taglist = {}

-- Thin wrapper around awful.widget.taglist so callers (rc.lua) create it the
-- same way as the other modules.widgets.* widgets: `taglist.new(s, buttons)`.
function taglist.new(s, buttons)
	return awful.widget.taglist {
		screen  = s,
		filter  = awful.widget.taglist.filter.all,
		buttons = buttons,
	}
end

return taglist
