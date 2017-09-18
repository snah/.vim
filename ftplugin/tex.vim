"----------------------------
" common custom shortcuts
"----------------------------

" Map F2 to execute/compile current file
noremap <F2> :w\|! pdflatex "%"<CR>
" Map F3 to execute/compile current file in background
noremap <F2> :w\|! pdflatex "%" &<CR>
" Map F4 to open interactive interpreter or view file
noremap <F4> :!xpdf<SPACE>%:r.pdf<SPACE>&<CR><CR>
" Map F5 to switch between syntax highlighting options

" <leader>c to comment current line
nnoremap <buffer> <leader>c I%<esc>

"----------------------------
" settings
"----------------------------

set spell

"----------------------------
" latex command shortcuts
"----------------------------
:command! -nargs=1 LatexCmd normal!yyPPa\begin{<args>}<DOWN><DOWN>\end{<args>}<UP><TAB>

noremap  <buffer> <C-b> <ESC>:LatexCmd<SPACE>
inoremap <buffer> <C-b> <ESC>:LatexCmd<SPACE>
inoremap <buffer> <C-e> <ESC>:LatexCmd equation<CR>a
inoremap <buffer> <C-a> <ESC>:LatexCmd array<CR>a

inoremap <buffer> <C-f> \frac{}{}<LEFT><LEFT><LEFT>

nnoremap <buffer> <leader>v EBi\verb!<ESC>Ea!<ESC>
nnoremap <buffer> <leader>$ EBi$<ESC>Ea$<ESC>
