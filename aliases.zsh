alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation

if (( $+commands[exa] )); then
  alias ls="exa"
  alias ll='ls -Fla'
  alias la='ls -aF'
else
  alias ll='ls -FGlAhp'
  alias la='ls -AF'
fi

alias l='ls -F'
alias lh='ls -d .*'
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias edit='nvim'                           # edit:         Opens any file in preferred editor
alias ~="cd ~"                              # ~:            Go Home
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias grep='grep --color'

if [[ "$OSTYPE" == "darwin"* ]]; then
  alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
  alias ss="/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background &"
fi


alias curl='curl -sS'

alias xit='exit'

# Git aliases

alias gcn="git commit --amend --no-edit --date=now"
alias gcan="git commit -a --amend --no-edit --date=now"
alias gst="git status -s"
alias gpb="git prune-branches-ok"
alias hstat="curl -o /dev/null --silent --head --write-out '%{http_code}\n'" $1
alias gs="git status -s"

# master -> main
alias gcm="git checkout main"
alias gcms="git checkout master"
alias gbda='git branch --no-color --merged | command grep -vE "^(\+|\*|\s*(master|main|develop|dev)\s*$)" | command xargs -n 1 git branch -d'
alias glum='git pull upstream main'
alias glums='git pull upstream master'
alias gmom='git merge origin/main'
alias gmoms='git merge origin/master'
alias gmum='git merge upstream/main'
alias gmums='git merge upstream/master'
alias grbm='git rebase main'
alias grbms='git rebase master'
alias grbom="git fetch && git rebase origin/main"
alias grboms="git fetch && git rebase origin/master"
