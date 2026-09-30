local awful		= require("awful")
local beautiful = require("beautiful")
local naughty	= require("naughty")
local wibox		= require("wibox")
local gears		= require("gears")

local wifi = {}

local STATUS_CMD = { "bash", "-c", "nmcli radio wifi; nmcli -t -f IN-USE,SIGNAL,SECURITY,SSID dev wifi list --rescan no" }

local text = wibox.widget({
	align = "center",
	widget = wibox.widget.textbox,
	text = "📶 ..",
})

wifi.widget = wibox.widget({
	text,
	fg = beautiful.colors.white,
	widget = wibox.container.background,
})

-- nmcli -t escapes ':' and '\' in values; SSID is the last field so it may
-- contain (escaped) colons.
local function parse_networks(stdout)
	local nets, by_ssid = {}, {}
	for line in stdout:gmatch("[^\n]+") do
		local in_use, signal, security, ssid = line:match("^([%* ]?):(%d+):([^:]*):(.*)$")
		if ssid then
			ssid = ssid:gsub("\\(.)", "%1")
		end
		if ssid and ssid ~= "" then
			local net = by_ssid[ssid]
			if not net then
				net = { ssid = ssid, signal = 0, secure = security ~= "" }
				by_ssid[ssid] = net
				nets[#nets + 1] = net
			end
			net.signal = math.max(net.signal, tonumber(signal))
			net.active = net.active or in_use == "*"
		end
	end
	table.sort(nets, function(a, b)
		if a.active ~= b.active then
			return a.active
		end
		return a.signal > b.signal
	end)
	return nets
end

function wifi.update()
	awful.spawn.easy_async(STATUS_CMD, function(stdout)
		if stdout:match("^disabled") then
			text:set_text("📶 off")
			return
		end
		local active = parse_networks(stdout)[1]
		if active and active.active then
			local name = #active.ssid > 15 and active.ssid:sub(1, 14) .. "…" or active.ssid
			text:set_text("📶 " .. name .. " " .. active.signal .. "%")
		else
			text:set_text("📶 --")
		end
	end)
end

local function notify(msg)
	naughty.notify({ title = "Wi-Fi", text = msg })
end

local function run_nmcli(args, done_msg)
	awful.spawn.easy_async(args, function(stdout, stderr, _, code)
		notify(code == 0 and done_msg or (stderr ~= "" and stderr or stdout))
		wifi.update()
	end)
end

local function ask_password(ssid)
	awful.spawn.easy_async({ "rofi", "-dmenu", "-password", "-l", "0", "-p", "Password for " .. ssid }, function(pw, _, _, code)
		pw = pw:gsub("\n$", "")
		if code == 0 and pw ~= "" then
			notify("Connecting to " .. ssid .. "…")
			run_nmcli({ "nmcli", "device", "wifi", "connect", ssid, "password", pw }, "Connected to " .. ssid)
		end
	end)
end

-- Reuses an existing profile for the SSID if there is one; only prompts for
-- a password when NetworkManager reports that secrets are missing.
local function connect(net)
	notify("Connecting to " .. net.ssid .. "…")
	awful.spawn.easy_async({ "nmcli", "device", "wifi", "connect", net.ssid }, function(stdout, stderr, _, code)
		if code == 0 then
			notify("Connected to " .. net.ssid)
		elseif net.secure and (stderr .. stdout):lower():match("secrets") then
			ask_password(net.ssid)
		else
			notify(stderr ~= "" and stderr or stdout)
		end
		wifi.update()
	end)
end

function wifi.toggle_radio()
	awful.spawn.easy_async({ "nmcli", "radio", "wifi" }, function(stdout)
		local turn_on = stdout:match("^disabled") ~= nil
		run_nmcli({ "nmcli", "radio", "wifi", turn_on and "on" or "off" }, "Wi-Fi " .. (turn_on and "enabled" or "disabled"))
	end)
end

local active_menu = nil

function wifi.show_menu()
	if active_menu and active_menu.wibox.visible then
		active_menu:hide()
		return
	end

	local cmd = {
		"bash",
		"-c",
		"nmcli radio wifi; nmcli -t -f IN-USE,SIGNAL,SECURITY,SSID dev wifi list --rescan auto",
	}
	awful.spawn.easy_async(cmd, function(stdout)
		local enabled = not stdout:match("^disabled")

		local items = {}
		if enabled then
			for _, net in ipairs(parse_networks(stdout)) do
				local label = string.format(
					"%s %3d%% %s%s",
					net.active and "●" or " ",
					net.signal,
					net.ssid,
					net.secure and " 🔒" or ""
				)
				items[#items + 1] = {
					label,
					function()
						connect(net)
					end,
				}
			end
			if #items == 0 then
				items[1] = { "No networks found" }
			end
		end
		items[#items + 1] = { enabled and "Turn Wi-Fi off" or "Turn Wi-Fi on", wifi.toggle_radio }
		items[#items + 1] = {
			"Edit connections…",
			function()
				awful.spawn("nm-connection-editor", false)
			end,
		}

		active_menu = awful.menu({ items = items, theme = { width = 300 } })
		active_menu:show()
	end)
end

wifi.widget:buttons(gears.table.join(
	awful.button({}, 1, wifi.show_menu),
	awful.button({}, 3, wifi.toggle_radio)
))

gears.timer({ timeout = 10, autostart = true, call_now = true, callback = wifi.update })

return wifi
