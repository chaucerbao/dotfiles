# Exports
export N_PREFIX=$HOME/.n
if [ -z $TMUX ]; then export PATH=node_modules/.bin:$N_PREFIX/bin:$HOME/.bin:/usr/local/opt/coreutils/libexec/gnubin:$PATH; fi
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/"'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

# History
HISTSIZE=5000

# Navigation
alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Docker
alias d='docker'
alias dc='docker-compose'
alias dprune='docker system prune --force'
alias drun='docker run --interactive --tty --rm'
alias dcrun='docker-compose run --rm'
alias -- drun.='drun --volume=$PWD:/mnt/host'

# Git
alias g='git'
alias ga='git a'
alias ga.='git a .'
alias gb='git b'
alias gc='git c'
alias gcd='git cd'
alias gcm='git cm'
alias gco='git co'
alias gd='git d'
alias gg='git g'
alias ggp='git gp'
alias ggu='git gu'
alias glo='git lo'
alias glog='git lo --graph'
alias glop='git lo --patch'
alias gm='git m'
alias grh='git rh'
alias grhh='git rhh'
alias gst='git st'
alias gsta='git sta'
alias gstp='git stp'

# Node
alias npmD='npm install --save-dev'
alias npmS='npm install --save'
alias npmR='rm --force --recursive node_modules; npm install'

# tmux
alias t='tmux'
alias ta='tmux attach-session'
alias tks='tmux kill-server'
alias tls='tmux list-sessions'
alias ts='tmux new-session -A -s'

# Vim
if [ -x "$(command -v nvim)" ]; then alias v='nvim'; else alias v='vim'; fi
alias vup='v +PlugUpgrade +PlugUpdate +only +"normal D" +"nnoremap <silent> <buffer> q :qall<CR>"'

# Miscellaneous
if [ -x "$(command -v bat)" ]; then alias c='bat'; else alias c='cat'; fi
alias l='ls -l'
alias ll='ls --almost-all -l'
alias ls='ls --color --classify --group-directories-first --human-readable --literal'

# macOS
if [[ $OSTYPE == "darwin"* ]]; then
	alias bubu='brew update && brew outdated && brew upgrade && brew cleanup'
	alias clean='rg --null --files --no-ignore-vcs --glob "*.DS_Store" $HOME/ | xargs -0 rm --'
	alias forklift='open -a ForkLift'
fi

# Functions
gbf() { if [ -n "$1" ]; then git checkout -b "feature/$1" "${2:-develop}"; fi; }
gbh() { if [ -n "$1" ]; then git checkout -b "hotfix/$1" "${2:-master}"; fi; }
fd() { if [ -n "$1" ]; then rg --files --glob "*$1*" "${2:-.}"; fi; }
