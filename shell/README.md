# Shell Settings
I'm using [Oh-My-Zsh] to manage the ZSH configuration.

## Installation
Create `~/.zshrc` and `~/.zshenv` to source the configuration files. I'm using the [solarized-dark-pygments] theme for [Pygments] by default, so have that installed.

```sh
# ~/.zshrc
export ZSH=$HOME/.oh-my-zsh
source $HOME/.dotfiles/shell/.zshrc
```

```sh
# ~/.zshenv
source $HOME/.dotfiles/shell/.zshenv
```

_Note: ZSH configuration includes the [zsh-syntax-highlighting] plugin and will attempt to automatically install it if missing._

[Oh-My-Zsh]:http://ohmyz.sh/
[Pygments]:http://pygments.org/
[zsh-syntax-highlighting]:https://github.com/zsh-users/zsh-syntax-highlighting
[solarized-dark-pygments]:https://github.com/gthank/solarized-dark-pygments