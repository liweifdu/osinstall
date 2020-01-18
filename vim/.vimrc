" vundle settings
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugin 'Valloric/YouCompleteMe'
" Plugin 'scrooloose/syntastic'
" Plugin 'bling/vim-airline'
Plugin 'SirVer/ultisnips'
" Plugin 'edsono/vim-matchit'
" Plugin 'elzr/vim-json'
Plugin 'honza/vim-snippets'
" Plugin 'justinmk/vim-sneak'
" Plugin 'kien/ctrlp.vim'
" Plugin 'ludovicchabant/vim-lawrencium'
Plugin 'majutsushi/tagbar'
Plugin 'mhinz/vim-signify'
Plugin 'plasticboy/vim-markdown'
Plugin 'scrooloose/nerdcommenter'
Plugin 'sjl/gundo.vim'
Plugin 'tpope/vim-fugitive'
" Plugin 'tpope/vim-sleuth'
" Plugin 'tpope/vim-surround'
" Plugin 'tyru/open-browser.vim'
" Plugin 'vim-scripts/a.vim'
Plugin 'scrooloose/nerdtree'

" Color schemes
Plugin 'flazz/vim-colorschemes'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" some usefull settings
syntax on

set number
set autoread
set noeb

" tab, search,indent settings
set tabstop=4
set softtabstop=4
set shiftwidth=4

set expandtab
set smarttab
autocmd BufRead,BufNewFile make,makefile,Makefile set noexpandtab

set showmatch
set hlsearch
set incsearch

set autoindent
set smartindent
set cindent

set mouse=a
set showcmd
set ruler

" map the keyboard
map <C-A> ggVG
map <F12> gg=G
nnoremap <silent> <F2> :TagbarToggle<CR>
nnoremap <silent> <F3> :NERDTreeToggle<CR>

" vmap the keyboard
vmap <leader>y "+y
vmap <leader>p "+p

" remap the gf
nnoremap gf <C-W>gf
vnoremap gf <C-W>gf
inoremap <C-u> <esc>gUiwea

" close bell
set vb t_vb=
au GuiEnter * set t_vb=

" advanced settings
set completeopt=preview,menu
set clipboard+=unnamed

" auto completement
autocmd BufRead,BufNewFile *.v iabbrev alw always @(posedge clk or negedge rstn) begin<Enter>  if(!rstn) begin<Enter>end<Enter>else begin<Enter>end<Enter>end<Esc>:call search('!cursor!','b')<CR>cf!

" fold settings
set foldcolumn=0
set foldmethod=marker
set foldlevel=3
set foldenable

" cursor
set cursorline
set cursorcolumn

" other settings
set guioptions-=m
set guioptions-=T
colorscheme solarized8_dark

"""""""""""""""""""""""""""""""""new file""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""some information"""""""""""""""""""""""""""""""""""""
" auto add the file title
func SetCommentC()        
    call setline(1, "/*************************************************************************")
    call append(line("."), "    > File Name: ".expand("%"))
    call append(line(".")+1, "    > Author: WeiLi")
    call append(line(".")+2, "    > Mail: lweifdu@gmail.com")
    call append(line(".")+3, "    > Created Time: ".strftime("%c"))
    call append(line(".")+4, "    > Description: ")
    call append(line(".")+5, " ************************************************************************/")
    call append(line(".")+6, "")
endfunc

func SetCommentShAndMake() 
    call setline(1, "\#########################################################################")
    call setline(2, "\# File Name: ".expand("%"))
    call setline(3, "\# Author: WeiLi")
    call setline(4, "\# Mail: lweifdu@gmail.com")
    call setline(5, "\# Created Time: ".strftime("%c"))
    call setline(6, "\# Description: ")
    call setline(7, "\#########################################################################")
endfunc

autocmd BufNewFile *.cpp,*.[ch],*.sh,*.pl,*.java,*.v,makefile exec ":call SetTitle()"
func SetTitle()
    if &filetype == 'sh'
        call SetCommentShAndMake()
        call setline(8,"\#!/bin/bash")
        call setline(9,"")

    elseif &filetype == 'perl'
        call SetCommentShAndMake()
        call setline(8,"\#!/usr/bin/perl")
        call setline(9,"")

    elseif &filetype == 'make'
        call SetCommentShAndMake()
        call setline(8,"")
        call setline(9,"")

    else
        call SetCommentC()
        if &filetype == 'cpp'
            call append(line(".")+7, "#include<iostream>")
            call append(line(".")+8, "using namespace std;")
            call append(line(".")+9, "")

        elseif &filetype == 'c'
            call append(line(".")+7, "#include<stdio.h>")
            call append(line(".")+8, "")
            call append(line(".")+9, "")
        endif

    endif
    autocmd BufNewFile * normal G
endfunc
""""""""""""""""""""""""""""""""""end newfile""""""""""""""""""""""""""""""""""""""""

" CTags settings
let g:tagbar_ctags_bin = 'ctags'
let g:tagbar_left = 1
let g:tagbar_width = 30

" nerdtree settings
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
let g:NERDTreeWinPos='left'
let g:NERDTreeSize=30
let g:NERDTreeShowLineNumbers=1

" CtrlP settings
" let g:ctrlp_map = '<leader>p'
" let g:ctrlp_cmd = 'CtrlP'
" map <leader>f :CtrlPMRU<CR>
" let g:ctrlp_custom_ignore = {
"     \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
"     \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
"     \ }
" let g:ctrlp_working_path_mode=0
" let g:ctrlp_match_window_bottom=1
" let g:ctrlp_max_height=15
" let g:ctrlp_match_window_reversed=0
" let g:ctrlp_mruf_max=500
" let g:ctrlp_follow_symlinks=1

" NerdComment settings
let g:NERDSpaceDelims=1

" Gundo settings
nnoremap <leader>h :GundoToggle<CR>

" Snips settings
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
