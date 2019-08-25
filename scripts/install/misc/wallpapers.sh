#!/usr/bin/env sh

# The APIKEY is hardcoded in the file. Create a version that does not include this so we can pass it normally.
script="$(mktemp --suffix='.sh')"
echo ">>> Creating custom version of the script that can accept APIKEY at '$script'."
grep -v '^APIKEY=' < opt/wallhaven-downloader/wallhaven.sh > "$script"
chmod +x "$script"

echo ">>> Enter API key (get it at https://wallhaven.cc/settings/account):"
read -r APIKEY
export APIKEY

"$script" \
	--location "$HOME/.local/share/backgrounds/" \
	--type favorites \
	--user MaienM \
	--favcollection Nature

