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

# Zoxide
if [ -x "$(command -v zoxide)" ]; then
	eval "$(zoxide init bash)"
fi

# Aliases
source ${SCRIPT_PATH}/aliases
