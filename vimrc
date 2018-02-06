set nocompatible			" be iMproved, required
set laststatus=2  	 		 " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs

"fix powerline status no color issue
set t_Co=256

filetype off				" required 

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-scripts/Conque-GDB'
let g:ConqueTerm_Color = 2         " 1: strip color after 200 lines, 2: always with color
let g:ConqueTerm_CloseOnEnd = 1    " close conque when program ends running
let g:ConqueTerm_StartMessages = 0 " display warning messages if conqueTerm is configured incorrectly

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
