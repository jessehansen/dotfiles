" contains theme / color scheme config

let g:vim_monokai_tasty_italic = 1

try
  colorscheme vim-monokai-tasty
catch /^Vim\%((\a\+)\)\=:E185/
  echo "Could not find monokai colorscheme"
endtry
