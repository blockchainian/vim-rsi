" rsi.vim - Disfigured line editing
" Version:      0.0.1
" GetLatestVimScripts: 4359 1 :AutoInstall: rsi.vim

if exists("g:loaded_rsi") || v:version < 700 || &cp
  finish
endif
let g:loaded_rsi = 1

set ttimeout
if &ttimeoutlen == -1
  set ttimeoutlen=50
endif

function! s:ctrl_x()
  let line = getcmdline()
  let len = strlen(line)
  let pos = getcmdpos()
  let count = len - pos + 1

  if pos > 0
    let @+ = strpart(line, pos - 1)
  endif

  return pos <= len ? repeat("\<Del>", count) : ""
endfunction

function! s:ctrl_u()
  if getcmdpos() > 1
    let @+ = getcmdline()[:getcmdpos()-2]
  endif
  return "\<C-U>"
endfunction

" motion
inoremap        <C-A> <Home>
cnoremap        <C-A> <Home>
inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
cnoremap        <C-B> <Left>
inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"
noremap!        <C-H> <S-Left>
noremap!        <C-L> <S-Right>

" editing
inoremap <C-D> <C-O>dw
cnoremap <C-D> <S-Right><Right><C-W>
inoremap <C-X> <C-O>D
cnoremap <expr> <C-X> <SID>ctrl_x()
cnoremap <expr> <C-U> <SID>ctrl_u()
inoremap <expr> <C-Y> "\<C-R>+"
cnoremap <expr> <C-Y> pumvisible() ? "\<C-Y>" : "\<C-R>+"
