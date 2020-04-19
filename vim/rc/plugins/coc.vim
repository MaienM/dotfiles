execute pathogen#infect('bundle-coc/{}')

" Use the neovim node environment.
let g:coc_node_path = g:nodejs_host_prog

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, inserting an undo point when doing so.
if exists('*complete_info')
	inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
	imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use <Tab>/<S-Tab> to page through options.
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" D[i]agnostics mappings.
nmap <silent> [i <Plug>(coc-diagnostic-prev)
nmap <silent> ]i <Plug>(coc-diagnostic-next)
nmap <silent> <Leader>if <Plug>(coc-fix-current)
nmap <silent> <Leader>ii :<C-u>CocFzfList diagnostics<CR>
" nmap <silent> <Leader>ii <Plug>(coc-diagnostic-info)

" Code navigation ([g]o-to as mnemonic).
nmap <silent> <Leader>gd <Plug>(coc-definition)
nmap <silent> <Leader>gy <Plug>(coc-type-definition)
nmap <silent> <Leader>gi <Plug>(coc-implementation)
nmap <silent> <Leader>gr <Plug>(coc-references)

" R[e]factoring mappings.
" Symbol renaming.
nmap <silent> <Leader>er <Plug>(coc-rename)
nmap <silent> <Leader>ef <Plug>(coc-action-format)

" Miscellaneous stuff.
nmap <silent> <Leader>gg :<C-u>CocFzfList<CR>
nmap <silent> <Leader>gG :<C-u>CocFzfListResume<CR>

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Setup formatexpr specified filetype(s).
" TODO: Are there downsides to just enabling this for all filetypes?
autocmd FileType * setl formatexpr=CocAction('formatSelected')

" Update signature help on jump placeholder.
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

