"common custom shortcuts

" Map F2 to execute/compile current file
":!make<CR>
" Map F3 to execute/compile current file in background
":!make<CR>&
" Map F4 to open interactive interpreter or view file
" Map F5 to switch between syntax highlighting options

" <leader>c to comment current line
nnoremap <buffer> <leader>c I//<esc>

"---

au FileType c,cpp inoremap <buffer> /*! /*!<CR><SPACE>*<CR><SPACE>*/<UP><TAB>
