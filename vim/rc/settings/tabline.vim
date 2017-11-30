set tabline=%!MyTabLine()  " custom tab pages line
function! MyTabLine()
    let line = ''

    let tabSel = tabpagenr()
    let tabCount = tabpagenr('$')
    let tabLen = (&columns / tabCount) - 3

    for i in range(tabCount)
        let tabnr = i + 1
        let buflist = tabpagebuflist(tabnr)
        let winnr = tabpagewinnr(tabnr)
        let bufnr = buflist[winnr - 1]

        let line .= '%' . tabnr . 'T'
        let line .= (tabnr == tabSel ? '%1*' : '%2*') 
        let line .= ' '
        let line .= tabnr . '' 
        let line .= ' %*'
        let line .= (tabnr == tabSel ? '%#TabLineSel#' : '%#TabLine#')
        let line .= MyFileName(bufnr, tabLen)
    endfor

    "let line .= '%T%#TabLineFill#%='
    "let line .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
    return line
endfunction

function! MyFileName(bufnr, maxlen)
    " Get base filename.
    let file = bufname(a:bufnr)
    if file == ''
        if getbufvar(a:bufnr, '&buftype') == 'nofile'
            let file = '[Scratch]'
        else
            let file = '[New]'
        endif
    else
        let file = fnamemodify(file, ':~:.')
    endif

    " Determine the file flag.
    let flag = ''
    if getbufvar(a:bufnr, '&modified') == 1
        let flag .= '+'
    endif
    let maxlen = a:maxlen - strlen(flag)

    " Split dirs, and shorten them.
    " Start by trying to include 3 directories, and work down from that if
    " that is too long.
    let parts = split(file, '/')
    for chars in [3, 2, 1, 0]
        for dirs in [3, 2, 1]
            let file = ''
            for dir in parts[:-1][dirs * -1:-2]
                let file .= dir[:chars] . '/'
            endfor
            let file .= parts[-1]

            if strlen(file) <= maxlen
                break
            endif
        endfor

        if strlen(file) <= maxlen
            break
        endif
    endfor

    " If this is still too long, try the filename without any directories.
    if strlen(file) > maxlen
        let file = parts[-1]
    endif

    " If this is STILL too long, remove parts from the middle of the filename.
    if strlen(file) > maxlen
        let parts = split(file, '\.')
        if len(parts) > 0
            let rem = maxlen - strlen(parts[-1]) - 2

            let right = max([1, rem / 2])
            let left = max([1, rem - right])
            let file = strpart(parts[0], 0, left) . '~' . strpart(parts[-2], strlen(parts[-2]) - right, right) . '.' . parts[-1]
        endif
    endif 

    return flag . file
endfunction

