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
" Telescope Mappings

" find a file
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

map <C-p> :Telescope find_files<CR>
" find a command
map <M-p> :Telescope commands<CR>
" find a changed file
map <C-s> :Telescope git_status<CR>
" find a git-tracked file
map <M-s> :Telescope git_files<CR>
" find a recently opened file
map <C-e> :Telescope oldfiles<CR>
" find a mapping
nnoremap <leader>m :Telescope keymaps<CR>
" Mapping selecting mappings
nmap <leader><tab> :lua require("telescope.builtin").keymaps{modes={"n"}}<CR>
xmap <leader><tab> :lua require("telescope.builtin").keymaps{modes={"x"}}<CR>

" find in current dir
map <M-f> :Telescope live_grep
" Find word under cursor
noremap <leader>g :Telescope grep_string<space>search=<C-r><C-w><CR>

" (Visual mode) find selection - replaces whitespace with '\s+'
xnoremap <leader>g :<C-U>
  \<CR>
  \gv"zy:Telescope grep_string use_regex=true search=<C-R><C-R>=substitute(
  \escape(@z, '\.*$^~['), '\_s\+', '\\s+', 'g')<CR><CR>

" fix my :Rg muscle memory
cabbrev Rg Telescope grep_string

" End Telescope Mappings

"quickfix navigation
nnoremap <leader>> :cn<CR>
nnoremap <leader>. :cn<CR>
nnoremap <leader>< :cp<CR>
nnoremap <leader>, :cp<CR>

" show dir tree
nnoremap <leader>d :CHADopen<CR>
" hack to replicate NERDTreeFind - turn follow on, then open & focus, then turn it back off
 nnoremap <leader>e :lua CHAD.Toggle_follow(false);CHAD.Open({'--always-focus'});CHAD.Toggle_follow(false)<CR>

" %% in command mode inserts dir of current file
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>

" clear current search highlight
map <leader>/ :noh<CR>
" close other buffers
" Bwipeout actually deletes the buffers instead of just hiding them. It's rare
" that I want to keep a buffer around but hidden
map <leader>q :Bwipeout hidden<CR>

" close location list and quick fix windows
nnoremap <leader>x :ccl <bar> lcl <bar> TroubleClose<CR>

" ,y = copy to clipboard
xnoremap <leader>y "+y
" <c-y> = copy to clipboard
xnoremap <C-y> "+y
nnoremap <C-y> "+yy

" when pasting over in visual mode, keep pasted test in register
xnoremap p pgv"@=v:register.'y'<cr>

" Buffer navigation

"go to xth buffer
nmap <silent> <leader>1 :LualineBuffersJump 1<cr>
nmap <silent> <leader>2 :LualineBuffersJump! 2<cr>
nmap <silent> <leader>3 :LualineBuffersJump! 3<cr>
nmap <silent> <leader>4 :LualineBuffersJump! 4<cr>
nmap <silent> <leader>5 :LualineBuffersJump! 5<cr>
nmap <silent> <leader>6 :LualineBuffersJump! 6<cr>
nmap <silent> <leader>7 :LualineBuffersJump! 7<cr>
nmap <silent> <leader>8 :LualineBuffersJump! 8<cr>
nmap <silent> <leader>9 :LualineBuffersJump! 9<cr>
nmap <silent> <leader>0 :LualineBuffersJump $<cr>

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
" ,P = copy github link to current file
nnoremap <silent> <leader>P :GBrowse!<cr>
" ,L = copy github link to current line
nnoremap <silent> <leader>L :.GBrowse!<cr>
" same, but for selected range (& keep it selected)
xnoremap <silent> <leader>L :GBrowse!<cr>gv"@=v:register.'y'

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

" Trouble mappings
nnoremap <leader>t <cmd>TroubleToggle<cr>
" nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
" nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
" nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
" nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
" nnoremap gR <cmd>TroubleToggle lsp_references<cr>

