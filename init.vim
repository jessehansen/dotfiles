" Install vim-plug if not found
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" vim-plug
call plug#begin(stdpath('data') . './plugged')

Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
" Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
if !empty($GOPATH)
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
endif
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'mxw/vim-jsx'
Plug 'ianks/vim-tsx'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'
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
Plug 'terryma/vim-multiple-cursors'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'svermeulen/vim-subversive'
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

" Coc handles plugins differently. Define them here instead of relying on its
" internal store
let g:coc_global_extensions = ['coc-json', 'coc-eslint', 'coc-tsserver']

if !empty($GOPATH)
  let g:coc_global_extensions = g:coc_global_extensions + ['coc-go']
endif

" load plugins only on this machine (not checked into dotfiles repo)
" note - add Coc extensions using
" let g:coc_global_extensions= g:coc_global_extensions + ['my-extension']
if filereadable($DOTFILES . "/init-plugins.local.vim")
  execute "source " . $DOTFILES . "/init-plugins.local.vim"
endif

" include dotfiles
execute "Plug '" . $DOTFILES . "/nvim'"

call plug#end()

" better update time for async
set updatetime=100

syntax enable
let g:vim_monokai_tasty_italic = 1

try
  colorscheme vim-monokai-tasty
catch /^Vim\%((\a\+)\)\=:E185/
  echo "Could not find monokai colorscheme"
endtry

if executable('rg')
  let g:ackprg = 'rg --vimgrep --no-heading --hidden'
  set grepprg=rg\ --vimgrep\ --smart-case\ --follow
  map <M-f> :Rg
endif

" NERDCommenter defaults
let g:NERDSpaceDelims = 1

let g:fzf_history_dir = '~/.local/share/fzf-history'

" Don't require jsx extension for jsx features
let g:jsx_ext_required = 0

" Use gofumpt
let g:go_fmt_command="gopls"
let g:go_gopls_gofumpt=1

" show hidden chars
set list
set ts=4 sts=4 sw=4 noexpandtab
set listchars=tab:▸\ ,eol:¬,space:·
" work with hidden buffers
set hidden
" don't ever ever flash my screen
set novisualbell
" always show line numbers
set nu
" Duplicated in lightline
set noshowmode
" live substitution
set inccommand=nosplit

" Mouse support
set mouse=a
if has('mouse_sgr')
    set ttymouse=sgr
endif

" disable background color erase (helps kitty and tmux)
let &t_ut=''

" let g:chadtree_settings = { "theme.text_colour_set": "nerdtree_syntax_dark"}
let g:NERDTreeDirArrowExpandable = ' '
let g:NERDTreeDirArrowCollapsible = ' '

" window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" window sizing
map <C-w>. <C-w>>
map <C-w>, <C-w><

"quickfix navigation
nnoremap <leader>> :cn<CR>
nnoremap <leader>< :cp<CR>

let mapleader=","
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>e :NERDTreeFind<CR>
" nnoremap <leader>e :NERDTreeFind<CR>
" edit init.vim (or vertically split with init.vim)
nnoremap <leader>rc :execute "e " . $DOTFILES . "/init.vim"<CR>
nnoremap <leader>vr :execute "vsp " . $DOTFILES . "/init.vim"<CR>
" %% in command mode inserts dir of current file
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>
" Find word under cursor
noremap <leader>g :Rg<space><C-r><C-w><CR>
" clear current search highlight
map <leader>/ :noh<CR>
" close other buffers
map <leader>q :Bdelete hidden<CR>
" close location list and quick fix windows
nnoremap <leader>x :ccl <bar> lcl<CR>

" fzf
map <C-p> :Files<CR>
map <M-p> :Commands<CR>
map <C-s> :GFiles?<CR>
map <M-s> :GFiles<CR>
" map <C-b> :Buffers<CR>
" map <C-f> :BLines<CR>
map <M-t> :History<CR>
nnoremap <leader>m :Maps<CR>

"go to xth buffer
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

"go to next/prev buffer
nnoremap <Leader>h :bp<CR>
nnoremap <Leader>l :bn<CR>

"close current buffer, switch to another
nmap <Leader>w :b#<bar>bd#<CR>

"select all
nnoremap <leader>a ggVG
"copy current buffer name to system clipboard
nnoremap <leader>p :let @+ = expand("%")<cr>

" visual mode mappings
vmap <Tab> >gv
vmap <S-Tab> <gv

" insert mode mappings
imap <C-s> <ESC>:w<CR>a
inoremap <S-Tab> <C-D>

" always open help in right vertical pane
autocmd FileType help wincmd L

" Lightline config
let g:lightline = {
  \ 'colorscheme': 'monokai_tasty',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head'
  \ },
\ }
let g:lightline.tabline          = {'left': [['buffers']], 'right': [[]]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
let g:lightline.enable = { 'statusline': 1, 'tabline': 1 }
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#unicode_symbols = 1
" always show tab line so that buffers are always available
set showtabline=2

" coc config
" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

nmap <leader>rn <Plug>(coc-rename)
nmap <F2> <Plug>(coc-rename)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" machine-specific config
if filereadable($DOTFILES . "/init.local.vim")
  execute "source " . $DOTFILES . "/init.local.vim"
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif
