" Force 256 colors with Screen/Tmux.
if match($TERM, 'screen-256color') != -1
	set t_Co=256
endif

" Fix certain incoming keystrokes.
execute 'set <xUp>=\e[1;*A'
execute 'set <xDown>=\e[1;*B'
execute 'set <xRight>=\e[1;*C'
execute 'set <xLeft>=\e[1;*D'
imap [Z <S-Tab>
