# Dotfiles Path
DOTFILES_ABS="$(cd $(dirname ${BASH_SOURCE[0]:-$0})/..; pwd -P)"
DOTFILES="$DOTFILES_ABS"
case "$DOTFILES" in
	$HOME* ) DOTFILES="~${DOTFILES#$HOME}" ;;
esac

# Homebrew Environment
if [ "$(uname -m)" = "arm64" ]; then
	HOMEBREW_PREFIX="/opt/homebrew"
else
	HOMEBREW_PREFIX="/usr/local"
fi
if [ -x "$(command -v ${HOMEBREW_PREFIX}/bin/brew)" ]; then
	eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
fi

# Exports
if [ -x "$(command -v bat)" ]; then
	eval export BAT_CONFIG_PATH=$DOTFILES/bat.conf
fi

if [ -x "$(command -v docker)" ] && [ "$(uname -m)" = "arm64" ]; then
	export DOCKER_DEFAULT_PLATFORM=linux/arm64
fi

if [ -x "$(command -v fzf)" ]; then
	if [ -x "$(command -v fd)" ]; then
		export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --strip-cwd-prefix --exclude ".git/" --exclude "node_modules/"'
		export FZF_ALT_C_COMMAND='fd --type directory --hidden --follow --strip-cwd-prefix --exclude ".git/" --exclude "node_modules/"'
	elif [ -x "$(command -v rg)" ]; then
		export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!{.git,node_modules}/"'
	fi

	export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
fi

if [ -x "$(command -v less)" ]; then
	export LESS="--RAW-CONTROL-CHARS --ignore-case"
fi

if [ -x "$(command -v n)" ]; then
	export N_PREFIX=$HOME/.n
	export N_PRESERVE_NPM=1
	export N_PRESERVE_COREPACK=1
fi

if [ -x "$(command -v rg)" ]; then
	eval export RIPGREP_CONFIG_PATH=${DOTFILES}/.ripgreprc
fi

if [ -x "$(command -v nvim)" ]; then
	export VISUAL=nvim
elif [ -x "$(command -v vim)" ]; then
	export VISUAL=vim
fi

# Path
if [ -x "$(command -v brew)" ]; then
	COREUTILS="$(brew --prefix coreutils)/libexec/gnubin"
fi

export PATH=node_modules/.bin:$HOME/.bin:$N_PREFIX/bin:$COREUTILS:$PATH

# Clean Up
unset DOTFILES DOTFILES_ABS HOMEBREW_PREFIX
