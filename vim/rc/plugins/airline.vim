let g:airline_highlighting_cache = 1
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#obsession#enabled = 1

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

let g:airline_symbols.branch = 'שׂ'
let g:airline_symbols.crypt = ''
let g:airline_symbols.dirty = '±'
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.paste = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.spell = '' " Would be '暈', but this is double wide in NerdFont, unfortunately.
let g:airline_symbols.whitespace = ''
