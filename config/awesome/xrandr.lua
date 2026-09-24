--- Separating Multiple Monitor functions as a separeted module (taken from awesome wiki)

local gtable = require("gears.table")
local gshape = require("gears.shape")
local spawn = require("awful.spawn")
local naughty = require("naughty")
local awful_menu = require("awful.menu")
local awful_screen = require("awful.screen")
local beautiful = require("beautiful")

-- A path to a fancy icon
local icon_path = ""

-- Get active outputs
local function outputs()
	local outputs = {}
	local xrandr = io.popen("xrandr -q --current")

	if xrandr then
		for line in xrandr:lines() do
			local output = line:match("^([%w-]+) connected ")
			if output then
				outputs[#outputs + 1] = output
			end
		end
		xrandr:close()
	end

	return outputs
end

local function arrange(out)
	-- We need to enumerate all permutations of horizontal outputs.

	local choices = {}
	local previous = { {} }
	for i = 1, #out do
		-- Find all permutation of length `i`: we take the permutation
		-- of length `i-1` and for each of them, we create new
		-- permutations by adding each output at the end of it if it is
		-- not already present.
		local new = {}
		for _, p in pairs(previous) do
			for _, o in pairs(out) do
				if not gtable.hasitem(p, o) then
					new[#new + 1] = gtable.join(p, { o })
				end
			end
		end
		choices = gtable.join(choices, new)
		previous = new
	end

	return choices
end

-- Build available choices
local function menu()
	local menu = {}
	local out = outputs()
	local choices = arrange(out)

	for _, choice in pairs(choices) do
		local cmd = "xrandr"
		-- Enabled outputs
		for i, o in pairs(choice) do
			cmd = cmd .. " --output " .. o .. " --auto"
			if i > 1 then
				cmd = cmd .. " --right-of " .. choice[i - 1]
			end
		end
		-- Disabled outputs
		for _, o in pairs(out) do
			if not gtable.hasitem(choice, o) then
				cmd = cmd .. " --output " .. o .. " --off"
			end
		end

		local label = ""
		if #choice == 1 then
			label = 'Only <span weight="bold">' .. choice[1] .. "</span>"
		else
			for i, o in pairs(choice) do
				if i > 1 then
					label = label .. " + "
				end
				label = label .. '<span weight="bold">' .. o .. "</span>"
			end
		end

		menu[#menu + 1] = { label, cmd }
	end

	return menu
end

-- Display xrandr notifications from choices
local state = { cid = nil }

local function naughty_destroy_callback(reason)
	if
		reason == naughty.notificationClosedReason.expired
		or reason == naughty.notificationClosedReason.dismissedByUser
	then
		local action = state.index and state.menu[state.index - 1][2]
		if action then
			spawn(action, false)
			state.index = nil
		end
	end
end

local function xrandr()
	-- Build the list of choices
	if not state.index then
		state.menu = menu()
		state.index = 1
	end

	-- Select one and display the appropriate notification
	local label, action
	local next = state.menu[state.index]
	state.index = state.index + 1

	if not next then
		label = "Keep the current configuration"
		state.index = nil
	else
		label, action = next[1], next[2]
	end
	state.cid = naughty.notify({
		text = label,
		icon = icon_path,
		timeout = 4,
		screen = mouse.screen,
		replaces_id = state.cid,
		destroy = naughty_destroy_callback,
	}).id
end

-- Show a real clickable popup listing every output arrangement, instead of
-- the fragile "press the key repeatedly to cycle notifications" approach.
local menu_instance = nil

local function popup()
	-- Check wibox.visible (not just nil) since the menu can also close
	-- itself via Escape or item selection, leaving a stale reference.
	if menu_instance and menu_instance.wibox.visible then
		menu_instance:hide()
		return
	end

	local items = {}
	for _, choice in ipairs(menu()) do
		local label, cmd = choice[1], choice[2]
		-- awful.menu escapes its label text (only supports "&x" mnemonics,
		-- not pango markup), so strip the <span> tags meant for naughty.
		label = label:gsub("</?span[^>]*>", "")
		items[#items + 1] = {
			label,
			function()
				spawn(cmd, false)
			end,
		}
	end

	if #items == 0 then
		naughty.notify({ text = "xrandr: no outputs detected", timeout = 4 })
		return
	end

	menu_instance = awful_menu({ items = items })

	-- Position top-right, same corner and padding as naughty notifications.
	local scr = awful_screen.focused()
	local wa = scr.workarea
	local padding = naughty.config.padding or 4
	local width = beautiful.menu_width or 220
	menu_instance:show({ coords = { x = wa.x + wa.width - width - padding, y = wa.y + padding } })

	menu_instance.wibox.shape = function(cr, w, h)
		gshape.rounded_rect(cr, w, h, 8)
	end
	menu_instance.wibox.opacity = 0.95
	-- Highlight the first entry immediately so arrow-key navigation has
	-- visible focus right away instead of requiring an initial keypress.
	menu_instance:item_enter(1)
end

return {
	outputs = outputs,
	arrange = arrange,
	menu = menu,
	xrandr = xrandr,
	popup = popup,
}
