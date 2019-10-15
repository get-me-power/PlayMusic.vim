scriptencoding utf-8

if exists('g:loaded_PlayMusic')
  finish
endif

if !has('sound')
  echomsg 'PlayMusic.vim'
  echomsg '+sound option must be enabled'
  finish
endif

let g:loaded_PlayMusic = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 PlayMusic call PlayMusic#Select()
command! -nargs=0 MusicStop call sound_clear()

let &cpo = s:save_cpo
unlet s:save_cpo
