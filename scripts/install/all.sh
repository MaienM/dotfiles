#!/usr/bin/env bash

set -o errexit

DIR=$(dirname "${BASH_SOURCE[0]}")

echo '=== Setting up development environments'
for file in "$DIR"/devenvs/*.sh; do
   echo "== $file"
   $file
done

echo '=== Setting up other stuff'
for file in "$DIR"/misc/*.sh; do
   echo "== $file"
   $file
done
