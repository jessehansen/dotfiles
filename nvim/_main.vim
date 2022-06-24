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

" load plugins
call SourceMy ("plugs.vim")

" coq config
call SourceMy ("coq.lua")
" CHADtree config
call SourceMy ("chadtree.lua")
" Trouble config
call SourceMy ("trouble.lua")
" set up lsp servers
call SourceMy ("lsp.lua")

" variables
call SourceMy ("vars.vim")
" autocommands
call SourceMy ("autocmds.vim")
" colorscheme
call SourceMy ("colors.vim")
" lightline config
call SourceMy ("lualine.lua")
" mappings
call SourceMy ("maps.vim")
