local beautiful = require("beautiful")
local settings = {}

-- Put there only apps which you need to start with awesome
-- If you looking for way to start applications with X you
-- can use ~/.xprofile file.
-- Read more: https://wiki.archlinux.org/index.php/Xprofile
-- { command, rule }: skipped if a window matching rule already exists.
settings.autostart = {
	{ "alacritty", { class = "Alacritty" } },
	{
		"/opt/microsoft/msedge/microsoft-edge --profile-directory=Default --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo --app-url=https://teams.microsoft.com/v2/?clientType=pwa",
		{ instance = "crx__cifhbcnohmdccbgoicgdjpfamggdegmo" },
	},
}

settings.default_apps = {
	terminal = "alacritty",
}

settings.battery = {
	show_current_level = true,
	timeout = 30,
	path_to_icons = "/usr/share/icons/Adwaita/symbolic/status/",
	warning_msg_title = "Low battery",
	warning_msg_text = "Battery below 15%. Connect the charger.",
}

settings.resources = {
	cpu = { timeout = 5, width = 40, enable_kill_button = false },
	ram = {
		timeout = 10,
		widget_height = 18,
		widget_width = 18,
		color_used = beautiful.colors.aqua,
		color_free = beautiful.colors.darkGrey,
		color_buf = beautiful.colors.grey,
	},
	filesystem = {
		mounts = { "/" },
		refresh_rate = 60,
		widget_width = 40,
		widget_bar_color = beautiful.colors.aqua,
		widget_background_color = beautiful.colors.darkGrey,
		popup_bg = beautiful.bg_normal,
		popup_bar_color = beautiful.colors.aqua,
		popup_border_color = beautiful.colors.grey,
	},
}

-- Apps launched with Super+F<n> (keep under 7, F7 is the display menu) and listed in the main menu.
settings.launcher = {
	"microsoft-edge",
	"nautilus",
	"pavucontrol",
	"arandr",
	"nm-connection-editor",
}

-- Put here command which will lock your computer.
settings.lock_command = "i3lock -c 000000"

-- Put here commands for volume control.
-- Uses wpctl (WirePlumber CLI) since this system runs PipeWire without the
-- pulseaudio-alsa compat plugin, so `amixer -D pulse` fails outright.
settings.volume_commands = {
	GET_VOL_CMD = "wpctl get-volume @DEFAULT_AUDIO_SINK@",
	SET_VOL_CMD = "wpctl set-volume @DEFAULT_AUDIO_SINK@ ",
	TOG_VOL_CMD = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
}

-- Change this command, if you use another player.
-- This commands are for spotify.
settings.player_commands = {
	GET_TRACK_CMD = [[sleep 0.1; dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | grep -Eo '("(.*)")|(\b[0-9][a-zA-Z0-9.]*\b)' | grep -E "(title)|(artist)" -A 1 | tr -d '"' | grep -v : | tr -d '\n' | sed 's/--/ - /']],

	PREV_TRACK_CMD = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous",
	TOGGLE_TRACK_CMD = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause",
	NEXT_TRACK_CMD = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next",
}

return settings
