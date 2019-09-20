scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:dir = expand($HOME . '/Music/')
let s:music_list = map(glob(s:dir . '/*.wav', 1, 1), 'fnamemodify(v:val, ":t:r")')
echomsg s:music_list

function PlayMusic#Select()
  call s:show_popup(s:music_list)
  " call sound_playfile($HOME . '/Music/GetWild.wav')
endfunction

function PlayMusic#Play()
endfunction

function! s:popup_menu_update(wid, ctx) abort
  let l:buf = winbufnr(a:wid)
  let l:menu = map(copy(a:ctx.menu), '(v:key == a:ctx.select ? "→" : "  ") .. v:val')
  call setbufline(l:buf, 1, l:menu)
endfunction

function! s:popup_filter(ctx, wid, c) abort
  if a:c ==# 'j'
    let a:ctx.select += a:ctx.select ==# len(a:ctx.menu)-1 ? 0 : 1
    call s:popup_menu_update(s:wid, a:ctx)
  elseif a:c ==# 'k'
    let a:ctx.select -= a:ctx.select ==# 0 ? 0 : 1
    call s:popup_menu_update(s:wid, a:ctx)
  elseif a:c ==# "\n" || a:c ==# "\r" || a:c ==# ' '
    call popup_close(a:wid)
    " ここで，sound再生を呼び出す
    call sound_playfile($HOME . '/Music/' . a:ctx.menu[a:ctx.select] . '.wav', 'Callback')
  elseif a:c ==# "\x1b"
    call popup_close(a:wid)
    return 0
  endif
  return 1
endfunction

function! Callback(id, status)
  echomsg "sound " . a:id . " finished with " . a:status
endfunction

function! s:show_popup(menu) abort
  let l:ctx = {'select': 0, 'menu': a:menu}
  let s:wid = popup_create(a:menu, {
        \ 'border': [1,1,1,1],
        \ 'filter': function('s:popup_filter', [l:ctx]),
        \})
  call s:popup_menu_update(s:wid, l:ctx)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
