# Mjolnir settings
[Mjolnir] is a lightweight automation app for OS X. I use it to manage my windows.

## Installation
```sh
brew install lua luarocks
luarocks install mjolnir.application
luarocks install mjolnir.hotkey
```

I prefer to source the 'init.lua' file rather than symlinking to it, so I can add additional configuration if needed.

```lua
dofile('../.dotfiles/mjolnir/init.lua')

local hotkey = require 'mjolnir.hotkey'
hotkey.bind({'alt'}, 'L', function() os.execute('/usr/local/bin/lock') end)
```

[Mjolnir]:https://github.com/mjolnir-io/mjolnir
