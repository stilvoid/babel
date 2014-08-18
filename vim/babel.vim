" Filename:     babel.vim
" Purpose:      Vim syntax file
" Language:     babel files
" Maintainer:   Steve Engledow <steve@offend.me.uk>
" Last Change:  Aug 17, 2014

if exists("b:current_syntax") && !exists ("g:syntax_debug")
  finish
endif

syn case match
setlocal iskeyword+=

syn match cont /^\s\+.*$/
syn match name /^\s*\w\+\(\[\w\+\]\)\?\s*\ze=/ nextgroup=equals
syn match equals "=" nextgroup=value contained
syn match value /.*$/ contained
syn region comment start=/^\s*#/ end=/$/

highlight link name Identifier
highlight link comment Comment
highlight link value String
highlight link cont String

let b:current_syntax = "babel"
" vim: fdm=marker
