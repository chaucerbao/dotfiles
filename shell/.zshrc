# Oh My Zsh
if [ ! -d "$ZSH/custom/plugins/zsh-syntax-highlighting" ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH/custom/plugins/zsh-syntax-highlighting
fi
if [ -z "$ZSH_THEME" ]; then ZSH_THEME="gallois" fi
if [ -z "$plugins" ]; then plugins=(git jump zsh-syntax-highlighting) fi
source $ZSH/oh-my-zsh.sh

# Environment
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --glob "!.git/"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
unset LSCOLORS

# Aliases
alias bubu='brew update && brew outdated && brew upgrade && brew cleanup'
alias c='source-highlight --failsafe --line-number --out-format=esc256 --output=STDOUT -i'
alias j='jump'
alias l='ls -l'
alias ll='ls -lA'
alias ls='ls -hFG'
alias npmD="npm i -D "
alias npmS="npm i -S "
alias rg='rg --smart-case --glob "!.git/"'
alias t='tmux'
alias ts='tmux new-session -s'
alias v='vim'

# Disable START/STOP flow control to reclaim CTRL-S and CTRL-Q
/bin/stty -ixon
