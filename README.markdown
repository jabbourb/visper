This is a (very) minimalistic plugin for Vim to make working with Lisp
easier, by sending buffer contents to a listening REPL.

**Note** This is still a work in progress, with features being
implemented as I need them.

Rationale
=========
I didn't like most other plugins since they seemed to implement more
features than I need right now, with bugs that I wasn't willing to try to
fix. In this approach, the responsibility of starting a REPL is left to
the user in an OS-dependant way, and we only take care of communicating
with a local socket.

Quick start guide
=================
- Drop the lisp.vim file into ~/.vim/ftplugin
 
- Create the file *g:lisp_input* (*/tmp/lisp-input* by default); under
  Linux, you can create a FIFO socket with:

        mkfifo /tmp/lisp-input

- In a terminal, start a lisp interpreter (here *SBCL*) reading from
  that file, for example:
  
        cat > lisp-input | cat lisp-input | sbcl

  The first *cat* command is not required, but will allow to interact
  with the REPL directly from the terminal where it was launched. The
  downside of such a command is that sending an interrupt to the REPL
  (CTRL-C) will kill the whole pipe.

- Open a Lisp file in vim, or type

        :set ft=lisp

  in the default buffer

- Now you can send expressions to the REPL using *,-,/x/...* (look at
  the beginning of the plugin file to change variables and mappings)

Features
========
- Provide an Omnifunc completion if a local copy of the HyperSpec
  database is installed
- Send expressions to the REPL

ToDo List
=========
- Read the output of the REPL back into a Vim buffer
- Macro expansion
- Documentation lookup
