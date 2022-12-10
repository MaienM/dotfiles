BASE16_SHELL_HOOKS=$HOME/.zsh/bundle/base16-hooks/
BASE16_SHELL=$HOME/.zsh/bundle/base16
[ -n "$PS1" ] && [ -s "$BASE16_SHELL/profile_helper.sh" ] && source $BASE16_SHELL/profile_helper.sh
alias base16-colortest="$BASE16_SHELL/colortest"
