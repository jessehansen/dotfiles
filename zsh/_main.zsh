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
    return
  fi

  # oh-my-zsh plugins/libs
  #   OMZL::functions.zsh - OMZ common functions - including this fixes an issue in apple terminal that resulted in command not found: omz_urlencode
  #   OMZP::bgnotify - notifier when commands run long
  #   OMZP::vi-mode - set vi-mode and keybindings
  #   OMZP::fzf - fzf keybindings
  #   OMSL::history - primarily imported for omz's history command, which prints
  #       all history instead of just the last 30
  zinit wait lucid for \
    OMZL::functions.zsh \
    OMZP::bgnotify \
    OMZP::vi-mode \
    OMZP::fzf \
    OMZL::history.zsh \
    OMZP::nvm

  zinit load agkozak/zsh-z

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

load_zinit_warp() {
  if [[ -e "${HOME}/.zinit/bin/zinit.zsh" ]]; then
    source "${HOME}/.zinit/bin/zinit.zsh"
  else
    echo "Install zinit"
    echo "$ mkdir ~/.zinit"
    echo "$ git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin"
    return
  fi

  zinit wait lucid for \
    OMZL::history.zsh \
    OMZP::nvm
}


load_all() {
  source "$DOTFILES/zsh/plugin_config.zsh"
  source "$DOTFILES/zsh/history.zsh"
  source "$DOTFILES/zsh/setopt.zsh"
  source "$DOTFILES/zsh/exports.zsh"
  source "$DOTFILES/zsh/aliases.zsh"

  if [[ $TERM_PROGRAM != "WarpTerminal" ]];then
    source "$DOTFILES/zsh/bindkeys.zsh"
  fi

  source "$DOTFILES/zsh/functions.zsh"

  [[ -e ${DOTFILES}/zsh/_local.zsh ]] && source ${DOTFILES}/zsh/_local.zsh
}

reload() {
  load_all
}

load_all

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  load_zinit
  unset -f load_zinit
  unset -f load_zinit_warp
elif [[ "$OSTYPE" == "darwin"* ]]; then
  if (( ! $+commands[brew] )); then
    echo "Install brew"
    echo "/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\""
  else
    if (( ! $+commands[terminal-notifier] )); then
      echo "Install terminal-notifier"
      echo "$ brew install terminal-notifier"
    fi

    # Loading zinit must be last, because zsh-syntax-highlighting
    # needs to be loaded after all aliases, plugins, etc
    if [[ $TERM_PROGRAM != "WarpTerminal" ]];then
      load_zinit
      unset -f load_zinit
      unset -f load_zinit_warp
    else
      load_zinit_warp
      unset -f load_zinit
      unset -f load_zinit_warp
    fi
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
  [[ "$OSTYPE" == "darwin"* ]] && echo "$ brew install git-delta"
fi

if [[ $TERM_PROGRAM != "WarpTerminal" ]];then
  source "$DOTFILES/zsh/p10k.zsh"
fi

# some aliases need to be set again because they are overridden by zsh
# plugins. Always prefer our aliases
source "$DOTFILES/zsh/aliases.zsh"
