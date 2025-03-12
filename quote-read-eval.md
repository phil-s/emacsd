It's very important to understand that `'...` which means `(quote ...)`
is not a shorthand for making lists.  It's a form which causes lisp to
return, unevaluated, the object that was created by the lisp reader
(at read time)(^1).

If you quote a list and then *modify* the quoted list, it stays
modified.  If you want to create a list and then modify it, create it
(at eval time) with `(list ...)`.

Be sure to go over the distinct `read` and `eval` phases of lisp
execution.  Once you understand the distinction, `quote` will make
much more sense.

    (defun foo () (list 'a 'b 'c)) => foo
    (defun bar () '(a b c)) => bar

    (foo) => (a b c)
    (bar) => (a b c)

    (delq 'b (foo)) => (a c)
    (delq 'b (bar)) => (a c)

    (foo) => (a b c)
    (bar) => (a c)

    (symbol-function 'foo) => (closure (t) nil (list 'a 'b 'c))
    (symbol-function 'bar) => (closure (t) nil '(a c))

This is self-modifying code (something you'd want to avoid in most
cases), as well as an example of the "code is data" nature of lisp.

----

(^1): More accurately `quote` simply *returns its argument*, and there
*are* other ways (such as macro expansion) in which that argument could
be established.  In the *vast* majority of cases, however, a quoted
argument is created by the lisp reader, and this (normal) scenario is
the one which is the most useful to understand in the first instance,
because it's the `read` vs `eval` distinction which is liable to cause
the most confusion for new lisp programmers when it comes to `quote`
(whereas a programmer who is writing *macros* will almost certainly
understand these things already).
