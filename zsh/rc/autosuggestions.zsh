# Stop if tmux is not available, we're in a session nested in something, or we're not connected through SSH
if [ $+functions[_histdb_query] -eq 0 ]; then
	echo >&2 "Histdb unvailable (is sqlite installed?)."
	return 1
fi

# Use histdb to determine the autosuggestions based on previous commands in the current directory.
_zsh_autosuggest_strategy_histdb_top() {
   local query
   suggestion="$(_histdb_query "
		SELECT commands.argv
		FROM history
			LEFT JOIN commands ON history.command_id = commands.rowid
			LEFT JOIN places ON history.place_id = places.rowid
		WHERE commands.argv LIKE '$(sql_escape $1)%'
		GROUP BY commands.argv, places.dir
		ORDER BY places.dir != '$(sql_escape $PWD)', COUNT(*) DESC LIMIT 1
	")"
}
ZSH_AUTOSUGGEST_STRATEGY=histdb_top
