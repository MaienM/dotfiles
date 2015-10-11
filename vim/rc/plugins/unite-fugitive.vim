" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

" let g:unite_source_menu_menus.git = {
"     \ 'description' : '            gestionar repositorios git
"         \                            ⌘ <Leader>mg',
"     \}
" let g:unite_source_menu_menus.git.command_candidates = [
"     \['▷ git status       (Fugitive)',                    'Gstatus'],
"     \['▷ git diff         (Fugitive)',                    'Gdiff'],
"     \['▷ git commit       (Fugitive)',                    'Gcommit'],
"     \['▷ git log          (Fugitive)',                    'exe "silent Glog | Unite quickfix"'],
"     \['▷ git blame        (Fugitive)',                    'Gblame'],
"     \['▷ git stage        (Fugitive)',                    'Gwrite'],
"     \['▷ git checkout     (Fugitive)',                    'Gread'],
"     \['▷ git rm           (Fugitive)',                    'Gremove'],
"     \['▷ git mv           (Fugitive)',                    'exe "Gmove " input("destination: ")'],
"     \['▷ git push         (Fugitive, output in buffer)',  'Git! push'],
"     \['▷ git pull         (Fugitive, output in buffer)',  'Git! pull'],
"     \['▷ git prompt       (Fugitive, output in buffer)',  'exe "Git! " input("git command: ")'],
"     \['▷ git cd           (Fugitive)',                    'Gcd'],
" \]

" nnoremap <silent>[menu]g :Unite -silent -start-insert menu:git<CR>

" " Mappings.
" nnoremap <Leader>gg :Gstatus<CR>
