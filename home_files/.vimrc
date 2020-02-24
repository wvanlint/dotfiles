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
autocmd Filetype go setlocal shiftwidth=2 tabstop=2 noexpandtab

" No automatic comment leaders
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Remove trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

" Bindings
let mapleader = " "

function! SearchProject()
  let search = input('Search: ')
  let temp = tempname()
  execute 'silent ! rg --color=always --no-heading ' . search .  ' | fzf --ansi -d : -n 1 --preview ''bat --color=always $(echo {} | cut -d: -f1) | rg --color=always --colors "match:fg:white" --colors "match:bg:red" -C 5 ' . search . ' '' | cut -d: -f1 > ' . temp
  redraw!
  try
    let out = filereadable(temp) ? readfile(temp) : []
  finally
    silent! call delete(temp)
  endtry
  if !empty(out)
    execute 'edit! ' . out[0]
  endif
endfunction

nnoremap <silent> <Leader>f :call SearchProject()<CR>

function! FuzzyFind()
  let temp = tempname()
  execute 'silent ! fzf --preview ''bat {}'' > ' . temp
  redraw!
  try
    let out = filereadable(temp) ? readfile(temp) : []
  finally
    silent! call delete(temp)
  endtry
  if !empty(out)
    execute 'edit! ' . out[0]
  endif
endfunction

nnoremap <silent> <Leader>p :call FuzzyFind()<CR>

function! SelectBuffer()
  redir => ls
    silent ls
  redir END
  let ls = split(ls, '\n')
  let temp_input = tempname()
  let temp_output = tempname()
  try
    call writefile(reverse(ls), temp_input)
    execute 'silent ! cat ' . temp_input . ' | fzf > ' . temp_output
    redraw!
    let out = filereadable(temp_output) ? readfile(temp_output) : []
  finally
    silent! call delete(temp_input)
    silent! call delete(temp_output)
  endtry
  if !empty(out)
    execute 'buffer!' matchstr(out[0], '^[ 0-9]*')
  endif
endfunction

nnoremap <silent> <Leader>b :call SelectBuffer()<CR>
