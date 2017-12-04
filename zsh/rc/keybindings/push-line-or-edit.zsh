if [ -z "$key_info[Escape]" ]; then
	return 1;
fi

# Use a more flexible push-line
for key in "$key_info[Escape]"{q,Q}; do
	bindkey "$key" push-line-or-edit
done
