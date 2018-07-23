# Prompt for confirmation.
# $1: The message/question.
# $2: The default answer ('Y' or 'N')
prompt_confirm()
{
	local message default options reply

	message=$1
	case $2 in
		[yY]) 
			default=0
			options='Yn'
		;;
		*)    
			default=1
			options='yN'
		;;
	esac

	while true; do
		echo "$message [$options]"
		case $SHELL in
			*/zsh)
				read -k 1 reply
			;;
			*)
				read -n 1 reply
			;;
		esac
		case $reply in 
			[yY])
				return 0;
			;;
			[nN])
				return 1;
			;;
			[$IFS])
				return $default
			;;
		esac
	done
}
