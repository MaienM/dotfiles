if [ -z "$key_info[Control]" ] || [ -z "$key_info[Escape]" ]; then
	return 1;
fi

# I want the word-based actions to be available in two flavors: whitespace (ish) based (the default), and shell argument
# based. select-word-style with the provided *-match functions can provide both of these, but unfortunately switching
# between these at runtime doesn't work (due to the syntax highlighting plugin). The core of these functions is the
# match-words-by-style function, which (luckily) accepts the style to use as an argument, which we can use to
# reimplement the desired functions fairly easily.
autoload -Uz match-words-by-style

# Implementations of generic functions {{{
function match-words-by-style-from-name {
	style="${WIDGET#*-by-style-}"
	match-words-by-style -w "$style"
}
function backward-kill-word-with-style {
	match-words-by-style-from-name
	word="${(j..)matched_words[2,3]}"
	[ -z "$word" ] && return
	zle copy-region-as-kill -- "$word"
	LBUFFER="${matched_words[1]}"
}
function backward-word-with-style {
	match-words-by-style-from-name
	word="${(j..)matched_words[2,3]}"
	(( CURSOR -= ${#word} ))
}
function forward-word-with-style {
	match-words-by-style-from-name
	word="${(j..)matched_words[4,5]}"
	(( CURSOR += ${#word} ))
}
# Jumps to the start/end of the current word, but doesn't leave it. Idempotent.
function begin-of-word-with-style {
	match-words-by-style-from-name
	[ -n "${matched_words[3]}" ] && [ -z "${matched_words[4]}" ] && return
	word="${(j..)matched_words[2,3]}"
	(( CURSOR -= ${#word} ))
}
function end-of-word-with-style {
	match-words-by-style-from-name
	[ -z "${matched_words[3]}" ] && [ -n "${matched_words[4]}" ] && return
	word="${(j..)matched_words[4,5]}"
	(( CURSOR += ${#word} ))
}
# Transpose alternative that moves the word in either direction (not just backwards), and moves the cursor with it.
function forward-transpose-words-with-style {
	end-of-word-with-style
	match-words-by-style-from-name
	LBUFFER="${matched_words[1]}${matched_words[5]}${(j..)matched_words[3,4]}${matched_words[2]}"
	RBUFFER="${(j..)matched_words[6,7]}"
}
function backward-transpose-words-with-style {
	begin-of-word-with-style
	match-words-by-style-from-name
	LBUFFER="${matched_words[1]}"
	RBUFFER="${matched_words[5]}${(j..)matched_words[3,4]}${matched_words[2]}${(j..)matched_words[6,7]}"
}

word_styles=(shell normal)
word_functions=(
	backward-kill-word-with-style
	backward-word-with-style
	forward-word-with-style
	begin-of-word-with-style
	end-of-word-with-style
	forward-transpose-words-with-style
	backward-transpose-words-with-style
)
for style in "${word_styles[@]}"; do
	for func in "${word_functions[@]}"; do
		zle -N "$func-$style" "$func"
	done
done
# }}}

# Bindings with control operate on whitespace based words (as default). The same bindings with alt operate on arguments.

# Bindings {{{
# Remove word with mod+w.
bindkey "$key_info[Control]w" backward-kill-word-with-style-normal
bindkey "$key_info[Escape]w" backward-kill-word-with-style-shell

# Jump words with mod+h/l.
bindkey "$key_info[Control]h" backward-word-with-style-normal
bindkey "$key_info[Control]l" forward-word-with-style-normal
bindkey "$key_info[Escape]h" backward-word-with-style-shell
bindkey "$key_info[Escape]l" forward-word-with-style-shell

# Transpose words with mod+j/k.
bindkey "$key_info[Control]j" backward-transpose-words-with-style-normal
bindkey "$key_info[Control]k" forward-transpose-words-with-style-normal
bindkey "$key_info[Escape]j" backward-transpose-words-with-style-shell
bindkey "$key_info[Escape]k" forward-transpose-words-with-style-shell
# }}}

# The forward-word widgets should also accept an equal portion of the autosuggest.
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(
	"#{ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS[@]}"
	forward-word-with-style-normal
	forward-word-with-style-shell
)

