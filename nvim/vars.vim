" contains variables and default config

" better update time for async
set updatetime=600

syntax enable

" NERDCommenter defaults
let g:NERDSpaceDelims = 1

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

" use ripgrep for fzf and Ack if avialable
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --follow
endif

" keep fzf history
let g:fzf_history_dir = '~/.local/share/fzf-history'

" always show tab line so that buffers are always available
set showtabline=2

" Don't require jsx extension for jsx features
let g:jsx_ext_required = 0

" Use gofumpt
let g:go_fmt_command="gopls"
let g:go_gopls_gofumpt=1
