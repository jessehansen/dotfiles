# Jesse's dotfiles

To install:
```zsh
# clone
git clone https://github.com/twindagger/dotfiles
# Add zprofile export that points to this directory
cd dotfiles
echo "export DOTFILES=$(pwd)" > ~/.zprofile

# set up zprofile & zshrc
cat example/zprofile >> ~/.zprofile
cp example/zshrc ~/.zshrc

# include .gitconfig from this directory
git config --global include.path "$(pwd)/gitconfig"
git config --global core.excludesfile "$(pwd)/gitignore-global"

# set up init.vim for nvim
cp example/init.vim ~/.config/nvim/
```
