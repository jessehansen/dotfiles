# p10k instant prompt support
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

load_plugins() {
  if (( ! $+commands[sheldon] )); then
    echo "Install sheldon"
    echo "$ brew|cargo install sheldon"
  else
    # plugins contained in $DOTFILES/zsh/plugins.toml
    if [[ "$TERM_PROGRAM" = "iTerm.app" ]]; then
      export SHELDON_PROFILE="iterm"
    fi
    export SHELDON_CONFIG_DIR=$DOTFILES/zsh

    autoload -U compaudit compinit zrecompile
    # some plugins require the compdef function to be available, use compinit to add it here
    # The -D flag prevents churning of .zcompdump - we don't want to cache this pre-inited
    # output
    compinit -D
    eval "$(sheldon --color always source)"
    # some plugins change FPATH, reinit (& cache)
    compinit
  fi
}

load_all() {
  source "$DOTFILES/zsh/plugin_config.zsh"
  source "$DOTFILES/zsh/history.zsh"
  source "$DOTFILES/zsh/setopt.zsh"
  source "$DOTFILES/zsh/exports.zsh"
  source "$DOTFILES/zsh/aliases.zsh"
  source "$DOTFILES/zsh/bindkeys.zsh"
  source "$DOTFILES/zsh/functions.zsh"

  # kitty has notifications built in
  if [[ "$TERM" != "xterm-kitty" ]]; then
    source "$DOTFILES/zsh/notify.zsh"
  fi

  [[ -e ${DOTFILES}/zsh/_local.zsh ]] && source ${DOTFILES}/zsh/_local.zsh
}

reload() {
  load_all
}

load_all

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  load_plugins
  unset -f load_plugins
elif [[ "$OSTYPE" == "darwin"* ]]; then
  if (( ! $+commands[brew] )); then
    echo "Install brew"
    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  else
    if (( ! $+commands[terminal-notifier] )) && [[ "$TERM" != "xterm-kitty" ]]; then
      echo "Install terminal-notifier"
      echo "$ brew install terminal-notifier"
    fi

    # include homebrew completions
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

    # Loading zinit must be last, because zsh-syntax-highlighting
    # needs to be loaded after all aliases, plugins, etc
    load_plugins
    unset -f load_plugins
  fi
fi

if (( ! $+commands[fzf] )); then
  echo "Install fzf"
  [[ "$OSTYPE" == "linux-gnu"* ]] && echo "$ sudo apt install fzf"
  [[ "$OSTYPE" == "darwin"* ]] && echo "$ brew install fzf"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  source "$(brew --prefix fzf)/shell/completion.zsh"
  source "$(brew --prefix fzf)/shell/key-bindings.zsh"
else
  source "/usr/share/doc/fzf/examples/completion.zsh"
  source "/usr/share/doc/fzf/examples/key-bindings.zsh"
fi

if (( ! $+commands[rg] )); then
  echo "Install ripgrep"
  [[ "$OSTYPE" == "linux-gnu"* ]] && echo "$ sudo apt install ripgrep"
  [[ "$OSTYPE" == "darwin"* ]] && echo "$ brew install ripgrep"
fi

if (( ! $+commands[delta] )); then
  echo "Install delta"
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Get latest version for your platform from https://github.com/dandavison/delta/releases"
    echo "Example: wget https://github.com/dandavison/delta/releases/download/0.6.0/git-delta_0.6.0_armhf.deb && \\\n  sudo dpkg -i git-delta_0.6.0_armhf.deb && \\\n rm git-delta_0.6.0_armhf.deb"
  fi
  [[ "$OSTYPE" == "darwin"* ]] && echo "$ brew install git-delta"
fi

# load p10k config
source "$DOTFILES/zsh/p10k.zsh"
# support platforms without nerd fonts
if [[ "$JESSE_NOFONT" == "1" ]]; then
  typeset -g POWERLEVEL9K_MODE=powerline
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline)
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\UE0A0 '
  p10k reload
fi

# some aliases need to be set again because they are overridden by zsh
# plugins. Always prefer our aliases
source "$DOTFILES/zsh/aliases.zsh"
