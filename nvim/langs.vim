let g:jesse_lang_go = v:false
if !empty($GOPATH)
  let g:jesse_lang_go = v:true
endif

let g:jesse_lang_rust = v:false
if isdirectory($HOME . "/.cargo")
  let g:jesse_lang_rust = v:true
endif

let g:jesse_lang_js = v:false
if executable('node')
  let g:jesse_lang_js = v:true
endif

let g:jesse_lang_python = v:false
if executable('python3')
  let g:jesse_lang_python = v:true
endif

" always load lua
let g:jesse_lang_lua = v:true

" override in langs.local.vim
call SourceMy ("langs.local.vim")
