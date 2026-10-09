local awful = require("awful")
local tyrannical = require("tyrannical")

-- {{{ Tyrannical (grouped application tagging)
-- https://github.com/Elv13/tyrannical
-- Fixed groups prevent unmatched applications from creating per-class tags.
-- Edit the "class"/"instance" lists below to match the apps you actually use.

tyrannical.settings.default_layout = awful.layout.suit.tile
tyrannical.settings.master_width_factor = 0.66
tyrannical.settings.group_children = true -- popups/dialogs inherit the parent's tags
tyrannical.settings.block_children_focus_stealing = true -- block popups from stealing focus

tyrannical.tags = {
    {
        name = "Term", -- Call the tag "Term"
        index = 1,
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
        index = 2,
        init = true,
        exclusive = true,
        -- icon = "~net.png", -- Use this icon for the tag (uncomment with a real path)
        screen = 2, -- Screen 2 if it exists, else the last screen (clamped by patched tyrannical)
        layout = awful.layout.suit.max, -- Use the max layout
        class = {
            "microsoft-edge",
            "Firefox",
        },
    },
    {
        name = "Work",
        index = 3,
        init = true,
        exclusive = true,
        screen = 1,
        layout = awful.layout.suit.max,
        class = {
            "gnome-text-editor",
            "org.gnome.TextEditor",
            "org.remmina.Remmina",
            "Code",
            "jetbrains-idea",
            "jetbrains-idea-ce",
            "Assistant",
            "Okular",
            "Evince",
            "org.gnome.Evince",
            "EPDFviewer",
            "xpdf",
        },
    },
    {
        name = "Teams",
        index = 4,
        init = true,
        exclusive = true,
        -- icon = "~net.png", -- Use this icon for the tag (uncomment with a real path)
        screen = 2, -- Screen 2 if it exists, else the last screen (clamped by patched tyrannical)
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
        index = 5,
        init = true,
        exclusive = true,
        screen = 1,
        layout = awful.layout.suit.tile,
        -- exec_once = { "dolphin" }, -- When the tag is accessed for the first time, execute this command
        class = {
            "org.gnome.Nautilus",
        },
    },
    {
        name = "Media",
        index = 6,
        init = true,
        exclusive = true,
        screen = 2,
        layout = awful.layout.suit.max,
        class = {
            "Spotify",
            "vlc",
            "mpv",
        },
    },
    {
        name = "Misc",
        index = 7,
        init = true,
        exclusive = true,
        fallback = true,
        screen = { 1, 2 },
        layout = awful.layout.suit.max,
        class = {
            "intune-portal",
            "Drawing",
            "zenity",
            "pavucontrol",
            "Nm-connection-editor",
            "Arandr",
            "Lxappearance",
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

return tyrannical
