" contains custom mappings
" additional mappings present in plug/ftplugin for specific file types

let mapleader=","

" window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" window sizing
map <C-w>. <C-w>>
map <C-w>, <C-w><

" FZF Mappings

" find a file
map <C-p> :Files<CR>
" find a command
map <M-p> :Commands<CR>
" find a changed file
map <C-s> :GFiles?<CR>
" find a git-tracked file
map <M-s> :GFiles<CR>
" find a recently opened file
map <C-e> :History<CR>
" find a mapping
nnoremap <leader>m :Maps<CR>
" find in current dir
map <M-f> :Rg
" Find word under cursor
noremap <leader>g :Rg<space><C-r><C-w><CR>
" (Visual mode) find selection - replaces whitespace with '\s+'
xnoremap <leader>g :<C-U>
  \<CR>
  \gv"zy:Rg <C-R><C-R>=substitute(
  \escape(@z, '\.*$^~['), '\_s\+', '\\s+', 'g')<CR><CR>

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

"quickfix navigation
nnoremap <leader>> :cn<CR>
nnoremap <leader>. :cn<CR>
nnoremap <leader>< :cp<CR>
nnoremap <leader>, :cp<CR>

" show dir tree
nnoremap <leader>d :CHADopen<CR>
" hack to replicate NERDTreeFind - turn follow on, then open & focus, then turn it back off
nnoremap <leader>e :lua CHAD.Toggle_follow(false);CHAD.Open({'--always-focus'});CHAD.Toggle_follow(false)<CR>

" edit _main.vim (or vertically split with _main.vim)
nnoremap <leader>rc :execute "e " . g:dotfiles_nvim . "_main.vim"<CR>
nnoremap <leader>vr :execute "vsp " . g:dotfiles_nvim . "_main.vim"<CR>

" %% in command mode inserts dir of current file
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>

" clear current search highlight
map <leader>/ :noh<CR>
" close other buffers
" Bwipeout actually deletes the buffers instead of just hiding them. It's rare
" that I want to keep a buffer around but hidden
map <leader>q :Bwipeout hidden<CR>

" close location list and quick fix windows
nnoremap <leader>x :ccl <bar> lcl<CR>

" ,y = copy to clipboard
xnoremap <leader>y "+y

" Buffer navigation

"go to xth buffer
nmap <leader>1 <Plug>lightline#bufferline#go(1)
nmap <leader>2 <Plug>lightline#bufferline#go(2)
nmap <leader>3 <Plug>lightline#bufferline#go(3)
nmap <leader>4 <Plug>lightline#bufferline#go(4)
nmap <leader>5 <Plug>lightline#bufferline#go(5)
nmap <leader>6 <Plug>lightline#bufferline#go(6)
nmap <leader>7 <Plug>lightline#bufferline#go(7)
nmap <leader>8 <Plug>lightline#bufferline#go(8)
nmap <leader>9 <Plug>lightline#bufferline#go(9)
nmap <leader>0 <Plug>lightline#bufferline#go(10)

" This used to just be :bp and :bn, but I didn't like quickfix and dir-list
" windows showing up when I was trying to tab through windows. Also the order
" was based on when the window was opened, not the lightline buffer ordinal.
" This function only opens buffers that have lightline ordinals and uses the
" current ordinal to determine next/prev, fixing both issues
function! GoToRelativeBuffer(delta)
  let l:next_buf_ord = lightline#bufferline#get_ordinal_number_for_buffer(bufnr('%'))+a:delta
  let l:next_buf_nr = lightline#bufferline#get_buffer_for_ordinal_number(l:next_buf_ord)
  if l:next_buf_nr > 0
    exec l:next_buf_nr . "b"
  endif
endfunction

"go to next/prev buffer
nnoremap <silent> <Leader>h :call GoToRelativeBuffer(-1)<CR>
nnoremap <silent> <Leader>l :call GoToRelativeBuffer(1)<CR>

" ,w = close current buffer, switch to another
nmap <Leader>w :b#<bar>bd#<CR>

" ,a = select all
nnoremap <leader>a ggVG
nnoremap <C-a> ggVG

" ,p = copy current buffer name to system clipboard
nnoremap <leader>p :let @+ = expand("%")<cr>

" visual mode indentation should not clear selection
vmap <Tab> >gv
vmap <S-Tab> <gv
vnoremap > >gv
vnoremap < <gv

" ctrl-s saves in insert mode
imap <C-s> <ESC>:w<CR>a

" terminal mode mappings

" Esc exits
tnoremap <Esc> <C-\><C-n>
