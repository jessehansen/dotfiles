export EDITOR='vim'

# Enable color in grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;33'
export BUILDER_ID_RSA=~/.ssh/id_rsa
export NPM_AUTH_TOKEN=
export GOPATH="/Users/jesse.hansen/go"
export PATH=$PATH:$(go env GOPATH)/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin
export LESS="-FRX"
# export TERM="xterm-256color"
export KEYTIMEOUT=1

[[ -e ${DOTFILES}/exports.local.zsh ]] && source ${DOTFILES}/exports.local.zsh
