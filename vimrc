" My customized .vimrc
" I'm quite surprised at how much (useful) crap I've managed to gather in here
" over the years.
" Last change: Tue, 15 Mar 2011 17:16:23 +0100

" When started as "evim", evim.vim will already have done these settings. Not
" that I EVER use evim, but whatever :P
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Load the rc files responsible for the rest of the initialisation.
runtime! rc/**.vim
