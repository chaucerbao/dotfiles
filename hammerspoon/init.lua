-- Style options
hs.alert.defaultStyle.radius = 5
hs.alert.defaultStyle.strokeColor.alpha = 0
hs.window.animationDuration = 0

-- Move the focused window to a target position on the current screen
function moveTo(target)
  local window = hs.window.frontmostWindow()
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
  end

  window:setFrame(frame)
end

-- Control the volume of the active audio device
function setVolume(target)
  local audioDevice = hs.audiodevice.defaultOutputDevice()

  if target == 'toggle' then
    audioDevice:setMuted(not audioDevice:muted())
    hs.alert.show(audioDevice:muted() and 'Mute' or 'Unmute')
  elseif target == 'low' then
    audioDevice:setVolume(2/16 * 100)
    audioDevice:setMuted(false)
    hs.alert.show('Volume low')
  elseif target == 'normal' then
    audioDevice:setVolume(6/16 * 100)
    audioDevice:setMuted(false)
    hs.alert.show('Volume normal')
  end
end

-- Bind back/forward navigation on the mouse
hs.eventtap.new({hs.eventtap.event.types.otherMouseDown}, function(event)
  local mouseButton = event:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)

  if mouseButton == 3 then
    return true, {hs.eventtap.event.newKeyEvent({'cmd'}, '[', true)}
  elseif mouseButton == 4 then
    return true, {hs.eventtap.event.newKeyEvent({'cmd'}, ']', true)}
  end
end):start()

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

-- Caffeine
local caffeine = hs.menubar.new()
function toggleCaffeine()
  if (hs.caffeinate.toggle('displayIdle')) then
    caffeine:returnToMenuBar()
  else
    caffeine:removeFromMenuBar()
  end
end
if caffeine then
  caffeine:setTitle('\u{2615}')
  caffeine:setClickCallback(toggleCaffeine)
  caffeine:removeFromMenuBar()
end

-- Hotkey bindings
local mods = {'ctrl', 'cmd'}

hs.hotkey.bind(mods, '1', function() moveTo(1) end)
hs.hotkey.bind(mods, '2', function() moveTo(2) end)
hs.hotkey.bind(mods, '3', function() moveTo(3) end)
hs.hotkey.bind(mods, '4', function() moveTo(4) end)
hs.hotkey.bind(mods, 'C', function() hs.window.frontmostWindow():centerOnScreen() end)

hs.hotkey.bind(mods, 'M', function() hs.window.frontmostWindow():maximize() end)
hs.hotkey.bind(mods, 'N', function() hs.window.frontmostWindow():moveToUnit({ x = 1/4, y = 1/4, w = 1/2, h = 1/2 }) end)
hs.hotkey.bind(mods, 'B', function() hs.window.frontmostWindow():moveToUnit({ x = 1/8, y = 1/8, w = 3/4, h = 3/4 }) end)
hs.hotkey.bind(mods, 'H', function() hs.window.frontmostWindow():moveToUnit(hs.layout.left50) end)
hs.hotkey.bind(mods, 'L', function() hs.window.frontmostWindow():moveToUnit(hs.layout.right50) end)

hs.hotkey.bind(mods, '[', function() hs.window.frontmostWindow():moveOneScreenWest() end)
hs.hotkey.bind(mods, ']', function() hs.window.frontmostWindow():moveOneScreenEast() end)

hs.hotkey.bind(mods, '0', function() setVolume('toggle') end)
hs.hotkey.bind(mods, '-', function() setVolume('low') end)
hs.hotkey.bind(mods, '=', function() setVolume('normal') end)

hs.hotkey.bind(mods, 'A', function() autoClick() end)
hs.hotkey.bind(mods, 'Z', function() toggleCaffeine() end)
hs.hotkey.bind(mods, 'R', function() hs.reload() end)
