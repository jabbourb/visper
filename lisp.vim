" Author: Bassam Jabbour
" Date: February 22th, 2011
" Description: A minimalistic Lisp plugin

" {{{1 Exported variables

"" The pipe the lisp process will be listening on
let g:lisp_input="/tmp/lisp-input"
"" TODO: The file the lisp process will write to, to be read into a Vim buffer
let g:lisp_output="/tmp/lisp-output"
"" HyperSpec local path
let g:lisp_hyper="/usr/share/doc/HyperSpec"
"" Flag indicating whether autocompletion should use lower case
"" Setting this to 0 will convert to upper case instead
let g:lisp_complete_lower=1

" {{{1 Mappings

"" The prefix to use for Lisp files mappings
let maplocalleader=','

nmap <buffer> <LocalLeader>x :silent call <SID>LispEvalWrap("LispEvalCurrent")<CR>
nmap <buffer> <LocalLeader>t :silent call <SID>LispEvalWrap("LispEvalCurrent",1)<CR>
nmap <buffer> <LocalLeader>b :silent call <SID>LispEvalWrap("LispEvalBuffer")<CR>
nmap <buffer> <LocalLeader>p :silent call LispPrint("")<Left><Left>

" {{{1 Internal variables

"" Relative path of the symbol map file in the HyperSpec doc
let s:hyper_map="Data/Map_Sym.txt"
"" Regexp used to match the boundaries of a symbol from the CL package
let s:reg_bounds='(\|\s\|`\|'''

" {{{1 REPL interface

" Check if the cursor is in a comment or string
func! s:CommentOrString()
    return match(synIDattr(synID(line('.'), col('.'), 1), "name"), '\ccomment\|\cstring')>=0 
endfunc

" Send a string to the lisp REPL listening on g:lisp_input
func! LispEval(expression)
    exe 'redir >> '.g:lisp_input
    echon a:expression."\n"
    redir END
endfunc

" Save the @a register before calling the given function, making it
" available for use. The register is restored, along with the cursor
" position, on exit.
"
" @param function The string name (or funcref) representing the function
" to wrap
" @param ... additional arguments to be passed to the function
func! s:LispEvalWrap(function,...)
    let origPos = getpos('.')
    let origReg = @a

    try
        call call(a:function,a:000)
    finally
        call setpos('.', origPos)
        let @a = origReg
    endtry
endfunc

" Evaluate the expression the cursor is currently in.
"
" @param ... an optional non-zero argument results in the top-most
" expression being evaluated instead of the inner one.
func! LispEvalCurrent(...)
    let flags = a:0 && a:1 ? 'rb' : 'b'

    "" Select text to be evaluated into @a
    call searchpair('(','',')', flags, 's:CommentOrString()')
    call searchpair('(','',')', 's', 's:CommentOrString()')
    """ y% doesn't work since it doesn't ignore comments/strings
    normal "ay`'

    """ Append missing )
    call LispEval(@a.")")
endfunc

" Evaluate the whole buffer.
func! LispEvalBuffer()
    normal gg"ayG
    call LispEval(@a)
endfunc

" Print the value of a lisp variable in the REPL.
func! LispPrint(var)
    call LispEval("(print ".a:var.")")
endfunc

" {{{1 Omnifunc

setl omnifunc=LispComplete

" Auto-completion using the HyperSpec thesaurus
func! LispComplete(findstart, base)
    if a:findstart
        if !s:CommentOrString() && search(s:reg_bounds, 'b')
            return col('.')
        endif
        return -1
    else
        let results = []
        if strlen(a:base)
            exe 'noau silent! lvimgrep /^'.a:base.'/j '.g:lisp_hyper.'/'.s:hyper_map
            for line in getloclist(0)
                let text = g:lisp_complete_lower ? tolower(line.text) : line.text
                call add(results, text)
            endfor
        endif
        return results
    endif
endfunc

" vim:fdm=marker
