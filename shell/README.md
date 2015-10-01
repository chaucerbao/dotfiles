# Shell Settings
I'm using [Oh-My-Zsh] to manage the ZSH configuration.

## Installation
Create `~/.zshrc` and `~/.zprofile` to source the configuration files.

```sh
# ~/.zshrc
export ZSH=$HOME/.oh-my-zsh
source $HOME/.dotfiles/shell/.zshrc
```

```sh
# ~/.zprofile
source $HOME/.dotfiles/shell/.zprofile
```

_Note: ZSH configuration includes the [zsh-syntax-highlighting] plugin and will attempt to automatically install it if missing._

[Oh-My-Zsh]:http://ohmyz.sh/
[zsh-syntax-highlighting]:https://github.com/zsh-users/zsh-syntax-highlighting
