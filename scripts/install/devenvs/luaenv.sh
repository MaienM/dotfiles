#!/usr/bin/env sh

clone() {
	[ -d "$2" ] || git clone "$1" "$2"
}

clone https://github.com/cehoffman/luaenv.git ~/.luaenv
clone https://github.com/cehoffman/lua-build.git ~/.luaenv/plugins/lua-build
clone https://github.com/xpol/luaenv-luarocks.git ~/.luaenv/plugins/luaenv-luarocks
