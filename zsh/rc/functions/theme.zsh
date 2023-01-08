function activate_base16_theme() {
	setopt localoptions errexit
	base16-colorscheme "$1"
	source ~/.profile.d/50_base16.local
	source ~/.profile.d/50_dircolors.local
	source ~/.zsh/rc/base16.local.zsh
}

alias let-there-be-light='activate_base16_theme light || true'
alias it-burns='activate_base16_theme dark || true'
