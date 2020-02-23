filetype plugin on
syntax on

set nocompatible

set backspace=indent,eol,start
set hlsearch
set list
set listchars=tab:>_,trail:~
set noerrorbells visualbell t_vb=
set nofixendofline
set ruler
set showcmd
set smarttab
set t_Co=256
set title
set ttimeoutlen=50

" Theme
colorscheme zenburn

" Indentation defaults
set expandtab
set shiftwidth=2
set tabstop=2
set autoindent nosmartindent nocindent

" Language settings
autocmd Filetype {c,cpp} setlocal tabstop=2 shiftwidth=2 expandtab
autocmd Filetype ruby setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType java setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType haskell setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType markdown setlocal textwidth=0
autocmd Filetype {html,css} setlocal tabstop=2 shiftwidth=2 expandtab
autocmd Filetype make setlocal shiftwidth=8 tabstop=8 noexpandtab

" No automatic comment leaders
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Set filetypes
autocmd BufRead,BufNewFile,FileReadPre *.md setlocal filetype=markdown
autocmd BufRead,BufNewFile,FileReadPre *.markdown setlocal filetype=markdown

" Remove trailing whitespace
autocmd BufWritePre * %s/\s\+$//e
