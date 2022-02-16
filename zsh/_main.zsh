if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

load_zinit() {
  if [[ -e "${HOME}/.zinit/bin/zinit.zsh" ]]; then
    source "${HOME}/.zinit/bin/zinit.zsh"
  else
    echo "Install zinit"
    echo "$ mkdir ~/.zinit"
    echo "$ git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin"
    exit
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
    zdharma-continuum/fast-syntax-highlighting

  if [[ "$TERM_PROGRAM" = "iTerm.app" ]]; then
    zinit ice as"command" pick"bin/*" atclone'./_utils/download_files.sh' \
      atpull'%atclone' if"[[ $+ITERM_PROFILE ]]"
    zinit light decayofmind/zsh-iterm2-utilities

    # functions
    zinit snippet 'https://raw.githubusercontent.com/gnachman/iTerm2-shell-integration/main/shell_integration/zsh'
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

  [[ -e ${DOTFILES}/zsh/_local.zsh ]] && source ${DOTFILES}/zsh/_local.zsh
}

reload() {
  clear
  load_all
}

load_all

if [[ "$TERM" = "xterm-kitty" ]]; then
  kitty + complete setup zsh | source /dev/stdin
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
if (( ! $+commands[delta] )); then
  echo "Install delta"
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Get latest version for your platform from https://github.com/dandavison/delta/releases"
    echo "Example: wget https://github.com/dandavison/delta/releases/download/0.6.0/git-delta_0.6.0_armhf.deb && \\\n  sudo dpkg -i git-delta_0.6.0_armhf.deb && \\\n rm git-delta_0.6.0_armhf.deb"
  fi
  [[ "$OSTYPE" == "darwin"* ]] && echo "$ brew install delta"
fi

source "$DOTFILES/zsh/p10k.zsh"

# some aliases need to be set again because they are overridden by zsh
# plugins. Always prefer our aliases
source "$DOTFILES/zsh/aliases.zsh"
