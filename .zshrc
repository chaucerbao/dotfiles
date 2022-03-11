# Import Profile
source ${0:a:h}/.profile

# Navigation
setopt AUTO_CD

# History
HISTFILE=$HOME/.zsh_history
SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS SHARE_HISTORY

# Environment
autoload -U compinit; compinit
autoload -U edit-command-line; zle -N edit-command-line; bindkey '\C-x\C-e' edit-command-line
autoload -U select-word-style; select-word-style bash
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|=*' 'l:|=* r:|=*'
bindkey -e

# Disable START/STOP flow control to reclaim CTRL-S and CTRL-Q
/bin/stty -ixon

# Antibody plugin manager
source <(antibody init)
antibody bundle <<-PLUGINS
	subnixr/minimal
	rupa/z
	zsh-users/zsh-syntax-highlighting
PLUGINS
