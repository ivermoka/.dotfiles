local awful         = require("awful")
local gears         = require("gears")
local wibox         = require("wibox")
local beautiful     = require("beautiful")

local mainmenu      = require("modules.menus.mainmenu")

local menu_button = {}

menu_button = wibox.widget{
    text = '≡',
    align  = 'center',
    valign = 'center',
    forced_width = 24,
    widget = wibox.widget.textbox
}

menu_button:buttons(gears.table.join(
        awful.button({ }, 1, function ()
            mainmenu:toggle()
        end),
        awful.button({ }, 2, function ()
            mainmenu:toggle()
        end),
        awful.button({ }, 3, function ()
            mainmenu:toggle()
        end)
    )
)

return menu_button
