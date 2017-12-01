# Expand command name to full path
for key in "$key_info[Escape]"{E,e}; do
	bindkey "$key" expand-cmd-path
done
