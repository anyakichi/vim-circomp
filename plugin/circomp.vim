" Circular completion plugin
" Maintainer: INAJIMA Daisuke <inajima@sopht.jp>
" Version: 0.1
" License: MIT License

if exists("g:loaded_circomp")
    finish
endif
let g:loaded_circomp = 1

let s:cpo_save = &cpo
set cpo&vim

if !exists('g:circomp_no_mappings') || !g:circomp_no_mappings
    if mapcheck("<C-k>", "i") == ''
	inoremap <silent> <expr> <C-k> circomp#start()
    endif
    if mapcheck("<C-i>", "i") == ''
	inoremap <silent> <expr> <C-i> pumvisible() ? circomp#next() : "\<C-i>"
    endif
    if mapcheck("<C-a>", "i") == ''
	inoremap <silent> <expr> <C-a> pumvisible() ? circomp#prev() : "\<C-a>"
    endif
endif

if !exists('g:circomp_config')
    let g:circomp_config = {
    \	'_': [
    \	    { 'key': "\<C-x>\<C-u>", 'condition': '!empty(&l:completefunc)' },
    \	    { 'key': "\<C-x>\<C-o>", 'condition': '!empty(&l:omnifunc)' },
    \	    { 'key': "\<C-n>" },
    \	    { 'key': "\<C-x>\<C-]>", 'condition': '!empty(tagfiles())' },
    \	    { 'key': "\<C-x>\<C-i>" },
    \	    { 'key': "\<C-x>\<C-d>" },
    \	    { 'key': "\<C-x>\<C-k>", 'condition': '!empty(&l:dictionary)' },
    \	    { 'key': "\<C-x>\<C-t>", 'condition': '!empty(&l:thesaurus)' },
    \	    { 'key': "\<C-x>\<C-f>" },
    \	    { 'key': "\<C-x>\<C-s>", 'condition': '&l:spell' },
    \	],
    \	'vim': [
    \	    { 'key': "\<C-x>\<C-u>", 'condition': '!empty(&l:completefunc)' },
    \       { 'key': "\<C-x>\<C-v>" },
    \	    { 'key': "\<C-x>\<C-o>", 'condition': '!empty(&l:omnifunc)' },
    \	    { 'key': "\<C-n>" },
    \	    { 'key': "\<C-x>\<C-]>", 'condition': '!empty(tagfiles())' },
    \	    { 'key': "\<C-x>\<C-i>" },
    \	    { 'key': "\<C-x>\<C-d>" },
    \	    { 'key': "\<C-x>\<C-k>", 'condition': '!empty(&l:dictionary)' },
    \	    { 'key': "\<C-x>\<C-t>", 'condition': '!empty(&l:thesaurus)' },
    \	    { 'key': "\<C-x>\<C-f>" },
    \	    { 'key': "\<C-x>\<C-s>", 'condition': '&l:spell' },
    \	]
    \}
endif

let &cpo = s:cpo_save
