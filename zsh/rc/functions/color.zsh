truecolortest() {
	awk 'BEGIN{
		s="/\\/\\/\\/\\/\\"; s=s s s s s s s s s s s s s s s s s s s s s s s;
		for (colnum = 0; colnum<256; colnum++) {
			r = 255-(colnum*255/255);
			g = (colnum*510/255);
			b = (colnum*255/255);
			if (g>255) g = 510-g;
			printf "\033[48;2;%d;%d;%dm", r,g,b;
			printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
			printf "%s\033[0m", substr(s,colnum+1,1);
		}
		printf "\n";
	}'
}

colorlist() {
    local k

    echo "NAME         EXAMPLE      CODE"
    echo "fg[*]"
    for k in ${(k)fg}; do
        echo "${(r:12:)k} ${fg[$k]}example$reset_color     ${(q)fg[$k]}"
    done
    echo "bg[*]"
    for k in ${(k)bg}; do
        echo "${(r:12:)k} ${bg[$k]}example$reset_color     ${(q)bg[$k]}"
    done
}

colorgrid() {
    local fgk bgk width

    width=11

    echo -n ${(r:$width:)$(echo '↓ bg fg ->')}
    for fgk in ${(k)fg}; do
        echo -n ${(r:$width:)fgk}
    done
    echo
    for bgk in ${(k)bg}; do
        echo -n ${(r:$width:)bgk}
        for fgk in ${(k)fg}; do
            echo -n "${fg[$fgk]}${bg[$bgk]}example$reset_color${${(r:$width:)$(echo example)}#example}"
        done
        echo
    done
}

alias stripescape='sed -E "s/[[:cntrl:]]\[[0-9]{1,3}(;[0-9]{1,3}){0,2}[mGK]//g"'
