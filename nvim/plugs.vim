" Install vim-plug if not found
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" vim-plug
call plug#begin(stdpath('data') . './plugged')

" dir tree support
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
" fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" minimal status bar
Plug 'itchyny/lightline.vim'
" adds a line for open buffers at the top (I don't use tabs)
Plug 'mengelbrecht/lightline-bufferline'
" git integration
Plug 'tpope/vim-fugitive'
" show plus/minus indicators in gutter
Plug 'mhinz/vim-signify'
" highlight what was just yanked
Plug 'machakann/vim-highlightedyank'
" use .editorconfig files
Plug 'editorconfig/editorconfig-vim'
" my preferred color scheme
Plug 'patstockwell/vim-monokai-tasty'
" close multiple buffers - I use Bwipeout to remove hidden buffers
Plug 'Asheq/close-buffers.vim'
" comment/uncomment lines & regions
Plug 'scrooloose/nerdcommenter'
" split/join lines semantically
Plug 'AndrewRadev/splitjoin.vim'
" surround with brackets, quotes, etc.
Plug 'tpope/vim-surround'
" plural-aware find and replace
Plug 'tpope/vim-abolish'

" lsp support
Plug 'neovim/nvim-lspconfig'
" autocomplete
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

" language-specific plugins

if g:jesse_lang_go
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
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


" load plugins only on this machine (not checked into dotfiles repo)
call SourceMy ("plugs.local.vim")

" include my personal dotfiles plugin (easy way to check in ftplugin)
execute "Plug '" . g:dotfiles_nvim . "/plug'"

call plug#end()

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif
