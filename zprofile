export GOPATH="${HOME}/go"
export PATH=$PATH:$GOPATH/bin
export DOTFILES="${HOME}/src/dotfiles"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
test -e "${HOME}/src/dotfiles/exports.zsh" && source "${HOME}/src/dotfiles/exports.zsh"
