" Circular completion plugin
" Maintainer: INAJIMA Daisuke <inajima@sopht.jp>
" License: MIT License

let s:cpo_save = &cpo
set cpo&vim

function! circomp#list()
    return get(g:circomp_config, &filetype, g:circomp_config['_'])
endfunction

function! circomp#set_index(i)
    if type(a:i) == type(0)
        let b:circomp_idx = a:i
    elseif type(a:i) == type("")
        for i in range(0, len(circomp#list()) - 1)
            if circomp#list()[i]['key'] == a:i
                let b:circomp_idx = i
                break
            endif
        endfor
    endif
endfunction

function! circomp#key(step)
    let complist = circomp#list()

    while !empty(b:circomp_seq)
	let b:circomp_idx = remove(b:circomp_seq, 0)
	let entry = complist[b:circomp_idx]
	if eval(get(entry, 'condition', '1'))
            if b:circomp_idx < 0
                let b:circomp_idx += len(complist)
            endif
	    return entry['key']
	endif
    endwhile

    return ''
endfunction

function! circomp#start(...)
    let default_idx = a:0 > 0 ? a:1 : 0
    let step = a:0 > 1 && a:2 < 0 ? -1 : 1

    if !pumvisible()
        call circomp#set_index(default_idx)
        let b:circomp_idx -= step
        if b:circomp_idx < 0
            let b:circomp_idx += len(circomp#list())
        endif
    endif
    return circomp#jump(step)
endfunction

function! circomp#jump(step)
    if !exists('b:circomp_idx')
        let b:circomp_idx = len(circomp#list()) - a:step
    endif

    let len = len(circomp#list())
    let index = b:circomp_idx
    if a:step > 0
	let b:circomp_seq = range(index - len + 1, index)
    else
        let b:circomp_seq = range(index - 1, index - len, -1)
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
        if g:circomp_insert_first_candidate
            return ""
        else
            return "\<C-p>\<Down>"
        endif
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
