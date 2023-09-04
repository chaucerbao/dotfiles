# Import Profile
source ${0:a:h}/profile

# Navigation
setopt AUTO_CD

# History
HISTFILE=$HOME/.zsh_history
SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS SHARE_HISTORY

# Environment
bindkey -e
autoload -U compinit; compinit
autoload -U edit-command-line; zle -N edit-command-line; bindkey '\C-x\C-e' edit-command-line
autoload -U select-word-style; select-word-style bash
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|=*' 'l:|=* r:|=*'

# Disable START/STOP flow control to reclaim CTRL-S and CTRL-Q
/bin/stty -ixon

# Antidote plugin manager
antidote() { if [ ! -x "$(command -v antidote)" ] && [ -x "$(command -v brew)" ]; then source $(brew --prefix antidote)/share/antidote/antidote.zsh; fi; antidote "$@"; }
if [ ! -f "$HOME/.cache/.zsh_plugins" ]; then
	mkdir --parents $HOME/.cache
	antidote bundle >$HOME/.cache/.zsh_plugins <<-PLUGINS
		subnixr/minimal
		zsh-users/zsh-syntax-highlighting
	PLUGINS
fi
source $HOME/.cache/.zsh_plugins

# Custom FZF Completions
source ${0:a:h}/fzf-completion
