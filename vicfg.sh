#!/bin/bash
#This script is to configure vim automatically
#History:
# 2018/02/03 First Release by arisskz6

read -p "Before we configure vimrc,do you sure 'git' and 'vim' have been installed?y/N" yn
if [ "$yn" = "y" ] || [ "$yn" = "Y"]
then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	cp ./vimrc ~/.vimrc
	vim +PluginInstall +qall
	echo 
	echo "############"
	echo "# Complete!#"
	echo "############"
	echo
	exit 0
else
	exit 2
fi
