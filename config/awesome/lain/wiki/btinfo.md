## What is BTinfo?

This is a small and very simple widget that probes the status of bluetooth devices, specifically for; device type, connectivity, pairing, and battery life. 

This is given by the output of `bluetoothctl info <YOUR_DEVICE>` and parsed by the widget. 

The `settings()` function should be overridden to make use of the `bt_now` variable, which has the following subfields: `icon`, `connected`, `paired`, and `percentage`.


## Usage

Other than the `settings` callback, the widget takes two optional arguments: 

* `device_mac`,  the MAC address of the device to probe. If blank, probes the default device.
* `timeout`, how often to probe. If blank, probes every 30 seconds.

```lua
local btinfo = lain.widget.contrib.btinfo({
      device = "11:22:33:44:55:66", timeout = 30,
      settings = function(bt_now)
         -- Icon type: you might need to install font-awesome to see some of glyphs here.
         local device_glyph=""
         if     bt_now.icon == "audio-headset"    then device_glyph=""
         elseif bt_now.icon == "audio-headphones" then device_glyph=""
         elseif bt_now.icon == "audio-speakers"   then device_glyph="" 
         else                                          device_glyph="?" end

         -- Info text: Make a symbol to summarize the connectivity
         local info_text = ""
         if bt_now.connected and bt_now.paired then info_text = "⧉"
         elseif bw_now.connected               then info_text = "⊚"
         else info_text = "/" end

         -- Battery text: Change the color of widget depending on battery level
         local batt_text = "?"
         local fg_color = "black"
         if     bt_now.percentage >= 90 then fg_color = "#000000"
         elseif bt_now.percentage >= 70 then fg_color = "#110000"
         elseif bt_now.percentage >= 50 then fg_color = "#330000"
         elseif bt_now.percentage >= 30 then fg_color = "#550000"
         elseif bt_now.percentage >= 20 then fg_color = "#aa0000"
         elseif bt_now.percentage >= 10 then fg_color = "#cc0000"
         else                                fg_color = "#ff0000"
         end

         -- and now we put it all together.
         widget:set_markup(markup.fontfg(theme.font, fg_color,
                                         info_text .. device_glyph ..
                                         " " .. tostring(bt_now.percentage) .. "%"))
      end
})
```

(You may need to define `theme.font` for the above example to work properly, and import `lain.util.markup`)
