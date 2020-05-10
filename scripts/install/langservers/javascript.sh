#!/usr/bin/env bash

# Javascript/Typescript
if command -v asdf &> /dev/null && ! (asdf current node | grep -q system) &> /dev/null;
then
	npm install -g javascript-typescript-langserver
else
	echo "Node must be installed through asdf"
fi
