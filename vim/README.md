# Vim Settings
My configuration for [Vim] as a web developer.  I'm using [Vim-Plug] as the plug-in manager, which maintains plug-ins using [Git] \(so be sure to have it installed\).

## Installation
Rather than symlinking directly to the configuration file, I prefer to create a `~/.vimrc` that sources this config.  This lets me add environment-specific settings.

```vim
" Include original settings
source ~/.dotfiles/vim/.vimrc

" Environment-specific settings
...
```

[Git]:http://git-scm.com/
[Vim-Plug]:https://github.com/junegunn/vim-plug
[Vim]:http://www.vim.org/
