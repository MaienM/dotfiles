# Words will mean arguments as the shell recognizes them.
autoload -U select-word-style
select-word-style shell

if [ -z "$key_info[Control]" ] || [ -z "$key_info[Alt]" ]; then
	return 1;
fi

# Bindings with control operate on shell words/arguments.
# The same bindings with alt instead of control operate on regular (bash-style?) words.

# Remove word with mod+w.
bindkey "$key_info[Control]w" backward-kill-word
bindkey "$key_info[Alt]w" .backward-kill-word

# Jump words with mod+h/l
bindkey "$key_info[Control]h" backward-word
bindkey "$key_info[Control]l" forward-word
bindkey "$key_info[Alt]h" .backward-word
bindkey "$key_info[Alt]l" .forward-word

# Transpose word with ctrl+y.
bindkey "$key_info[Control]y" transpose-words
bindkey "$key_info[Alt]y" .transpose-words

