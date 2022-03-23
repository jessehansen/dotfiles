" set up mappings to run tests and update snapshots for a python project
"
" This is very specific to a certain project. I should probably make it more
" configurable if I find myself working in other python projects

function! SetTestFileMappings()
  nnoremap <buffer> <leader>t :call RunPythonTests()<CR>
  if match(@%, '/snapshot_test_.*') > 0
    nnoremap <buffer> <leader>u :call PythonSnapshotUpdate()<CR>
  endif
endfunction

function! RunInRightTerminal(cmd_to_run)
  vertical rightbelow new
  call termopen(a:cmd_to_run)
  au BufDelete <buffer> wincmd p " switch back to last window
  startinsert
endfunction

function! RunPythonTests()
  let l:path_without_api = @%[4:]
  echo 'Running Tests in '
  echon l:path_without_api
  call RunInRightTerminal('docker compose run --rm web ./manage.py test ' . l:path_without_api)
endfunction

function! PythonSnapshotUpdate()
  let l:path_without_api = expand('%')[4:]
  let l:snap_path = expand('%:h') . '/snapshots/snap_' . expand('%:t')
  echo 'Updating Snapshots in '
  echon l:path_without_api
  call RunInRightTerminal('docker compose run --rm web ./manage.py test --snapshot-update --no-input --run-once ' . l:path_without_api . ' && black ' . l:snap_path)
endfunction

augroup python_test_file_mappings
  autocmd!
  autocmd BufRead,BufEnter */api/*/tests/* call SetTestFileMappings()
augroup END

