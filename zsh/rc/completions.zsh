declare -A generated
generated[ferium]="ferium complete zsh"
generated[helm]="helm completion zsh"
generated[kubectl]="kubectl completion zsh"
generated[poetry]="poetry completions zsh"
generated[pnpm]="
	HOME=\"\$(mktemp -d)\"
	pnpm install-completion zsh > /dev/null
	echo '#compdef pnpm'
	cat ~/.config/tabtab/zsh/pnpm.zsh
"
generated[pulumi]="pulumi completion zsh"

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
	if $regen || ! [ -s "$fn" ]; then
		zsh -c "$gencmd" > "$fn"
	fi
done

fpath=(
	$HOME/.zsh/rc/completions
	$HOME/.zsh/rc/completions/generated
	$HOME/.zsh/bundle/completion-gradle
	$HOME/.zsh/bundle/completions/src
	$fpath
)

autoload -Uz compinit
compinit
