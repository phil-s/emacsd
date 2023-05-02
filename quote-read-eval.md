It's very important to understand that `'...` which means `(quote ...)`
is not a shorthand for making lists.  It's a form which causes lisp to
return, unevaluated, the object that was created by the lisp reader.

If you quote a list and then *modify* the quoted list, it stays
modified.  If you want to create a list and then modify it, create it
with `(list ...)`.

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
