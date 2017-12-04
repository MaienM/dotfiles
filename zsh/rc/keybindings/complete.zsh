if [ -z "$key_info[Backtab]" ]; then
	return 1;
fi

# Bind Shift + Tab to go to the previous menu item
bindkey "$key_info[BackTab]" reverse-menu-complete
