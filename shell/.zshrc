# Oh-My-Zsh
if [ ! -d "$ZSH/custom/plugins/zsh-syntax-highlighting" ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH/custom/plugins/zsh-syntax-highlighting
fi
if [ "$ZSH_THEME" = ""  ]; then ZSH_THEME="gallois" fi
if [ "$plugins" = ""  ]; then plugins=(git git-flow zsh-syntax-highlighting) fi
source $ZSH/oh-my-zsh.sh

# Environment
unset LSCOLORS
unset GREP_COLOR

# Aliases
alias ag='ag --ignore-case --color-match 0\;31 --color-line-number 0\;32 --color-path 0\;34'
alias c='pygmentize -g'
alias l='ls -l'
alias ll='ls -lA'
alias ls='ls -hFG'
alias t='tmux'
alias v='vim'

# Disable START/STOP flow control to reclaim CTRL-S and CTRL-Q
/bin/stty -ixon
