
vnoremap <leader>f :call FrequencyCount()<CR>

let g:toolbox='~/h/h/toolbox/cryptography/'

function! FrequencyCount()
	normal! '<"ay'>
	let @s=system("python " . g:toolbox . "freqtable.py -s", @a)
	let @d=system("python " . g:toolbox . "freqtable.py -d", @a)
	let @t=system("python " . g:toolbox . "freqtable.py -t", @a)
endfunction
