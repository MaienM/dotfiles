if ! command -v histdb &> /dev/null; then
	source "$HOME/.zsh/bundle/histdb/zsh-histdb.plugin.zsh"
fi
if ! command -v histdb &> /dev/null; then
	return
fi

SEC_IN_MINUTE=60
SEC_IN_HOUR=$((60 * SEC_IN_MINUTE))
SEC_IN_DAY=$((24 * SEC_IN_HOUR))
format_time() {
	local duration
	duration="$1"
	case "$duration" in
		-*) echo 'Unknown' ;;
		0) echo '0s' ;;
		*)
			printf '%id %ih %im %is' \
				"$((duration / SEC_IN_DAY))" \
				"$(((duration % SEC_IN_DAY) / SEC_IN_HOUR))" \
				"$(((duration % SEC_IN_HOUR) / SEC_IN_MINUTE))" \
				"$((duration % SEC_IN_MINUTE))" \
				| sed 's/^\(0*[a-z]\s*\)*//'
		;;
	esac
}

_fzf_pipeline_histdb_commands_source() {
	_histdb_query -separator ' ' "
		SELECT history.id, commands.argv
		FROM history
			LEFT JOIN commands ON history.command_id = commands.rowid
		GROUP BY commands.argv
		ORDER BY MAX(history.start_time) DESC
	"
}
_fzf_pipeline_histdb_commands_preview() {
	read -r  hdb_exit_status hdb_start_time hdb_duration < <(_histdb_query -separator ' ' "
		SELECT IFNULL(history.exit_status, 0), IFNULL(history.start_time, 0), IFNULL(history.duration, -1)
		FROM history
		WHERE history.id = "$1"
		LIMIT 1
	")
	hdb_pwd="$(_histdb_query "
		SELECT places.dir
		FROM history
			LEFT JOIN places ON history.place_id = places.rowid
		WHERE history.id = "$1"
		LIMIT 1
	")"
	hdb_cmd="$(_histdb_query "
		SELECT commands.argv
		FROM history
			LEFT JOIN commands ON history.command_id = commands.rowid
		WHERE history.id = "$1"
		LIMIT 1
	")"

	echo "ID:\t\t$1"
	echo "Command:\t$hdb_cmd"
	echo "Directory:\t$hdb_pwd"
	echo "Started at:\t$(date --date="@$hdb_start_time")"
	echo "Finished at:\t$(date --date="@$((hdb_start_time + hdb_duration))")"
	echo "Duration:\t$(format_time "$hdb_duration")"
	echo "Result:\t\t$hdb_exit_status"
}
_fzf_pipeline_histdb_commands_target() {
	shift 1
	echo "$@"
}

_fzf_pipeline_histdb_commands_local_source() {
	_histdb_query -separator ' ' "
		SELECT history.id, commands.argv
		FROM history
			LEFT JOIN commands ON history.command_id = commands.rowid
			LEFT JOIN places ON history.place_id = places.rowid
		WHERE places.dir = '$(sql_escape $PWD)'
		GROUP BY commands.argv
		ORDER BY MAX(history.start_time) DESC
	"
}
alias _fzf_pipeline_histdb_commands_local_preview='_fzf_pipeline_histdb_commands_preview'
alias _fzf_pipeline_histdb_commands_local_target='_fzf_pipeline_histdb_commands_target'

# Presets
alias _fzf_preset_histdb_commands='_fzf_config_add histdb_commands'
alias _fzf_preset_histdb_commands_local='_fzf_config_add histdb_commands_local'

_fzf_register_preset "histdb_commands" "ZSH history" "histdb:commands"
_fzf_register_preset "histdb_commands_local" "ZSH history for current folder" "histdb:commands:local"
