#!/bin/sh

if which nvim &> /dev/null; then
    alias vim="echo Use 'nvim' instead. If you _really_ need vim, use 'noalias vim'"
fi
