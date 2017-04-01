set nocompatible			" be iMproved, required
set laststatus=2  	 		 " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs

filetype off				" required 

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" All of your Plugins must be added before the following line
call vundle#end()			" required
filetype plugin indent on   " required
" Define bundles via Github repos
Bundle "Lokaltog/vim-powerline"

set nu
color desert
syntax on
set smartindent
set tabstop=4
set incsearch
set hlsearch
