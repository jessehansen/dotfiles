mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview

#   extract:  Extract most known archives with one command
#   ---------------------------------------------------------
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2) tar xvjf $1;;
            *.tar.gz) tar xvzf $1;;
            *.tar.xz) tar xvJf $1;;
            *.tar.lzma) tar --lzma xvf $1;;
            *.bz2) bunzip $1;;
            *.rar) unrar $1;;
            *.gz) gunzip $1;;
            *.tar) tar xvf $1;;
            *.tbz2) tar xvjf $1;;
            *.tgz) tar xvzf $1;;
            *.zip) unzip $1;;
            *.Z) uncompress $1;;
            *.7z) 7z x $1;;
            *.dmg) hdiutul mount $1;; # mount OS X disk images
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# httpHeaders:      Grabs headers from web page
httpHeaders () { /usr/bin/curl -I -L $@ ; }

# -------------------------------------------------------------------
# any function from http://onethingwell.org/post/14669173541/any
# search for running processes
# -------------------------------------------------------------------
any() {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any " >&2 ; return 1
    else
        ps xauwww | grep -i --color=auto "[${1[1]}]${1[2,-1]}"
    fi
}

command_not_found_handler() {
    # Do not run within a pipe
    if test ! -t 1; then
        >&2 echo "command not found: $1"
        return 127
    fi
    if [ `echo $1 | cut -b1-3` = "git" ]
    then
        first=$1
        shift
        echo Autocorrecting to: git `echo $first | sed 's/git//'`$*
        git `echo $first | sed 's/git//'`$*
        return 0
    fi

    >&2 echo "command not found: $1"
    return 1
}

gotools () {
  origdir=`pwd`

  go get golang.org/x/tools/cmd/goimports@latest
  go get golang.or/x/lint/golint@latest
  go get golang.org/x/tools/gopls@latest
  go get mvdan.cc/gofumpt@latest
  go get mvdan.cc/gofumpt/gofumports@latest
  go get github.com/gregoryv/uncover@latest

  cd $origdir
}

gocover () {
    t="/tmp/go-cover.$$.tmp"
    go test -coverprofile=$t && go tool cover -html=$t && unlink $t
}

gouncover () {
    if [ "$1" = "" ]
    then
        echo "Usage: gouncover [FuncName]"
    fi
    t="/tmp/go-cover.$$.tmp"
    go test -coverprofile=$t && uncover $t $1 && unlink $t
}

rmake () {
    origdir=`pwd`
    while [[ ! -f ./Makefile && ! `pwd` == "/" ]]; do cd ../ ; done
    if [[ -f ./Makefile ]]; then
        make $@
    else
        echo "Couldn't find a makefile"
    fi
    cd $origdir
}
alias m=rmake

jwtdump () {
  target="all"
  raw=""
  while [[ "$#" -gt 0 ]]; do
    case $1 in
        -H|--header) target="header" ;;
        -p|--payload) target="payload" ;;
        -a|--all) target="all" ;;
        -r|--raw) raw="-cM" ;;
        -h|--help)
          echo "JWT dump tool - takes input from stdin"
          echo
          echo "Syntax: jwtdump [-H|--header|-p|--payload|-a|--all] [-r|--raw] <string>"
          echo "options:"
          echo "h|help     Print this Help."
          echo "H|header   Print JWT header contents."
          echo "p|payload  Print JWT payload contents."
          echo "a|all      Print header, payload, and signature."
          echo "r|raw      Don't pretty-print the output."
          echo
          echo " Example: pbpaste | jwtdump -a"
          return;;
        *) echo "Unknown parameter passed: $1"; return 1;;
    esac
    shift
  done
  jwtParts=`\cat`
  if [[ $target == "all" ]]; then
    echo "Header:"
  fi
  if [[ $target == "all" ]] || [[ $target == "header" ]]; then
    echo -n "${jwtParts%%.*}" | base64 --decode | jq $raw
  fi
  if [[ $target == "all" ]]; then
    echo "Payload:"
  fi
  if [[ $target == "all" ]] || [[ $target == "payload" ]]; then
    echo -n "${${jwtParts%.*}#*.}" | base64 --decode | jq $raw
  fi
  if [[ $target == "all" ]]; then
    echo "Signature:"
    echo "${jwtParts##*.}"
  fi
}

nofont () {
  typeset -g POWERLEVEL9K_MODE=powerline
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline)
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\UE0A0 '
  p10k reload
}

if (( $+commands[op] )); then
  pass () {
    if [ "$1" = "" ]; then
      echo "Usage: pass [Service]"
    else
      op item get $1 --fields password
    fi
  }

  passf () {
    if [ "$1" = "" ]; then
      echo "Usage: passf [search str]"
    else
      for acct in `op account list --format json | jq -r '.[].url'`; do
        for item in `op item list --account $acct | grep -i $1 | cut -d ' ' -f 1`; do
          op item get $item --account $acct
        done
      done
    fi
  }
fi
