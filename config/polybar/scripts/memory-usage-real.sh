#!/usr/bin/env sh

# Polybar by default shows all memory that is 'available' as free. This includes dick cache, but it doesn't take into account ZFS's disk cache.

total="$(free -b | awk '/^Mem:/ { print $2 }')"
avail="$(free -b | awk '/^Mem:/ { print $7 }')"
arc="$(command -v arcstat > /dev/null && (arcstat -p -f size | tail -n1) || echo 0)"

used="$((total - avail - arc))"
used="$((used + (total / 200)))" # Round up

echo "$((used * 100 / total))%"
