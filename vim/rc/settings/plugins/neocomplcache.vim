" Part of my modulized vimrc file.
" Last change: Tue, 03 Jul 2012 16:50:35 +0200

" Make the popup look decent.
hi Pmenu ctermbg=235 ctermfg=252 cterm=none

" Mappings.
" Use the arrow keys, or tab/shift-tab to move through the list.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr><Down> pumvisible() ? "\<Down>" : "\<nop>"
inoremap <expr><Up> pumvisible() ? "\<Up>" : "\<nop>"

" <Tab> also shows the popup, and completes to the common string.
set completeopt+=longest
inoremap <expr><TAB> pumvisible() ? 
\                      (<SID>hasCommon() ?
\                        <SID>getCommon() :
\                        "\<C-n>") :
\                      (<SID>checkSpace() ? 
\                        "\<TAB>" : 
\                        "\<C-x>\<C-u>")

" See if there is anything to complete.
function! s:checkSpace()"{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~ '\s'
endfunction"}}

" The function complete_common_string is not quite enough for our purproses.
" Wrapper around it to check if it will do anything, and to just get the new
" part without canceling the completion dialog.
function! s:hasCommon()"{{{
  return len(<SID>getCommon())
endfunction"}}
function! s:getCommon()"{{{
  " Get the completion.
  let command = neocomplcache#complete_common_string()

  " Extract the common part.
  let bs = matchstr(command, "\<C-E>\\([^\w]kb\\)*")
  let word = substitute(command, "\<C-E>\\([^\w]kb\\)*", "", "")
  let common = strpart(word, len(bs)/3)

  return common
endfunction"}}

" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
inoremap <expr><Down> <SID>test()

" Disable AutoComplPop, use neocomplcache.
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1

" No auto popup, we show the complete popup on tab.
let g:neocomplcache_disable_auto_complete = 1

" Don't auto-highlight the first canidate.
let g:neocomplcache_enable_auto_select = 0

" Use smartcase, camel case and underline completion.
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1

" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
