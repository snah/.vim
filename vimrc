set nocompatible
filetype plugin indent on

augroup fileextentions
	autocmd!
	autocmd BufRead *.tikz :setf tex
augroup END

" Better filename autocomplete
set wildmenu
set wildmode=longest,list

"restore cursor position
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

let g:ConqueTerm_PyVersion = 2
set hidden

set splitright
 
"Yellow line numbers conflict with most highlighting schemes
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

"better tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4

"no auto comment
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"configure syntac highlighting:
syntax enable
set background=dark

"enable line numbers:
set number
highlight LineNr ctermfg=grey
highlight CursorLineNr cterm=bold ctermfg=grey

noremap <F12> :noh<CR>
noremap <S-F12> :set hlsearch!<CR>

"normal mode mappings
nnoremap ; :
nnoremap ;w :w<CR>
nnoremap ;q :q<CR>
nnoremap <m-tab> <C-^>
nnoremap <F8> :set paste!<CR>

"only in vimrc files?
nnoremap \hh :h <C-r><C-w><CR>

"super quick inline mappings
inoremap kj <ESC>
inoremap df <CR>
"and prevent it in the rare cases where it is actually typed
inoremap dfu dfu
inoremap pdf pdf
inoremap dfo dfo

"maps to allow easy rc file editing:
nnoremap <leader>orc :new $HOME/.vimrc<CR>
nnoremap <leader>lrc :source $HOME/.vimrc<CR>
nnoremap <leader>olc :execute 'new '.$HOME.'/.vim/ftplugin/'.&filetype.'.vim'<CR>
nnoremap <leader>llc :execute 'source '.$HOME.'/.vim/ftplugin/'.&filetype.'.vim'<CR>
augroup ReloadRc
	autocmd!
	autocmd BufWritePost .vimrc :source $HOME/.vimrc
augroup END

"---
"various functions

function! DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction
nnoremap <leader>dh :call DeleteHiddenBuffers()<CR>

function! SelectDownUntillDifferent()
	let [line, column] = getpos("'>")[1:2]
	let char = getline("'>")[column - 1]
	let counter = -1
	while getline(line)[column - 1] == char
		let line = line + 1
		let counter = counter + 1
	endwhile
	exe "normal \<c-v>" . counter . "j"
endfunction

vnoremap <c-j> :<BS><BS><BS><BS><BS>call SelectDownUntillDifferent()<CR>

"---
" Keyword fold text function
function! MyFoldText()
	let l:lines = getline(v:foldstart, v:foldend)
	let l:indent_level = indent(v:foldstart)/4
	let l:next_indent = "\^" . repeat("\t", l:indent_level + 1)
	let l:folds_removed = filter(l:lines, 'v:val !~ next_indent')
	let l:lines2 = join(l:folds_removed, ',')
    let l:sub = substitute(l:lines2, '\(\d\|:\)\+\s\?', '', 'g')
    let l:sub = substitute(l:sub, '\s\?(.*)', '', 'g')
    return v:folddashes . sub
endfunction

" Open corresponing unit test
nnoremap <leader>ut :call OpenUnitTest()<CR>

function! OpenUnitTest()
	let l:filename = bufname('%')
	let l:unittest = 'tests/unit/test_'.split(l:filename, '\/')[-1]
	let l:window = FindWindow('test/unit/.*.py')
	if l:window == -1
		echo l:unittest
		execute "vs ".l:unittest
	else
		echo l:window
		execute l:window.'wincmd w' 
		execute "e ".l:unittest
	endif
endfunction

function! FindWindow(buffer_name)
	let l:oldwin = winnr()
	let l:x = []
	let l:result = -1
	windo call add(l:x, [winnr(), bufname('%')])
	for l:window in l:x
		if (l:window[1] =~ a:buffer_name)
			let l:result = l:window[0]
		endif
	endfor
	execute l:oldwin.'wincmd w' 
	return l:result
endfunction


"---
"refactoring mappings and functions

"Extract method
nnoremap <leader>em :let @a=@.<CR>o<CR><C-h>def <ESC>"apa:<ESC>:s/self.//<CR>oreturn <ESC>p==

"Rename function or variable
nnoremap <leader>rn :call StartRename()<CR>

function! StartRename()
	let l:view=winsaveview()
	normal "zyiw
	nnoremap <leader>\ :let t=winsaveview()<CR>:%s/\<<C-r><C-r>z\>/<C-r><C-w>/g<CR>:sil call winrestview(t)<CR>
	nnoremap <leader>l :let t=winsaveview()<CR>"yyiwvip:s/\<<C-r><C-r>z\>/<C-r><C-r>y/g<CR>:sil call winrestview(t)<CR>
	call winrestview(l:view)
endfunction

noremap <M-j> ddp
noremap <M-k> ddkP
noremap <S-M-j> {V}kd}Pj
noremap <S-M-k> {V}kd{Pj

"correct typos
iab slef self
