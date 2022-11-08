# Jesse's dotfiles

To install:
```zsh
# clone
git clone https://github.com/jessehansen/dotfiles
# Add zshenv export that points to this directory
cd dotfiles
echo "export DOTFILES=$(pwd)" > ~/.zshenv

# set up zshenv & zshrc
cat example/zshenv >> ~/.zshenv
cp example/zshrc ~/.zshrc

# include .gitconfig from this directory
git config --global include.path "$(pwd)/gitconfig"
git config --global core.excludesfile "$(pwd)/gitignore-global"

# set up init.vim for nvim
cp example/init.vim ~/.config/nvim/
```
