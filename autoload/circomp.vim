" Circular completion plugin
" Maintainer: INAJIMA Daisuke <inajima@sopht.jp>
" License: MIT License

let s:cpo_save = &cpo
set cpo&vim

function! circomp#list()
    return get(g:circomp_config, &filetype, g:circomp_config['_'])
endfunction

function! circomp#key(step)
    let complist = circomp#list()

    while !empty(b:circomp_seq)
	let b:circomp_idx = remove(b:circomp_seq, 0)
	let entry = complist[b:circomp_idx]
	if eval(get(entry, 'condition', '1'))
	    return entry['key']
	endif
    endwhile

    return ''
endfunction

function! circomp#start()
    if pumvisible()
	return circomp#jump(1)
    endif

    let b:circomp_seq = range(0, len(circomp#list()) - 1)

    let key = circomp#key(1)
    if key == ''
	return ''
    endif

    let pre = key == "\<C-x>\<C-v>" ? "\<C-o>:redraw\<CR>" : ""
    return pre . key . "\<C-r>=circomp#after(1)\<CR>"
endfunction

function! circomp#jump(step)
    let len = len(circomp#list())
    let index = b:circomp_idx
    if a:step > 0
	let b:circomp_seq = extend(range(index + 1, len - 1),
	\			    range(0, index))
    else
	let b:circomp_seq = extend(range(index - 1, 0, -1),
	\			    range(len - 1, index, -1))
    endif

    let key = circomp#key(a:step)
    if key == ''
	return ''
    endif

    let pre = pumvisible() ? "\<C-e>" : ""
    let pre .= key == "\<C-x>\<C-v>" ? "\<C-o>:redraw\<CR>" : ""
    return pre . key . "\<C-r>=circomp#after(" . a:step . ")\<CR>"
endfunction

function! circomp#next()
    return circomp#jump(1)
endfunction

function! circomp#prev()
    return circomp#jump(-1)
endfunction

function! circomp#after(step)
    if pumvisible()
	return "\<C-p>\<Down>"
    elseif empty(b:circomp_seq)
	return ""
    else
	let key = circomp#key(a:step)
	if key == ''
	    return ''
	endif

	return key . "\<C-r>=circomp#after(" . a:step . ")\<CR>"
    endif
endfunction

let &cpo = s:cpo_save
