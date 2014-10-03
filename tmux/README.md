# tmux settings
[tmux] is a terminal multiplexer

## Installation
Rather than symlinking directly to the configuration file, I prefer to create a `~/.tmux.conf` that sources this config.  This lets me add environment-specific settings.

```sh
# Include original settings
source-file ~/.dotfiles/tmux/.tmux.conf

# Environment-specific settings
...
```

[tmux]:http://tmux.sourceforge.net/
