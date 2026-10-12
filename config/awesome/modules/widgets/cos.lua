local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local cos = {}

-- Mirrors the checks in ~/.local/bin/cos (vpn_running / tunnel_running).
local STATUS_CMD = {
	"bash",
	"-c",
	"pgrep -x openconnect >/dev/null && echo vpn=1 || echo vpn=0; pgrep -f 'sshuttle.*ssh\\.cosng\\.net' >/dev/null && echo tun=1 || echo tun=0",
}

local text = wibox.widget({
	align = "center",
	widget = wibox.widget.textbox,
	text = "🔒",
})

cos.widget = wibox.widget({
	text,
	fg = beautiful.colors.white,
	widget = wibox.container.background,
})

function cos.update()
	awful.spawn.easy_async(STATUS_CMD, function(stdout)
		local vpn = stdout:match("vpn=1") ~= nil
		local tun = stdout:match("tun=1") ~= nil
		if vpn and tun then
			text:set_text("🔒")
		elseif not vpn and not tun then
			text:set_text("🔓")
		else
			text:set_text("⚠️")
		end
	end)
end

gears.timer({ timeout = 10, autostart = true, call_now = true, callback = cos.update })

return cos
