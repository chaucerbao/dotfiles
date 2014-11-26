local window = require 'mjolnir.window'
local hotkey = require 'mjolnir.hotkey'
local mods = {'ctrl', 'cmd'}

function focused()
	local window = window.focusedwindow()
	local screen = window:screen()

	return {
		['app'] = window,
		['window'] = window:frame(),
		['screen'] = screen:frame()
	}
end

function moveTo(target)
	local focused = focused()
	local window = focused.window
	local screen = focused.screen
	local x, y, targetScreen

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
	elseif string.find(target, 'screen') then
		-- Previous/next screen
		targetScreen = string.find(target, '+') and focused.app:screen():next():frame() or focused.app:screen():previous():frame()
		x = targetScreen.x
		y = targetScreen.y
	end

	focused.app:settopleft({x = x, y = y})
end

-- Hotkey bindings
hotkey.bind(mods, '1', function() moveTo(1) end)
hotkey.bind(mods, '2', function() moveTo(2) end)
hotkey.bind(mods, '3', function() moveTo(3) end)
hotkey.bind(mods, '4', function() moveTo(4) end)
hotkey.bind(mods, 'C', function() moveTo('center') end)
hotkey.bind(mods, '[', function() moveTo('screen-') end)
hotkey.bind(mods, ']', function() moveTo('screen+') end)
hotkey.bind(mods, 'M', function() focused().app:maximize() end)
hotkey.bind(mods, 'N', function() focused().app:movetounit({x = .25, y = .25, w = .5, h = .5}) end)
hotkey.bind(mods, 'H', function() focused().app:movetounit({x = .25, y = 0, w = .5, h = 1}) end)
hotkey.bind(mods, 'R', function() mjolnir.reload() end)
