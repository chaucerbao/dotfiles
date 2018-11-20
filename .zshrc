# Changing directories
DIRSTACKSIZE=10
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=5000
SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS INC_APPEND_HISTORY

# Environment
autoload -U compinit; compinit
autoload -U edit-command-line; zle -N edit-command-line; bindkey '\C-x\C-e' edit-command-line
autoload -U select-word-style; select-word-style bash
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|=*' 'l:|=* r:|=*'

# Disable START/STOP flow control to reclaim CTRL-S and CTRL-Q
/bin/stty -ixon

# Antibody plugin manager
source <(antibody init)
antibody bundle <<-PLUGINS
	subnixr/minimal
	rupa/z
	zsh-users/zsh-completions
	zsh-users/zsh-syntax-highlighting
PLUGINS

# Aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -="dirs -v | head -$DIRSTACKSIZE"
alias 1='cd -'
alias 2='cd +2'
alias 3='cd +3'
alias 4='cd +4'
alias 5='cd +5'
alias 6='cd +6'
alias 7='cd +7'
alias 8='cd +8'
alias 9='cd +9'

# Profile
source ${0:a:h}/.profile
