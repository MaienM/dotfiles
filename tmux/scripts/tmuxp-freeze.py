#!/usr/bin/env cached-nix-shell
#!nix-shell -i python
#!nix-shell -p python3
#!nix-shell -p python3.pkgs.kaptan
#!nix-shell -p python3.pkgs.libtmux
#!nix-shell -p tmuxp

import kaptan
from tmuxp import config
from tmuxp.cli.freeze import freeze
from libtmux import Server


def freeze_as_json(session_name, path):
	t = Server()
	session = t.find_where({"session_name": session_name})
	if not session:
		print("Cannot find session", session_name)
		return

	configparser = kaptan.Kaptan()
	configparser.import_config(config.inline(freeze(session)))
	sconfig = configparser.export("json", indent=2)

	with open(path, "w") as f:
		f.write(sconfig)


if __name__ == "__main__":
	import sys

	freeze_as_json(*sys.argv[1:])

