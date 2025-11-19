# Script
SCRIPT_PATH=${0:a:h}

# Navigation
setopt AUTO_CD

# History
HISTSIZE=5000
SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS SHARE_HISTORY

# Command Line
bindkey -e
autoload -U edit-command-line; zle -N edit-command-line; bindkey '\C-x\C-e' edit-command-line
autoload -U select-word-style; select-word-style bash

# Completions
[ -x "$(command -v brew)" ] && export FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
[ -x "$(command -v fzf)" ] && source ${SCRIPT_PATH}/fzf-completion
autoload -U compinit; compinit

# Disable START/STOP flow control to reclaim CTRL-S and CTRL-Q
stty -ixon

# Antidote plugin manager
antidote() { if [ ! -x "$(command -v antidote)" ] && [ -x "$(command -v brew)" ]; then source $(brew --prefix antidote)/share/antidote/antidote.zsh; fi; antidote "$@"; }
if [ ! -f "$HOME/.cache/.zsh_plugins" ]; then
	mkdir --parents $HOME/.cache
	antidote bundle >$HOME/.cache/.zsh_plugins <<-PLUGINS
		romkatv/powerlevel10k
		zsh-users/zsh-autosuggestions
		zsh-users/zsh-syntax-highlighting
	PLUGINS
fi
source $HOME/.cache/.zsh_plugins

# Tooling
[ -x "$(command -v mise)" ] && eval "$(mise activate zsh)"
[ -x "$(command -v zoxide)" ] && eval "$(zoxide init zsh)"

# Aliases
source ${SCRIPT_PATH}/aliases
