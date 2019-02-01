#!/usr/bin/env zsh

set -o errexit

fn="$HOME/.zhistory_bad_$(date +%s)"
mv ~/.zhistory "$fn"
strings "$fn" > ~/.zhistory
fc -R ~/.zhistory
