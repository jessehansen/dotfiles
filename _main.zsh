load_antigen() {
    if [[ -e /usr/local/share/antigen/antigen.zsh ]]; then
        source /usr/local/share/antigen/antigen.zsh
    elif [[ -e "${HOME}/antigen.zsh" ]]; then
	source "${HOME}/antigen.zsh"
    else
	echo "Install antigen"
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	    echo "$ curl -L git.io/antigen > ~/antigen.zsh"
	    echo "$ chmod +x ~/antigen.zsh"
        elif [[ "$OSTYPE" == "darwin"* ]]; then
	    echo "$ brew install antigen"
	fi
	return
    fi

    source "$DOTFILES/plugin_config.zsh"

    antigen use oh-my-zsh

    antigen bundle git
    antigen bundle zsh-users/zsh-completions
    antigen bundle bgnotify
    antigen bundle vi-mode
    antigen bundle zsh-users/zsh-autosuggestions

    antigen theme romkatv/powerlevel10k

    antigen bundle zsh-users/zsh-syntax-highlighting

    antigen apply
}

load_all() {
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

	load_antigen
	unset -f load_antigen
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

	    # Loading antigen must be last, because zsh-syntax-highlighting
	    # needs to be loaded after all aliases, plugins, etc
	    load_antigen
	    unset -f load_antigen
	fi
fi

source "$DOTFILES/p10k.zsh"

# some aliases need to be set again because they are overridden by zsh
# plugins. Always prefer our aliases
source "$DOTFILES/aliases.zsh"
