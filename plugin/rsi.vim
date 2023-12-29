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

function! s:ctrl_d(line, pos)
  let len = strlen(a:line)
  let next = matchend(a:line, '\>\s*', a:pos)
  let count = next - a:pos + 1  " adjust for [0,1]-based indexes

  if a:pos > 0
    let @+ = strpart(a:line, a:pos - 1, count)
  endif

  return a:pos <= len ? repeat("\<Del>", count) : ""
endfunction

function! s:ctrl_u(line, pos)
  if a:pos > 1
    " hack for prompt
    let @+ = substitute(a:line[:a:pos-2], '^\s*❭\s*', '', '')
  endif
  return "\<C-U>"
endfunction

function! s:ctrl_x(line, pos)
  let len = strlen(a:line)
  let count = len - a:pos + 1

  if a:pos > 0
    let @+ = strpart(a:line, a:pos - 1)
  endif

  return a:pos <= len ? repeat("\<Del>", count) : ""
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
inoremap <expr> <C-D> <SID>ctrl_d(getline('.'), col('.'))
cnoremap <expr> <C-D> <SID>ctrl_d(getcmdline(), getcmdpos())
inoremap <expr> <C-X> <SID>ctrl_x(getline('.'), col('.'))
cnoremap <expr> <C-X> <SID>ctrl_x(getcmdline(), getcmdpos())
inoremap <expr> <C-U> <SID>ctrl_u(getline('.'), col('.'))
cnoremap <expr> <C-U> <SID>ctrl_u(getcmdline(), getcmdpos())
inoremap <expr> <C-Y> "\<C-R>+"
cnoremap <expr> <C-Y> pumvisible() ? "\<C-Y>" : "\<C-R>+"
