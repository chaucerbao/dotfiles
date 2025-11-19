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
source ${SCRIPT_PATH}/fzf-completion

# Tooling
[ -x "$(command -v mise)" ] && eval "$(mise activate bash)"
[ -x "$(command -v zoxide)" ] && eval "$(zoxide init bash)"

# Aliases
source ${SCRIPT_PATH}/aliases
