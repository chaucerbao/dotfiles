# Dotfiles Path
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd -P)"

# Load Homebrew Environment
command -v /opt/homebrew/bin/brew >/dev/null && eval "$(/opt/homebrew/bin/brew shellenv)"

# Exports
command -v bat >/dev/null && export BAT_CONFIG_PATH="${DOTFILES}/bat.conf"
command -v docker >/dev/null && [ "$(uname -m)" = "arm64" ] && export DOCKER_DEFAULT_PLATFORM=linux/arm64
command -v less >/dev/null && export LESS="--RAW-CONTROL-CHARS --ignore-case"
command -v rg >/dev/null && export RIPGREP_CONFIG_PATH="${DOTFILES}/.ripgreprc"

if command -v fzf >/dev/null; then
  if command -v fd >/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --strip-cwd-prefix --exclude ".git/" --exclude "node_modules/"'
    export FZF_ALT_C_COMMAND='fd --type directory --hidden --follow --strip-cwd-prefix --exclude ".git/" --exclude "node_modules/"'
  elif command -v rg >/dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!{.git,node_modules}/"'
  fi

  if command -v bat >/dev/null; then
    export FZF_CTRL_T_OPTS='--preview="bat --color=always {}"'
  else
    export FZF_CTRL_T_OPTS='--preview="cat {}"'
  fi

  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='--info=inline-right --margin=1,2 --no-separator --no-scrollbar'
  export FZF_ALT_C_OPTS='--preview="ls -1 --almost-all --classify --color=always --group-directories-first --literal {}"'
fi

if command -v nvim >/dev/null; then
  export VISUAL=nvim
elif command -v vim >/dev/null; then
  export VISUAL=vim
fi

# Path
command -v brew >/dev/null && PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
PATH="node_modules/.bin:$HOME/.bin:$PATH"
export PATH

# Clean Up
unset DOTFILES
