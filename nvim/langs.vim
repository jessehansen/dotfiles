if !empty($GOPATH)
  let g:jesse_lang_go = v:true
endif

if isdirectory($HOME . "/.cargo")
  let g:jesse_lang_rust = v:true
endif

if executable('node')
  let g:jesse_lang_js = v:true
endif

if executable('python3')
  let g:jesse_lang_python = v:true
endif

" always load lua
let g:jesse_lang_lua = v:true

" override in langs.local.vim
call SourceMy ("langs.local.vim")
