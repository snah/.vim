"----------------------------
"	Python specific stuff
"----------------------------

" Map F2 to execute/compile current file
noremap <F2> :w\|!python %<CR>
" Map F3 to execute/compile current file in background
noremap <F3> :w\|!python<SPACE>%<SPACE>&<CR><CR>
" Map F4 to open interactive interpreter or view file
noremap <F4> :!xterm<SPACE>-e<SPACE>python<SPACE>&<CR><CR>
" Map F5 to switch between syntax highlighting options
noremap <F5> :setf html<CR>

" <leader>c to comment current line
nnoremap <leader>c I#<esc>


"---

setlocal omnifunc=pythoncomplete#Complete
setlocal expandtab
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal autoindent

inoremap <buffer> #! #!<SPACE>/usr/bin/env<SPACE>python3<CR><CR>

inoremap """ """"""<LEFT><LEFT><LEFT>
nnoremap <TAB> >> 
nnoremap <S-TAB> << 

" Really lazy mappings
inoremap _ -
inoremap - _
inoremap ; :
inoremap : ;
inoremap ( 9
inoremap 9 (
inoremap ) 0
inoremap 0 )

"---
"test driven development
if expand('%:t') =~# "test.py$"
	nnoremap <buffer>sk O@unittest.skip('')<ESC><LEFT><LEFT>
endif

"---
"refactoring

function! AutoFix()
	if getline('.') =~# "^import"
		normal vip
		let l:lines = getline("'<","'>")
		normal <CR>
		call setline('.',sort(l:lines))
	endif
endfunction

nnoremap <leader>rf :call AutoFix()<CR>

" Find duplicate code
nnoremap <leader>du :/\v\W(\w+\W+)(\w+\W+)(\w+\W+)(\w+\W+)(\_.*\1\2\3\4)@=

" Skip test
nnoremap <leader>sk O@unittest.skip<ESC>

"Move function up or down in class
nnoremap <leader>k $?^ *def <CR>V/^ *\(def\\|class\) <CR>kd?^ *\(def\\|class\) <CR>nP?^ *\(def\\|class\) <CR>z.
nnoremap <leader>j $?^ *def <CR>V/^ *\(def\\|class\) <CR>kd/^ *\(def\\|class\) <CR>P?^ *\(def\\|class\) <CR>z.
vnoremap <leader>k d?^ *\(def\\|class\) <CR>nP?^ *\(def\\|class\) <CR>z.`[v`]
vnoremap <leader>j d/^ *\(def\\|class\) <CR>P?^ *\(def\\|class\) <CR>z.`[v`]

"---
"WIP: project utilities

function! ProjectUtilities()
	if filereadable("__init__.py")
		let rel_path = "./"
		while filereadable(rel_path . "__init__.py")
			let rel_path = rel_path . "../"
		endw
	
		let g:project_root = fnamemodify(rel_path , ":p")
		let g:project_name = split(g:project_root, "/")[-1]
		let g:package_root = g:project_root . g:project_name
	
		" Return the path of the current file relative to the package root
		function! RelPath()
			let l:depth = len(split(g:package_root, "/"))
			return join(split(expand("%:p"), "/")[depth :], "/")
		endfunction

		nnoremap <leader>et <c-w>l:exec "e " . UnitTestFile()<CR>
		nnoremap <leader>st :exec "s " . UnitTestFile()<CR><C-w>r
		nnoremap <leader>vt :exec "vs " . UnitTestFile()<CR><C-w>r
	
	
		function! UnitTestFile()
			let l:filename = fnamemodify(RelPath(), ":r") . "_test.py"
			return g:project_root . "/test/unit/" . l:filename
		endfunction
	
		function! RunUnitTest()
			wincmd k
			startinsert
			stopinsert
			wincmd p
			let l:unit_test = UnitTestFile()
			"call system("nosetests " . l:unit_test . " 2> /tmp/unittest_output &")
			"call conque_term#get_instance(g:unittest_terminal).writeln('nosetests ' . l:unit_test)
			call conque_term#get_instance(g:unittest_terminal.idx).writeln('clear; nosetests ' . l:unit_test)
		endfunction
	endif
endfunction

"au BufWinEnter * :call ProjectUtilities()
au VimEnter * :call ProjectUtilities()
