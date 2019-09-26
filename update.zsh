brew list > ${DOTFILES}/brew_list
brew cask list > ${DOTFILES}/brew_cask_list

\cp ~/.gitconfig ${DOTFILES}/gitconfig
\cp ~/.gitignore-global ${DOTFILES}/gitignore-global
\cp ~/.zprofile ${DOTFILES}/zprofile
\cp ~/.zshrc ${DOTFILES}/zshrc
