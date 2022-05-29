" contains autocommands

" always open help in right vertical pane
autocmd FileType help wincmd L

autocmd FileType fzf tnoremap <buffer> <silent> <Esc> <C-\><C-n>:q<CR>
