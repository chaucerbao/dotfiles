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
	local window = focused.window
	local screen = focused.screen
	local x, y, toScreen

	if target == 1 then
		-- Quadrant 1 (Top-left)
		x = screen.x
		y = screen.y
	elseif target == 2 then
		-- Quadrant 2 (Top-right)
		x = screen.x + screen.w - window.w
		y = screen.y
	elseif target == 3 then
		-- Quadrant 3 (Bottom-right)
		x = screen.x + screen.w - window.w
		y = screen.y + screen.h - window.h
	elseif target == 4 then
		-- Quadrant 4 (Bottom-left)
		x = screen.x
		y = screen.y + screen.h - window.h
	elseif target == 'center' then
		-- Center
		x = screen.x + (screen.w - window.w) / 2
		y = screen.y + (screen.h - window.h) / 2
	elseif target == 'nextScreen' or target == 'previousScreen' then
		-- Previous/next screen
		if target == 'nextScreen' then toScreen = focused.screenObject:next():frame_without_dock_or_menu()
		else toScreen = focused.screenObject:previous():frame_without_dock_or_menu() end
		x = toScreen.x + (window.x - screen.x) / screen.w * toScreen.w
		y = toScreen.y + (window.y - screen.y) / screen.h * toScreen.h
	end

	focused.windowObject:settopleft({x = x, y = y})
end

-- Resize the focused window to preset sizes
function resizeTo(target)
	local focused = focused()
	local window = focused.window
	local screen = focused.screen
	local x, y, w, h

	if target == 'full' then
		x = screen.x
		y = screen.y
		w = screen.w
		h = screen.h
	elseif target == 'quarter' then
		w = screen.w / 2
		h = screen.h / 2
		if (window.x - screen.x + w > screen.w) then x = screen.x + screen.w - w
		else x = window.x end
		if (window.y - screen.y + h > screen.h) then y = screen.y + screen.h - h
		else y = window.y end
	end

	focused.windowObject:setframe({x = x, y = y, w = w, h = h})
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
hotkey.bind(mods, "F", function() resizeTo('full') end)
hotkey.bind(mods, "Q", function() resizeTo('quarter') end)
hotkey.bind(mods, "R", core.reload)

print "Config successfully loaded"
