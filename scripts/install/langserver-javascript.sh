#!/bin/sh

# Javascript/Typescript
if which nodenv &> /dev/null
  && (nodenv version | grep -v system) &> /dev/null;
then
  npm install -g javascript-typescript-langserver
else
  echo "Node must be installed through nodenv"
fi
