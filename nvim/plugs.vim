" Install vim-plug if not found
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" vim-plug
call plug#begin(stdpath('data') . './plugged')

" language-specific plugins

if g:jesse_lang_go
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

  " Use gofumpt
  let g:go_fmt_command="gopls"
  let g:go_gopls_gofumpt=1
endif

if g:jesse_lang_rust
  Plug 'rust-lang/rust.vim'
  Plug 'simrat39/rust-tools.nvim'
endif

" javascript
if g:jesse_lang_js
  Plug 'pangloss/vim-javascript'
  Plug 'leafgarland/typescript-vim'
  Plug 'mxw/vim-jsx'
  Plug 'ianks/vim-tsx'
  Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
  Plug 'jparise/vim-graphql'
endif

Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'machakann/vim-highlightedyank'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'editorconfig/editorconfig-vim'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'tpope/vim-eunuch'
Plug 'Asheq/close-buffers.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'svermeulen/vim-subversive'
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

Plug 'neovim/nvim-lspconfig'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}

" load plugins only on this machine (not checked into dotfiles repo)
" note - add Coc extensions using
call SourceMy ("plugs.local.vim")

" include my personal dotfiles plugin
execute "Plug '" . g:dotfiles_nvim . "/plug'"

call plug#end()

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif
