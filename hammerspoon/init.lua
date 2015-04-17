-- Hotkey modifiers
local mods = {'ctrl', 'cmd'}

-- Disable animations by default
hs.window.animationDuration = 0

-- Get the focused window/frame/screen
function focused()
  local window = hs.window.focusedWindow()
  local frame = window:frame()
  local screen = window:screen():frame()

  return {
    window = window,
    frame = frame,
    screen = screen
  }
end

-- Move the focused window to a target position on the current screen
function moveTo(target)
  local focused = focused()
  local screen = focused.screen
  local window = focused.window
  local frame = focused.frame

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

  window:setFrame(frame, .2)
end

-- Move the focused window to the previous/next screen
function moveToScreen(target)
  local focused = focused()
  local window = focused.window
  local frame = focused.frame
  local toScreen

  if target == '-' then
    -- Previous screen
    toScreen = window:screen():previous():frame()
  elseif target == '+' then
    -- Next screen
    toScreen = window:screen():next():frame()
  end

  frame.x = toScreen.x + (toScreen.w - frame.w) / 2
  frame.y = toScreen.y + (toScreen.h - frame.h) / 2

  window:setFrame(frame, .2)
end

-- Hotkey bindings
hs.hotkey.bind(mods, '1', function() moveTo(1) end)
hs.hotkey.bind(mods, '2', function() moveTo(2) end)
hs.hotkey.bind(mods, '3', function() moveTo(3) end)
hs.hotkey.bind(mods, '4', function() moveTo(4) end)
hs.hotkey.bind(mods, 'C', function() moveTo('center') end)
hs.hotkey.bind(mods, 'M', function() focused().window:maximize() end)
hs.hotkey.bind(mods, 'N', function() focused().window:moveToUnit({ x = .25, y = .25, w = .5, h = .5 }) end)
hs.hotkey.bind(mods, 'H', function() focused().window:moveToUnit({ x = .25, y = 0, w = .5, h = 1 }) end)
hs.hotkey.bind(mods, '[', function() moveToScreen('-') end)
hs.hotkey.bind(mods, ']', function() moveToScreen('+') end)
hs.hotkey.bind(mods, 'R', function() hs.reload() end)
