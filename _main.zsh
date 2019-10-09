# Preconditions
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
    echo "Install oh-my-zsh"
    echo "sh -c \"$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)\""
fi
export ZSH="${HOME}/.oh-my-zsh"

if [[ ! -d "${ZSH}/custom/themes/powerlevel9k" ]]; then
    echo "Install powerlevel9k"
    echo "git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k"
fi

if [[ ! -d "${ZSH}/custom/plugins/zsh-autosuggestions" ]]; then
    echo "Install zsh-autosuggestions"
    echo "git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
else
    ZSH_THEME="powerlevel9k/powerlevel9k"
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
fi

source "$DOTFILES/plugin_config.zsh"

plugins=(git zsh-completions zsh-syntax-highlighting bgnotify zsh-better-npm-completion vi-mode zsh-autosuggestions)
autoload -U compinit && compinit

source "$ZSH/oh-my-zsh.sh"

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
