if exists("g:loaded_yarn_plugin")
  finish
endif
let g:loaded_yarn_plugin = 1

lua require'yarn'

function! s:yarn_complete_packages(A, L, P)
  return v:lua.yarn_complete_packages(a:A, a:L, a:P)
endfunction

function! s:yarn_open(name)
  call v:lua.require('yarn').open_package(a:name)
endf

command! -nargs=1 -complete=customlist,<sid>yarn_complete_packages Yopen call <sid>yarn_open(<q-args>)

augroup yarn_plugin
  au!
  au FileType *
        \  if filereadable("yarn.lock")
        \|   call v:lua.require('yarn').cache_installed_packages()
        \| endif
augroup END
