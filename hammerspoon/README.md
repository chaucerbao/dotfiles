# Hammerspoon settings
[Hammerspoon] is a desktop automation tool for OS X. I use it to manage my windows.

## Installation
I prefer to source the 'init.lua' file rather than symlinking to it, so I can add additional configuration if needed.

```lua
dofile('../.dotfiles/hammerspoon/init.lua')

hs.hotkey.bind({'alt'}, 'L', function() os.execute('/usr/local/bin/lock') end)
```

[Hammerspoon]:http://www.hammerspoon.org/
