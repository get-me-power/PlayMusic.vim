if exists('g:loaded_PlayMusic')
  finish
endif
let g:loaded_PlayMusic = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 PlayMusic call PlayMusic#Play()

let &cpo = s:save_cpo
unlet s:save_cpo
