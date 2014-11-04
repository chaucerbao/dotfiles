# Environment
unset LSCOLORS
unset GREP_COLOR

# Aliases
alias ag='ag --ignore-case --color-match 0\;31 --color-line-number 0\;32 --color-path 0\;34'
alias c='pygmentize -g -f 256 -O style=trac'
alias ls='ls -hFG'
alias t='tmux'
alias v='vim'

# Disable START/STOP flow control to reclaim CTRL-S and CTRL-Q
/bin/stty -ixon
