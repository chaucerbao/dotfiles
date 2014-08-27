local hotkey = core.hotkey
local mods = {"cmd", "alt"}

-- Return the focused window/screen
function focused()
	local window = core.window.focusedwindow()
	local screen = window:screen()

	return {
		['windowObject'] = window,
		['screenObject'] = screen,
		['window'] = window:frame(),
		['screen'] = screen:frame_without_dock_or_menu()
	}
end

-- Move the focused window to different locations
function moveTo(target)
	local focused = focused()
	local x, y, toScreen

	if target == 1 then
		-- Quadrant 1 (Top-left)
		x = focused.screen.x
		y = focused.screen.y
	elseif target == 2 then
		-- Quadrant 2 (Top-right)
		x = focused.screen.x + focused.screen.w - focused.window.w
		y = focused.screen.y
	elseif target == 3 then
		-- Quadrant 3 (Bottom-right)
		x = focused.screen.x + focused.screen.w - focused.window.w
		y = focused.screen.y + focused.screen.h - focused.window.h
	elseif target == 4 then
		-- Quadrant 4 (Bottom-left)
		x = focused.screen.x
		y = focused.screen.y + focused.screen.h - focused.window.h
	elseif target == 'center' then
		-- Center
		x = focused.screen.x + (focused.screen.w - focused.window.w) / 2
		y = focused.screen.y + (focused.screen.h - focused.window.h) / 2
	elseif target == 'nextScreen' or target == 'previousScreen' then
		-- Previous/next screen
		if target == 'nextScreen' then toScreen = focused.screenObject:next():frame_without_dock_or_menu()
		else toScreen = focused.screenObject:previous():frame_without_dock_or_menu() end
		x = toScreen.x + (focused.window.x - focused.screen.x) / focused.screen.w * toScreen.w
		y = toScreen.y + (focused.window.y - focused.screen.y) / focused.screen.h * toScreen.h
	end

	focused.windowObject:settopleft({x = x, y = y})
end

-- Expand the focused window to fit the entire screen
function fullscreen()
	local focused = focused()
	local screen = focused.screen

	focused.windowObject:setframe({x = screen.x, y = screen.y, w = screen.w, h = screen.h})
end

-- Resize the focused window, snapping to an invisible 8x8 grid
function snapResize(dimension, count)
	local focused = focused()
	local tiles = {["wide"] = 8, ["high"] = 8}
	local w, h

	if (dimension == 'w') then
		w = breakpoint(focused.screen.w, focused.window.w, tiles.wide, count)
		h = focused.window.h
	elseif (dimension == 'h') then
		w = focused.window.w
		h = breakpoint(focused.screen.h, focused.window.h, tiles.high, count)
	end

	focused.windowObject:setsize({w = w, h = h})
end

function breakpoint(screenSize, windowSize, tiles, count)
	local tileSize = screenSize / tiles
	local units = windowSize / tileSize

	if (count > 0) then
		units = math.min(math.floor(units + .1), tiles - 1)
	else
		units = math.max(math.ceil(units - .1), 2)
	end

	return (units + count) * tileSize
end

-- Hotkey bindings
hotkey.bind(mods, "1", function() moveTo(1) end)
hotkey.bind(mods, "2", function() moveTo(2) end)
hotkey.bind(mods, "3", function() moveTo(3) end)
hotkey.bind(mods, "4", function() moveTo(4) end)
hotkey.bind(mods, "C", function() moveTo('center') end)
hotkey.bind(mods, "]", function() moveTo('nextScreen') end)
hotkey.bind(mods, "[", function() moveTo('previousScreen') end)
hotkey.bind(mods, "RIGHT", function() snapResize('w', 1) end)
hotkey.bind(mods, "LEFT", function() snapResize('w', -1) end)
hotkey.bind(mods, "DOWN", function() snapResize('h', 1) end)
hotkey.bind(mods, "UP", function() snapResize('h', -1) end)
hotkey.bind(mods, "F", fullscreen)
hotkey.bind(mods, "R", core.reload)

print "Config successfully loaded"
