local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup").widget

require("awful.autofocus")
require("awful.remote")

local dpi = require("beautiful.xresources").apply_dpi

-- Theme init (must happen before requiring "modules": the widgets under
-- modules/widgets/*.lua read beautiful.colors at require-time)
beautiful.init(gears.filesystem.get_configuration_dir() .. "gruvbox-theme/theme.lua")

local modules = require("modules")
local settings = require("settings")
local volume_widget = require("awesome-wm-widgets.pactl-widget.volume")
-- Set default apps
local terminal = settings.default_apps.terminal

-- Start autostart apps without a matching window (delayed so restart has re-managed existing clients).
gears.timer.delayed_call(function()
	for _, app in ipairs(settings.autostart) do
		local running = false
		for _, c in ipairs(client.get()) do
			running = running or awful.rules.match(c, app[2])
		end
		if not running then
			awful.spawn(app[1])
		end
	end
end)
-- Lock on suspend/lid close (daemon has no window, so guard with pgrep).
awful.spawn.with_shell(
	"pgrep -u $USER -x xss-lock >/dev/null || xss-lock --transfer-sleep-lock -- i3lock --nofork -c 000000"
)

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true
		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end

-- Notification configuration
naughty.config.defaults.border_width = dpi(0)
naughty.config.spacing = dpi(8)
naughty.config.padding = dpi(8)
naughty.config.defaults.margin = dpi(8)
naughty.config.defaults.timeout = 5

-- Default modkey.
local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.floating,
		awful.layout.suit.tile,
		awful.layout.suit.tile.left,
		awful.layout.suit.tile.bottom,
		-- awful.layout.suit.tile.top,
		-- awful.layout.suit.fair,
		-- awful.layout.suit.fair.horizontal,
		-- awful.layout.suit.spiral,
		-- awful.layout.suit.spiral.dwindle,
		-- awful.layout.suit.max,
		-- awful.layout.suit.max.fullscreen,
		-- awful.layout.suit.magnifier,
		-- awful.layout.suit.corner.nw,
		-- awful.layout.suit.corner.ne,
		-- awful.layout.suit.corner.sw,
		-- awful.layout.suit.corner.se,
	})
end)

local fehbg = os.getenv("HOME") .. "/.fehbg"
local function set_wallpaper(s)
	if gears.filesystem.file_readable(fehbg) then
		awful.spawn.with_shell(fehbg)
	else
		gears.wallpaper.maximized(gears.filesystem.get_configuration_dir() .. "images/wallpaper.jpg", s)
	end
end
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local mytextclock = wibox.widget.textclock("%R")
mytextclock:buttons(gears.table.join(awful.button({}, 1, function()
	modules.sidebar.toggle()
end)))

local mykeyboardlayout = awful.widget.keyboardlayout()
local mypromptbox = awful.widget.prompt()
local myseparator = wibox.widget.textbox(" ")
local nextEmptyTag = wibox.widget({
	markup = "<b>+</b>",
	align = "center",
	forced_width = dpi(16),
	widget = wibox.widget.textbox,
})

nextEmptyTag:buttons(gears.table.join(awful.button({}, 1, function()
	awful.tag.viewnone()
	local tgs = awful.screen.focused().tags
	for i = 1, #tgs do
		if #tgs[i]:clients() == 0 then
			awful.tag.viewtoggle(tgs[i])
			break
		end
	end
end)))

awful.screen.connect_for_each_screen(function(s)
	set_wallpaper(s)

	-- Tags are created by tyrannical (modules/tools/tagnames.lua) based on
	-- client rules, not statically here.
	-- Buttons for taglist and taglist widget
	local taglist_buttons = gears.table.join(
		awful.button({}, 1, function(t)
			t:view_only()
		end),
		awful.button({ modkey }, 1, function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end),
		awful.button({}, 2),
		awful.button({}, 3, awful.tag.viewtoggle),
		awful.button({ modkey }, 3, function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end),
		awful.button({}, 4, function(t)
			awful.tag.viewnext(t.screen)
		end),
		awful.button({}, 5, function(t)
			awful.tag.viewprev(t.screen)
		end)
	)
	s.mytaglist = modules.widgets.taglist.new(s, taglist_buttons)

	-- Layoutbox widget and buttons
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 2, function()
			awful.tag.togglemfpol()
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))

	local tasklist_buttons = gears.table.join(
		awful.button({}, 1, function(c)
			if c == client.focus then
				c.minimized = true
			else
				c.minimized = false
				if not c:isvisible() and c.first_tag then
					c.first_tag:view_only()
				end
				client.focus = c
				c:raise()
			end
		end),
		awful.button({}, 2, function(c)
			-- c:kill()
		end),
		awful.button({}, 3, function(c)
			modules.menus.clientmenu(c)
		end),
		awful.button({}, 4, function()
			awful.client.focus.byidx(1)
		end),
		awful.button({}, 5, function()
			awful.client.focus.byidx(-1)
		end)
	)

	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		layout = {
			spacing = beautiful.tasklist_spacing or dpi(8),
			layout = wibox.layout.flex.horizontal,
		},
		widget_template = {
			{
				id = "text_role",
				align = "center",
				widget = wibox.widget.textbox,
			},
			id = "background_role",
			widget = wibox.container.background,
		},
	})
	s.mytasklist:set_max_widget_size(dpi(200))

	s.wibar = awful
		.wibar({
			position = "top",
			screen = s,
			height = dpi(24),
			ontop = false,
			bg = beautiful.colors.black .. "DD",
		})
		:setup({
			{
				-- Left widgets
				layout = wibox.layout.fixed.horizontal,
				modules.widgets.menu_button,
				mypromptbox,
				s.mylayoutbox,
				s.mytaglist,
				nextEmptyTag,
			},
			{
				-- Center widgets
				layout = wibox.layout.align.horizontal,
				myseparator,
				s.mytasklist,
				myseparator,
			},
			{
				-- Right widgets
				layout = wibox.layout.fixed.horizontal,
				github_prs_widget({
					reviewer = "ivermoka",
				}),
				myseparator,
				modules.widgets.player.widget,
				myseparator,
				modules.widgets.wifi.widget,
				myseparator,
				modules.widgets.battery.widget,
				myseparator,
				volume_widget(),
				myseparator,
				mytextclock,
				myseparator,
				modules.widgets.tray.widget,
				layout = wibox.layout.fixed.horizontal,
			},
			layout = wibox.layout.align.horizontal,
		})
end)

-- Set keys
local globalkeys = gears.table.join(
	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "Applications" }),

	awful.key({ modkey, "Shift" }, "Return", function()
		awful.spawn(terminal, { floating = true })
	end, { description = "open a floating terminal", group = "Applications" }),

	----------------------{ AWESOME }--------------------------------------------
	awful.key({ modkey }, "space", function()
		awful.spawn.with_shell("~/.config/rofi/launchers/type-3/launcher.sh")
	end, { description = "Run rofi launcher", group = "Awesome" }),

	-- rofi: window switcher/overview across all tags and screens
	awful.key({ modkey, "Shift" }, "Tab", function()
		awful.spawn.with_shell("~/.config/rofi/launchers/type-3/windows.sh")
	end, { description = "window overview (search open windows)", group = "Awesome" }),

	awful.key({ modkey, "Shift" }, "r", function()
		mypromptbox:run()
	end, { description = "Run prompt", group = "Awesome" }),

	awful.key({ "Control", "Mod1" }, "l", function()
		awful.spawn(settings.lock_command)
	end, { description = "Lock", group = "Awesome" }),

	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "Reload awesome", group = "Awesome" }),

	awful.key({ modkey, "Shift" }, "a", hotkeys_popup.show_help, { description = "Show help", group = "Awesome" }),

	awful.key({ modkey }, "c", function()
		modules.sidebar.toggle()
	end, { description = "Open system info popup", group = "Awesome" }),

	awful.key({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "Lua execute prompt", group = "Awesome" }),

	awful.key({ modkey }, "a", function()
		modules.menus.mainmenu:toggle()
	end, { description = "Show main menu", group = "Awesome" }),

	awful.key({ modkey }, "q", function()
		modules.widgets.tray.toggle()
	end, { description = "Show system tray", group = "Awesome" }),

	awful.key({ modkey, "Shift" }, "p", function()
		modules.widgets.pomodoro.toggle()
	end, { description = "Show/hide pomodoro timer", group = "Awesome" }),

	awful.key({ modkey }, "b", function()
		modules.widgets.battery.show_status()
	end, { description = "Show battery status", group = "Awesome" }),

	awful.key({ modkey }, "w", function()
		modules.widgets.wifi.show_menu()
	end, { description = "Show Wi-Fi menu", group = "Awesome" }),

	awful.key({ modkey, "Control", "Shift" }, "t", function()
		for _, c in ipairs(client.get()) do
			awful.titlebar.toggle(c)
		end
	end, { description = "Toggle titlebar of all windows", group = "Clients management" }),

	----------------------{ SOUND }--------------------------------------------
	awful.key({}, "XF86AudioRaiseVolume", function()
		volume_widget:inc(5)
	end, { description = "Increase volume by 2", group = "Volume control" }),

	awful.key({}, "XF86AudioLowerVolume", function()
		volume_widget:dec(5)
	end, { description = "Decrease volume by 2", group = "Volume control" }),

	awful.key({}, "XF86AudioMute", function()
		volume_widget:toggle()
	end, { description = "Mute/Unmute volume", group = "Volume control" }),

	awful.key({}, "XF86AudioMicMute", function()
		awful.spawn.with_shell(
			[[pactl list sources | grep -oP "Name: \S+" | grep "input" | cut -d' ' -f2 | xargs -I{} pactl set-source-mute {} toggle]]
		)
	end, { description = "Toggle mute on all microphones", group = "Volume control" }),

	awful.key({ "Shift" }, "XF86AudioMicMute", function()
		awful.spawn.with_shell(
			[[pactl list sources | grep -oP "Name: \S+" | grep "input" | cut -d' ' -f2 | xargs -I{} pactl set-source-mute {} false]]
		)
	end, { description = "Unmute all microphones", group = "Volume control" }),

	--------------------------{ BRIGHTNESS }----------------------------------
	awful.key({}, "XF86MonBrightnessUp", function()
		awful.spawn(gears.filesystem.get_configuration_dir() .. "scripts/brightness.sh up", false)
	end, { description = "Increase screen brightness", group = "Brightness control" }),

	awful.key({}, "XF86MonBrightnessDown", function()
		awful.spawn(gears.filesystem.get_configuration_dir() .. "scripts/brightness.sh down", false)
	end, { description = "Decrease screen brightness", group = "Brightness control" }),

	awful.key({ "Shift" }, "XF86MonBrightnessUp", function()
		awful.spawn(gears.filesystem.get_configuration_dir() .. "scripts/brightness.sh set 100", false)
	end, { description = "Set screen brightness on 100", group = "Brightness control" }),

	awful.key({ "Shift" }, "XF86MonBrightnessDown", function()
		awful.spawn(gears.filesystem.get_configuration_dir() .. "scripts/brightness.sh set 1", false)
	end, { description = "Set screen brightness to minimum", group = "Brightness control" }),

	----------------------{ PRINTSCREEN }--------------------------------------------

	awful.key({}, "Print", nil, function()
		awful.spawn(gears.filesystem.get_configuration_dir() .. "scripts/screenshot.sh -s", false)
	end, { description = "Screenshot selected area/window", group = "Screenshot" }),

	awful.key({ "Control" }, "Print", nil, function()
		awful.spawn(gears.filesystem.get_configuration_dir() .. "scripts/screenshot.sh", false)
	end, { description = "Screenshot full screen", group = "Screenshot" }),

	awful.key({ "Shift" }, "Print", nil, function()
		awful.spawn(gears.filesystem.get_configuration_dir() .. "scripts/screenshot.sh -s", false)
	end, { description = "Screenshot selected area/window", group = "Screenshot" }),

	----------------------{ PLAYER }--------------------------------------------

	awful.key({ modkey }, "XF86AudioMute", function()
		modules.widgets.player.control.toggle()
	end, { description = "Toggle Pause", group = "Music player control" }),

	awful.key({ modkey }, "XF86AudioLowerVolume", function()
		modules.widgets.player.control.prev()
	end, { description = "Previous track", group = "Music player control" }),

	awful.key({ modkey }, "XF86AudioRaiseVolume", function()
		modules.widgets.player.control.next()
	end, { description = "Next track", group = "Music player control" }),

	----------------------{ TAGS }--------------------------------------------
	awful.key({ modkey }, "p", function()
		awful.tag.togglemfpol()
	end, { description = "Toggle master fill police", group = "Tag management" }),

	--awful.key({ modkey,}, "`",     awful.tag.history.restore, {description = "Go to previous tag", group = "Tag management"}),

	awful.key({ modkey }, "-", function()
		awful.tag.incgap(-5)
	end, { description = "Decrease gaps", group = "Tag management" }),

	awful.key({ modkey }, "=", function()
		awful.tag.incgap(5)
	end, { description = "Increase gaps", group = "Tag management" }),

	awful.key({ modkey }, "0", function()
		local t = awful.screen.focused().selected_tag
		if t then
			t.gap = 0
		end
	end, { description = "Set zero gaps", group = "Tag management" }),

	awful.key({ modkey }, "i", function()
		awful.prompt.run({
			prompt = "Rename tag: ",
			textbox = mypromptbox.widget,
			exe_callback = function(new_name)
				local t = awful.screen.focused().selected_tag -- Get current tag
				if t then -- If success, check does we got text or no
					if not new_name or #new_name == 0 then -- If length of input text 0 set default tag name
						t.name = t.index
					else
						t.name = t.index .. ":" .. new_name
					end
				end
			end,
		})
	end, { description = "Rename active tag", group = "Tag management" }),

	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "Increase master width factor", group = "Tag management" }),

	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "Decrease master width factor", group = "Tag management" }),

	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "Increase the number of master clients", group = "Tag management" }),

	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "Decrease the number of master clients", group = "Tag management" }),

	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "Increase the number of columns", group = "Tag management" }),

	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "Decrease the number of columns", group = "Tag management" }),

	awful.key({ "Mod1" }, "space", function()
		awful.layout.inc(1)
	end, { description = "Select next tag layout", group = "Tag management" }),

	awful.key({ "Mod1" }, "j", function()
		local scr = awful.screen.focused()
		for i = 1, #scr.tags do
			awful.tag.viewnext()
			if #scr.selected_tag:clients() ~= 0 then
				break
			end
		end
	end, { description = "View next not-empty tag", group = "Tag management" }),

	awful.key({ "Mod1" }, "k", function()
		local scr = awful.screen.focused()
		for i = 1, #scr.tags do
			awful.tag.viewprev()
			if #scr.selected_tag:clients() ~= 0 then
				break
			end
		end
	end, { description = "View prev not-empty tag", group = "Tag management" }),

	awful.key({ "Mod1", "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "Select previous tag layout", group = "Tag management" }),

	----------------------{ WINDOWS CONTROL }--------------------------------------------
	awful.key({ modkey }, "`", function()
		awful.client.focus.byidx(1)
	end, { description = "Focus next by index", group = "Clients management" }),
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.byidx(1)
	end, { description = "Focus next by index", group = "Clients management" }),

	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "Focus next by index", group = "Clients management" }),

	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "Focus previous by index", group = "Clients management" }),

	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "Swap with next client by index", group = "Clients management" }),

	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "Swap with previous client by index", group = "Clients management" }),

	awful.key({ modkey }, "o", function()
		awful.screen.focus_relative(1)
	end, { description = "Focus the next screen", group = "Screens management" }),

	awful.key({ modkey, "Shift" }, "o", function()
		local c = client.focus
		if c then
			c:move_to_screen()
		end
	end, { description = "Move focused window on next screen", group = "Screens management" }),

	awful.key({ modkey }, "F7", function()
		modules.tools.xrandr.popup()
	end, { description = "Display layout menu", group = "Screens management" }),

	awful.key({ modkey }, "u", function()
		awful.client.urgent.jumpto()
	end, { description = "Jump to urgent client", group = "Clients management" }),

	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			client.focus = c
			c:raise()
		end
	end, { description = "Restore minimized", group = "Clients management" })
)

for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "View tag", group = "Tag management" }),

		-- Toggle tag display.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "Toggle tag", group = "Tag management" }),

		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "Move client to tag", group = "Tag management" }),

		-- Toggle tag on focused client.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "Add client to tag", group = "Tag management" })
	)
end

for i = 1, #settings.launcher do
	globalkeys = gears.table.join(
		globalkeys,
		-- Add launcher hotkey for this button
		awful.key({ modkey }, "F" .. i, function()
			awful.spawn(settings.launcher[i])
		end, { description = settings.launcher[i], group = "Applications" })
	)
end

root.keys(globalkeys)
-- Set buttons
local rootbuttons = gears.table.join(
	awful.button({}, 3, function()
		modules.menus.mainmenu:toggle()
	end)
	-- awful.button({ }, 4, awful.tag.viewnext),
	-- awful.button({ }, 5, awful.tag.viewprev)
)

root.buttons(rootbuttons)

-- Create table with client buttons
local clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		client.focus = c
		c:raise()
	end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize)
)

local clientkeys = gears.table.join(
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "Toggle fullscreen", group = "Clients management" }),

	--awful.key({ "Mod1"}, "F4",
	--    function (c)
	--        c:kill()
	--    end, {description = "Close", group = "Clients management"}),

	awful.key({ modkey, "Shift" }, "q", function(c)
		c:kill()
	end, { description = "Close", group = "Clients management" }),

	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "Move to master", group = "Clients management" }),

	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "Toggle keep on top", group = "Clients management" }),

	awful.key({ modkey, "Shift" }, "t", function(c)
		awful.titlebar.toggle(c)
	end, { description = "Toggle titlebar of active window", group = "Clients management" }),

	awful.key(
		{ modkey, "Shift" },
		"f",
		awful.client.floating.toggle,
		{ description = "Toggle floating", group = "Clients management" }
	),

	awful.key({ modkey }, "s", function(c)
		c.sticky = not c.sticky
	end, { description = "Toogle sticky", group = "Clients management" }),

	awful.key({ modkey }, "n", function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, { description = "Minimize", group = "Clients management" }),

	awful.key({ modkey }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(Un)maximize", group = "Clients management" }),

	awful.key({ modkey, "Shift" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, { description = "(Un)maximize vertically", group = "Clients management" }),

	awful.key({ modkey, "Control" }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end, { description = "(Un)maximize horizontally", group = "Clients management" }),

	awful.key({ modkey, "Control" }, "k", function(c)
		if awful.layout.get() ~= awful.layout.suit.floating then
			awful.client.incwfact(-0.05, c)
		end
	end, { description = "Decrease client factor", group = "Clients management" }),

	awful.key({ modkey }, "g", function(c)
		local cp = (awful.placement.under_mouse + awful.placement.no_offscreen)
		cp(c)
	end, { description = "Put client under cursor", group = "Clients management" }),

	awful.key({ modkey, "Control" }, "j", function(c)
		if awful.layout.get() ~= awful.layout.suit.floating then
			awful.client.incwfact(0.05, c)
		end
	end, { description = "Increase client factor", group = "Clients management" })
)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	{
		-- All clients will match this rule.
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.under_mouse + awful.placement.no_offscreen,
		},
	},
	{
		rule_any = {
			instance = { "DTA", "copyq" },
			class = {
				"Arandr",
				"Gpick",
				"Kruler",
				"Wpa_gui",
				"pinentry",
				"veromix",
				"xtightvncviewer",
				"Lxappearance",
				"Matplotlib",
				"Nm-connection-editor",
				"Msgcompose",
			},
			name = {
				"Event Tester",
				"Figure *",
				"Write: *",
				"Wpicker",
				"Mathpix Snipping Tool",
			},
			role = { "AlarmWindow", "pop-up" },
		},
		properties = { floating = true },
	},
	{
		rule_any = { type = { "normal", "dialog" } },
		properties = { titlebars_enabled = false },
	},
	{
		rule_any = { class = { "todoist", "Todoist" } },
		properties = {
			placement = awful.placement.top_right + awful.placement.stretch_down,
			width = dpi(420),
		},
	},
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	if not awesome.startup then
		awful.client.setslave(c)
	end
	if not awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		awful.placement.no_offscreen(c)
		--awful.placement.no_overlap(c)
	end
	-- Uncomment for rounded corners
	-- c.shape = gears.shape.rounded_rect
	if c.maximized then
		c.border_width = 0
		-- Uncomment for rounded corners
		-- c.shape = gears.shape.rect
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			client.focus = c
			c:raise()
			awful.mouse.client.move(c)
		end),
		-- awful.button({  }, 2, function() end),
		awful.button({}, 3, function()
			client.focus = c
			if c.maximized then
				c.maximized = false
			end
			c:raise()
			awful.mouse.client.resize(c)
		end)
		--awful.button({  }, 4, function(c) end),
		--awful.button({  }, 5, function(c) end)
	)
	awful
		.titlebar(c, {
			size = dpi(16),
			position = "top",
		})
		:setup({
			{
				-- Left
				layout = wibox.layout.fixed.horizontal,
				awful.titlebar.widget.closebutton(c), -- RED
				awful.titlebar.widget.minimizebutton(c), -- YELLOW
				awful.titlebar.widget.maximizedbutton(c), -- GREEN
				-- awful.titlebar.widget.floatingbutton (c),
				-- awful.titlebar.widget.ontopbutton    (c),
				-- awful.titlebar.widget.stickybutton   (c),
			},
			{
				-- Middle
				buttons = buttons,
				layout = wibox.layout.flex.horizontal,
			},
			{
				-- Right
				buttons = buttons,
				layout = wibox.layout.fixed.horizontal(),
			},
			layout = wibox.layout.align.horizontal,
		})
end)

-- Remove border when maximized
client.connect_signal("property::maximized", function(c)
	if c.maximized then
		c.border_width = 0
		-- Uncomment for rounded corners
		-- c.shape = gears.shape.rect
	else
		c.border_width = beautiful.border_width
		-- Uncomment for rounded corners
		-- c.shape = gears.shape.rounded_rect
	end
end)

-- Change border color
client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- Notification styling (naughty v1 API — this AwesomeWM version predates
-- the declarative "request::display"/naughty.layout.box template API).
-- Most fields (bg/fg/font/border/margin/icon_size/shape/...) are already
-- read automatically from beautiful.notification_* in gruvbox-theme.lua;
-- only per-urgency accents and icon-name resolution need setting here.
local menubar = require("menubar")

naughty.config.presets.low.border_color = beautiful.notification_border_color
naughty.config.presets.normal.border_color = beautiful.notification_border_color
naughty.config.presets.critical.bg = beautiful.notification_bg
naughty.config.presets.critical.fg = beautiful.colors.white
naughty.config.presets.critical.border_color = beautiful.colors.red
naughty.config.presets.critical.border_width = dpi(2)
naughty.config.presets.critical.timeout = 8

-- Apps like Teams send a bare icon-theme name over dbus (e.g.
-- "teams-for-linux"), not a file path; resolve it against the icon theme.
naughty.config.notify_callback = function(args)
	if args.icon and type(args.icon) == "string" and not args.icon:match("^/") then
		args.icon = menubar.utils.lookup_icon(args.icon) or args.icon
	end
	return args
end

gears.timer.start_new(10, function()
	collectgarbage("step", 20000)
	return true
end)
