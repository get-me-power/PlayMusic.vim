scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:dir = expand($HOME . '/Music/')
let s:music_list = map(glob(s:dir . '/*.wav', 1, 1), 'fnamemodify(v:val, ":t:r")')
echomsg s:music_list

function PlayMusic#Play()
  " call sound_playfile($HOME . '/Music/GetWild.wav')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
