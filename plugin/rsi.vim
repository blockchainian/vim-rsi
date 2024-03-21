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

function! s:reverse(s)
  let len = strlen(a:s)
  let rs = ''

  for i in range(len(a:s) - 1, 0, -1)
    let rs = rs . a:s[i]
  endfor

  return rs
endfunction

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

function! s:ctrl_w(line, pos)
  let idx = a:pos - 1
  let len = strlen(a:line)
  if idx < 0
    return ''
  endif

  let rline = s:reverse(a:line)
  let ridx = len - idx
  let prev = len - matchend(rline, '\>', ridx) - 1
  let count = max([idx - prev - 1, 1])

  let @+ = strpart(a:line, prev + 1, count)
  return repeat("\<Bs>", count)
endfunction

function! s:ctrl_d(line, pos)
  return "\<Del>"
endfunction

function! s:alt_d(line, pos)
  let idx = a:pos - 1
  let len = strlen(a:line)
  if idx >= len
    return ''
  endif

  let next = matchend(a:line, '\>\s*', idx)
  let count = max([next - idx, 1])

  let @+ = strpart(a:line, idx, count)
  return repeat("\<Del>", count)
endfunction

function! s:alt_f(line, pos)
  let idx = a:pos - 1
  let len = strlen(a:line)
  if idx >= len
    return ''
  endif

  let next = matchend(a:line, '\>\s*', idx)
  let count = max([next - idx, 1])

  return repeat("\<Right>", count)
endfunction

function! s:ctrl_u(line, pos)
  if a:pos > 1
    " hack for prompts
    if a:line[:1] == '❭ '
      let @+ = a:line[2:a:pos-2]
    else
      let @+ = a:line[:a:pos-2]
    endif
  endif
  return "\<C-U>"
endfunction

" Exported for init.vim
function! RSI_ctrl_k(line, pos)
  let len = strlen(a:line)
  let count = len - a:pos + 1

  if a:pos > 0
    let @+ = strpart(a:line, a:pos - 1)
  endif

  return a:pos <= len ? repeat("\<Del>", count) : ''
endfunction

" motion
nnoremap <expr> <C-A> <SID>ctrl_a()
inoremap <expr> <C-A> <SID>ctrl_a()
cnoremap        <C-A> <Home>
nnoremap <expr> <C-E> <SID>ctrl_e()
inoremap <expr> <C-E> <SID>ctrl_e()
nnoremap        <C-B> <Left>
inoremap        <C-B> <Left>
cnoremap        <C-B> <Left>
nnoremap        <C-F> <Right>
inoremap        <C-F> <Right>
cnoremap        <C-F> <Right>
" only if keymodel != startsel
nnoremap        <M-b> <S-Left>
inoremap        <M-b> <S-Left>
cnoremap        <M-b> <S-Left>
nnoremap <expr> <M-f> <SID>alt_f(getline('.'), col('.'))
inoremap <expr> <M-f> <SID>alt_f(getline('.'), col('.'))
cnoremap <expr> <M-f> <SID>alt_f(getcmdline(), getcmdpos())

" editing
inoremap <expr> <C-W> <SID>ctrl_w(getline('.'), col('.'))
cnoremap <expr> <C-W> <SID>ctrl_w(getcmdline(), getcmdpos())
inoremap <expr> <M-BS> <SID>ctrl_w(getline('.'), col('.'))
cnoremap <expr> <M-BS> <SID>ctrl_w(getcmdline(), getcmdpos())
inoremap <expr> <C-D> <SID>ctrl_d(getline('.'), col('.'))
cnoremap <expr> <C-D> <SID>ctrl_d(getcmdline(), getcmdpos())
inoremap <expr> <M-d> <SID>alt_d(getline('.'), col('.'))
cnoremap <expr> <M-d> <SID>alt_d(getcmdline(), getcmdpos())
inoremap <expr> <C-K> RSI_ctrl_k(getline('.'), col('.'))
cnoremap <expr> <C-K> RSI_ctrl_k(getcmdline(), getcmdpos())
inoremap <expr> <C-U> <SID>ctrl_u(getline('.'), col('.'))
cnoremap <expr> <C-U> <SID>ctrl_u(getcmdline(), getcmdpos())
inoremap <expr> <C-Y> "\<C-R>+"
cnoremap <expr> <C-Y> pumvisible() ? "\<C-Y>" : "\<C-R>+"
