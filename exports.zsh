[[ -e ${DOTFILES}/exports.local.zsh ]] && source ${DOTFILES}/exports.local.zsh

export EDITOR='nvim'

export BUILDER_ID_RSA=~/.ssh/id_rsa
export NPM_AUTH_TOKEN=
export GOPATH="/Users/jesse.hansen/go"
export PATH=$PATH:$(go env GOPATH)/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin
export LESS="-FRX"
export KEYTIMEOUT=1
#ripgreprc
export RIPGREP_CONFIG_PATH=$DOTFILES/ripgreprc

