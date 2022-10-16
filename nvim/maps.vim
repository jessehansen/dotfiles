" contains custom mappings
" additional mappings present in plugin configs and in plug/ftplugin for specific file types

let mapleader=","

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
nnoremap <leader>. :cn<CR>
nnoremap <leader>< :cp<CR>
nnoremap <leader>, :cp<CR>

" %% in command mode inserts dir of current file
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>

" clear current search highlight
map <leader>/ :noh<CR>

" close location list and quick fix windows
nnoremap <leader>x :ccl <bar> lcl<CR>

" ,y = copy to clipboard
xnoremap <leader>y "+y
" <c-y> = copy to clipboard
xnoremap <C-y> "+y
nnoremap <C-y> "+yy

" when pasting over in visual mode, keep pasted test in register
xnoremap p pgv"@=v:register.'y'<cr>

"go to next/prev buffer
nnoremap <silent> <Leader>h :bp<cr>
nnoremap <silent> <Leader>l :bn<cr>

" ,w = close current buffer, switch to another
nmap <Leader>w :b#<bar>bd#<CR>

" ,a = select all
nnoremap <leader>a ggVG

" copies a:value to system clipboard and " register, then echoes that
function! CopySystem(value)
  let @+ = a:value
  echo "Copied '" . a:value . "' to system clipboard"
endfunction

" ,p = copy current buffer name to system clipboard
nnoremap <silent> <leader>p :call CopySystem(expand("%"))<cr>

" visual mode indentation should not clear selection
vmap <Tab> >gv
vmap <S-Tab> <gv
vnoremap > >gv
vnoremap < <gv

" ctrl-s saves in insert mode
inoremap <C-s> <ESC>:w<CR>a

" terminal mode mappings

" Esc exits
tnoremap <Esc> <C-\><C-n>
