if ! [[ ${commands[terraform]} ]]; then
	return
fi

alias terraform_with_targets="xargs -d$'\n' -I{} echo -target='{}' | xargs -d$'\n' --no-run-if-empty terraform"
