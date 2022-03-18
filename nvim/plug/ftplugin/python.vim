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

function! RunPythonTests()
  let l:path_without_api = @%[4:]
  exec('echo "Running Tests in '. l:path_without_api . '"')
  exec('terminal docker compose run --rm web ./manage.py test ' . l:path_without_api)
endfunction

function! PythonSnapshotUpdate()
  let l:path_without_api = expand('%')[4:]
  let l:snap_path = expand('%:h') . '/snapshots/snap_' . expand('%:t')
  exec('echo "Updating Snapshots in '. l:path_without_api . '"')
  exec('terminal docker compose run --rm web ./manage.py test --snapshot-update --no-input --run-once ' . l:path_without_api . ' && black ' . l:snap_path)
endfunction

augroup python_test_file_mappings
  autocmd!
  autocmd BufRead,BufEnter */api/*/tests/* call SetTestFileMappings()
augroup END

