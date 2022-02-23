filetype plugin on
syntax on

set nocompatible

set backspace=indent,eol,start
set hlsearch
set nolist
set listchars=tab:▸·,trail:·
set noerrorbells visualbell t_vb=
set nofixendofline
set ruler
set hidden
set showcmd
set smarttab
set title

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors


" Theme
colorscheme zenburn

" Indentation defaults
set expandtab
set shiftwidth=2
set tabstop=2
set autoindent nosmartindent nocindent

autocmd BufEnter * :syntax sync fromstart
syntax sync fromstart

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
function! GoFmt(f)
  let v = winsaveview()
  execute 'silent ! gofmt -s -w ' . a:f
  redraw!
  edit
  call winrestview(v)
endfunction
augroup GoFmt
autocmd Filetype go autocmd! BufWritePost <buffer> call GoFmt(@%)
augroup END

" No automatic comment leaders
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Remove trailing whitespace
function! DelTrailingWhitespace()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction
autocmd BufWritePre * :call DelTrailingWhitespace()

" Bindings
let mapleader = " "

function! SearchHelper(search)
  let search = a:search
  if search == ""
    return
  endif
  let temp = tempname()
  execute 'silent ! rg -l "' . search .  '" | fzf --ansi -d : -n 1 --preview ''rg --context-separator "\n...\n" -n --color=always -C 2 "' . search . '" {}'' > ' . temp
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

function! SearchProject()
  let newSearch = input('Search: ')
  if newSearch == ""
    return
  endif
  let g:search = newSearch
  call SearchHelper(g:search)
endfunction

nnoremap <silent> <Leader>f :call SearchProject()<CR>

function! RedoSearchProject()
  let g:search = get(g:, 'search', "")
  call SearchHelper(g:search)
endfunction

nnoremap <silent> <Leader>n :call RedoSearchProject()<CR>

function! FuzzyFind()
  let temp = tempname()
  execute 'silent ! fzf --preview ''bat --color=always {}'' > ' . temp
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

function! Twf()
  let temp = tempname()
  execute 'silent ! twf ' . @% . ' > ' . temp
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

nnoremap <silent> <Space>t :call Twf()<CR>

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
