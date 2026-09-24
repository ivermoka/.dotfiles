--[[

     Awesome WM configuration template
     github.com/lcpz

--]]

-- {{{ Required libraries

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local lain = require("lain")
local menubar = require("menubar")
local freedesktop = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local mytable = awful.util.table or gears.table -- 4.{0,1} compatibility
local tyrannical = require("tyrannical")

-- Custom modules
local xrandr = require("xrandr")
require("startup")

-- }}}

-- {{{ Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false

	awesome.connect_signal("debug::error", function(err)
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

-- }}}

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
	for _, cmd in ipairs(cmd_arr) do
		awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
	end
end

run_once({ "urxvtd", "unclutter -root" }) -- comma-separated entries

-- {{{ Variable definitions
local modkey = "Mod4"
local altkey = "Mod1"
local terminal = "alacritty"
local vi_focus = false -- vi-like client focus https://github.com/lcpz/awesome-copycats/issues/275
local cycle_prev = true -- cycle with only the previously focused client or all https://github.com/lcpz/awesome-copycats/issues/274
local editor = os.getenv("EDITOR") or "nvim"
local browser = "microsoft-edge"
local scrlocker = "i3lock -c 000000"

awful.util.terminal = terminal
awful.layout.layouts = {
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	--awful.layout.suit.fair,
	--awful.layout.suit.fair.horizontal,
	--awful.layout.suit.spiral,
	--awful.layout.suit.spiral.dwindle,
	--awful.layout.suit.max,
	--awful.layout.suit.max.fullscreen,
	--awful.layout.suit.magnifier,
	--awful.layout.suit.corner.nw,
	--awful.layout.suit.corner.ne,
	--awful.layout.suit.corner.sw,
	--awful.layout.suit.corner.se,
	--lain.layout.cascade,
	--lain.layout.cascade.tile,
	--lain.layout.centerwork,
	--lain.layout.centerwork.horizontal,
	--lain.layout.termfair,
	--lain.layout.termfair.center
}

lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
lain.layout.cascade.tile.offset_x = 2
lain.layout.cascade.tile.offset_y = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster = 5
lain.layout.cascade.tile.ncol = 2

awful.util.taglist_buttons = mytable.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
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

awful.util.tasklist_buttons = mytable.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

beautiful.init(string.format("%s/.config/awesome/theme/theme.lua", os.getenv("HOME")))
beautiful.useless_gap = 2

-- }}}

-- {{{ Naughty notifications
-- Theme-consistent, rounded notifications with a subtle per-urgency accent
-- border instead of a full-bleed color fill, plus icon-theme-name resolution
-- (apps like Teams send a bare icon name over dbus, not a file path).
local dpi = require("beautiful.xresources").apply_dpi

-- Match the system GTK icon theme so icon-name lookups (e.g. Teams sends
-- "teams-for-linux", not a file path) also search it, not just the sparser
-- "hicolor" fallback theme. Must run before any icon lookup happens, since
-- menubar.utils caches the lookup path for the whole session.
do
	local f = io.popen("gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null")
	if f then
		local name = f:read("*l")
		f:close()
		if name then
			beautiful.icon_theme = name:match("^'(.-)'$") or name
		end
	end
end

naughty.config.defaults.margin = dpi(12)
naughty.config.defaults.border_width = dpi(2)
naughty.config.defaults.icon_size = dpi(48)
naughty.config.defaults.opacity = 0.95
naughty.config.defaults.shape = function(cr, w, h)
	gears.shape.rounded_rect(cr, w, h, dpi(8))
end

naughty.config.notify_callback = function(args)
	if args.icon and type(args.icon) == "string" and not args.icon:match("^/") then
		args.icon = menubar.utils.lookup_icon(args.icon) or args.icon
	end
	return args
end

-- naughty.dbus captures references to these preset tables at require-time
-- (before this file runs), so mutate their fields in place rather than
-- replacing the tables, or dbus-sourced notifications (Teams, etc.) won't
-- pick up the changes.
local function style_preset(preset, overrides)
	for k, v in pairs(overrides) do
		preset[k] = v
	end
end

style_preset(naughty.config.presets.normal, {
	bg = beautiful.bg_focus,
	fg = beautiful.fg_normal,
	border_color = beautiful.border_focus,
})
style_preset(naughty.config.presets.low, {
	bg = beautiful.bg_focus,
	fg = beautiful.fg_normal,
	border_color = beautiful.border_normal,
})
style_preset(naughty.config.presets.critical, {
	bg = beautiful.bg_focus,
	fg = beautiful.fg_normal,
	border_color = beautiful.fg_urgent,
	border_width = dpi(1),
	timeout = 8,
})

-- awful.menu popups (e.g. the xrandr output picker): match the same dark,
-- accented look as the notifications above.
beautiful.menu_bg_normal = beautiful.bg_focus
beautiful.menu_fg_normal = beautiful.fg_normal
beautiful.menu_bg_focus = beautiful.bg_focus
beautiful.menu_fg_focus = beautiful.fg_normal
beautiful.menu_border_color = beautiful.border_normal
beautiful.menu_border_width = dpi(2)
beautiful.menu_height = dpi(28)
beautiful.menu_width = dpi(220)
-- }}}

-- {{{ Tyrannical (dynamic, per-class tagging)
-- https://github.com/Elv13/tyrannical
-- Tags are created on demand from client rules instead of being static.
-- Edit the "class"/"instance" lists below to match the apps you actually use.

tyrannical.settings.default_layout = awful.layout.suit.tile
tyrannical.settings.master_width_factor = 0.66
tyrannical.settings.group_children = true -- popups/dialogs inherit the parent's tags
tyrannical.settings.block_children_focus_stealing = true -- block popups from stealing focus

tyrannical.tags = {
	{
		name = "Term", -- Call the tag "Term"
		init = true, -- Load the tag on startup
		exclusive = true, -- Refuse any other type of clients (by classes)
		screen = { 1, 2 }, -- Create this tag on screen 1 and screen 2
		layout = awful.layout.suit.tile, -- Use the tile layout
		instance = { "dev", "ops" }, -- Accept the following instances. This takes precedence over 'class'
		class = { -- Accept the following classes, refuse everything else (because of "exclusive=true")
			"Alacritty",
			"xterm",
			"urxvt",
			"aterm",
			"URxvt",
			"XTerm",
			"konsole",
			"terminator",
			"gnome-terminal",
		},
	},
	{
		name = "Internet",
		init = true,
		exclusive = true,
		-- icon = "~net.png",                 -- Use this icon for the tag (uncomment with a real path)
		screen = screen.count() > 1 and 2 or 1, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
		layout = awful.layout.suit.max, -- Use the max layout
		class = {
			"microsoft-edge",
			"Firefox",
		},
	},
	{
		name = "Teams",
		init = true,
		exclusive = true,
		-- icon = "~net.png",                 -- Use this icon for the tag (uncomment with a real path)
		screen = screen.count() > 1 and 2 or 1, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
		layout = awful.layout.suit.max, -- Use the max layout
		-- Teams runs as an Edge PWA: WM_CLASS is just "Microsoft-edge" for
		-- every Edge window, but WM_INSTANCE is the app's unique
		-- crx__<id>, so match on instance (checked first, takes
		-- precedence over class). Verify with: xprop | grep WM_CLASS.
		instance = { "crx__cifhbcnohmdccbgoicgdjpfamggdegmo" },
		class = {
			"Microsoft Teams",
			"teams-for-linux",
		},
	},
	{
		name = "Files",
		init = false,
		exclusive = true,
		screen = 1,
		layout = awful.layout.suit.tile,
		-- exec_once = { "dolphin" }, -- When the tag is accessed for the first time, execute this command
		class = {
			"org.gnome.Nautilus",
		},
	},
	{
		name = "Doc",
		init = false, -- This tag wont be created at startup, but will be when one of the
		-- client in the "class" section will start. It will be created on
		-- the client startup screen
		exclusive = true,
		layout = awful.layout.suit.max,
		class = {
			"Assistant",
			"Okular",
			"Evince",
			"EPDFviewer",
			"xpdf",
			"Xpdf",
		},
	},
	{
		name = "intune",
		init = true,
		exclusive = true,
		layout = awful.layout.suit.max,
		class = {
			"intune-portal",
		},
	},
}

-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {
	"ksnapshot",
	"pinentry",
	"gtksu",
	"kcalc",
	"xcalc",
	"feh",
	"Gradient editor",
	"About KDE",
	"Paste Special",
	"Background color",
	"kcolorchooser",
	"plasmoidviewer",
	"Xephyr",
	"kruler",
	"plasmaengineexplorer",
}

-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {
	"MPlayer",
	"pinentry",
	"ksnapshot",
	"gtksu",
	"xine",
	"feh",
	"kmix",
	"kcalc",
	"xcalc",
	"yakuake",
	"Select Color$",
	"kruler",
	"kcolorchooser",
	"Paste Special",
	"New Form",
	"Insert Picture",
	"kcharselect",
	"mythfrontend",
	"plasmoidviewer",
}

-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {
	"Xephyr",
	"ksnapshot",
	"kruler",
}

-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.placement = {
	kcalc = awful.placement.centered,
}

-- }}}

-- {{{ Menu

-- Create a launcher widget and a main menu
local myawesomemenu = {
	{
		"Hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "Manual", string.format("%s -e man awesome", terminal) },
	{ "Edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
	{ "Restart", awesome.restart },
	{
		"Quit",
		function()
			awesome.quit()
		end,
	},
}

awful.util.mymainmenu = freedesktop.menu.build({
	after = {
		{ "Open terminal", terminal },
		{ "Sleep", "systemctl suspend" },
		{ "Reboot", "systemctl reboot" },
		{ "Shutdown", "systemctl poweroff" },
		{
			"XRandr menu",
			function()
				xrandr.popup()
			end,
		},
		-- other triads can be put here
	},
})

-- Set the Menubar terminal for applications that require it
menubar.utils.terminal = terminal

-- }}}

-- {{{ Screen

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function(s)
	local only_one = #s.tiled_clients == 1
	for _, c in pairs(s.clients) do
		if only_one and not c.floating or c.maximized or c.fullscreen then
			c.border_width = 0
		else
			c.border_width = beautiful.border_width
		end
	end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
	beautiful.at_screen_connect(s)
end)

-- {{{ Key bindings

globalkeys = mytable.join(
	-- Clickable popup listing every output arrangement (click one to apply)
	awful.key({ altkey }, "±", function()
		xrandr.popup()
	end, { description = "xrandr menu", group = "hotkeys" }),
	-- Destroy all notifications
	awful.key({ "Control" }, "space", function()
		naughty.destroy_all_notifications()
		naughty.notify({
			title = "Notifications cleared",
			text = "All notifications have been destroyed",
			timeout = 5,
		})
	end, { description = "destroy all notifications", group = "hotkeys" }),
	-- Take a screenshot
	-- https://github.com/lcpz/dots/blob/master/bin/screenshot
	awful.key({ altkey }, "p", function()
		os.execute("screenshot")
	end, { description = "take a screenshot", group = "hotkeys" }),

	-- X screen locker
	awful.key({ altkey, "Control" }, "l", function()
		awful.spawn(scrlocker)
	end, { description = "lock screen", group = "hotkeys" }),
	awful.key({ modkey }, "l", function()
		awful.spawn(scrlocker)
	end, { description = "lock screen", group = "hotkeys" }),

	-- Show help
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),

	-- Tag browsing
	awful.key({ modkey }, ",", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, ".", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

	-- Non-empty tag browsing
	awful.key({ altkey }, "Left", function()
		lain.util.tag_view_nonempty(-1)
	end, { description = "view  previous nonempty", group = "tag" }),
	awful.key({ altkey }, "Right", function()
		lain.util.tag_view_nonempty(1)
	end, { description = "view  previous nonempty", group = "tag" }),

	-- Default client focus
	awful.key({ altkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),
	awful.key({ altkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),

	-- By-direction client focus
	awful.key({ modkey }, "j", function()
		awful.client.focus.global_bydirection("down")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus down", group = "client" }),
	awful.key({ modkey }, "k", function()
		awful.client.focus.global_bydirection("up")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus up", group = "client" }),
	awful.key({ modkey }, "h", function()
		awful.client.focus.global_bydirection("left")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus left", group = "client" }),
	awful.key({ modkey }, "Right", function()
		awful.client.focus.global_bydirection("right")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus right", group = "client" }),

	-- Menu
	awful.key({ modkey }, "w", function()
		awful.util.mymainmenu:show()
	end, { description = "show main menu", group = "awesome" }),

	-- Layout manipulation
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),
	awful.key({ modkey, "Control" }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),
	awful.key({ modkey, "Control" }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
	awful.key({ modkey }, "Tab", function()
		if cycle_prev then
			awful.client.focus.history.previous()
		else
			awful.client.focus.byidx(-1)
		end
		if client.focus then
			client.focus:raise()
		end
	end, { description = "cycle with previous/go back", group = "client" }),

	-- Show/hide wibox
	awful.key({ modkey }, "b", function()
		for s in screen do
			s.mywibox.visible = not s.mywibox.visible
			if s.mybottomwibox then
				s.mybottomwibox.visible = not s.mybottomwibox.visible
			end
		end
	end, { description = "toggle wibox", group = "awesome" }),

	-- On-the-fly useless gaps change
	awful.key({ altkey, "Control" }, "+", function()
		lain.util.useless_gaps_resize(1)
	end, { description = "increment useless gaps", group = "tag" }),
	awful.key({ altkey, "Control" }, "-", function()
		lain.util.useless_gaps_resize(-1)
	end, { description = "decrement useless gaps", group = "tag" }),

	-- Dynamic tagging
	awful.key({ modkey, "Shift" }, "n", function()
		lain.util.add_tag()
	end, { description = "add new tag", group = "tag" }),
	awful.key({ modkey, "Shift" }, "r", function()
		lain.util.rename_tag()
	end, { description = "rename tag", group = "tag" }),
	awful.key({ modkey, "Shift" }, "Left", function()
		lain.util.move_tag(-1)
	end, { description = "move tag to the left", group = "tag" }),
	awful.key({ modkey, "Shift" }, "Right", function()
		lain.util.move_tag(1)
	end, { description = "move tag to the right", group = "tag" }),
	awful.key({ modkey, "Shift" }, "d", function()
		lain.util.delete_tag()
	end, { description = "delete tag", group = "tag" }),

	-- Standard program
	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

	awful.key({ modkey, altkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ modkey, altkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),
	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),
	awful.key({ modkey }, "space", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),
	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),

	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),

	-- Dropdown application
	awful.key({ modkey }, "z", function()
		awful.screen.focused().quake:toggle()
	end, { description = "dropdown application", group = "launcher" }),

	-- Widgets popups
	awful.key({ altkey }, "c", function()
		if beautiful.cal then
			beautiful.cal.show(7)
		end
	end, { description = "show calendar", group = "widgets" }),
	awful.key({ altkey }, "h", function()
		if beautiful.fs then
			beautiful.fs.show(7)
		end
	end, { description = "show filesystem", group = "widgets" }),
	awful.key({ altkey }, "w", function()
		if beautiful.weather then
			beautiful.weather.show(7)
		end
	end, { description = "show weather", group = "widgets" }),

	-- Screen brightness
	awful.key({}, "XF86MonBrightnessUp", function()
		os.execute("xbacklight -inc 10")
	end, { description = "+10%", group = "hotkeys" }),
	awful.key({}, "XF86MonBrightnessDown", function()
		os.execute("xbacklight -dec 10")
	end, { description = "-10%", group = "hotkeys" }),

	-- ALSA volume control
	awful.key({ altkey }, "Up", function()
		os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
		beautiful.volume.update()
	end, { description = "volume up", group = "hotkeys" }),
	awful.key({ altkey }, "Down", function()
		os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
		beautiful.volume.update()
	end, { description = "volume down", group = "hotkeys" }),
	awful.key({ altkey }, "m", function()
		os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
		beautiful.volume.update()
	end, { description = "toggle mute", group = "hotkeys" }),
	awful.key({ altkey, "Control" }, "m", function()
		os.execute(string.format("amixer -q set %s 100%%", beautiful.volume.channel))
		beautiful.volume.update()
	end, { description = "volume 100%", group = "hotkeys" }),
	awful.key({ altkey, "Control" }, "0", function()
		os.execute(string.format("amixer -q set %s 0%%", beautiful.volume.channel))
		beautiful.volume.update()
	end, { description = "volume 0%", group = "hotkeys" }),

	-- Hardware volume keys
	awful.key({}, "XF86AudioRaiseVolume", function()
		os.execute(string.format("amixer -q set %s 5%%+", beautiful.volume.channel))
		beautiful.volume.update()
	end, { description = "volume up", group = "hotkeys" }),
	awful.key({}, "XF86AudioLowerVolume", function()
		os.execute(string.format("amixer -q set %s 5%%-", beautiful.volume.channel))
		beautiful.volume.update()
	end, { description = "volume down", group = "hotkeys" }),
	awful.key({}, "XF86AudioMute", function()
		os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
		beautiful.volume.update()
	end, { description = "toggle mute", group = "hotkeys" }),
	awful.key({}, "F9", function()
		os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
		beautiful.volume.update()
	end, { description = "toggle mute", group = "hotkeys" }),

	-- MPD control
	awful.key({ altkey, "Control" }, "'", function()
		os.execute("mpc toggle")
		beautiful.mpd.update()
	end, { description = "mpc toggle", group = "widgets" }),
	awful.key({ altkey, "Control" }, "Down", function()
		os.execute("mpc stop")
		beautiful.mpd.update()
	end, { description = "mpc stop", group = "widgets" }),
	awful.key({ altkey, "Control" }, "Left", function()
		os.execute("mpc prev")
		beautiful.mpd.update()
	end, { description = "mpc prev", group = "widgets" }),
	awful.key({ altkey, "Control" }, "Right", function()
		os.execute("mpc next")
		beautiful.mpd.update()
	end, { description = "mpc next", group = "widgets" }),
	awful.key({ altkey }, "0", function()
		local common = { text = "MPD widget ", position = "top_middle", timeout = 2 }
		if beautiful.mpd.timer.started then
			beautiful.mpd.timer:stop()
			common.text = common.text .. lain.util.markup.bold("OFF")
		else
			beautiful.mpd.timer:start()
			common.text = common.text .. lain.util.markup.bold("ON")
		end
		naughty.notify(common)
	end, { description = "mpc on/off", group = "widgets" }),

	-- Copy primary to clipboard (terminals to gtk)
	awful.key({ modkey }, "c", function()
		awful.spawn.with_shell("xsel | xsel -i -b")
	end, { description = "copy terminal to gtk", group = "hotkeys" }),
	-- Copy clipboard to primary (gtk to terminals)
	awful.key({ modkey }, "v", function()
		awful.spawn.with_shell("xsel -b | xsel")
	end, { description = "copy gtk to terminal", group = "hotkeys" }),

	-- User programs
	awful.key({ modkey }, "q", function()
		awful.spawn(browser)
	end, { description = "run browser", group = "launcher" }),

	-- Default
	--[[ Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    --]]
	--[[ dmenu
    awful.key({ modkey }, "x", function ()
            os.execute(string.format("dmenu_run -i -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
            beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
        end,
        {description = "show dmenu", group = "launcher"}),
    --]]
	-- rofi: fuzzy app search/launcher (like GNOME's Activities search)
	awful.key({ modkey }, "d", function()
		awful.spawn("rofi -show drun")
	end, { description = "application launcher (search apps)", group = "launcher" }),

	-- rofi: window switcher/overview across all tags and screens
	awful.key({ modkey, "Shift" }, "Tab", function()
		awful.spawn("rofi -show window")
	end, { description = "window overview (search open windows)", group = "launcher" }),

	-- Prompt
	awful.key({ modkey }, "r", function()
		awful.screen.focused().mypromptbox:run()
	end, { description = "run prompt", group = "launcher" }),

	awful.key({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" })
	--]]
)

clientkeys = mytable.join(
	awful.key({ altkey, "Shift" }, "m", lain.util.magnify_client, { description = "magnify client", group = "client" }),
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),
	awful.key({ modkey, "Shift" }, "c", function(c)
		c:kill()
	end, { description = "close", group = "client" }),
	awful.key(
		{ modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),
	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),
	awful.key({ modkey }, "o", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),
	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),
	awful.key({ modkey }, "n", function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, { description = "minimize", group = "client" }),
	awful.key({ modkey }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" }),
	awful.key({ modkey, "Control" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, { description = "(un)maximize vertically", group = "client" }),
	awful.key({ modkey, "Shift" }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end, { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = mytable.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

clientbuttons = mytable.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)

-- }}}

-- {{{ Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			callback = awful.client.setslave,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			size_hints_honor = false,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Microsoft Teams' main window is reported with role "pop-up" (it's an
	-- Edge --app/PWA window), which would otherwise match the floating rule
	-- above. Force it back to tiled so it obeys the tag's layout.
	{
		rule = { instance = "crx__cifhbcnohmdccbgoicgdjpfamggdegmo" },
		properties = { floating = false },
	},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },

	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { screen = 1, tag = "2" } },
}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- Custom
	if beautiful.titlebar_fun then
		beautiful.titlebar_fun(c)
		return
	end

	-- Default
	-- buttons for the titlebar
	local buttons = mytable.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c, { size = 25 }):setup({
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{ -- Middle
			{ -- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	})
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = vi_focus })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- switch to parent after closing child window
local function backham()
	local s = awful.screen.focused()
	local c = awful.client.focus.history.get(s, 0)
	if c then
		client.focus = c
		c:raise()
	end
end

-- attach to minimized state
client.connect_signal("property::minimized", backham)
-- attach to closed state
client.connect_signal("unmanage", backham)
-- ensure there is always a selected client during tag switching or logins
tag.connect_signal("property::selected", backham)

-- }}}
