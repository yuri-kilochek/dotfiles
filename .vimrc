" disable compatibility with Vi
set nocompatible

" make backspace work
set backspace=indent,eol,start

" show commands
set showcmd

" always show status line
set laststatus=2

" show line numbers
set number

" show cursor position
set ruler

" enable syntax highlithing
filetype on
filetype plugin on
filetype indent on
colorscheme molokai
syntax enable

" highlight cursor line
set cursorline

" convert tabs to spaces
set expandtab
set tabstop=4
set softtabstop=4
set smarttab
set shiftwidth=4
set autoindent
set smartindent

" enable mouse support
set mouse=a

" show lines/columns around cursor
set scrolloff=7
set sidescrolloff=14

" remove buffer when tab closes
set nohidden

" disable bells
set noerrorbells
set visualbell
set t_vb=

" disable backup files
set nobackup


