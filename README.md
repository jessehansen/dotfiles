# Jesse's dotfiles

To install:
```zsh
# Add zprofile export that points to this directory
echo "export DOTFILES=$(pwd)" > ~/.zprofile
# include iterm integration and exports from this directory
cat example/zprofile >> ~/.zprofile
# Add zshrc that references _main.zsh
cp example/zshrc ~/.zshrc

# include .gitconfig from this directory
git config --global include.path "$(pwd)/gitconfig"
git config --global core.excludesfile "$(pwd)/gitignore-global"

# set up nvi
mkdir -p ~/.config/nvim/ftplugin
cp example/init.vim ~/.config/nvim/
cp example/ftplugin-go.vim ~/.config/nvim/ftplugin/go.vim
cp coc-settings.json ~/.config/nvim/
```
