let g:dotfiles_nvim = $DOTFILES . "/nvim/"

function! SourceMy(relativePath)
  let l:fullPath = g:dotfiles_nvim . a:relativePath
  if filereadable(l:fullPath)
    execute "source " . l:fullPath
  endif
endfunction

" detect which langugages should be supported
" - should set g:jesse_lang_xxxx = true
call SourceMy ("langs.vim")
" override in _langs.local.vim
call SourceMy ("langs.local.vim")

" load plugins first so they can be overridden
call SourceMy ("plugs.vim")

" set up lsp servers
call SourceMy ("lsp.lua")

" variables
call SourceMy ("vars.vim")
" autocommands
call SourceMy ("autocmds.vim")
" colorscheme
call SourceMy ("colors.vim")
" lightline config
call SourceMy ("lightline.vim")
" coq config
call SourceMy ("coq.lua")
" mappings
call SourceMy ("maps.vim")
