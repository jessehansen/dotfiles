let g:dotfiles_nvim = $DOTFILES . "/nvim/"

function! SourceMy(relativePath)
  let l:fullPath = g:dotfiles_nvim . a:relativePath
  if filereadable(l:fullPath)
    execute "source " . l:fullPath
  endif
endfunction

" load plugins first so they can be overridden
call SourceMy ("plugs.vim")

call SourceMy ("lsp.lua")

" variables
call SourceMy ("vars.vim")
" autocommands
call SourceMy ("autocmds.vim")
" colorscheme
call SourceMy ("colors.vim")
" lightline config
call SourceMy ("lightline.vim")
" mappings
call SourceMy ("maps.vim")
