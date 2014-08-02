# Prompt for confirmation.
# $1: The message/question.
# $2: The default answer ('Y' or 'N')
prompt_confirm()
{
	MESSAGE=$1
	case $2 in
		[yY]) 
			DEFAULT='Y'
			OPTIONS='Yn'
		;;
		*)    
			DEFAULT='N'
			OPTIONS='yN'
		;;
	esac

	echo "$MESSAGE [$OPTIONS]"
	case $SHELL in
		*/zsh) read -k 1 REPLY;;
		*) read -n 1 REPLY;;
	esac
	case $REPLY in 
		[yY]) true;;
		[nN]) false;;
		[$IFS])   [[ $DEFAULT == 'Y' ]] && true || false;;
		*)    prompt_confirm $MESSAGE $DEFAULT;;
	esac
}
