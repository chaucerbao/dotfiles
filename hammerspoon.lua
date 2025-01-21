-- Initialize the configuration
if _G.config == nil then _G.config = {} end

-- Style options
hs.alert.defaultStyle.radius = 3
hs.alert.defaultStyle.strokeColor.alpha = 0
hs.window.animationDuration = 0

-- Move the focused window to a target position on the current screen
local function moveTo(target)
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
local function setVolume(target, message)
  local audioDevice = hs.audiodevice.defaultOutputDevice()

  if target == 0 then
    audioDevice:setMuted(not audioDevice:muted())

    if message then hs.alert.show(audioDevice:muted() and message[1] or message[2]) end
  else
    audioDevice:setVolume(target * 100)
    audioDevice:setMuted(false)

    if message then hs.alert.show(message) end
  end
end

-- Microphone mute
local micMuteIcon = hs.menubar.new(false)

local function toggleMicMute()
  local audioDevice = hs.audiodevice.defaultInputDevice()

  audioDevice:setInputMuted(not audioDevice:inputMuted())

  if audioDevice:inputMuted() then
    micMuteIcon:returnToMenuBar()
    micMuteIcon:setTitle('Mute')
    micMuteIcon:setTooltip('Microphone is muted')
    micMuteIcon:setClickCallback(toggleMicMute)
  else
    micMuteIcon:removeFromMenuBar()
  end
end

-- Caffeine
local caffeineIcon = hs.menubar.new(false)

local function toggleCaffeine()
  if hs.caffeinate.toggle('displayIdle') then
    caffeineIcon:returnToMenuBar()
    caffeineIcon:setTitle('☕️')
    caffeineIcon:setTooltip('Prevent display from sleeping')
    caffeineIcon:setClickCallback(toggleCaffeine)
  else
    caffeineIcon:removeFromMenuBar()
  end
end

-- Clipboard Manager
local clipboardManager = hs.loadSpoon('ClipboardTool')
clipboardManager.hist_size = 50
clipboardManager.show_copied_alert = false
clipboardManager.show_in_menubar = false
clipboardManager:bindHotkeys({ toggle_clipboard = { { 'ctrl' }, 'space' } })
clipboardManager:start()

-- AutoClicker
local autoClickerInterval = 0.005
local autoClickerIcon = hs.menubar.new(false)
local autoClickerTimer = nil

local function toggleAutoClicker()
  if autoClickerTimer then
    autoClickerIcon:removeFromMenuBar()
    autoClickerTimer = nil
  else
    autoClickerIcon:returnToMenuBar()
    autoClickerIcon:setTitle('🐭')
    autoClickerIcon:setClickCallback(toggleAutoClicker)

    -- Store in a variable to prevent garbage collection
    autoClickerTimer = hs.timer.doWhile(function()
      return autoClickerTimer
    end, function()
      hs.eventtap.leftClick(hs.mouse.absolutePosition(), autoClickerInterval * 0.5)
    end, autoClickerInterval)
  end
end

-- Safari mouse bindings
_G.watchers = {}

local safariMouseEventWatcher = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDown }, function(tapEvent)
  local buttonIndex = tapEvent:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)

  if buttonIndex == 3 then
    hs.eventtap.keyStroke({ 'cmd' }, '[')
  elseif buttonIndex == 4 then
    hs.eventtap.keyStroke({ 'cmd' }, ']')
  end
end)

_G.watchers.safariApplicationWatcher = hs.application.watcher.new(function(applicationName, eventType, application)
  if applicationName ~= 'Safari' then return end

  if eventType == hs.application.watcher.activated then
    safariMouseEventWatcher:start()
  elseif eventType == hs.application.watcher.deactivated then
    safariMouseEventWatcher:stop()
  end
end)
_G.watchers.safariApplicationWatcher:start()

-- Hotkey bindings
local mods = { 'ctrl', 'cmd' }

-- Move and resize windows
hs.hotkey.bind(mods, '1', function() moveTo(1) end)
hs.hotkey.bind(mods, '2', function() moveTo(2) end)
hs.hotkey.bind(mods, '3', function() moveTo(3) end)
hs.hotkey.bind(mods, '4', function() moveTo(4) end)
hs.hotkey.bind(mods, 'C', function() hs.window.frontmostWindow():centerOnScreen() end)

