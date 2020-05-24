# Use histdb to determine the autosuggestions based on previous commands in the current directory.
_zsh_autosuggest_strategy_histdb_top() {
   local query
	read -r -d '' query <<-END
		SELECT commands.argv
		FROM history
			LEFT JOIN commands ON history.command_id = commands.rowid
			LEFT JOIN places ON history.place_id = places.rowid
		WHERE commands.argv LIKE '$(sql_escape $1)%'
		GROUP BY commands.argv
		ORDER BY places.dir != '$(sql_escape $PWD)', COUNT(*) DESC LIMIT 1
	END
   suggestion=$(_histdb_query "$query")
}
ZSH_AUTOSUGGEST_STRATEGY=histdb_top
