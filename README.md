# Jesse's dotfiles

To install:
```zsh
echo "export DOTFILES=$(pwd)" > ~/.zprofile
cat example/zprofile >> ~/.zprofile
cp example/zshrc ~/.zshrc
git config --global include.path "$(pwd)/gitconfig"
git config --global core.excludesfile "$(pwd)/gitignore-global"
```
