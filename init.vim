" vim-plug
call plug#begin(stdpath('data') . './plugged')

Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'fatih/vim-go', { 'do': 'GoUpdateBinaries' }
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'
Plug 'ctrlpvim/ctrlp.vim'
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

call plug#end()

syntax enable
let g:vim_monokai_tasty_italic = 1
colorscheme vim-monokai-tasty

if executable('rg')
    " Note we extract the column as well as the file and line number
    let g:ackprg = 'rg --vimgrep --no-heading'
    let g:ctrlp_user_command = 'rg --files %s'
    let g:ctrlp_use_caching = 0
    let g:ctrlp_working_path_mode = 'ra'
    let g:ctrlp_switch_buffer = 'et'
endif

" Don't require jsx extension for jsx features
let g:jsx_ext_required = 0

" Use goimports instead of go fmt
let g:go_fmt_command = "goimports"

let g:splitjoin_html_attributes_bracket_on_new_line = 1

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

" Mouse support
set mouse=a
if has('mouse_sgr')
    set ttymouse=sgr
endif

" disable background color erase (helps kitty and tmux)
let &t_ut=''

" window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" window sizing
map <C-w>. <C-w>>
map <C-w>, <C-w><

let mapleader=","
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>e :NERDTreeFind<CR>
" edit init.vim (or vertically split with init.vim)
nnoremap <leader>rc :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>vr :vsp ~/.config/nvim/init.vim<CR>
" %% in command mode inserts dir of current file
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>
" Find word under cursor
noremap <leader>g :Ack<space><C-r><C-w><CR>
" clear current search highlight
map <leader>/ :noh<CR>
" close other buffers
map <leader>q :CloseHiddenBuffers<CR>
" close location list and quick fix windows
nnoremap <leader>x :ccl <bar> lcl<CR>

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

"select all
nnoremap <leader>a ggVG

" visual mode mappings
vmap <Tab> >gv
vmap <S-Tab> <gv

" insert mode mappings
imap <C-s> <ESC>:w<CR>a
imap <C-b> <ESC>,ba
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
