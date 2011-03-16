" Part of my modulized vimrc file.
" Last change: Mon, 14 Mar 2011 15:06:12 +0100
" Updates the first timestamp found in the specified range.

""
" First we create a dict for all pieces that can be used in a timestamp.
""
let s:tr = {}
" Three letters.
let s:tr['a'] = '[A-Z][a-z]{2}'
let s:tr['b'] = s:tr['a']

" Three or four letters (timezone).
let s:tr['Z'] = '[A-Z]{3,4}'

" One word.
let s:tr['A'] = '\S+'
let s:tr['B'] = s:tr['A']

" AM/PM.
let s:tr['p'] = '[AP]M'
let s:tr['P'] = '[ap]m'

" Characters.
let s:tr['n'] = '[\r\n]'
let s:tr['t'] = '\t'

" +hhmm or -hhmm.
let s:tr['z'] = '[+-][0-9]{4}'

" 0-6.
let s:tr['w'] = '[0-6]'

" 1-7.
let s:tr['u'] = '[1-7]'

" 01-12.
let s:tr['I'] = '(0[1-9]|1[0-2])'
let s:tr['m'] = s:tr['I']
" _1-12
let s:tr['l'] = '( [0-9]|1[0-2])'

" 00-23.
let s:tr['H'] = '([01][0-9]|2[0-3])'
" _0-23.
let s:tr['k'] = '( [0-9]|1[0-9]|2[0-3])'

" 01-31.
let s:tr['d'] = '(0[1-9]|[12][0-9]|3[01])'
" _1-31.
let s:tr['e'] = '([ 12][0-9]|3[01])'

" 00-53.
let s:tr['U'] = '([0-4][0-9]|5[0-3])'
let s:tr['W'] = s:tr['U']
" 01-53.
let s:tr['V'] = '(0[1-9]|[1-4][0-9]|5[0-3])'

" 00-59.
let s:tr['M'] = '[0-5][0-9]'
let s:tr['S'] = s:tr['M']

" 00-99.
let s:tr['C'] = '[0-9]{2}'
let s:tr['y'] = s:tr['C']

" 001-366.
let s:tr['j'] = '(00[1-9]|0[1-9][0-9]|[12][0-9][0-9]|' .
               \'3[0-5][0-9]|36[0-6]))'

" 0000-9999.
let s:tr['Y'] = '[0-9]{4}'

" Seconds since the epoch. Big number.
let s:tr['s'] = '[0-9]+'

" Aliases.
let s:tr['D'] = '%m/%d/%y'
let s:tr['F'] = '%Y-%m-%d'
let s:tr['r'] = '%I:%M:%S %p'
let s:tr['R'] = '%H:%M'
let s:tr['T'] = '%H:%M:%S'


""
" This function is used to create a regex that matches the specifies timestamp
" format.
""
function! s:CR(format)
  let l:retval = ''
  let l:s1 = ''
  let l:s2 = ''
  let i = 0
  while i < strlen(a:format)
    let l:s2 = strpart(a:format, i, 1)
    if l:s1 == '%'
      if l:s2 == '%'
        let l:retval .= '%'
      else
        let l:retval .= s:CR(s:tr[l:s2])[1]
      endif
      let l:s1 = ''
    elseif l:s2 == '%'
      let l:s1 = '%'
    else
      let l:retval .= l:s2
      let l:s1 = ''
    endif
    let i += 1
  endwhile
  return [a:format, l:retval]
endfunction

""
" Define the timestamp formats we know/care about.
""
let s:formats = [s:CR('%a, %d %b %Y %T %z'),  
                \s:CR('%d-%m-%Y %R %Z')]
              
""
" Do the actual updating.
""
function! UpdateTimestamp() range
  let i = a:firstline
  while i <= a:lastline
    call cursor(i, 1)
    for [l:format, l:regexp] in s:formats
      if search('\v'.l:regexp, 'n', i)
        execute ':s/\v'.l:regexp.'/'.strftime(l:format).'/'
        return
      endif
    endfor
    let i += 1
  endwhile
endfunction
