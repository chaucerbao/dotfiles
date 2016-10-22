-- Disable animations by default
hs.window.animationDuration = 0

-- Set grid options
hs.grid.setGrid('4x4')
hs.grid.setMargins({0, 0})
hs.grid.ui.cellColor = {0, 0, 0, .65}
hs.grid.ui.highlightColor = {.5, .85, 1, .35}
hs.grid.ui.highlightStrokeColor = {0, .5, .85}
hs.grid.ui.highlightStrokeWidth = 1
hs.grid.ui.cellStrokeWidth = 4
hs.grid.ui.showExtraKeys = false

-- Move the focused window to a target position on the current screen
function moveTo(target)
  local window = hs.window.focusedWindow()
  local frame = window:frame()
  local screen = window:screen():frame()

  if target == 1 then
    -- Quadrant 1 (Top-left)
    frame.x = screen.x
    frame.y = screen.y
  elseif target == 2 then
    -- Quadrant 2 (Top-right)
    frame.x = screen.x + screen.w - frame.w
    frame.y = screen.y
  elseif target == 3 then
    -- Quadrant 3 (Bottom-right)
    frame.x = screen.x + screen.w - frame.w
    frame.y = screen.y + screen.h - frame.h
  elseif target == 4 then
    -- Quadrant 4 (Bottom-left)
    frame.x = screen.x
    frame.y = screen.y + screen.h - frame.h
  elseif target == 'center' then
    -- Center
    frame.x = screen.x + (screen.w - frame.w) / 2
    frame.y = screen.y + (screen.h - frame.h) / 2
  end

  window:setFrame(frame)
end

-- Automatically left-click at an interval
local autoClickActive = false
function autoClick()
  autoClickActive = not autoClickActive

  if (autoClickActive) then
    hs.timer.doWhile(
      function () return autoClickActive end,
      function () hs.eventtap.leftClick(hs.mouse.getAbsolutePosition()) end,
      .1
      )
  end
end

-- Hotkey bindings
local mods = {'ctrl', 'cmd'}

hs.hotkey.bind(mods, '1', function() moveTo(1) end)
hs.hotkey.bind(mods, '2', function() moveTo(2) end)
hs.hotkey.bind(mods, '3', function() moveTo(3) end)
hs.hotkey.bind(mods, '4', function() moveTo(4) end)
hs.hotkey.bind(mods, 'C', function() moveTo('center') end)

hs.hotkey.bind(mods, 'M', function() hs.window.focusedWindow():maximize() end)
hs.hotkey.bind(mods, 'N', function() hs.window.focusedWindow():moveToUnit({ x = 1/4, y = 1/4, w = 1/2, h = 1/2 }) end)
hs.hotkey.bind(mods, 'B', function() hs.window.focusedWindow():moveToUnit({ x = 1/8, y = 1/8, w = 3/4, h = 3/4 }) end)
hs.hotkey.bind(mods, 'H', function() hs.window.focusedWindow():moveToUnit(hs.layout.left50) end)
hs.hotkey.bind(mods, 'L', function() hs.window.focusedWindow():moveToUnit(hs.layout.right50) end)

hs.hotkey.bind(mods, '[', function() hs.window.focusedWindow():moveOneScreenWest() end)
hs.hotkey.bind(mods, ']', function() hs.window.focusedWindow():moveOneScreenEast() end)

hs.hotkey.bind(mods, '0', function()
  local audioDevice = hs.audiodevice.defaultOutputDevice()
  audioDevice:setMuted(not audioDevice:muted())
end)
hs.hotkey.bind(mods, '-', function() hs.audiodevice.defaultOutputDevice():setVolume(25/2) end)
hs.hotkey.bind(mods, '=', function() hs.audiodevice.defaultOutputDevice():setVolume(100) end)

hs.hotkey.bind(mods, '`', function() hs.grid.toggleShow() end)
hs.hotkey.bind(mods, 'R', function() hs.reload() end)
hs.hotkey.bind(mods, 'A', function() autoClick() end)

hs.hotkey.bind({'alt'}, 'L', function() hs.caffeinate.lockScreen() end)
