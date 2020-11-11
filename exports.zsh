export EDITOR='nvim'

export BUILDER_ID_RSA=~/.ssh/id_rsa
export NPM_AUTH_TOKEN=
# go exports
if (( $+commands[go] )); then
    export GOPATH="/Users/jesse.hansen/go"
    export PATH=$PATH:$(go env GOPATH)/bin
fi

# yarn exports
if (( $+commands[yarn] )); then
    export PATH=$PATH:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin
fi

# less commands
export LESS="-FRX"
export KEYTIMEOUT=1

#ripgrep config
export RIPGREP_CONFIG_PATH=$DOTFILES/ripgreprc
export FZF_DEFAULT_COMMAND="rg --files"


[[ -e ${DOTFILES}/exports.local.zsh ]] && source ${DOTFILES}/exports.local.zsh

