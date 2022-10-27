alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias grep='grep --color'

if (( $+commands[exa] )); then
  alias ls='exa'
  alias ll='ls -Fla'
  alias la='ls -aF'
else
  alias ll='ls -FGlAhp'
  alias la='ls -AF'
fi

if (( $+commands[bat] )); then
  alias cat='bat'
fi

if [[ "$TERM" == "xterm-kitty" ]] && (( $+commands[kitty] )); then
  alias ssh='kitty +kitten ssh'
fi

alias l='ls -F'
alias lh='ls -d .*'
alias lr='ls -R | grep ':$' | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .2='cd ../../'                        # Go back 2 directory levels - for consistency
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels

alias edit='nvim'
alias ~='cd ~'

alias path='echo -e ${PATH//:/\\n}'

alias utc='date -u -I seconds'

if [[ "$OSTYPE" == "darwin"* ]]; then
  alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
  alias ss='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background &'
fi


alias curl='curl -sS'
alias hstat="curl -o /dev/null --silent --head --write-out '%{http_code}\n'" $1

alias xit='exit'

# Git aliases
# Outputs the name of the current branch
# Usage example: git pull origin $(git_current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function git_current_branch() {
  local ref
  ref=$(git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit'
alias gcn='git commit --amend --no-edit --date=now'
alias gcan='git commit -a --amend --no-edit --date=now'
alias gst='git status -s'
alias gs='git status -s'
alias gss='git status -s'
alias gsi='git status --ignored'
alias gd='git diff'
alias gdc='git diff --cached'
alias gpb='git prune-branches-ok'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout main'
alias gcms='git checkout master'
alias gcp='git cherry-pick'
alias grb='git rebase'
alias grbm='git rebase main'
alias grbms='git rebase master'
alias grbom='git fetch && git rebase origin/main'
alias grboms='git fetch && git rebase origin/master'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias gf='git fetch'
alias gup='git pull --rebase'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gpt='git push --tags'
alias gbrn='git branch -m'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'
alias gunwip='git log -n 1 | grep -q -c -- "--wip--" && git reset HEAD~1'
