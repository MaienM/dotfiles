" Don't show a warning if parts of the modeline are ignored. This is annoying
" as hell.
let g:secure_modelines_verbose=0

" Don't force-disable the regular modelines option, I do this manually, and
" the message stating that this useless action has been performed annoys me.
set nomodeline
let g:secure_modelines_leave_modeline=1
