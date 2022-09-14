declare -A generated
generated[ferium]="ferium complete zsh"
generated[kubectl]="kubectl completion zsh"
generated[poetry]="poetry completions zsh"

fn="/tmp/$USER-zsh-completion-last-regen"
regen=false
if ! [ -f "$fn" ] || [ $(($(cat "$fn") + (12 * 60 * 60))) -lt "$(date +'%s')" ]; then
	regen=true
	date +'%s' > "$fn"
fi

for cmd gencmd in "${(kv)generated[@]}"; do
	if ! [[ $commands[$cmd] ]]; then
		continue
	fi

	fn="$HOME/.zsh/rc/completions/generated/_$cmd"
	if $regen || ! [ -f "$fn" ]; then
		${(z)gencmd} > "$fn"
	fi
done

fpath=(
	$HOME/.zsh/rc/completions
	$HOME/.zsh/rc/completions/generated
	$HOME/.asdf/completions
	$HOME/.zsh/bundle/completion-gradle
	$HOME/.zsh/bundle/completions/src
	$fpath
)

autoload -Uz compinit
compinit
