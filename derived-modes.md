Derived modes, and mode hooks
=============================

https://stackoverflow.com/a/19295380/324105

TL;DR
-----

    (run-hooks 'change-major-mode-hook) ;; actually the first thing done by
    (kill-all-local-variables)          ;; <-- this function
    ,@grandparent-body
    ,@parent-body
    ,@child-body
    (run-hooks 'change-major-mode-after-body-hook)
    (run-hooks 'grandparent-mode-hook)
    (run-hooks 'parent-mode-hook)
    (run-hooks 'child-mode-hook)
    (run-hooks 'after-change-major-mode-hook)

Details
-------

The majority of major modes are defined with the macro `define-derived-mode`.  (Of course there's nothing *stopping* you from simply writing `(defun foo-mode ...)` and doing whatever you want; but if you want to ensure that your major mode plays nicely with the rest of Emacs, you'll use the standard macros.)

When you define a derived mode, you must specify the parent mode which it derives *from*.  If the mode has no logical parent, you still use this macro to define it (in order to get all the standard benefits), and you simply specify `nil` for the parent.  Alternatively you could specify `fundamental-mode` as the parent, as the effect is much the same as for `nil`, as we shall see momentarily.

`define-derived-mode` then defines the mode function for you using a standard template, and the very first thing that happens when the mode function is called is:

    (delay-mode-hooks
      (PARENT-MODE)
      ,@body
      ...)

or if no parent is set:

    (delay-mode-hooks
      (kill-all-local-variables)
      ,@body
      ...)

As `fundamental-mode` itself calls `(kill-all-local-variables)` and then immediately returns when called in this situation, the effect of specifying it as the parent is equivalent to if the parent were `nil`.

Note that `kill-all-local-variables` runs `change-major-mode-hook` before doing anything else, so that will be the first hook which is run during this whole sequence (and it happens while the previous major mode is still active, before any of the code for the new mode has been evaluated).

So that's the first thing that happens.  The very *last* thing that the mode function does is to call `(run-mode-hooks MODE-HOOK)` for its own `MODE-HOOK` variable (this variable name is literally the mode function's symbol name with a `-hook` suffix).

So if we consider a mode named `child-mode` which is derived from `parent-mode` which is derived from `grandparent-mode`, the whole chain of events when we call `(child-mode)` looks something like this:

    (delay-mode-hooks
      (delay-mode-hooks
        (delay-mode-hooks
          (kill-all-local-variables) ;; runs change-major-mode-hook
          ,@grandparent-body)
        (run-mode-hooks 'grandparent-mode-hook)
        ,@parent-body)
      (run-mode-hooks 'parent-mode-hook)
      ,@child-body)
    (run-mode-hooks 'child-mode-hook)

What does `delay-mode-hooks` do? It simply binds the variable `delay-mode-hooks`, which is checked by `run-mode-hooks`.  When this variable is non-`nil`, `run-mode-hooks` just pushes its argument onto a list of hooks to be run at some future time, and returns immediately.

Only when `delay-mode-hooks` is `nil` will `run-mode-hooks` *actually* run the hooks.  In the above example, this is not until `(run-mode-hooks 'child-mode-hook)` is called.

For the general case of `(run-mode-hooks HOOKS)`, the following hooks run in sequence:

- `change-major-mode-after-body-hook`
- `delayed-mode-hooks` (in the sequence in which they would otherwise have run)
- `HOOKS` (being the argument to `run-mode-hooks`)
- `after-change-major-mode-hook`

So when we call `(child-mode)`, the full sequence is:

    (run-hooks 'change-major-mode-hook) ;; actually the first thing done by
    (kill-all-local-variables)          ;; <-- this function
    ,@grandparent-body
    ,@parent-body
    ,@child-body
    (run-hooks 'change-major-mode-after-body-hook)
    (run-hooks 'grandparent-mode-hook)
    (run-hooks 'parent-mode-hook)
    (run-hooks 'child-mode-hook)
    (run-hooks 'after-change-major-mode-hook)

<!-- Local Variables: -->
<!-- eval: (my-adaptive-visual-line-mode 1) -->
<!-- End: -->
