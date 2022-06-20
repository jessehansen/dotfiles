" set up mappings to run tests and update snapshots for a python project
"
" This is very specific to a certain project. I should probably make it more
" configurable if I find myself working in other python projects

function! SetTestFileMappings(path_prefix)
  execute 'nnoremap <buffer> <leader>t :call RunPythonTests("' . a:path_prefix . '")<CR>'
  execute 'nnoremap <buffer> <leader>u :call PythonSnapshotUpdate("' . a:path_prefix . '")<CR>'
endfunction

function! RunInRightTerminal(cmd_to_run)
  vertical rightbelow new
  call termopen(a:cmd_to_run)
  au BufDelete <buffer> wincmd p " switch back to last window
  startinsert
endfunction

function! RunPythonTests(path_prefix)
  let l:path_without_prefix = substitute(@%[len(a:path_prefix)+1:], '/', '.', 'g')[:-4]
  let l:workdir = '/usr/local/cedar/' . a:path_prefix
  echo 'Running Tests in '
  echon l:path_without_prefix
  call RunInRightTerminal('docker compose run --rm --workdir ' . l:workdir . ' web ./manage.py test ' . l:path_without_prefix)
endfunction

function! PythonSnapshotUpdate(path_prefix)
  let l:path_without_prefix = @%[len(a:path_prefix)+1:]
  let l:workdir = '/usr/local/cedar/' . a:path_prefix
  echo 'Updating Snapshots in '
  echon l:path_without_prefix
  call RunInRightTerminal('docker compose run --rm  --workdir ' . l:workdir . ' web ./manage.py test --snapshot-update --no-input --run-once ' . l:path_without_prefix)
endfunction

augroup python_test_file_mappings
  autocmd!
  autocmd BufRead,BufEnter */api/*/tests/* call SetTestFileMappings("api")
  autocmd BufRead,BufEnter */integrations/*/tests/* call SetTestFileMappings("integrations")
  autocmd BufRead,BufEnter */python_packages/*/tests/* call SetTestFileMappings("python_packages")
augroup END

