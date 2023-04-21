if ! [[ ${commands[nix-shell]} ]]; then
	return
fi


# Keep track of what nix packages are specific to this shell, be it through 'nix-shell', 'nix develop', direnv, etc.
# Two sources are used for this:
#   $buildInputs, which appears to contain packages for the current invocation, but not those of parent shells.
#   $nix_shell_packages, which is set in the ns function below to work around the restrictions of $buildInputs.
local _detect_nix_shell_packages() {
	if [ -n "$nix_shell_packages" ]; then
		nix_shell_packages=("${(z)nix_shell_packages}")
	fi
	typeset -gaU nix_shell_packages
	if [ -n "$buildInputs" ]; then
		for pkg in "${(z)buildInputs}"; do
			name="$pkg"
			name="${name#/nix/store/*-}"
			name="${name%-[0-9].[0-9]*}"
			nix_shell_packages=("${nix_shell_packages[@]}" "$name")
		done
	fi
}
typeset -ag precmd_functions;
if [[ -z "${precmd_functions[(r)_detect_nix_shell_packages]+1}" ]]; then
  precmd_functions=( ${precmd_functions[@]} _detect_nix_shell_packages )
fi
typeset -ag chpwd_functions;
if [[ -z "${chpwd_functions[(r)_detect_nix_shell_packages]+1}" ]]; then
  chpwd_functions=( ${chpwd_functions[@]} _detect_nix_shell_packages )
fi


if [[ ${commands[nixos-rebuild]} ]]; then
	alias dot-nixos-rebuild='sudo nixos-rebuild --flake "$HOME/dotfiles#$(hostname)"'
fi

if [[ ${commands[darwin-rebuild]} ]]; then
	alias dot-darwin-rebuild='darwin-rebuild --flake "$HOME/dotfiles#$(hostname)"'
fi

if [[ ${commands[home-manager]} ]]; then
	alias dot-home-manager='home-manager --flake "$HOME/dotfiles#${USER}@$(hostname)"'
fi

ns() {
	nix_shell_packages="${nix_shell_packages[*]}" nix-shell --command zsh -p "$@"
}
nx() {
	local prog="$1"
	shift 1
	nix-shell --command "$(printf '%q ' "${prog##*.}" "$@")" -p "$prog"
}

dot-nix-push() {
	setopt localoptions errreturn
	ssh "$1" '
		set -e

		cd dotfiles

		if ! [ "$(git rev-parse --abbrev-ref HEAD)" = master ]; then
			>&2 echo "Not on master branch, aborting."
			exit 1
		fi
		if [ -n "$(git status --porcelain=v1 --ignore-submodules 2>/dev/null)" ]; then
			>&2 echo "There are uncomitted changes, aborting."
			exit 1
		fi
		if ! [ "$(git rev-parse HEAD)" = "$(git rev-parse desktop/master)" ]; then
			>&2 echo "There are local commits, aborting."
			exit 1
		fi

		if ! git show-ref --verify --quiet refs/heads/desktop/master > /dev/null 2>&1; then
			echo "There is no desktop/master branch, creating it now."
			git checkout -b desktop/master
			git checkout master
		fi
	'
	git push -f "$1" master:desktop/master
	ssh "$1" '
		set -e

		cd dotfiles
		git checkout desktop/master -B master
		./local/bin/git-submodule-init
	'
	echo 'Remote dotfiles have been updated.'
}
