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

" variables
call SourceMy ("vars.vim")

" autocommands
call SourceMy ("autocmds.vim")

" global mappings - plugin mappings should be done in specific files
call SourceMy ("maps.lua")

" load plugins - also loads plugin configs
call SourceMy ("plugs.lua")

" set up lsp
call SourceMy ("lsp.lua")

call SourceMy ("commands.lua")
