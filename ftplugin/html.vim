"common custom shortcuts

" Map F2 to execute/compile current file
" Map F3 to execute/compile current file in background
" Map F4 to open interactive interpreter or view file
" Map F5 to switch between syntax highlighting options
au FileType html noremap <F5> :setf python<CR>

"---

au FileType html setlocal autoindent
