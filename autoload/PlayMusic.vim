scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:dir = expand($HOME . '/Music/')
if has('win32')
  let s:music_list = map(glob(s:dir . '/*.mp3', 1, 1), 'fnamemodify(v:val, ":t:r")')
else
  let s:music_list = map(glob(s:dir . '/*.wav', 1, 1), 'fnamemodify(v:val, ":t:r")')
endif
" echomsg s:music_list

function PlayMusic#Select()
  call s:show_popup(s:music_list)
endfunction

function! s:popup_menu_update(wid, ctx) abort
  let l:buf = winbufnr(a:wid)
  let l:menu = map(copy(a:ctx.menu), '(v:key == a:ctx.select ? "->" : "  ") .. v:val')
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
    call sound_clear()
    if has('win32')
      call sound_playfile($HOME . '/Music/' . a:ctx.menu[a:ctx.select] . '.mp3', 'Callback')
    else
      call sound_playfile($HOME . '/Music/' . a:ctx.menu[a:ctx.select] . '.wav', 'Callback')
    endif
    echomsg 'NowPlaying... ' . a:ctx.menu[a:ctx.select]
  elseif a:c ==# "\x1b"
    call popup_close(a:wid)
    return 0
  endif
  return 1
endfunction

function! s:show_popup(menu) abort
  let l:ctx = {'select': 0, 'menu': a:menu}
  let s:wid = popup_create(a:menu, {
        \ 'border': [1,1,1,1],
        \ 'filter': function('s:popup_filter', [l:ctx]),
        \})
  call s:popup_menu_update(s:wid, l:ctx)
endfunction

function! Callback(id, status)
  let l:play_status = {0: 'finish', 1: 'stop', 2: 'error'}
  echomsg "Music is " . l:play_status[a:status]
endfunction

function! ViewMusic(music_name)
  echomsg a:music_name
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
