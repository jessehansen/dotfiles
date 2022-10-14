" Install vim-plug if not found
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" vim-plug
call plug#begin(stdpath('data') . './plugged')

" required for lots of plugins
Plug 'nvim-lua/plenary.nvim'

" dir tree support
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}

" fuzzy finder
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }

" statusbar & buffer line
Plug 'nvim-lualine/lualine.nvim'
" git integration
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
" show plus/minus indicators in gutter
Plug 'mhinz/vim-signify'
" highlight what was just yanked
Plug 'machakann/vim-highlightedyank'
" use .editorconfig files
Plug 'editorconfig/editorconfig-vim'
" my preferred color scheme
Plug 'ellisonleao/gruvbox.nvim'
" close multiple buffers - I use Bwipeout to remove hidden buffers
Plug 'Asheq/close-buffers.vim'
" comment/uncomment lines & regions
Plug 'numToStr/Comment.nvim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
" split/join lines semantically
Plug 'AndrewRadev/splitjoin.vim'
" surround with brackets, quotes, etc.
Plug 'tpope/vim-surround'
" plural-aware find and replace
Plug 'tpope/vim-abolish'

" lsp support
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jayp0521/mason-null-ls.nvim'
Plug 'neovim/nvim-lspconfig'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
" autocomplete
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

" linting error list
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
" trouble diagnostics update too frequently, this plugin allows a timeout for
" updating
Plug 'https://gitlab.com/yorickpeterse/nvim-dd.git'

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
  Plug 'pantharshit00/vim-prisma'
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
