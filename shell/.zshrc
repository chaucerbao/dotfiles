# Environment
unset LSCOLORS
unset GREP_COLOR

# Aliases
alias c='pygmentize -g -f 256 -O style=trac'
alias ls='ls -hFG'
alias t='tmux'
alias v='vim'

# Disable START/STOP flow control to reclaim CTRL-S and CTRL-Q
/bin/stty -ixon
