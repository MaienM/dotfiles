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


yaml-to-nix-selection() {
	xclip -out | yaml-to-nix | xclip -in
}
yaml-to-nix-clipboard() {
	xclip -out -selection clipboard | yaml-to-nix | xclip -in -selection clipboard
}

nix-to-json-selection() {
	xclip -out | nix-to-json | xclip -in
}
nix-to-json-clipboard() {
	xclip -out -selection clipboard | nix-to-json | xclip -in -selection clipboard
}
