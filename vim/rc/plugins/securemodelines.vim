" Don't show a warning if parts of the modeline are ignored.
let g:secure_modelines_verbose=0

" Don't force-disable the regular modelines option, do so manually, to prevent the message for this.
set nomodeline
let g:secure_modelines_leave_modeline=1