hs.hotkey.bind(mods, 'M', function() hs.window.frontmostWindow():maximize() end)
hs.hotkey.bind(
  mods,
  'N',
  function() hs.window.frontmostWindow():moveToUnit({ x = 1 / 4, y = 1 / 4, w = 1 / 2, h = 1 / 2 }) end
)
hs.hotkey.bind(
  mods,
  'B',
  function() hs.window.frontmostWindow():moveToUnit({ x = 1 / 8, y = 1 / 8, w = 3 / 4, h = 3 / 4 }) end
)

hs.hotkey.bind(mods, 'H', function() hs.window.frontmostWindow():moveToUnit(hs.layout.left50) end)
hs.hotkey.bind(mods, 'L', function() hs.window.frontmostWindow():moveToUnit(hs.layout.right50) end)

hs.hotkey.bind(mods, '[', function() hs.window.frontmostWindow():moveOneScreenWest() end)
hs.hotkey.bind(mods, ']', function() hs.window.frontmostWindow():moveOneScreenEast() end)

-- Volume
hs.hotkey.bind(mods, '0', function() setVolume(0, { 'Mute', 'Unmute' }) end)
hs.hotkey.bind(mods, '-', function() setVolume(2 / 16, 'Volume low') end)
hs.hotkey.bind(mods, '=', function() setVolume(8 / 16, 'Volume normal') end)
hs.hotkey.bind(mods, 'delete', function() toggleMicMute() end)

-- Utilities
hs.hotkey.bind(mods, 'A', toggleAutoClicker)
hs.hotkey.bind(mods, 'Z', toggleCaffeine)
hs.hotkey.bind(mods, 'R', function() hs.reload() end)

hs.hotkey.bind(mods, 'P', function()
  print(hs.application.frontmostApplication())
  print(hs.application.frontmostApplication():focusedWindow())
  print(hs.application.frontmostApplication():bundleID())
end)

-- Focus applications
hs.hotkey.bind(mods, 'I', function() hs.application.launchOrFocusByBundleID('com.apple.Safari') end)

hs.hotkey.bind(
  'cmd',
  'escape',
  function() hs.application.launchOrFocusByBundleID(_G.config.terminal and _G.config.terminal or 'com.apple.Terminal') end
)

-- Quick focus window
local quickFocusWindowId = nil

hs.hotkey.bind(hs.fnutils.concat({ 'shift' }, mods), 'U', function()
  local focusedWindow = hs.window.focusedWindow()

  quickFocusWindowId = quickFocusWindowId ~= focusedWindow:id() and focusedWindow:id() or nil
end)

hs.hotkey.bind(mods, 'U', function()
  local quickFocusWindow = quickFocusWindowId and hs.window.get(quickFocusWindowId) or nil

  if quickFocusWindow then
    quickFocusWindow:focus()
  end
end)

if _G.config.browser then
  hs.hotkey.bind(mods, 'O', function() hs.application.launchOrFocusByBundleID(_G.config.browser) end)
end

if _G.config.quickLaunch then
  hs.hotkey.bind(mods, '\\', function()
    for _, bundleID in ipairs(_G.config.quickLaunch) do
      hs.application.launchOrFocusByBundleID(bundleID)
    end
  end)
end

-- Shortcut chooser
if _G.config.shortcuts then
  local function sendText(text)
    local delimiterMap = { ['\n'] = 'return', ['\t'] = 'tab' }

    local delimiterRegex = ''
    for key in pairs(delimiterMap) do
      delimiterRegex = delimiterRegex .. key
    end

    local delimiters = {}
    for delimiter in string.gmatch(text, '[' .. delimiterRegex .. ']') do
      table.insert(delimiters, delimiterMap[delimiter])
    end

    local i = 1
    for substring in string.gmatch(text, '[^' .. delimiterRegex .. ']*') do
      hs.eventtap.keyStrokes(substring)

      if delimiters[i] then hs.eventtap.keyStroke({}, delimiters[i]) end

      i = i + 1
    end
  end

  local shortcutChooser = hs.chooser.new(function(choice)
    if choice then
      if choice.keyStrokes then
        if type(choice.keyStrokes) == 'string' then sendText(choice.keyStrokes) end

        if type(choice.keyStrokes) == 'table' then
          if choice.interval then
            for i, text in ipairs(choice.keyStrokes) do
              hs.timer.doAfter(choice.interval * (i - 1), function() sendText(text) end)
            end
          else
            sendText(table.concat(choice.keyStrokes, ''))
          end
        end
      end

      if _G[choice.callback] ~= nil then _G[choice.callback]() end
    end
  end)

  shortcutChooser:choices(_G.config.shortcuts)

  hs.hotkey.bind(mods, ';', function()
    shortcutChooser:query(nil)
    shortcutChooser:show()
  end)
end
