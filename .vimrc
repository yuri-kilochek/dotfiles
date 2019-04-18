" disable compatibility with Vi
if &compatible
    set nocompatible
endif

" dein plugin managemenr
if dein#load_state('~/.local/share/dein')
    call dein#begin('~/.local/share/dein')

    call dein#add('hdima/python-syntax')
    call dein#add('tomasr/molokai')
    call dein#add('tpope/vim-vinegar')
    call dein#add('tpope/vim-eunuch')
    call dein#add('terryma/vim-multiple-cursors')
    call dein#add('bogado/file-line')

    call dein#end()
    call dein#save_state()
endif

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

" max line length indicator
set colorcolumn=80

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
set nowritebackup

" use X clipboard as yank buffer
set clipboard=unnamedplus

" set netrw to tree view by default
let g:netrw_liststyle=3

" enable russin layout
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0

" highlight search results
set hlsearch

