" Install vim-plug if not found
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Coc handles plugins differently. Define them here instead of relying on its
" internal store
let g:coc_config_home = $DOTFILES . "/nvim"
let g:coc_global_extensions = ['coc-json']

" vim-plug
call plug#begin(stdpath('data') . './plugged')

" language-specific plugins
" I should probably come up with a better way of doing this

" golang
if !empty($GOPATH)
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  let g:coc_global_extensions = g:coc_global_extensions + ['coc-go']

  " Use gofumpt
  let g:go_fmt_command="gopls"
  let g:go_gopls_gofumpt=1

endif

" rust
if isdirectory($HOME . "/.cargo")
  Plug 'rust-lang/rust.vim'
  let g:coc_global_extensions = g:coc_global_extensions + ['coc-rls']
endif

" python
if executable('python3')
  let g:coc_global_extensions = g:coc_global_extensions + ['@yaegassy/coc-pylsp']
endif

" javascript
if executable('node')
  Plug 'pangloss/vim-javascript'
  Plug 'leafgarland/typescript-vim'
  Plug 'mxw/vim-jsx'
  Plug 'ianks/vim-tsx'
  Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
  Plug 'jparise/vim-graphql'
  let g:coc_global_extensions = g:coc_global_extensions + ['coc-eslint', 'coc-tsserver']
  " Don't require jsx extension for jsx features
  let g:jsx_ext_required = 0
endif

Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'mileszs/ack.vim'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'machakann/vim-highlightedyank'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'editorconfig/editorconfig-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
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

" load plugins only on this machine (not checked into dotfiles repo)
" note - add Coc extensions using
" let g:coc_global_extensions= g:coc_global_extensions + ['my-extension']
call SourceMy ("plugs.local.vim")

" include my personal dotfiles plugin
execute "Plug '" . g:dotfiles_nvim . "/plug'"

call plug#end()

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif
