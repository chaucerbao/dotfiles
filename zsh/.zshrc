# Changing directories
DIRSTACKSIZE=10
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=5000
SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS INC_APPEND_HISTORY

# Environment
export PATH=node_modules/.bin:vendor/bin:$HOME/.composer/vendor/bin:$PATH
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/"'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
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

alias d="dirs -v | head -$DIRSTACKSIZE"
alias -- -='cd -'
alias 1='cd -'
alias 2='cd +2'
alias 3='cd +3'
alias 4='cd +4'
alias 5='cd +5'
alias 6='cd +6'
alias 7='cd +7'
alias 8='cd +8'
alias 9='cd +9'

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

alias dcbuild='docker-compose build --force-rm --no-cache'
alias dclean='docker rmi $(docker images --all --quiet --filter "dangling=true")'
alias drun='docker run --rm --interactive --tty'

alias bubu='brew update && brew outdated && brew upgrade && brew cleanup'
alias c='source-highlight --failsafe --line-number --out-format=esc256 --output=STDOUT -i'
alias ds='rg --null --files --no-ignore --glob "*.DS_Store" ~/ | xargs -0 rm --'
alias l='ls -l'
alias ll='ls --almost-all -l'
alias ls='ls --color --classify --group-directories-first --human-readable --literal'
alias npmD='npm install --save-dev'
alias npmS='npm install --save'
alias rg='rg --fixed-strings --smart-case'
alias t='tmux'
alias ts='tmux new-session -s'
alias v='vim'

rgf() { rg --files --glob "*$1*" }
