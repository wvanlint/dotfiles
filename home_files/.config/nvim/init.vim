syntax on
filetype plugin on
filetype indent off
set nocompatible

colorscheme zenburn

set autoread
set hidden
set hlsearch
set laststatus=2
set listchars=tab:▸·,trail:·
set mouse=
set noerrorbells visualbell
set nofixendofline
set nolist
set ruler
set showcmd
set termguicolors
set title
set wildmenu

set smarttab
set expandtab
set shiftwidth=2
set tabstop=2
set autoindent nosmartindent nocindent
set backspace=indent,eol,start
set formatoptions-=cro

autocmd BufEnter * :syntax sync fromstart
syntax sync fromstart

augroup indentation
autocmd!
autocmd Filetype {c,cpp} setlocal tabstop=2 shiftwidth=2 expandtab
autocmd Filetype ruby setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType java setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType haskell setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType markdown setlocal textwidth=0
autocmd Filetype {html,css} setlocal tabstop=2 shiftwidth=2 expandtab
autocmd Filetype make setlocal shiftwidth=8 tabstop=8 noexpandtab
autocmd Filetype go setlocal shiftwidth=2 tabstop=2 noexpandtab
autocmd Filetype yaml setlocal shiftwidth=2 tabstop=2 expandtab
autocmd Filetype rust setlocal shiftwidth=2 tabstop=2 noexpandtab
augroup END

function! DelTrailingWhitespace()
  let v = winsaveview()
  %s/\s\+$//e
  call winrestview(v)
endfunction
augroup deltrailing
autocmd! BufWritePre * :call DelTrailingWhitespace()
augroup END

function! RustFmt(f)
  let v = winsaveview()
  exe 'silent ! rustfmt ' shellescape(a:f)
  redraw!
  edit
  call winrestview(v)
endfunction

function! GoFmt(f)
  let v = winsaveview()
  exe 'silent ! gofmt -s -w ' shellescape(a:f)
  redraw!
  edit
  call winrestview(v)
endfunction

augroup gofmt
  autocmd! Filetype go autocmd! gofmt BufWritePost <buffer> call GoFmt(@%)
augroup END

" augroup rust
"   autocmd! Filetype rust autocmd! rustfmt BufWritePost <buffer> call RustFmt(@%)
"   autocmd! Filetype rust autocmd! rustfmt BufWritePost <buffer> call RustFmt(@%)
" augroup END

augroup reloadvimrc
  autocmd! BufWritePost $MYVIMRC :let rcvw = winsaveview()|source $MYVIMRC|call winrestview(rcvw)|unlet rcvw
augroup end

let mapleader = " "
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
nnoremap <silent> ]ol :<C-u>setlocal list<CR>
nnoremap <silent> [ol :<C-u>setlocal nolist<CR>
nnoremap <silent> ]q :<C-u>cnext<CR>
nnoremap <silent> [q :<C-u>cprev<CR>
nnoremap <silent> <leader>v :edit $MYVIMRC<CR>

nnoremap <silent> <leader>wo <C-w>o
nnoremap <silent> <leader>wj <C-w>j
nnoremap <silent> <leader>wJ <C-w>J
nnoremap <silent> <leader>wk <C-w>k
nnoremap <silent> <leader>wK <C-w>K
nnoremap <silent> <leader>wh <C-w>h
nnoremap <silent> <leader>wH <C-w>H
nnoremap <silent> <leader>wl <C-w>l
nnoremap <silent> <leader>wL <C-w>L

function InteractiveTerm(cmd, opts)
  function! ITExit(inputTemp, outputTemp, Handler)
    function! ITClosure(job_id, data, event) closure
      bd!
      try
        let out = filereadable(a:outputTemp) ? readfile(a:outputTemp) : []
      finally
        silent! call delete(a:inputTemp)
        silent! call delete(a:outputTemp)
      endtry
      if !empty(out)
        call a:Handler(out)
      endif
    endfunction
    return funcref('ITClosure')
  endfunction

  let input_temp = tempname()
  let output_temp = tempname()
  let fullCmd = ''
  if has_key(a:opts, 'input')
    call writefile(a:opts['input'], input_temp)
    let fullCmd = 'cat ' . input_temp . ' | '
  endif
  let fullCmd = fullCmd . a:cmd . ' > ' . output_temp
  let Handler = { out -> 0 }
  if has_key(a:opts, 'handler')
    let Handler = a:opts.handler
  endif
  enew
  call termopen(fullCmd, {'on_exit': ITExit(input_temp, output_temp, Handler)})
  let &l:statusline=' '
  startinsert
endfunction

function! SelectBuffer()
  redir => ls
    silent ls
  redir END
  let ls = reverse(split(ls, '\n'))
  call InteractiveTerm(
    \'fzf',
    \{
      \'input': ls,
      \'handler': { out -> execute('buffer! ' . matchstr(out[0], '^[ 0-9]*')) },
    \}
  \)
endfunction

nnoremap <silent> <Leader>b :call SelectBuffer()<CR>

 function! FuzzyFind()
   call InteractiveTerm(
     \'fzf --preview ''bat --color=always {}''',
     \{'handler': { out -> execute('edit! ' . out[0]) } }
   \)
 endfunction

nnoremap <silent> <Leader>p :call FuzzyFind()<CR>

function! Twf()
  call InteractiveTerm(
    \'twf ' . @%,
    \{'handler': { out -> execute('edit! ' . out[0]) } }
  \)
endfunction

nnoremap <silent> <Leader>t :call Twf()<CR>

function! Rg(search, fixed)
  function! RgHandler(out)
    cexpr a:out
  endfunction

  let search = ''
  let fixed = 0
  if strlen(a:search) > 0
    let search = a:search
    let fixed = a:fixed
    let g:lastRgSearch = search
    let g:lastRgFixed = fixed
  elseif exists("g:lastRgSearch") && strlen(g:lastRgSearch) > 0
    let search = g:lastRgSearch
    let fixed = g:lastRgFixed
  else
    return
  end

  let rgBase = 'rg'
  if fixed
    let rgBase = rgBase . ' -F'
  endif
  let previewCmd = rgBase . ' --context-separator "\n...\n" -n --color=always -C 2 ' . shellescape(search) . ' {}'
  call InteractiveTerm(
    \rgBase . ' -l ' . shellescape(search) .  ' | ' .
    \'fzf --ansi -d : -n 1 ' .
    \'--preview ' . shellescape(previewCmd) . ' | ' .
    \'xargs ' . rgBase . ' --vimgrep ' . shellescape(search),
    \{'handler': funcref('RgHandler') }
  \)
endfunction

command! -nargs=? Rg call Rg(<q-args>, 0)

function! RgOpFunc(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@

  if a:0
    silent exe "normal! gvy"
  elseif a:type == 'line'
    silent exe "normal! '[V']y"
  else
    silent exe "normal! `[v`]y"
  endif

  let search = @@
  let &selection = sel_save
  let @@ = reg_save

  call Rg(search, 1)
endfunction

nnoremap <silent> <Leader>f :set opfunc=RgOpFunc<CR>g@
nnoremap <Leader>ff :Rg<Space>
vnoremap <silent> <Leader>f :<C-u>call RgOpFunc(visualmode(), 1)<CR>
