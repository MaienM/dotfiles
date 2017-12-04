if [ -z "$key_info[ControlLeft]" ] || [ -z "$key_info[ControlRight]" ]; then
	return 1;
fi

# Jump words with ctrl+left/right
for key in "${(s: :)key_info[ControlLeft]}"; do
	bindkey "$key" vi-backward-word
done
for key in "${(s: :)key_info[ControlRight]}"; do
	bindkey "$key" vi-forward-word
done
