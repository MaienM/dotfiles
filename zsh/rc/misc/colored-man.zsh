# termcap  
# ks       make the keypad send commands
# ke       make the keypad send digits
# vb       emit visual bell
# mb       start blink
# md       start bold
# me       turn off bold, blink and underline
# so       start standout (reverse video)
# se       stop standout
# us       start underline
# ue       stop underline

function man() {
    env \
        LESS_TERMCAP_mb=$(printf "${fg[blue]}") \
        LESS_TERMCAP_md=$(printf "${fg[magenta]}") \
        LESS_TERMCAP_so=$(printf "${fg[black]}${bg[white]}") \
        LESS_TERMCAP_us=$(printf "${fg[green]}") \
        LESS_TERMCAP_me=$(printf "$reset_color") \
        LESS_TERMCAP_se=$(printf "$reset_color") \
        LESS_TERMCAP_ue=$(printf "$reset_color") \
        PAGER="${commands[less]:-$PAGER}" \
        man "$@"
}

