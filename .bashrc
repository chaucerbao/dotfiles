# Import Profile
source $(dirname "${BASH_SOURCE[0]}")/.profile

# Navigation
shopt -s autocd

# History
HISTFILESIZE=$HISTSIZE
HISTCONTROL=erasedups:ignorespace
shopt -s histappend
