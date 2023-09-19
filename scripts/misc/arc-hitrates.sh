#!/usr/bin/env bash

head -n12 /proc/spl/kstat/zfs/arcstats \
	| tail -n10 \
	| while
		read -r hitline
		read -r missesline
	do
		printf '%s\n' "$hitline" "$missesline"

		prefix="${hitline%hits *}"
		if [[ $prefix == "$hitline" ]] || [[ $missesline != "${prefix}misses "* ]]; then
			echo >&2 "Unable to parse."
			exit 1
		fi

		hits="${hitline##* }"
		misses="${missesline##* }"
		printf '%shitrate - %f%%\n' "${prefix}" "$(calc "$hits/($hits+$misses)*100")"
	done \
	| column -t
