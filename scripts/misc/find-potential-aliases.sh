# shellcheck shell=zsh

if ! command -v _histdb_query > /dev/null 2>&1; then
	echo >&2 "Cannot find _histdb_query command."
	echo >&@ "Make sure you're sourcing this script, not running it."
	return
fi

_histdb_query "
	SELECT COUNT(*) as count, commands.argv
	FROM history
		LEFT JOIN commands ON history.command_id = commands.rowid
	WHERE commands.argv NOT IN ($(printf "'%s', " "${(k)aliases[@]}" "${(k)functions[@]}")'')
		AND LENGTH(commands.ARGV) >= 10
		AND commands.argv LIKE '% %'
	GROUP BY commands.argv
	ORDER BY COUNT(*) DESC LIMIT 25
"
