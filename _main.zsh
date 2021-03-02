load_zinit() {
    if [[ -e "${HOME}/.zinit/bin/zinit.zsh" ]]; then
        source "${HOME}/.zinit/bin/zinit.zsh"
    else
        echo "Install zinit"
        echo "$ mkdir ~/.zinit"
        echo "$ git clone https://github.com/zdharma/zinit.git ~/.zinit/bin"
    fi

    # oh-my-zsh plugins/libs
    #   OMZL::git.zsh - git common functions
    #   OMZP::git - git aliases
    #   OMZP::bgnotify - notifier when commands run long
    #   OMZP::vi-mode - set vi-mode and keybindings
    #   OMZP::fzf - fzf keybindings
    #   OMSL::history - primarily imported for omz's history command, which prints
    #       all history instead of just the last 30
    #   OMZL::termsupport - imported so tab title gets set correctly
    zinit wait lucid for \
        OMZL::git.zsh \
        OMZP::git \
        OMZP::bgnotify \
        OMZP::vi-mode \
        OMZP::fzf \
        OMZL::history.zsh \
        OMZL::termsupport.zsh

    # p10k theme
    zinit ice depth=1; zinit light romkatv/powerlevel10k

    # ordering here is deliberate - syntax highlighting must come last or it
    # complains about widget binding
    #   zsh-autosuggestions - autosuggest
    #   zsh-completions - completions library
    #   fast-syntax-highlighting - easily see syntax errors while typing cmds
    zinit wait lucid for \
        blockf \
        zsh-users/zsh-completions \
        atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
        atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma/fast-syntax-highlighting
    }

load_all() {
    source "$DOTFILES/plugin_config.zsh"
    source "$DOTFILES/history.zsh"
    source "$DOTFILES/setopt.zsh"
    source "$DOTFILES/exports.zsh"
    source "$DOTFILES/aliases.zsh"
    source "$DOTFILES/bindkeys.zsh"
    source "$DOTFILES/functions.zsh"

    [[ -e ${DOTFILES}/_local.zsh ]] && source ${DOTFILES}/_local.zsh
}

reload() {
    clear
    load_all
}

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

load_all

if [[ "$TERM" = "xterm-kitty" ]]; then
    kitty + complete setup zsh | source /dev/stdin
else
    export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [[ -e /usr/share/autojump/autojump.sh ]]; then
        source /usr/share/autojump/autojump.sh
    else
        echo "Install autojump"
        echo "$ sudo apt install autojump"
    fi

    load_zinit
    unset -f load_zinit
elif [[ "$OSTYPE" == "darwin"* ]]; then
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

        # Loading zinit must be last, because zsh-syntax-highlighting
        # needs to be loaded after all aliases, plugins, etc
        load_zinit
        unset -f load_zinit
    fi
fi
if (( ! $+commands[fzf] )); then
    echo "Install fzf"
    [[ "$OSTYPE" == "linux-gnu"* ]] && echo "$ sudo apt install fzf"
    [[ "$OSTYPE" == "darwin"* ]] && echo "$ brew install fzf"
fi
if (( ! $+commands[rg] )); then
    echo "Install ripgrep"
    [[ "$OSTYPE" == "linux-gnu"* ]] && echo "$ sudo apt install ripgrep"
    [[ "$OSTYPE" == "darwin"* ]] && echo "$ brew install ripgrep"
fi

source "$DOTFILES/p10k.zsh"

# some aliases need to be set again because they are overridden by zsh
# plugins. Always prefer our aliases
source "$DOTFILES/aliases.zsh"
