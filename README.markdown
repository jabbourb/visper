This is a (very) minimalistic plugin for Vim to make working with Lisp
easier, by sending buffer contents to a listening REPL.

Rationale
=========
I didn't like most other plugins since they seemed to implement more
features than I need right now, with bugs that I wasn't willing to try to
fix. This is still a work in progress, with features being implemented
as I need them.

Quick start guide
=================
- Drop the lisp.vim file into ~/.vim/ftplugin

- Start a lisp interpreter listening on *g:lisp_input*
  (*/tmp/lisp-input* by default); under Linux, you can use the following
  command in a terminal (with SBCL):
  
        (tail -f /tmp/lisp-input & cat -) | sbcl

  The *cat* command is not required, but will allow you to interact with
  the REPL directly from the terminal where it was launched; the
  downside is that killing the process can be somewhat tricky...

- Open a Lisp file in vim, or type

        :set ft=lisp

  for the default buffer.

- Now you can send expressions to the REPL using *,x - ,t ...* (look at
  the beginning of the plugin file to change variables and mappings)


ToDo List
=========
- Read the output of the REPL back into a Vim buffer
- Macro expansion
- Documentation lookup

