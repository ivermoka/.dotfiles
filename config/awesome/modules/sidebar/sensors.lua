local gears     = require("gears")
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful") 
local dpi       = require("beautiful.xresources").apply_dpi

local helpers   = require("modules.sidebar.helpers")

-- Sensors widget template
local function new_sensors_text_widget(init_text)
    return wibox.widget {
    align         = 'center',
    text          = init_text,
    font          = beautiful.si_temp_font or beautiful.font,
    widget        = wibox.widget.textbox,
    forced_height = dpi(24)
}
end

local cpu_widget = new_sensors_text_widget("CPU temp: +..°C")
local gpu_widget = new_sensors_text_widget("GPU temp: +..°C")

local function cpu_update()
    local command = [[sensors k10temp-pci-00c3 -u]]

    awful.spawn.easy_async(command, function(stdout)
        local cpu = stdout:match("temp1_input:%s*([%d.]+)")
        if cpu then
            cpu_widget:set_text(string.format("CPU temp: +%.0f°C", tonumber(cpu)))
        end
    end)
end

local function gpu_update()
    local command = [[sensors amdgpu-pci-c300 -u]]

    awful.spawn.easy_async(command, function(stdout)
        local gpu = stdout:match("temp1_input:%s*([%d.]+)")
        if gpu then
            gpu_widget:set_text(string.format("GPU temp: +%.0f°C", tonumber(gpu)))
        end
    end)
end

local function update()
    cpu_update()
    gpu_update()
end

return {
    widget = helpers.add_label("", {
            cpu_widget,
            gpu_widget,
            layout = wibox.layout.fixed.vertical,
        }, 20),
    update = update,
}
