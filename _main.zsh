load_antigen() {
    source /usr/local/share/antigen/antigen.zsh

    source "$DOTFILES/plugin_config.zsh"

    antigen use oh-my-zsh

    antigen bundle git
    antigen bundle zsh-users/zsh-completions
    antigen bundle bgnotify
    antigen bundle vi-mode
    antigen bundle zsh-users/zsh-autosuggestions

    antigen theme bhilburn/powerlevel9k

    antigen bundle zsh-users/zsh-syntax-highlighting

    antigen apply
}

source "$DOTFILES/exports.zsh"
source "$DOTFILES/aliases.zsh"
source "$DOTFILES/bindkeys.zsh"
source "$DOTFILES/functions.zsh"

[[ -e ${DOTFILES}/_local.zsh ]] && source ${DOTFILES}/_local.zsh

if [[ "$TERM" = "xterm-kitty" ]]; then
    kitty + complete setup zsh | source /dev/stdin
else
    export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
fi

if (( ! $+commands[brew] )); then
    echo "Install brew"
    echo "/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\""
else
    if [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]]; then
      source $(brew --prefix)/etc/profile.d/autojump.sh
    else
      echo "Install autojump"
      echo "$ brew install autojump"
    fi
    if (( ! $+commands[terminal-notifier] )); then
      echo "Install terminal-notifier"
      echo "$ brew install terminal-notifier"
    fi

    # Loading antigen must be last, because zsh-syntax-highlighting
    # needs to be loaded after all aliases, plugins, etc
    if [[ -s "/usr/local/share/antigen/antigen.zsh" ]]; then
        load_antigen
        unset -f load_antigen
    else
        echo "Install antigen"
        echo "$ brew install antigen"
    fi
fi

# some aliases need to be set again because they are overridden by zsh
# plugins. Always prefer our aliases
source "$DOTFILES/aliases.zsh"
