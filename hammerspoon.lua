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
function setVolume(target, message)
  local audioDevice = hs.audiodevice.defaultOutputDevice()

  if target == 0 then
    audioDevice:setMuted(not audioDevice:muted())
    hs.alert.show(audioDevice:muted() and message[1] or message[2])
  else
    audioDevice:setVolume(target * 100)
    audioDevice:setMuted(false)
    hs.alert.show(message)
  end
end

-- Caffeine
local caffeine = hs.menubar.new(hs.caffeinate.get('displayIdle'))

function setCaffeineDisplay(state)
  if state then
    caffeine:returnToMenuBar()
    caffeine:setTitle('☕️')
    caffeine:setTooltip('Prevent display from sleeping')
    caffeine:setClickCallback(toggleCaffeineDisplay)
  else
    caffeine:removeFromMenuBar()
  end
end

function toggleCaffeineDisplay()
  setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

-- Clipboard Manager
local clipboardManager = hs.loadSpoon('ClipboardTool')
clipboardManager.show_copied_alert = false
clipboardManager.show_in_menubar = false
clipboardManager.hist_size = 500
clipboardManager:bindHotkeys({ toggle_clipboard = { { 'ctrl' }, 'space' } })
clipboardManager:start()

-- Hotkey bindings
local mods = { 'ctrl', 'cmd' }

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

hs.hotkey.bind(mods, '0', function() setVolume(0, { 'Mute', 'Unmute' }) end)
hs.hotkey.bind(mods, '-', function() setVolume(2/16, 'Volume low') end)
hs.hotkey.bind(mods, '=', function() setVolume(6/16, 'Volume normal') end)

hs.hotkey.bind(mods, 'Z', toggleCaffeineDisplay)
hs.hotkey.bind(mods, 'R', function() hs.reload() end)

hs.hotkey.bind(mods, 'I', function() hs.application.launchOrFocusByBundleID('com.apple.Safari') end)
hs.hotkey.bind('cmd', 'escape', function() hs.application.launchOrFocusByBundleID('com.apple.Terminal') end)

-- Conditional hotkey bindings
if browser then
  hs.hotkey.bind(mods, 'O', function() hs.application.launchOrFocusByBundleID(browser) end)
end

if quickLaunch then
  hs.hotkey.bind(mods, '\\', function()
    for i, bundleID in ipairs(quickLaunch) do
      hs.application.launchOrFocusByBundleID(bundleID)
    end
  end)
end

if shortcuts then
  function sendText(text)
    local sentinelRegex = '([\n\t])$'
    local _, _, sentinel = string.find(text, sentinelRegex)

    hs.eventtap.keyStrokes(string.gsub(text, sentinelRegex, ''))

    if sentinel then
      if sentinel == '\n' then hs.eventtap.keyStroke({}, 'return') end
      if sentinel == '\t' then hs.eventtap.keyStroke({}, 'tab') end
    end
  end

  local shortcutChooser = hs.chooser.new(function(choice)
    if choice then
      if choice.keyStrokes then
        if (type(choice.keyStrokes) == 'string') then sendText(choice.keyStrokes) end

        if (type(choice.keyStrokes) == 'table') then
          if choice.interval then
            for i, keyStrokes in ipairs(choice.keyStrokes) do
              hs.timer.doAfter(
                choice.interval * (i - 1),
                function() sendText(keyStrokes) end
              )
            end
          else
            for _, keyStrokes in ipairs(choice.keyStrokes) do
              sendText(keyStrokes)
            end
          end
        end
      end

      if _G[choice.callback] ~= nil then
        _G[choice.callback]()
      end
    end
  end)

  shortcutChooser:choices(shortcuts)

  hs.hotkey.bind('ctrl', 'escape', function()
    shortcutChooser:query(nil)
    shortcutChooser:show()
  end)
end
