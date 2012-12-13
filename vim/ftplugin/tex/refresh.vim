" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

command! -b Refresh :call ShellIfExists(expand('%:p:r') . '.pdf', 'xdotool search -name "'.expand("<afile>:r").'" key R', 0)
