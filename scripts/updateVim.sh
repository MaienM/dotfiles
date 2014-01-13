#!/bin/bash

# Make sure Vundle is installed.
if [[ ! -d vim/bundle/vundle ]]
then
	[[ -f master.zip ]] && rm master.zip
	wget https://github.com/gmarik/vundle/archive/master.zip
	unzip master.zip
	rm master.zip
	
	mkdir -p vim/bundle 
	mv vundle-master vim/bundle/vundle
fi

vim -u vim/vundle.vim +BundleInstall +qall
