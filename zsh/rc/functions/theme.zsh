function base16-colorscheme() {
	setopt localoptions errreturn
	command base16-colorscheme "$@"
	source ~/.profile.d/50_base16.local
	source ~/.profile.d/50_dircolors.local
	source ~/.zsh/rc/base16.local.zsh
}

alias let-there-be-light='base16-colorscheme light'
alias it-burns='base16-colorscheme dark'
