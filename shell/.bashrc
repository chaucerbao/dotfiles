# Script
SCRIPT_PATH=$(dirname "${BASH_SOURCE[0]}")

# Navigation
shopt -s autocd

# History
HISTSIZE=5000
HISTFILESIZE=$HISTSIZE
HISTCONTROL=erasedups:ignorespace
shopt -s histappend

# Completions
command -v fzf >/dev/null && source "${SCRIPT_PATH}/fzf-completion"

# Disable START/STOP flow control to reclaim CTRL-S and CTRL-Q
stty -ixon

# Tooling
command -v mise >/dev/null && eval "$(mise activate bash)"
command -v zoxide >/dev/null && eval "$(zoxide init bash)"

# Aliases
source "${SCRIPT_PATH}/aliases"

# Clean Up
unset SCRIPT_PATH
