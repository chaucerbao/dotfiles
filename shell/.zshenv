export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export NVM_DIR=/usr/local/var/nvm
source $(brew --prefix nvm)/nvm.sh

export PATH=node_modules/.bin:vendor/bin:~/.composer/vendor/bin:$PATH
