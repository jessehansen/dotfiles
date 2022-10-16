" contains autocommands

" always open help in right vertical pane
autocmd FileType help wincmd L

" ESC in FZF should always close the window
autocmd FileType fzf tnoremap <buffer> <silent> <Esc> <C-\><C-n>:q<CR>

" :bp and :bn should skip quickfix buffers
autocmd FileType qf set nobuflisted

" Highlight yanked text
autocmd TextYankPost * silent! lua vim.highlight.on_yank() {on_visual=false}
