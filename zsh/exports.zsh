if [[ -d "/opt/homebrew/bin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export BUILDER_ID_RSA=~/.ssh/id_rsa
export NPM_AUTH_TOKEN=

# EDITOR
if (( $+commands[nvim] )); then
  export EDITOR='nvim'
  export SUDO_EDITOR=$(which nvim)
elif (( $+commands[vim] )); then
  export EDITOR='vim'
  export SUDO_EDITOR=$(which vim)
fi

# go exports
if [[ -d "$HOME/go" ]]; then
  export GOPATH="$HOME/go"
fi
if (( $+commands[go] )); then
  export PATH=$PATH:$(go env GOPATH)/bin
fi

# yarn exports
if (( $+commands[yarn] )); then
    export PATH=$PATH:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin
fi

# cargo bin
if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH=$PATH:$HOME/.cargo/bin
fi

# less commands
export LESS="-FRX"
export KEYTIMEOUT=1

# ripgrep config
export RIPGREP_CONFIG_PATH=$DOTFILES/ripgreprc
export FZF_DEFAULT_COMMAND="rg --files"

[[ -e ${DOTFILES}/zsh/exports.local.zsh ]] && source ${DOTFILES}/zsh/exports.local.zsh

