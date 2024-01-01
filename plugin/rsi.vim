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

function! s:ctrl_a()
  let mode = mode()
  if mode ==# 'n'
    return '^'
  elseif mode ==# 'c'
    return "\<Home>"
  endif

  let pos = col('.')
  let hol = max([match(getline('.'), '\S\zs'), 1])

  if pos > hol
    return repeat("\<Left>", pos - hol)
  else
    return repeat("\<Right>", hol - pos)
  endif
endfunction

function! s:ctrl_e()
  if col('.') >strlen(getline('.')) || pumvisible()
    return "\<C-E>"
  endif
  return "\<End>"
endfunction

function! s:ctrl_d(line, pos)
  let len = strlen(a:line)
  if a:pos > len
    return "\<Del>"
  endif

  let next = matchend(a:line, '\>\s*', a:pos)
  let count = max([next - a:pos + 1, 1])

  let @+ = strpart(a:line, a:pos - 1, count)
  return repeat("\<Del>", count)
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
nnoremap <expr> <C-A> <SID>ctrl_a()
inoremap <expr> <C-A> <SID>ctrl_a()
cnoremap        <C-A> <Home>
inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<C-D>\<Esc>kJs":"\<Left>"
cnoremap        <C-B> <Left>
inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<C-F>":"\<Right>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Right>"
nnoremap <expr> <C-E> <SID>ctrl_e()
inoremap <expr> <C-E> <SID>ctrl_e()
inoremap        <C-J> <Down>
cnoremap        <C-J> <Down>
inoremap        <C-K> <Up>
cnoremap        <C-K> <Up>
" only if keymodel != startsel
nnoremap        <C-H> <S-Left>
inoremap        <C-H> <S-Left>
cnoremap        <C-H> <S-Left>
nnoremap        <C-L> <S-Right>
inoremap        <C-L> <S-Right>
cnoremap        <C-L> <S-Right>

" editing
inoremap <expr> <C-D> <SID>ctrl_d(getline('.'), col('.'))
cnoremap <expr> <C-D> <SID>ctrl_d(getcmdline(), getcmdpos())
inoremap <expr> <C-X> <SID>ctrl_x(getline('.'), col('.'))
cnoremap <expr> <C-X> <SID>ctrl_x(getcmdline(), getcmdpos())
inoremap <expr> <C-U> <SID>ctrl_u(getline('.'), col('.'))
cnoremap <expr> <C-U> <SID>ctrl_u(getcmdline(), getcmdpos())
inoremap <expr> <C-Y> "\<C-R>+"
cnoremap <expr> <C-Y> pumvisible() ? "\<C-Y>" : "\<C-R>+"
