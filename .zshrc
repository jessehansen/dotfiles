#! /bin/zsh
# Path to your oh-my-zsh installation.
export ZSH=/Users/jessehansen/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(history dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(longstatus time)
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M:%S \uE868  %Y-%m-%d}"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MODE='awesome-patched'
# enable the vcs segment in general
POWERLEVEL9K_SHOW_CHANGESET=true
# just show the 6 first characters of changeset
POWERLEVEL9K_CHANGESET_HASH_LENGTH=6

ZSH_THEME="powerlevel9k/powerlevel9k"

ENABLE_CORRECTION="false"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-completions zsh-syntax-highlighting bgnotify)
autoload -U compinit && compinit

# User configuration
export PATH="/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

source "$ZSH/oh-my-zsh.sh"

source ~/.zsh/docker.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/exports.zsh
# source ~/.zsh/completion.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/bindkeys.zsh
source ~/.zsh/functions.zsh
# source ~/.zsh/history.zsh
# source ~/.zsh/zsh_hooks.zsh
# source ~/.zsh/hitch.zsh

export NVM_DIR="/Users/jessehansen/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

# The next line updates PATH for the Google Cloud SDK.
source '/Users/jessehansen/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
source '/Users/jessehansen/google-cloud-sdk/completion.zsh.inc'
