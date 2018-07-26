;;; .loaddefs.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "ace-jump-mode/ace-jump-mode" "ace-jump-mode/ace-jump-mode.el"
;;;;;;  (21910 33729 668993 333000))
;;; Generated autoloads from ace-jump-mode/ace-jump-mode.el

(autoload 'ace-jump-mode-pop-mark "ace-jump-mode/ace-jump-mode" "\
Pop up a postion from `ace-jump-mode-mark-ring', and jump back to that position

\(fn)" t nil)

(autoload 'ace-jump-char-mode "ace-jump-mode/ace-jump-mode" "\
AceJump char mode

\(fn QUERY-CHAR)" t nil)

(autoload 'ace-jump-word-mode "ace-jump-mode/ace-jump-mode" "\
AceJump word mode.
You can set `ace-jump-word-mode-use-query-char' to nil to prevent
asking for a head char, that will mark all the word in current
buffer.

\(fn HEAD-CHAR)" t nil)

(autoload 'ace-jump-line-mode "ace-jump-mode/ace-jump-mode" "\
AceJump line mode.
Marked each no empty line and move there

\(fn)" t nil)

(autoload 'ace-jump-mode "ace-jump-mode/ace-jump-mode" "\
AceJump mode is a minor mode for you to quick jump to a
position in the curret view.
   There is three submode now:
     `ace-jump-char-mode'
     `ace-jump-word-mode'
     `ace-jump-line-mode'

You can specify the sequence about which mode should enter
by customize `ace-jump-mode-submode-list'.

If you do not want to query char for word mode, you can change
`ace-jump-word-mode-use-query-char' to nil.

If you don't like the default move keys, you can change it by
setting `ace-jump-mode-move-keys'.

You can constrol whether use the case sensitive via
`ace-jump-mode-case-fold'.

\(fn &optional PREFIX)" t nil)

;;;***

;;;### (autoloads nil "ace-link/ace-link" "ace-link/ace-link.el"
;;;;;;  (21910 33729 668993 333000))
;;; Generated autoloads from ace-link/ace-link.el

(autoload 'ace-link-info "ace-link/ace-link" "\
Ace jump to links in `Info-mode' buffers.

\(fn)" t nil)

(autoload 'ace-link-help "ace-link/ace-link" "\
Ace jump to links in `help-mode' buffers.

\(fn)" t nil)

(autoload 'ace-link-org "ace-link/ace-link" "\
Ace jump to links in `org-mode' buffers.

\(fn)" t nil)

(autoload 'ace-link-setup-default "ace-link/ace-link" "\
Setup the defualt shortcuts.

\(fn)" nil nil)

;;;***

;;;### (autoloads nil "async/async" "async/async.el" (0 0 0 0))
;;; Generated autoloads from async/async.el

(autoload 'async-start-process "async/async" "\
Start the executable PROGRAM asynchronously.  See `async-start'.
PROGRAM is passed PROGRAM-ARGS, calling FINISH-FUNC with the
process object when done.  If FINISH-FUNC is nil, the future
object will return the process object when the program is
finished.  Set DEFAULT-DIRECTORY to change PROGRAM's current
working directory.

\(fn NAME PROGRAM FINISH-FUNC &rest PROGRAM-ARGS)" nil nil)

(autoload 'async-start "async/async" "\
Execute START-FUNC (often a lambda) in a subordinate Emacs process.
When done, the return value is passed to FINISH-FUNC.  Example:

    (async-start
       ;; What to do in the child process
       (lambda ()
         (message \"This is a test\")
         (sleep-for 3)
         222)

       ;; What to do when it finishes
       (lambda (result)
         (message \"Async process done, result should be 222: %s\"
                  result)))

If FINISH-FUNC is nil or missing, a future is returned that can
be inspected using `async-get', blocking until the value is
ready.  Example:

    (let ((proc (async-start
                   ;; What to do in the child process
                   (lambda ()
                     (message \"This is a test\")
                     (sleep-for 3)
                     222))))

        (message \"I'm going to do some work here\") ;; ....

        (message \"Waiting on async process, result should be 222: %s\"
                 (async-get proc)))

If you don't want to use a callback, and you don't care about any
return value from the child process, pass the `ignore' symbol as
the second argument (if you don't, and never call `async-get', it
will leave *emacs* process buffers hanging around):

    (async-start
     (lambda ()
       (delete-file \"a remote file on a slow link\" nil))
     'ignore)

Note: Even when FINISH-FUNC is present, a future is still
returned except that it yields no value (since the value is
passed to FINISH-FUNC).  Call `async-get' on such a future always
returns nil.  It can still be useful, however, as an argument to
`async-ready' or `async-wait'.

\(fn START-FUNC &optional FINISH-FUNC)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "async/async" '(#("async-" 0 6 (fontified nil face font-lock-function-name-face)))))

;;;***

;;;### (autoloads nil "async/async-bytecomp" "async/async-bytecomp.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from async/async-bytecomp.el

(autoload 'async-byte-recompile-directory "async/async-bytecomp" "\
Compile all *.el files in DIRECTORY asynchronously.
All *.elc files are systematically deleted before proceeding.

\(fn DIRECTORY &optional QUIET)" nil nil)

(defvar async-bytecomp-package-mode nil "\
Non-nil if Async-Bytecomp-Package mode is enabled.
See the `async-bytecomp-package-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `async-bytecomp-package-mode'.")

(custom-autoload 'async-bytecomp-package-mode "async/async-bytecomp" nil)

(autoload 'async-bytecomp-package-mode "async/async-bytecomp" "\
Byte compile asynchronously packages installed with package.el.
Async compilation of packages can be controlled by
`async-bytecomp-allowed-packages'.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "async/async-bytecomp" '("async-byte")))

;;;***

;;;### (autoloads nil "async/async-test" "async/async-test.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from async/async-test.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "async/async-test" '("async-test-")))

;;;***

;;;### (autoloads nil "async/dired-async" "async/dired-async.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from async/dired-async.el

(defvar dired-async-mode nil "\
Non-nil if Dired-Async mode is enabled.
See the `dired-async-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `dired-async-mode'.")

(custom-autoload 'dired-async-mode "async/dired-async" nil)

(autoload 'dired-async-mode "async/dired-async" "\
Do dired actions asynchronously.

\(fn &optional ARG)" t nil)

(autoload 'dired-async-do-copy "async/dired-async" "\
Run ‘dired-do-copy’ asynchronously.

\(fn &optional ARG)" t nil)

(autoload 'dired-async-do-symlink "async/dired-async" "\
Run ‘dired-do-symlink’ asynchronously.

\(fn &optional ARG)" t nil)

(autoload 'dired-async-do-hardlink "async/dired-async" "\
Run ‘dired-do-hardlink’ asynchronously.

\(fn &optional ARG)" t nil)

(autoload 'dired-async-do-rename "async/dired-async" "\
Run ‘dired-do-rename’ asynchronously.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "async/dired-async" '("dired-async-")))

;;;***

;;;### (autoloads nil "async/smtpmail-async" "async/smtpmail-async.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from async/smtpmail-async.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "async/smtpmail-async" '("async-smtpmail-")))

;;;***

;;;### (autoloads nil "auto-compile/auto-compile" "auto-compile/auto-compile.el"
;;;;;;  (21994 50055 427326 410000))
;;; Generated autoloads from auto-compile/auto-compile.el

(autoload 'auto-compile-mode "auto-compile/auto-compile" "\
Compile Emacs Lisp source files after the visiting buffers are saved.

After a buffer containing Emacs Lisp code is saved to its source
file update the respective byte code file.  If the latter does
not exist do nothing.  Therefore to disable automatic compilation
remove the byte code file.  See command `toggle-auto-compile' for
a convenient way to do so.

This mode should be enabled globally, using it's globalized
variant `auto-compile-on-save-mode'.  Also see the related
`auto-compile-on-load-mode'.

\(fn &optional ARG)" t nil)

(defvar auto-compile-on-save-mode nil "\
Non-nil if Auto-Compile-On-Save mode is enabled.
See the command `auto-compile-on-save-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `auto-compile-on-save-mode'.")

(custom-autoload 'auto-compile-on-save-mode "auto-compile/auto-compile" nil)

(autoload 'auto-compile-on-save-mode "auto-compile/auto-compile" "\
Toggle Auto-Compile mode in all buffers.
With prefix ARG, enable Auto-Compile-On-Save mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Auto-Compile mode is enabled in all buffers where
`turn-on-auto-compile-mode' would do it.
See `auto-compile-mode' for more information on Auto-Compile mode.

\(fn &optional ARG)" t nil)

(autoload 'toggle-auto-compile "auto-compile/auto-compile" "\
Toggle automatic compilation of an Emacs Lisp source file or files.

Read a file or directory name from the minibuffer defaulting to
the visited Emacs Lisp source file or `default-directory' if no
such file is being visited in the current buffer.

If the user selects a file then automatic compilation of only
that file is toggled.  Since both `auto-compile-on-save' and
`auto-compile-on-save' only ever _recompile_ byte code files,
toggling automatic compilation is done simply by creating or
removing the respective byte code file.

If the user selects a directory then automatic compilation for
multiple files is toggled as follows:

* With a positive prefix argument always compile source files;
  with a negative prefix argument always remove byte code files.

* Otherwise the existence or absence of the byte code file of
  the source file that was current when this command was invoked
  determines whether byte code files should be created or removed.

* If no Emacs Lisp source file is being visited in the buffer
  that was current when the command was invoked ask the user what
  to do.

* When _removing_ byte code files then all byte code files are
  removed.  If `auto-compile-deletes-stray-dest' is non-nil this
  even includes byte code files for which no source file exists.

* When _creating_ byte code files only do so for source files
  that are actual libraries.  Source files that provide the
  correct feature are considered to be libraries; see
  `packed-library-p'.

* Note that non-libraries can still be automatically compiled,
  you just cannot _recursively_ turn on automatic compilation
  using this command.

* When `auto-compile-toggle-recompiles' is non-nil recompile all
  affected source files even when the respective source files are
  up-to-date.  Do so even for non-library source files.

* Only enter subdirectories for which `packed-ignore-directory-p'
  returns nil; most importantly don't enter hidden directories or
  those containing a file named \".nosearch\".

\(fn FILE ACTION)" t nil)

;;;***

;;;### (autoloads nil "avy/avy" "avy/avy.el" (23166 56511 630386
;;;;;;  914000))
;;; Generated autoloads from avy/avy.el

(autoload 'avy-goto-char "avy/avy" "\
Jump to the currently visible CHAR.
The window scope is determined by `avy-all-windows' (ARG negates it).

\(fn CHAR &optional ARG)" t nil)

(autoload 'avy-goto-char-in-line "avy/avy" "\
Jump to the currently visible CHAR in the current line.

\(fn CHAR)" t nil)

(autoload 'avy-goto-char-2 "avy/avy" "\
Jump to the currently visible CHAR1 followed by CHAR2.
The window scope is determined by `avy-all-windows'.
When ARG is non-nil, do the opposite of `avy-all-windows'.
BEG and END narrow the scope where candidates are searched.

\(fn CHAR1 CHAR2 &optional ARG BEG END)" t nil)

(autoload 'avy-goto-char-2-above "avy/avy" "\
Jump to the currently visible CHAR1 followed by CHAR2.
This is a scoped version of `avy-goto-char-2', where the scope is
the visible part of the current buffer up to point.
The window scope is determined by `avy-all-windows'.
When ARG is non-nil, do the opposite of `avy-all-windows'.

\(fn CHAR1 CHAR2 &optional ARG)" t nil)

(autoload 'avy-goto-char-2-below "avy/avy" "\
Jump to the currently visible CHAR1 followed by CHAR2.
This is a scoped version of `avy-goto-char-2', where the scope is
the visible part of the current buffer following point.
The window scope is determined by `avy-all-windows'.
When ARG is non-nil, do the opposite of `avy-all-windows'.

\(fn CHAR1 CHAR2 &optional ARG)" t nil)

(autoload 'avy-isearch "avy/avy" "\
Jump to one of the current isearch candidates.

\(fn)" t nil)

(autoload 'avy-goto-word-0 "avy/avy" "\
Jump to a word start.
The window scope is determined by `avy-all-windows'.
When ARG is non-nil, do the opposite of `avy-all-windows'.
BEG and END narrow the scope where candidates are searched.

\(fn ARG &optional BEG END)" t nil)

(autoload 'avy-goto-word-1 "avy/avy" "\
Jump to the currently visible CHAR at a word start.
The window scope is determined by `avy-all-windows'.
When ARG is non-nil, do the opposite of `avy-all-windows'.
BEG and END narrow the scope where candidates are searched.
When SYMBOL is non-nil, jump to symbol start instead of word start.

\(fn CHAR &optional ARG BEG END SYMBOL)" t nil)

(autoload 'avy-goto-word-1-above "avy/avy" "\
Jump to the currently visible CHAR at a word start.
This is a scoped version of `avy-goto-word-1', where the scope is
the visible part of the current buffer up to point.
The window scope is determined by `avy-all-windows'.
When ARG is non-nil, do the opposite of `avy-all-windows'.

\(fn CHAR &optional ARG)" t nil)

(autoload 'avy-goto-word-1-below "avy/avy" "\
Jump to the currently visible CHAR at a word start.
This is a scoped version of `avy-goto-word-1', where the scope is
the visible part of the current buffer following point.
The window scope is determined by `avy-all-windows'.
When ARG is non-nil, do the opposite of `avy-all-windows'.

\(fn CHAR &optional ARG)" t nil)

(autoload 'avy-goto-symbol-1 "avy/avy" "\
Jump to the currently visible CHAR at a symbol start.
The window scope is determined by `avy-all-windows'.
When ARG is non-nil, do the opposite of `avy-all-windows'.

\(fn CHAR &optional ARG)" t nil)

(autoload 'avy-goto-symbol-1-above "avy/avy" "\
Jump to the currently visible CHAR at a symbol start.
This is a scoped version of `avy-goto-symbol-1', where the scope is
the visible part of the current buffer up to point.
The window scope is determined by `avy-all-windows'.
When ARG is non-nil, do the opposite of `avy-all-windows'.

\(fn CHAR &optional ARG)" t nil)

(autoload 'avy-goto-symbol-1-below "avy/avy" "\
Jump to the currently visible CHAR at a symbol start.
This is a scoped version of `avy-goto-symbol-1', where the scope is
the visible part of the current buffer following point.
The window scope is determined by `avy-all-windows'.
When ARG is non-nil, do the opposite of `avy-all-windows'.

\(fn CHAR &optional ARG)" t nil)

(autoload 'avy-goto-subword-0 "avy/avy" "\
Jump to a word or subword start.

The window scope is determined by `avy-all-windows' (ARG negates it).

When PREDICATE is non-nil it's a function of zero parameters that
should return true.

\(fn &optional ARG PREDICATE)" t nil)

(autoload 'avy-goto-subword-1 "avy/avy" "\
Jump to the currently visible CHAR at a subword start.
The window scope is determined by `avy-all-windows' (ARG negates it).
The case of CHAR is ignored.

\(fn CHAR &optional ARG)" t nil)

(autoload 'avy-goto-word-or-subword-1 "avy/avy" "\
Forward to `avy-goto-subword-1' or `avy-goto-word-1'.
Which one depends on variable `subword-mode'.

\(fn)" t nil)

(autoload 'avy-goto-line "avy/avy" "\
Jump to a line start in current buffer.

When ARG is 1, jump to lines currently visible, with the option
to cancel to `goto-line' by entering a number.

When ARG is 4, negate the window scope determined by
`avy-all-windows'.

Otherwise, forward to `goto-line' with ARG.

\(fn &optional ARG)" t nil)

(autoload 'avy-goto-line-above "avy/avy" "\
Goto visible line above the cursor.

\(fn)" t nil)

(autoload 'avy-goto-line-below "avy/avy" "\
Goto visible line below the cursor.

\(fn)" t nil)

(autoload 'avy-copy-line "avy/avy" "\
Copy a selected line above the current line.
ARG lines can be used.

\(fn ARG)" t nil)

(autoload 'avy-move-line "avy/avy" "\
Move a selected line above the current line.
ARG lines can be used.

\(fn ARG)" t nil)

(autoload 'avy-copy-region "avy/avy" "\
Select two lines and copy the text between them to point.

The window scope is determined by `avy-all-windows' or
`avy-all-windows-alt' when ARG is non-nil.

\(fn ARG)" t nil)

(autoload 'avy-move-region "avy/avy" "\
Select two lines and move the text between them above the current line.

\(fn)" t nil)

(autoload 'avy-kill-region "avy/avy" "\
Select two lines and kill the region between them.

The window scope is determined by `avy-all-windows' or
`avy-all-windows-alt' when ARG is non-nil.

\(fn ARG)" t nil)

(autoload 'avy-kill-ring-save-region "avy/avy" "\
Select two lines and save the region between them to the kill ring.
The window scope is determined by `avy-all-windows'.
When ARG is non-nil, do the opposite of `avy-all-windows'.

\(fn ARG)" t nil)

(autoload 'avy-kill-whole-line "avy/avy" "\
Select line and kill the whole selected line.

With a numerical prefix ARG, kill ARG line(s) starting from the
selected line.  If ARG is negative, kill backward.

If ARG is zero, kill the selected line but exclude the trailing
newline.

\\[universal-argument] 3 \\[avy-kil-whole-line] kill three lines
starting from the selected line.  \\[universal-argument] -3

\\[avy-kill-whole-line] kill three lines backward including the
selected line.

\(fn ARG)" t nil)

(autoload 'avy-kill-ring-save-whole-line "avy/avy" "\
Select line and save the whole selected line as if killed, but don’t kill it.

This command is similar to `avy-kill-whole-line', except that it
saves the line(s) as if killed, but does not kill it(them).

With a numerical prefix ARG, kill ARG line(s) starting from the
selected line.  If ARG is negative, kill backward.

If ARG is zero, kill the selected line but exclude the trailing
newline.

\(fn ARG)" t nil)

(autoload 'avy-setup-default "avy/avy" "\
Setup the default shortcuts.

\(fn)" nil nil)

(autoload 'avy-goto-char-timer "avy/avy" "\
Read one or many consecutive chars and jump to the first one.
The window scope is determined by `avy-all-windows' (ARG negates it).

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "dash/dash" "dash/dash.el" (0 0 0 0))
;;; Generated autoloads from dash/dash.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "dash/dash" '("dash-" "-keep" "-butlast" "-non" "-only-some" "-zip" "-e" "->" "-a" "-gr" "-when-let" "-d" "-l" "-s" "-p" "-r" "-m" "-i" "-f" "-u" "-value-to-list" "-t" "--" "-c" "!cons" "!cdr")))

;;;***

;;;### (autoloads nil "dash/dash-functional" "dash/dash-functional.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from dash/dash-functional.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "dash/dash-functional" '("-rpartial" "-juxt" "-not" "-o" "-a" "-iteratefn" "-c" "-f" "-p")))

;;;***

;;;### (autoloads nil "delight/delight" "delight/delight.el" (22694
;;;;;;  39803 0 0))
;;; Generated autoloads from delight/delight.el

(autoload 'delight "delight/delight" "\
Modify the lighter value displayed in the mode line for the given mode SPEC
if and when the mode is loaded.

SPEC can be either a mode symbol, or a list containing multiple elements of
the form (MODE VALUE FILE). In the latter case the two optional arguments are
omitted, as they are instead specified for each element of the list.

For minor modes, VALUE is the replacement lighter value (or nil to disable)
to set in the `minor-mode-alist' variable. For major modes VALUE is the
replacement buffer-local `mode-name' value to use when a buffer changes to
that mode.

In both cases VALUE is commonly a string, but may in fact contain any valid
mode-line construct. For details see the `mode-line-format' variable, and
Info node `(elisp) Mode Line Format'.

The FILE argument is passed through to `eval-after-load'. If FILE is nil then
the mode symbol is passed as the required feature. If FILE is t then it is
assumed that the mode is already loaded. (Note that you can also use 'emacs
for this purpose). These FILE options are relevant to minor modes only.

For major modes you should specify the keyword :major as the value of FILE,
to prevent the mode being treated as a minor mode.

\(fn SPEC &optional VALUE FILE)" nil nil)

;;;***

;;;### (autoloads nil "diff-hl/diff-hl" "diff-hl/diff-hl.el" (22363
;;;;;;  37200 580387 5000))
;;; Generated autoloads from diff-hl/diff-hl.el

(autoload 'diff-hl-mode "diff-hl/diff-hl" "\
Toggle VC diff highlighting.

\(fn &optional ARG)" t nil)

(autoload 'turn-on-diff-hl-mode "diff-hl/diff-hl" "\
Turn on `diff-hl-mode' or `diff-hl-dir-mode' in a buffer if appropriate.

\(fn)" nil nil)

(defvar global-diff-hl-mode nil "\
Non-nil if Global-Diff-Hl mode is enabled.
See the command `global-diff-hl-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-diff-hl-mode'.")

(custom-autoload 'global-diff-hl-mode "diff-hl/diff-hl" nil)

(autoload 'global-diff-hl-mode "diff-hl/diff-hl" "\
Toggle Diff-Hl mode in all buffers.
With prefix ARG, enable Global-Diff-Hl mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Diff-Hl mode is enabled in all buffers where
`turn-on-diff-hl-mode' would do it.
See `diff-hl-mode' for more information on Diff-Hl mode.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "diff-hl/diff-hl-amend" "diff-hl/diff-hl-amend.el"
;;;;;;  (22334 17133 710064 76000))
;;; Generated autoloads from diff-hl/diff-hl-amend.el

(autoload 'diff-hl-amend-mode "diff-hl/diff-hl-amend" "\
Show changes against the second-last revision in `diff-hl-mode'.
Most useful with backends that support rewriting local commits,
and most importantly, 'amending' the most recent one.
Currently only supports Git, Mercurial and Bazaar.

\(fn &optional ARG)" t nil)

(defvar global-diff-hl-amend-mode nil "\
Non-nil if Global-Diff-Hl-Amend mode is enabled.
See the command `global-diff-hl-amend-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-diff-hl-amend-mode'.")

(custom-autoload 'global-diff-hl-amend-mode "diff-hl/diff-hl-amend" nil)

(autoload 'global-diff-hl-amend-mode "diff-hl/diff-hl-amend" "\
Toggle Diff-Hl-Amend mode in all buffers.
With prefix ARG, enable Global-Diff-Hl-Amend mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Diff-Hl-Amend mode is enabled in all buffers where
`turn-on-diff-hl-amend-mode' would do it.
See `diff-hl-amend-mode' for more information on Diff-Hl-Amend mode.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "diff-hl/diff-hl-dired" "diff-hl/diff-hl-dired.el"
;;;;;;  (22363 37200 580387 5000))
;;; Generated autoloads from diff-hl/diff-hl-dired.el

(autoload 'diff-hl-dired-mode "diff-hl/diff-hl-dired" "\
Toggle VC diff highlighting on the side of a Dired window.

\(fn &optional ARG)" t nil)

(autoload 'diff-hl-dired-mode-unless-remote "diff-hl/diff-hl-dired" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "diff-hl/diff-hl-flydiff" "diff-hl/diff-hl-flydiff.el"
;;;;;;  (22363 37513 472970 170000))
;;; Generated autoloads from diff-hl/diff-hl-flydiff.el

(defvar diff-hl-flydiff-mode nil "\
Non-nil if Diff-Hl-Flydiff mode is enabled.
See the command `diff-hl-flydiff-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `diff-hl-flydiff-mode'.")

(custom-autoload 'diff-hl-flydiff-mode "diff-hl/diff-hl-flydiff" nil)

(autoload 'diff-hl-flydiff-mode "diff-hl/diff-hl-flydiff" "\
Highlight diffs on-the-fly

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "diff-hl/diff-hl-margin" "diff-hl/diff-hl-margin.el"
;;;;;;  (22334 17133 710064 76000))
;;; Generated autoloads from diff-hl/diff-hl-margin.el

(defvar diff-hl-margin-mode nil "\
Non-nil if Diff-Hl-Margin mode is enabled.
See the command `diff-hl-margin-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `diff-hl-margin-mode'.")

(custom-autoload 'diff-hl-margin-mode "diff-hl/diff-hl-margin" nil)

(autoload 'diff-hl-margin-mode "diff-hl/diff-hl-margin" "\
Toggle displaying `diff-hl-mode' highlights on the margin.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "dtrt-indent/dtrt-indent" "dtrt-indent/dtrt-indent.el"
;;;;;;  (21910 33729 672993 239000))
;;; Generated autoloads from dtrt-indent/dtrt-indent.el

(defvar dtrt-indent-mode nil "\
Non-nil if Dtrt-Indent mode is enabled.
See the command `dtrt-indent-mode' for a description of this minor mode.")

(custom-autoload 'dtrt-indent-mode "dtrt-indent/dtrt-indent" nil)

(autoload 'dtrt-indent-mode "dtrt-indent/dtrt-indent" "\
Toggle dtrt-indent mode.
With no argument, this command toggles the mode.  Non-null prefix
argument turns on the mode.  Null prefix argument turns off the
mode.

When dtrt-indent mode is enabled, the proper indentation
offset will be guessed for newly opened files and adjusted
transparently.

\(fn &optional ARG)" t nil)

(defvar dtrt-indent-mode nil "\
Toggle adaptive indentation mode.
Setting this variable directly does not take effect;
use either \\[customize] or the function `dtrt-indent-mode'.")

(custom-autoload 'dtrt-indent-mode "dtrt-indent/dtrt-indent" nil)

;;;***

;;;### (autoloads nil "ediff-trees/ediff-trees" "ediff-trees/ediff-trees.el"
;;;;;;  (21910 33729 672993 239000))
;;; Generated autoloads from ediff-trees/ediff-trees.el

(autoload 'ediff-trees "ediff-trees/ediff-trees" "\
Starts a new ediff session that recursively compares two
trees.

\(fn ROOT1 ROOT2)" t nil)

;;;***

;;;### (autoloads nil "elisp-slime-nav/elisp-slime-nav" "elisp-slime-nav/elisp-slime-nav.el"
;;;;;;  (21982 28935 500003 796000))
;;; Generated autoloads from elisp-slime-nav/elisp-slime-nav.el

(autoload 'elisp-slime-nav-mode "elisp-slime-nav/elisp-slime-nav" "\
Enable Slime-style navigation of elisp symbols using M-. and M-,

\(fn &optional ARG)" t nil)

(autoload 'turn-on-elisp-slime-nav-mode "elisp-slime-nav/elisp-slime-nav" "\
Explicitly enable `elisp-slime-nav-mode'.

\(fn)" nil nil)

(autoload 'elisp-slime-nav-find-elisp-thing-at-point "elisp-slime-nav/elisp-slime-nav" "\
Find the elisp thing at point, be it a function, variable, library or face.

With a prefix arg, or if there is no thing at point, prompt for
the symbol to jump to.

Argument SYM-NAME is the thing to find.

\(fn SYM-NAME)" t nil)

(autoload 'elisp-slime-nav-describe-elisp-thing-at-point "elisp-slime-nav/elisp-slime-nav" "\
Display the full documentation of the elisp thing at point.

The named subject may be a function, variable, library or face.

With a prefix arg, or if there is not \"thing\" at point, prompt
for the symbol to jump to.

Argument SYM-NAME is the thing to find.

\(fn SYM-NAME)" t nil)

;;;***

;;;### (autoloads nil "fic-mode/fic-mode" "fic-mode/fic-mode.el"
;;;;;;  (22068 11712 302870 623000))
;;; Generated autoloads from fic-mode/fic-mode.el

(autoload 'fic-mode "fic-mode/fic-mode" "\
Fic mode -- minor mode for highlighting FIXME/TODO in comments

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "find-file-in-tags/find-file-in-tags" "find-file-in-tags/find-file-in-tags.el"
;;;;;;  (21910 33729 724992 21000))
;;; Generated autoloads from find-file-in-tags/find-file-in-tags.el

(autoload 'ffit-determine-dir-for-current-file "find-file-in-tags/find-file-in-tags" "\
Return a directory to use as the base directory for a TAGS file, or nil if it couldn't be determined.
Basically, look at the path to the tags file (one level above TAGS, see if it matches that of the current file,
and if so, then use that directory.  Added the additional constraint that there must be a TAGS file in the
directory returned, i.e. if the directory calculated does not have a TAGS file, do not return it as a possibility.

This is to help minimize the number of TAGS files loaded by Emacs, b/c in general you're working on one software project
and the TAGS files for each of the sandboxes are about the same.  So just use one TAGS file, but find the files in
the appropriate sandbox.

\(fn)" nil nil)

(autoload 'find-file-in-tags "find-file-in-tags/find-file-in-tags" "\
find file, but completion just works on files found in TAGS
unless a prefix argument is given, only allows one file to be specified
with prefix argument, all files matching what was typed will be loaded.

\(fn FILE &optional PRE)" t nil)

;;;***

;;;### (autoloads nil "font-lock-studio/font-lock-studio" "font-lock-studio/font-lock-studio.el"
;;;;;;  (22017 17772 293350 25000))
;;; Generated autoloads from font-lock-studio/font-lock-studio.el

(autoload 'font-lock-studio "font-lock-studio/font-lock-studio" "\
Interactively debug the font-lock keywords of the current buffer.

With \\[universal-argument] prefix, create a new, unique, interface buffer.

\(fn &optional ARG)" t nil)

(autoload 'font-lock-studio-region "font-lock-studio/font-lock-studio" "\
Interactively debug the font-lock keywords in the region.

With \\[universal-argument] prefix, create a new, unique, interface buffer.

\(fn BEG END &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "deft/deft" "deft/deft.el" (21910 33729 672993
;;;;;;  239000))
;;; Generated autoloads from deft/deft.el

(autoload 'deft "deft/deft" "\
Switch to *Deft* buffer and load files.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "ediff-binary-hexl/ediff-binary-hexl" "ediff-binary-hexl/ediff-binary-hexl.el"
;;;;;;  (21910 33729 672993 239000))
;;; Generated autoloads from ediff-binary-hexl/ediff-binary-hexl.el

(defadvice ediff-files-internal (around ediff-files-internal-for-binary-files activate) "\
Catch the condition when the binary files differ.

The reason for catching the error out here (when re-thrown from
the inner advice) is to let the stack continue to unwind before
we start the new diff otherwise some code in the middle of the
stack expects some output that isn't there and triggers an error." (let ((file-A (ad-get-arg 0)) (file-B (ad-get-arg 1)) ediff-do-hexl-diff) (condition-case err (progn ad-do-it) (error (if ediff-do-hexl-diff (let ((buf-A (find-file-noselect file-A)) (buf-B (find-file-noselect file-B))) (with-current-buffer buf-A (hexl-mode 1)) (with-current-buffer buf-B (hexl-mode 1)) (ediff-buffers buf-A buf-B)) (error (error-message-string err)))))))

(defadvice ediff-setup-diff-regions (around ediff-setup-diff-regions-for-binary-files activate) "\
When binary files differ, set the trigger variable." (condition-case err (progn ad-do-it) (error (setq ediff-do-hexl-diff (and (string-match-p "^Errors in diff output.  Diff output is in.*" (error-message-string err)) (string-match-p "^\\(Binary \\)?[fF]iles .* and .* differ" (buffer-substring-no-properties (line-beginning-position) (line-end-position))) (y-or-n-p "The binary files differ, look at the differences in hexl-mode? "))) (error (error-message-string err)))))

;;;***

;;;### (autoloads nil "ffip/find-file-in-project" "ffip/find-file-in-project.el"
;;;;;;  (22799 12870 899275 791000))
;;; Generated autoloads from ffip/find-file-in-project.el

(autoload 'ffip-diff-backend-git-show-commit "ffip/find-file-in-project" "\


\(fn)" nil nil)

(autoload 'ffip-diff-backend-hg-show-commit "ffip/find-file-in-project" "\


\(fn)" nil nil)

(autoload 'ffip-copy-without-change "ffip/find-file-in-project" "\


\(fn P)" nil nil)

(autoload 'ffip-copy-reactjs-import "ffip/find-file-in-project" "\


\(fn P)" nil nil)

(autoload 'ffip-copy-org-file-link "ffip/find-file-in-project" "\


\(fn P)" nil nil)

(defvar ffip-find-relative-path-callback 'ffip-copy-without-change)

(autoload 'ffip-project-root "ffip/find-file-in-project" "\
Return the root of the project.

\(fn)" nil nil)

(autoload 'ffip-save-ivy-last "ffip/find-file-in-project" "\
Save `ivy-last' into `ffip-ivy-last-saved'.  Requires `ivy-mode'.

\(fn)" t nil)

(autoload 'ffip-get-project-root-directory "ffip/find-file-in-project" "\
Get the full path of project root directory.

\(fn)" nil nil)

(autoload 'ffip-ivy-resume "ffip/find-file-in-project" "\
Wrapper of `ivy-resume'.  Resume the search saved at `ffip-ivy-last-saved'.

\(fn)" t nil)

(autoload 'ffip-filename-identity "ffip/find-file-in-project" "\
Return identical KEYWORD.

\(fn KEYWORD)" nil nil)

(autoload 'ffip-filename-camelcase-to-dashes "ffip/find-file-in-project" "\
Convert KEYWORD from camel cased to dash seperated.
If CHECK-ONLY is true, only do the check.

\(fn KEYWORD &optional CHECK-ONLY)" nil nil)

(autoload 'ffip-filename-dashes-to-camelcase "ffip/find-file-in-project" "\
Convert KEYWORD from dash seperated to camel cased.
If CHECK-ONLY is true, only do the check.

\(fn KEYWORD &optional CHECK-ONLY)" nil nil)

(autoload 'ffip-completing-read "ffip/find-file-in-project" "\


\(fn PROMPT COLLECTION ACTION)" nil nil)

(autoload 'ffip-project-search "ffip/find-file-in-project" "\
Return an alist of all filenames in the project and their path.

Files with duplicate filenames are suffixed with the name of the
directory they are found in so that they are unique.

If KEYWORD is string, it's the file name or file path to find file.
If KEYWORD is list, it's the list of file names.

\(fn KEYWORD FIND-DIRECTORY)" nil nil)

(autoload 'ffip-find-files "ffip/find-file-in-project" "\
The API to find files.

\(fn KEYWORD OPEN-ANOTHER-WINDOW &optional FIND-DIRECTORY FN)" nil nil)

(autoload 'ffip-create-project-file "ffip/find-file-in-project" "\
Create or Append .dir-locals.el to set up per directory.
You can move .dir-locals.el to root directory.
See (info \"(Emacs) Directory Variables\") for details.

\(fn)" t nil)

(autoload 'ffip-current-full-filename-match-pattern-p "ffip/find-file-in-project" "\
Is current full file name (including directory) match the REGEX?

\(fn REGEX)" nil nil)

(autoload 'find-file-in-project "ffip/find-file-in-project" "\
Prompt with a completing list of all files in the project to find one.

If OPEN-ANOTHER-WINDOW is not nil, the file will be opened in new window.

The project's scope is defined as the first directory containing
a `ffip-project-file' whose value is \".git\" by default.

You can override this by setting the variable `ffip-project-root'.

\(fn &optional OPEN-ANOTHER-WINDOW)" t nil)

(autoload 'find-file-in-current-directory "ffip/find-file-in-project" "\
Like `find-file-in-project'.  But search only in current directory.

\(fn &optional OPEN-ANOTHER-WINDOW)" t nil)

(autoload 'find-file-in-project-by-selected "ffip/find-file-in-project" "\
Similar to `find-file-in-project'.
But use string from selected region to search files in the project.
If no region is selected, you need provide keyword.

Keyword could be ANY part of the file's full path and support wildcard.
For example, to find /home/john/proj1/test.js, below keywords are valid:
- test.js
- roj1/tes
- john*test

If keyword contains line number like \"hello.txt:32\" or \"hello.txt:32:\",
we will move to that line in opened file.

If OPEN-ANOTHER-WINDOW is not nil, the file will be opened in new window.

\(fn &optional OPEN-ANOTHER-WINDOW)" t nil)

(autoload 'find-file-in-current-directory-by-selected "ffip/find-file-in-project" "\
Like `find-file-in-project-by-selected'.  But search only in current directory.

\(fn &optional OPEN-ANOTHER-WINDOW)" t nil)

(autoload 'find-relative-path "ffip/find-file-in-project" "\
Find file/directory and copy its relative path into `kill-ring'.
Optional prefix FIND-DIRECTORY copy the directory path; file path by default.

You can set `ffip-find-relative-path-callback' to format the string before copying,
  (setq ffip-find-relative-path-callback 'ffip-copy-reactjs-import)
  (setq ffip-find-relative-path-callback 'ffip-copy-org-file-link)

\(fn &optional FIND-DIRECTORY)" t nil)

(autoload 'find-directory-in-project-by-selected "ffip/find-file-in-project" "\
Similar to `find-file-in-project-by-selected'.
Use string from selected region to find directory in the project.
If no region is selected, you need provide keyword.

Keyword could be directory's base-name only or parent-directoy+base-name
For example, to find /home/john/proj1/test, below keywords are valid:
- test
- roj1/test
- john*test

If OPEN-ANOTHER-WINDOW is not nil, the file will be opened in new window.

\(fn &optional OPEN-ANOTHER-WINDOW)" t nil)

(defalias 'ffip 'find-file-in-project)

(autoload 'ffip-diff-quit "ffip/find-file-in-project" "\


\(fn)" t nil)

(autoload 'ffip-diff-find-file "ffip/find-file-in-project" "\
File file(s) in current hunk.

\(fn &optional OPEN-ANOTHER-WINDOW)" t nil)

(autoload 'ffip-show-diff "ffip/find-file-in-project" "\
Show the diff output by excuting selected `ffip-diff-backends'.
NUM is the index selected backend from `ffip-diff-backends'.
NUM is zero based whose default value is zero.

\(fn &optional NUM)" t nil)

(put 'ffip-limit 'safe-local-variable 'integerp)

;;;***

;;;### (autoloads nil "geben/dbgp" "geben/dbgp.el" (0 0 0 0))
;;; Generated autoloads from geben/dbgp.el

(autoload 'dbgp-start "geben/dbgp" "\
Start a new DBGp listener listening to PORT.

\(fn HOST PORT)" t nil)

(autoload 'dbgp-exec "geben/dbgp" "\
Start a new DBGp listener listening to PORT.
Set the process up with SESSION-PARAMS.

\(fn HOST PORT &rest SESSION-PARAMS)" nil nil)

(autoload 'dbgp-proxy-register "geben/dbgp" "\
Register a new DBGp listener to an external DBGp proxy.
The proxy should be found at PROXY-IP-OR-ADDR / PROXY-PORT.
This creates a new DBGp listener and register it to the proxy
associating with the IDEKEY.
MULTI-SESSION-P indicates if multiple sessions are running or not.
SESSION-PORT is either the integer port number, or t.

\(fn PROXY-IP-OR-ADDR PROXY-PORT IDEKEY MULTI-SESSION-P &optional SESSION-PORT)" t nil)

(autoload 'dbgp-proxy-register-exec "geben/dbgp" "\
Register a new DBGp listener to an external DBGp proxy.
The proxy should be found at IP-OR-ADDR / PORT.
This create a new DBGp listener and register it to the proxy
associating with the IDEKEY.
MULTI-SESSION-P indicates if multiple sessions are running or not.
SESSION-PORT is either the integer port number, or t.
SESSION-PARAMS are added to the listener process.

\(fn IP-OR-ADDR PORT IDEKEY MULTI-SESSION-P SESSION-PORT &rest SESSION-PARAMS)" nil nil)

(autoload 'dbgp-proxy-unregister "geben/dbgp" "\
Unregister the DBGp listener associated with IDEKEY from a DBGp proxy.
After unregistration, it kills the listener instance.
PROXY-IP-OR-ADDR is the ip or host address of the proxy instance.
PROXY-PORT is the port number.

\(fn IDEKEY &optional PROXY-IP-OR-ADDR PROXY-PORT)" t nil)

(autoload 'dbgp-proxy-unregister-exec "geben/dbgp" "\
Unregister PROXY from a DBGp proxy.
After unregistration, it kills the listener instance.

\(fn PROXY)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "geben/dbgp" '("dbgp-")))

;;;***

;;;### (autoloads nil "geben/geben" "geben/geben.el" (0 0 0 0))
;;; Generated autoloads from geben/geben.el

(autoload 'geben-mode "geben/geben" "\
Minor mode for debugging source code with GEBEN.
The geben-mode buffer commands:
\\{geben-mode-map}

\(fn &optional ARG)" t nil)

(autoload 'geben-add-current-line-to-predefined-breakpoints "geben/geben" "\
Add the current line to the predefined breakpoints.

\(fn)" t nil)

(autoload 'geben "geben/geben" "\
Start GEBEN, a DBGp protocol frontend - a script debugger.
Variations are described below.

By default, starts GEBEN listening to port `geben-dbgp-default-port'.
Prefixed with one \\[universal-argument], asks listening port number interactively and
starts GEBEN on the port.
Prefixed with two \\[universal-argument]'s, starts a GEBEN proxy listener.
Prefixed with three \\[universal-argument]'s, kills a GEBEN listener.
Prefixed with four \\[universal-argument]'s, kills a GEBEN proxy listener.

GEBEN communicates with script servers, located anywhere local or
remote, in DBGp protocol (e.g. PHP with Xdebug extension)
to help you debugging your script with some valuable features:
 - continuation commands like `step in', `step out', ...
 - a kind of breakpoints like `line no', `function call' and
   `function return'.
 - evaluation
 - stack dump
 - etc.

The script servers should be DBGp protocol enabled.
Ask to your script server administrator about this setting up
issue.

Once you've done these setup operation correctly, run GEBEN first
and your script on your script server second. After some
negotiation GEBEN will display your script's entry source code.
The debugging session is started.

In the debugging session the source code buffers are under the
minor mode  `geben-mode'. Key mapping and other information is
described its help page.

\(fn &optional ARGS)" t nil)

(defvar geben-full-frame-mode nil "\
Non-nil if Geben-Full-Frame mode is enabled.
See the `geben-full-frame-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `geben-full-frame-mode'.")

(custom-autoload 'geben-full-frame-mode "geben/geben" nil)

(autoload 'geben-full-frame-mode "geben/geben" "\


\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "geben/geben" '("geben-")))

;;;***

;;;### (autoloads nil "ghub/ghub" "ghub/ghub.el" (0 0 0 0))
;;; Generated autoloads from ghub/ghub.el

(autoload 'ghub-create-token "ghub/ghub" "\
Create, store and return a new token.

HOST is the Github instance, usually \"api.github.com\".
USERNAME is the name of a user on that instance.
PACKAGE is the package that will use the token.
SCOPES are the scopes the token is given access to.

\(fn HOST USERNAME PACKAGE SCOPES)" t nil)

(autoload 'ghub-token-scopes "ghub/ghub" "\
Return and echo the scopes of the specified token.
This is intended for debugging purposes only.  The user
has to provide several values including their password.

\(fn HOST USERNAME PACKAGE)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ghub/ghub" '("auth-source-netrc-parse-next-interesting@save-match-data" "ghub-")))

;;;***

;;;### (autoloads nil "ghub/glab" "ghub/glab.el" (0 0 0 0))
;;; Generated autoloads from ghub/glab.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ghub/glab" '("glab-default-host")))

;;;***

;;;### (autoloads nil "git-modes/gitattributes-mode" "git-modes/gitattributes-mode.el"
;;;;;;  (22970 32184 513265 17000))
;;; Generated autoloads from git-modes/gitattributes-mode.el

(autoload 'gitattributes-mode "git-modes/gitattributes-mode" "\
A major mode for editing .gitattributes files.
\\{gitattributes-mode-map}

\(fn)" t nil)

(dolist (pattern '("/\\.gitattributes\\'" "/info/attributes\\'" "/git/attributes\\'")) (add-to-list 'auto-mode-alist (cons pattern #'gitattributes-mode)))

;;;***

;;;### (autoloads nil "git-modes/gitconfig-mode" "git-modes/gitconfig-mode.el"
;;;;;;  (22970 32184 517265 17000))
;;; Generated autoloads from git-modes/gitconfig-mode.el

(autoload 'gitconfig-mode "git-modes/gitconfig-mode" "\
A major mode for editing .gitconfig files.

\(fn)" t nil)

(dolist (pattern '("/\\.gitconfig\\'" "/\\.git/config\\'" "/modules/.*/config\\'" "/git/config\\'" "/\\.gitmodules\\'" "/etc/gitconfig\\'")) (add-to-list 'auto-mode-alist (cons pattern 'gitconfig-mode)))

;;;***

;;;### (autoloads nil "git-modes/gitignore-mode" "git-modes/gitignore-mode.el"
;;;;;;  (22970 32184 517265 17000))
;;; Generated autoloads from git-modes/gitignore-mode.el

(autoload 'gitignore-mode "git-modes/gitignore-mode" "\
A major mode for editing .gitignore files.

\(fn)" t nil)

(dolist (pattern (list "/\\.gitignore\\'" "/info/exclude\\'" "/git/ignore\\'")) (add-to-list 'auto-mode-alist (cons pattern 'gitignore-mode)))

;;;***

;;;### (autoloads nil "ibuffer-vc/ibuffer-vc" "ibuffer-vc/ibuffer-vc.el"
;;;;;;  (22126 49213 625871 603000))
;;; Generated autoloads from ibuffer-vc/ibuffer-vc.el

(autoload 'ibuffer-vc-generate-filter-groups-by-vc-root "ibuffer-vc/ibuffer-vc" "\
Create a set of ibuffer filter groups based on the vc root dirs of buffers.

\(fn)" nil nil)

(autoload 'ibuffer-vc-set-filter-groups-by-vc-root "ibuffer-vc/ibuffer-vc" "\
Set the current filter groups to filter by vc root dir.

\(fn)" t nil)
 (autoload 'ibuffer-make-column-vc-status "ibuffer-vc")
 (autoload 'ibuffer-make-column-vc-status-mini "ibuffer-vc")
 (autoload 'ibuffer-do-sort-by-vc-status "ibuffer-vc")

;;;***

;;;### (autoloads nil "idle-highlight-mode/idle-highlight-mode" "idle-highlight-mode/idle-highlight-mode.el"
;;;;;;  (22363 37200 580387 5000))
;;; Generated autoloads from idle-highlight-mode/idle-highlight-mode.el

(autoload 'idle-highlight-mode "idle-highlight-mode/idle-highlight-mode" "\
Idle-Highlight Minor Mode

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "iedit/iedit" "iedit/iedit.el" (22294 61345
;;;;;;  6841 74000))
;;; Generated autoloads from iedit/iedit.el

(autoload 'iedit-mode "iedit/iedit" "\
Toggle iedit mode.
If iedit mode is off, turn iedit mode on, off otherwise.

In Transient Mark mode, when iedit mode is turned on, all the
occurrences of the current region are highlighted. If one
occurrence is modified, the change are propagated to all other
occurrences simultaneously.

If Transient Mark mode is disabled or the region is not active,
the `current-word' is used as occurrence. All the occurrences of
the `current-word' are highlighted.

You can also switch to iedit mode from isearch mode directly. The
current search string is used as occurrence.  All occurrences of
the current search string are highlighted.

With a prefix argument, the occurrence when iedit is turned off
last time is used as occurrence.  This is intended to recover
last iedit which is turned off by mistake.

Commands:
\\{iedit-mode-map}

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "image-dimensions-minor-mode/image-dimensions-minor-mode"
;;;;;;  "image-dimensions-minor-mode/image-dimensions-minor-mode.el"
;;;;;;  (21910 33729 728991 928000))
;;; Generated autoloads from image-dimensions-minor-mode/image-dimensions-minor-mode.el

(autoload 'image-dimensions-minor-mode "image-dimensions-minor-mode/image-dimensions-minor-mode" "\
Displays the image dimensions in the mode line.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "jump-char/jump-char" "jump-char/jump-char.el"
;;;;;;  (21910 33729 732991 835000))
;;; Generated autoloads from jump-char/jump-char.el

(autoload 'jump-char-forward "jump-char/jump-char" "\
With UNIVERSAL prefix arg <C-u>, invoke `ace-jump-line-mode'


; next

, previous

search_char next

press current binding for `jump-char-forward' / `jump-char-backward' to reuse
last input.

\(fn ARG &optional BACKWARD)" t nil)

(autoload 'jump-char-backward "jump-char/jump-char" "\
backward movement version of `jump-char-forward'

\(fn ARG)" t nil)

;;;***

;;;### (autoloads nil "lexbind-mode/lexbind-mode" "lexbind-mode/lexbind-mode.el"
;;;;;;  (21910 33729 732991 835000))
;;; Generated autoloads from lexbind-mode/lexbind-mode.el

(autoload 'lexbind-toggle-lexical-binding "lexbind-mode/lexbind-mode" "\
Toggle the variable `lexical-binding' on and off.  Interactive.
When called with a numeric argument, set `lexical-binding' to t
if the argument is positive, nil otherwise.
Optional argument ARG if nil toggles `lexical-binding', positive
enables it, non-positive disables it.

\(fn &optional ARG)" t nil)

(autoload 'lexbind-lexscratch "lexbind-mode/lexbind-mode" "\
Make a lexical scratch buffer.

\(fn &optional OTHER-WINDOW)" t nil)

(autoload 'lexbind-modeline-content "lexbind-mode/lexbind-mode" "\
Generate mode line content to indicate the value of `lexical-binding'.
Optional argument ARGS if provided, the first argument is taken as the value
of `lexical-binding'.

\(fn &rest ARGS)" nil nil)

(autoload 'lexbind-mode "lexbind-mode/lexbind-mode" "\
Toggle Lexbind mode.
Interactively with no argument, this command toggles the mode.
A positive prefix argument enables the mode, any other prefix
argument disables it.  From Lisp, argument omitted or nil enables
the mode, `toggle' toggles the state.

When lexbind mode is enabled, the mode line of a window will
contain the string (LEX) for lexical binding, (DYN) for dynamic
binding, to indicate the state of the lexical-binding variable in
that buffer.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "key-chord/key-chord" "key-chord/key-chord.el"
;;;;;;  (21910 33729 732991 835000))
;;; Generated autoloads from key-chord/key-chord.el

(autoload 'key-chord-mode "key-chord/key-chord" "\
Toggle key chord mode.
With positive ARG enable the mode. With zero or negative arg disable the mode.
A key chord is two keys that are pressed simultaneously, or one key quickly
pressed twice.
See functions `key-chord-define-global' or `key-chord-define'
and variables `key-chord-two-keys-delay' and `key-chord-one-key-delay'.

\(fn ARG)" t nil)

(autoload 'key-chord-define-global "key-chord/key-chord" "\
Define a key-chord of two keys in KEYS starting a COMMAND.

KEYS can be a string or a vector of two elements. Currently only elements
that corresponds to ascii codes in the range 32 to 126 can be used.

COMMAND can be an interactive function, a string, or nil.
If COMMAND is nil, the key-chord is removed.

\(fn KEYS COMMAND)" t nil)

(autoload 'key-chord-define "key-chord/key-chord" "\
Define in KEYMAP, a key-chord of two keys in KEYS starting a COMMAND.

KEYS can be a string or a vector of two elements. Currently only elements
that corresponds to ascii codes in the range 32 to 126 can be used.

COMMAND can be an interactive function, a string, or nil.
If COMMAND is nil, the key-chord is removed.

\(fn KEYMAP KEYS COMMAND)" nil nil)

;;;***

;;;### (autoloads nil "macrostep/macrostep" "macrostep/macrostep.el"
;;;;;;  (21994 50055 439326 120000))
;;; Generated autoloads from macrostep/macrostep.el

(autoload 'macrostep-mode "macrostep/macrostep" "\
Minor mode for inline expansion of macros in Emacs Lisp source buffers.

\\<macrostep-keymap>Progressively expand macro forms with \\[macrostep-expand], collapse them with \\[macrostep-collapse],
and move back and forth with \\[macrostep-next-macro] and \\[macrostep-prev-macro].
Use \\[macrostep-collapse-all] or collapse all visible expansions to
quit and return to normal editing.

\\{macrostep-keymap}

\(fn &optional ARG)" t nil)

(autoload 'macrostep-expand "macrostep/macrostep" "\
Expand the Elisp macro form following point by one step.

Enters `macrostep-mode' if it is not already active, making the
buffer temporarily read-only. If macrostep-mode is active and the
form following point is not a macro form, search forward in the
buffer and expand the next macro form found, if any.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "magit/lisp/magit-autorevert" "magit/lisp/magit-autorevert.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-autorevert.el

(defvar magit-revert-buffers t)

(defvar magit-auto-revert-mode (and (with-no-warnings magit-revert-buffers) (not global-auto-revert-mode) (not noninteractive)) "\
Non-nil if Magit-Auto-Revert mode is enabled.
See the `magit-auto-revert-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `magit-auto-revert-mode'.")

(custom-autoload 'magit-auto-revert-mode "magit/lisp/magit-autorevert" nil)

(autoload 'magit-auto-revert-mode "magit/lisp/magit-autorevert" "\
Toggle Auto-Revert mode in all buffers.
With prefix ARG, enable Magit-Auto-Revert mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Auto-Revert mode is enabled in all buffers where
`magit-turn-on-auto-revert-mode-if-desired' would do it.
See `auto-revert-mode' for more information on Auto-Revert mode.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-autorevert" '("auto-revert-buffer" "magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-bookmark" "magit/lisp/magit-bookmark.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-bookmark.el

(autoload 'magit-bookmark--status-jump "magit/lisp/magit-bookmark" "\
Handle a Magit status BOOKMARK.

\(fn BOOKMARK)" nil nil)

(autoload 'magit-bookmark--status-make-record "magit/lisp/magit-bookmark" "\
Create a Magit status bookmark.

\(fn)" nil nil)

(autoload 'magit-bookmark--refs-jump "magit/lisp/magit-bookmark" "\
Handle a Magit refs BOOKMARK.

\(fn BOOKMARK)" nil nil)

(autoload 'magit-bookmark--refs-make-record "magit/lisp/magit-bookmark" "\
Create a Magit refs bookmark.

\(fn)" nil nil)

(autoload 'magit-bookmark--log-jump "magit/lisp/magit-bookmark" "\
Handle a Magit log BOOKMARK.

\(fn BOOKMARK)" nil nil)

(autoload 'magit-bookmark--log-make-record "magit/lisp/magit-bookmark" "\
Create a Magit log bookmark.

\(fn)" nil nil)

(autoload 'magit-bookmark--reflog-jump "magit/lisp/magit-bookmark" "\
Handle a Magit reflog BOOKMARK.

\(fn BOOKMARK)" nil nil)

(autoload 'magit-bookmark--reflog-make-record "magit/lisp/magit-bookmark" "\
Create a Magit reflog bookmark.

\(fn)" nil nil)

(autoload 'magit-bookmark--stashes-jump "magit/lisp/magit-bookmark" "\
Handle a Magit stash list BOOKMARK.

\(fn BOOKMARK)" nil nil)

(autoload 'magit-bookmark--stashes-make-record "magit/lisp/magit-bookmark" "\
Create a Magit stash list bookmark.

\(fn)" nil nil)

(autoload 'magit-bookmark--cherry-jump "magit/lisp/magit-bookmark" "\
Handle a Magit cherry BOOKMARK.

\(fn BOOKMARK)" nil nil)

(autoload 'magit-bookmark--cherry-make-record "magit/lisp/magit-bookmark" "\
Create a Magit cherry bookmark.

\(fn)" nil nil)

(autoload 'magit-bookmark--diff-jump "magit/lisp/magit-bookmark" "\
Handle a Magit diff BOOKMARK.

\(fn BOOKMARK)" nil nil)

(autoload 'magit-bookmark--diff-make-record "magit/lisp/magit-bookmark" "\
Create a Magit diff bookmark.

\(fn)" nil nil)

(autoload 'magit-bookmark--revision-jump "magit/lisp/magit-bookmark" "\
Handle a Magit revision BOOKMARK.

\(fn BOOKMARK)" nil nil)

(autoload 'magit-bookmark--revision-make-record "magit/lisp/magit-bookmark" "\
Create a Magit revision bookmark.

\(fn)" nil nil)

(autoload 'magit-bookmark--stash-jump "magit/lisp/magit-bookmark" "\
Handle a Magit stash BOOKMARK.

\(fn BOOKMARK)" nil nil)

(autoload 'magit-bookmark--stash-make-record "magit/lisp/magit-bookmark" "\
Create a Magit stash bookmark.

\(fn)" nil nil)

(autoload 'magit-bookmark--submodules-jump "magit/lisp/magit-bookmark" "\
Handle a Magit submodule list BOOKMARK.

\(fn BOOKMARK)" nil nil)

(autoload 'magit-bookmark--submodules-make-record "magit/lisp/magit-bookmark" "\
Create a Magit submodule list bookmark.

\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-bookmark" '("magit-bookmark--")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-branch" "magit/lisp/magit-branch.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-branch.el
 (autoload 'magit-branch-popup "magit" nil t)

(autoload 'magit-checkout "magit/lisp/magit-branch" "\
Checkout REVISION, updating the index and the working tree.
If REVISION is a local branch, then that becomes the current
branch.  If it is something else, then `HEAD' becomes detached.
Checkout fails if the working tree or the staging area contain
changes.

\(git checkout REVISION).

\(fn REVISION)" t nil)

(autoload 'magit-branch "magit/lisp/magit-branch" "\
Create BRANCH at branch or revision START-POINT.

\(git branch [ARGS] BRANCH START-POINT).

\(fn BRANCH START-POINT &optional ARGS)" t nil)

(autoload 'magit-branch-and-checkout "magit/lisp/magit-branch" "\
Create and checkout BRANCH at branch or revision START-POINT.

\(git checkout [ARGS] -b BRANCH START-POINT).

\(fn BRANCH START-POINT &optional ARGS)" t nil)

(autoload 'magit-branch-or-checkout "magit/lisp/magit-branch" "\
Hybrid between `magit-checkout' and `magit-branch-and-checkout'.

Ask the user for an existing branch or revision.  If the user
input actually can be resolved as a branch or revision, then
check that out, just like `magit-checkout' would.

Otherwise create and checkout a new branch using the input as
its name.  Before doing so read the starting-point for the new
branch.  This is similar to what `magit-branch-and-checkout'
does.

\(fn ARG &optional START-POINT)" t nil)

(autoload 'magit-branch-checkout "magit/lisp/magit-branch" "\
Checkout an existing or new local branch.

Read a branch name from the user offering all local branches and
a subset of remote branches as candidates.  Omit remote branches
for which a local branch by the same name exists from the list
of candidates.  The user can also enter a completely new branch
name.

- If the user selects an existing local branch, then check that
  out.

- If the user selects a remote branch, then create and checkout
  a new local branch with the same name.  Configure the selected
  remote branch as push target.

- If the user enters a new branch name, then create and check
  that out, after also reading the starting-point from the user.

In the latter two cases the upstream is also set.  Whether it is
set to the chosen START-POINT or something else depends on the
value of `magit-branch-adjust-remote-upstream-alist', just like
when using `magit-branch-and-checkout'.

\(fn BRANCH &optional START-POINT)" t nil)

(autoload 'magit-branch-orphan "magit/lisp/magit-branch" "\
Create and checkout an orphan BRANCH with contents from revision START-POINT.

\(git checkout --orphan [ARGS] BRANCH START-POINT).

\(fn BRANCH START-POINT &optional ARGS)" t nil)

(autoload 'magit-branch-pull-request "magit/lisp/magit-branch" "\
Create and configure a new branch from a pull-request.
Please see the manual for more information.

\(fn PR)" t nil)

(autoload 'magit-branch-spinoff "magit/lisp/magit-branch" "\
Create new branch from the unpushed commits.

Create and checkout a new branch starting at and tracking the
current branch.  That branch in turn is reset to the last commit
it shares with its upstream.  If the current branch has no
upstream or no unpushed commits, then the new branch is created
anyway and the previously current branch is not touched.

This is useful to create a feature branch after work has already
began on the old branch (likely but not necessarily \"master\").

If the current branch is a member of the value of option
`magit-branch-prefer-remote-upstream' (which see), then the
current branch will be used as the starting point as usual, but
the upstream of the starting-point may be used as the upstream
of the new branch, instead of the starting-point itself.

If optional FROM is non-nil, then the source branch is reset
to `FROM~', instead of to the last commit it shares with its
upstream.  Interactively, FROM is only ever non-nil, if the
region selects some commits, and among those commits, FROM is
the commit that is the fewest commits ahead of the source
branch.

The commit at the other end of the selection actually does not
matter, all commits between FROM and `HEAD' are moved to the new
branch.  If FROM is not reachable from `HEAD' or is reachable
from the source branch's upstream, then an error is raised.

\(fn BRANCH &optional FROM &rest ARGS)" t nil)

(autoload 'magit-branch-reset "magit/lisp/magit-branch" "\
Reset a branch to the tip of another branch or any other commit.

When the branch being reset is the current branch, then do a
hard reset.  If there are any uncommitted changes, then the user
has to confirm the reset because those changes would be lost.

This is useful when you have started work on a feature branch but
realize it's all crap and want to start over.

When resetting to another branch and a prefix argument is used,
then also set the target branch as the upstream of the branch
that is being reset.

\(fn BRANCH TO &optional ARGS SET-UPSTREAM)" t nil)

(autoload 'magit-branch-delete "magit/lisp/magit-branch" "\
Delete one or multiple branches.
If the region marks multiple branches, then offer to delete
those, otherwise prompt for a single branch to be deleted,
defaulting to the branch at point.

\(fn BRANCHES &optional FORCE)" t nil)

(autoload 'magit-branch-rename "magit/lisp/magit-branch" "\
Rename the branch named OLD to NEW.

With a prefix argument FORCE, rename even if a branch named NEW
already exists.

If `branch.OLD.pushRemote' is set, then unset it.  Depending on
the value of `magit-branch-rename-push-target' (which see) maybe
set `branch.NEW.pushRemote' and maybe rename the push-target on
the remote.

\(fn OLD NEW &optional FORCE)" t nil)

(autoload 'magit-branch-shelve "magit/lisp/magit-branch" "\
Shelve a BRANCH.
Rename \"refs/heads/BRANCH\" to \"refs/shelved/BRANCH\",
and also rename the respective reflog file.

\(fn BRANCH)" t nil)

(autoload 'magit-branch-unshelve "magit/lisp/magit-branch" "\
Unshelve a BRANCH
Rename \"refs/shelved/BRANCH\" to \"refs/heads/BRANCH\",
and also rename the respective reflog file.

\(fn BRANCH)" t nil)

(autoload 'magit-branch-config-popup "magit/lisp/magit-branch" "\
Popup console for setting branch variables.

\(fn BRANCH)" t nil)

(autoload 'magit-edit-branch*description "magit/lisp/magit-branch" "\
Edit the description of the current branch.
With a prefix argument edit the description of another branch.

The description for the branch named NAME is stored in the Git
variable `branch.<name>.description'.

\(fn BRANCH)" t nil)

(autoload 'magit-set-branch*merge/remote "magit/lisp/magit-branch" "\
Set or unset the upstream of the current branch.
With a prefix argument do so for another branch.

When the branch in question already has an upstream then simply
unsets it.  Invoke this command again to set another upstream.

Together the Git variables `branch.<name>.remote' and
`branch.<name>.merge' define the upstream branch of the local
branch named NAME.  The value of `branch.<name>.remote' is the
name of the upstream remote.  The value of `branch.<name>.merge'
is the full reference of the upstream branch, on the remote.

Non-interactively, when UPSTREAM is non-nil, then always set it
as the new upstream, regardless of whether another upstream was
already set.  When nil, then always unset.

\(fn BRANCH UPSTREAM)" t nil)

(autoload 'magit-cycle-branch*rebase "magit/lisp/magit-branch" "\
Cycle the value of `branch.<name>.rebase' for the current branch.
With a prefix argument cycle the value for another branch.

The Git variables `branch.<name>.rebase' controls whether pulling
into the branch named NAME is done by rebasing that branch onto
the fetched branch or by merging that branch.

When `true' then pulling is done by rebasing.
When `false' then pulling is done by merging.

When that variable is undefined then the value of `pull.rebase'
is used instead.  It defaults to `false'.

\(fn BRANCH)" t nil)

(autoload 'magit-cycle-branch*pushRemote "magit/lisp/magit-branch" "\
Cycle the value of `branch.<name>.pushRemote' for the current branch.
With a prefix argument cycle the value for another branch.

The Git variable `branch.<name>.pushRemote' specifies the remote
that the branch named NAME is usually pushed to.  The value has
to be the name of an existing remote.

If that variable is undefined, then the value of the Git variable
`remote.pushDefault' is used instead, provided that it is defined,
which by default it is not.

\(fn BRANCH)" t nil)

(autoload 'magit-cycle-pull\.rebase "magit/lisp/magit-branch" "\
Cycle the repository-local value of `pull.rebase'.

The Git variable `pull.rebase' specifies whether pulling is done
by rebasing or by merging.  It can be overwritten using the Git
variable `branch.<name>.rebase'.

When `true' then pulling is done by rebasing.
When `false' (the default) then pulling is done by merging.

\(fn)" t nil)

(autoload 'magit-cycle-remote\.pushDefault "magit/lisp/magit-branch" "\
Cycle the repository-local value of `remote.pushDefault'.

The Git variable `remote.pushDefault' specifies the remote that
local branches are usually pushed to.  It can be overwritten
using the Git variable `branch.<name>.pushRemote'.

\(fn)" t nil)

(autoload 'magit-cycle-branch*autoSetupMerge "magit/lisp/magit-branch" "\
Cycle the repository-local value of `branch.autoSetupMerge'.

The Git variable `branch.autoSetupMerge' under what circumstances
creating a branch (named NAME) should result in the variables
`branch.<name>.merge' and `branch.<name>.remote' being set
according to the starting point used to create the branch.  If
the starting point isn't a branch, then these variables are never
set.

When `always' then the variables are set regardless of whether
the starting point is a local or a remote branch.

When `true' (the default) then the variable are set when the
starting point is a remote branch, but not when it is a local
branch.

When `false' then the variables are never set.

\(fn)" t nil)

(autoload 'magit-cycle-branch*autoSetupRebase "magit/lisp/magit-branch" "\
Cycle the repository-local value of `branch.autoSetupRebase'.

The Git variable `branch.autoSetupRebase' specifies whether
creating a branch (named NAME) should result in the variable
`branch.<name>.rebase' being set to `true'.

When `always' then the variable is set regardless of whether the
starting point is a local or a remote branch.

When `local' then the variable are set when the starting point
is a local branch, but not when it is a remote branch.

When `remote' then the variable are set when the starting point
is a remote branch, but not when it is a local branch.

When `never' (the default) then the variable is never set.

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-branch" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-collab" "magit/lisp/magit-collab.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-collab.el

(autoload 'magit-browse-pull-request "magit/lisp/magit-collab" "\
Visit pull-request PR using `browse-url'.

Currently this only supports Github, but that restriction will
be lifted eventually to support other Git forges.

\(fn PR)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-collab" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-files" "magit/lisp/magit-files.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-files.el

(autoload 'magit-find-file "magit/lisp/magit-files" "\
View FILE from REV.
Switch to a buffer visiting blob REV:FILE,
creating one if none already exists.

\(fn REV FILE)" t nil)

(autoload 'magit-find-file-other-window "magit/lisp/magit-files" "\
View FILE from REV, in another window.
Like `magit-find-file', but create a new window or reuse an
existing one.

\(fn REV FILE)" t nil)
 (autoload 'magit-file-popup "magit" nil t)

(defvar global-magit-file-mode t "\
Non-nil if Global Magit-File mode is enabled.
See the `global-magit-file-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-magit-file-mode'.")

(custom-autoload 'global-magit-file-mode "magit/lisp/magit-files" nil)

(autoload 'global-magit-file-mode "magit/lisp/magit-files" "\
Toggle Magit-File mode in all buffers.
With prefix ARG, enable Global Magit-File mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Magit-File mode is enabled in all buffers where
`magit-file-mode-turn-on' would do it.
See `magit-file-mode' for more information on Magit-File mode.

\(fn &optional ARG)" t nil)

(autoload 'magit-file-checkout "magit/lisp/magit-files" "\
Checkout FILE from REV.

\(fn REV FILE)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-files" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-git" "magit/lisp/magit-git.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-git.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-git" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-imenu" "magit/lisp/magit-imenu.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-imenu.el

(autoload 'magit-imenu--log-prev-index-position-function "magit/lisp/magit-imenu" "\
Move point to previous line in current buffer.
This function is used as a value for
`imenu-prev-index-position-function'.

\(fn)" nil nil)

(autoload 'magit-imenu--log-extract-index-name-function "magit/lisp/magit-imenu" "\
Return imenu name for line at point.
This function is used as a value for
`imenu-extract-index-name-function'.  Point should be at the
beginning of the line.

\(fn)" nil nil)

(autoload 'magit-imenu--diff-prev-index-position-function "magit/lisp/magit-imenu" "\
Move point to previous file line in current buffer.
This function is used as a value for
`imenu-prev-index-position-function'.

\(fn)" nil nil)

(autoload 'magit-imenu--diff-extract-index-name-function "magit/lisp/magit-imenu" "\
Return imenu name for line at point.
This function is used as a value for
`imenu-extract-index-name-function'.  Point should be at the
beginning of the line.

\(fn)" nil nil)

(autoload 'magit-imenu--status-create-index-function "magit/lisp/magit-imenu" "\
Return an alist of all imenu entries in current buffer.
This function is used as a value for
`imenu-create-index-function'.

\(fn)" nil nil)

(autoload 'magit-imenu--refs-create-index-function "magit/lisp/magit-imenu" "\
Return an alist of all imenu entries in current buffer.
This function is used as a value for
`imenu-create-index-function'.

\(fn)" nil nil)

(autoload 'magit-imenu--cherry-create-index-function "magit/lisp/magit-imenu" "\
Return an alist of all imenu entries in current buffer.
This function is used as a value for
`imenu-create-index-function'.

\(fn)" nil nil)

(autoload 'magit-imenu--submodule-prev-index-position-function "magit/lisp/magit-imenu" "\
Move point to previous line in magit-submodule-list buffer.
This function is used as a value for
`imenu-prev-index-position-function'.

\(fn)" nil nil)

(autoload 'magit-imenu--submodule-extract-index-name-function "magit/lisp/magit-imenu" "\
Return imenu name for line at point.
This function is used as a value for
`imenu-extract-index-name-function'.  Point should be at the
beginning of the line.

\(fn)" nil nil)

(autoload 'magit-imenu--repolist-prev-index-position-function "magit/lisp/magit-imenu" "\
Move point to previous line in magit-repolist buffer.
This function is used as a value for
`imenu-prev-index-position-function'.

\(fn)" nil nil)

(autoload 'magit-imenu--repolist-extract-index-name-function "magit/lisp/magit-imenu" "\
Return imenu name for line at point.
This function is used as a value for
`imenu-extract-index-name-function'.  Point should be at the
beginning of the line.

\(fn)" nil nil)

(autoload 'magit-imenu--process-prev-index-position-function "magit/lisp/magit-imenu" "\
Move point to previous process in magit-process buffer.
This function is used as a value for
`imenu-prev-index-position-function'.

\(fn)" nil nil)

(autoload 'magit-imenu--process-extract-index-name-function "magit/lisp/magit-imenu" "\
Return imenu name for line at point.
This function is used as a value for
`imenu-extract-index-name-function'.  Point should be at the
beginning of the line.

\(fn)" nil nil)

(autoload 'magit-imenu--rebase-prev-index-position-function "magit/lisp/magit-imenu" "\
Move point to previous commit in git-rebase buffer.
This function is used as a value for
`imenu-prev-index-position-function'.

\(fn)" nil nil)

(autoload 'magit-imenu--rebase-extract-index-name-function "magit/lisp/magit-imenu" "\
Return imenu name for line at point.
This function is used as a value for
`imenu-extract-index-name-function'.  Point should be at the
beginning of the line.

\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-imenu" '("magit-imenu--index-function")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-margin" "magit/lisp/magit-margin.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-margin.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-margin" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-merge" "magit/lisp/magit-merge.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-merge.el
 (autoload 'magit-merge-popup "magit" nil t)

(autoload 'magit-merge "magit/lisp/magit-merge" "\
Merge commit REV into the current branch; using default message.

Unless there are conflicts or a prefix argument is used create a
merge commit using a generic commit message and without letting
the user inspect the result.  With a prefix argument pretend the
merge failed to give the user the opportunity to inspect the
merge.

\(git merge --no-edit|--no-commit [ARGS] REV)

\(fn REV &optional ARGS NOCOMMIT)" t nil)

(autoload 'magit-merge-editmsg "magit/lisp/magit-merge" "\
Merge commit REV into the current branch; and edit message.
Perform the merge and prepare a commit message but let the user
edit it.

\(git merge --edit --no-ff [ARGS] REV)

\(fn REV &optional ARGS)" t nil)

(autoload 'magit-merge-nocommit "magit/lisp/magit-merge" "\
Merge commit REV into the current branch; pretending it failed.
Pretend the merge failed to give the user the opportunity to
inspect the merge and change the commit message.

\(git merge --no-commit --no-ff [ARGS] REV)

\(fn REV &optional ARGS)" t nil)

(autoload 'magit-merge-into "magit/lisp/magit-merge" "\
Merge the current branch into BRANCH and remove the former.

Before merging, force push the source branch to its push-remote,
provided the respective remote branch already exists, ensuring
that the respective pull-request (if any) won't get stuck on some
obsolete version of the commits that are being merged.  Finally
if `magit-branch-pull-request' was used to create the merged
branch, then also remove the respective remote branch.

\(fn BRANCH &optional ARGS)" t nil)

(autoload 'magit-merge-absorb "magit/lisp/magit-merge" "\
Merge BRANCH into the current branch and remove the former.

Before merging, force push the source branch to its push-remote,
provided the respective remote branch already exists, ensuring
that the respective pull-request (if any) won't get stuck on some
obsolete version of the commits that are being merged.  Finally
if `magit-branch-pull-request' was used to create the merged
branch, then also remove the respective remote branch.

\(fn BRANCH &optional ARGS)" t nil)

(autoload 'magit-merge-squash "magit/lisp/magit-merge" "\
Squash commit REV into the current branch; don't create a commit.

\(git merge --squash REV)

\(fn REV)" t nil)

(autoload 'magit-merge-preview "magit/lisp/magit-merge" "\
Preview result of merging REV into the current branch.

\(fn REV)" t nil)

(autoload 'magit-merge-abort "magit/lisp/magit-merge" "\
Abort the current merge operation.

\(git merge --abort)

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-merge" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-mode" "magit/lisp/magit-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-mode.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-mode" '("magit-" "disable-magit-save-buffers" "inhibit-magit-refresh")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-notes" "magit/lisp/magit-notes.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-notes.el
 (autoload 'magit-notes-popup "magit" nil t)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-notes" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-process" "magit/lisp/magit-process.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-process.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-process" '("magit-" "tramp-sh-handle-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-refs" "magit/lisp/magit-refs.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-refs.el

(autoload 'magit-show-refs-popup "magit/lisp/magit-refs" "\
Popup console for `magit-show-refs'.

\(fn &optional ARG)" t nil)

(autoload 'magit-show-refs-head "magit/lisp/magit-refs" "\
List and compare references in a dedicated buffer.
Refs are compared with `HEAD'.

\(fn &optional ARGS)" t nil)

(autoload 'magit-show-refs-current "magit/lisp/magit-refs" "\
List and compare references in a dedicated buffer.
Refs are compared with the current branch or `HEAD' if
it is detached.

\(fn &optional ARGS)" t nil)

(autoload 'magit-show-refs "magit/lisp/magit-refs" "\
List and compare references in a dedicated buffer.
Refs are compared with a branch read from the user.

\(fn &optional REF ARGS)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-refs" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-repos" "magit/lisp/magit-repos.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-repos.el

(autoload 'magit-list-repositories "magit/lisp/magit-repos" "\
Display a list of repositories.

Use the options `magit-repository-directories'
and `magit-repository-directories-depth' to
control which repositories are displayed.

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-repos" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-reset" "magit/lisp/magit-reset.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-reset.el
 (autoload 'magit-reset-popup "magit" nil t)

(autoload 'magit-reset-index "magit/lisp/magit-reset" "\
Reset the index to COMMIT.
Keep the head and working tree as-is, so if COMMIT refers to the
head this effectively unstages all changes.

\(git reset COMMIT .)

\(fn COMMIT)" t nil)

(autoload 'magit-reset "magit/lisp/magit-reset" "\
Reset the head and index to COMMIT, but not the working tree.
With a prefix argument also reset the working tree.

\(git reset --mixed|--hard COMMIT)

\(fn COMMIT &optional HARD)" t nil)

(autoload 'magit-reset-head "magit/lisp/magit-reset" "\
Reset the head and index to COMMIT, but not the working tree.

\(git reset --mixed COMMIT)

\(fn COMMIT)" t nil)

(autoload 'magit-reset-soft "magit/lisp/magit-reset" "\
Reset the head to COMMIT, but not the index and working tree.

\(git reset --soft REVISION)

\(fn COMMIT)" t nil)

(autoload 'magit-reset-hard "magit/lisp/magit-reset" "\
Reset the head, index, and working tree to COMMIT.

\(git reset --hard REVISION)

\(fn COMMIT)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-reset" '("magit-reset-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-section" "magit/lisp/magit-section.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-section.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-section" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-status" "magit/lisp/magit-status.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-status.el

(autoload 'magit-init "magit/lisp/magit-status" "\
Initialize a Git repository, then show its status.

If the directory is below an existing repository, then the user
has to confirm that a new one should be created inside.  If the
directory is the root of the existing repository, then the user
has to confirm that it should be reinitialized.

Non-interactively DIRECTORY is (re-)initialized unconditionally.

\(fn DIRECTORY)" t nil)

(autoload 'magit-status "magit/lisp/magit-status" "\
Show the status of the current Git repository in a buffer.
With a prefix argument prompt for a repository to be shown.
With two prefix arguments prompt for an arbitrary directory.
If that directory isn't the root of an existing repository,
then offer to initialize it as a new repository.

\(fn &optional DIRECTORY CACHE)" t nil)

(autoload 'magit-status-internal "magit/lisp/magit-status" "\


\(fn DIRECTORY)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-status" '("magit")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-submodule" "magit/lisp/magit-submodule.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-submodule.el
 (autoload 'magit-submodule-popup "magit-submodule" nil t)

(autoload 'magit-submodule-add "magit/lisp/magit-submodule" "\
Add the repository at URL as a module.

Optional PATH is the path to the module relative to the root of
the superproject.  If it is nil, then the path is determined
based on the URL.  Optional NAME is the name of the module.  If
it is nil, then PATH also becomes the name.

\(fn URL &optional PATH NAME ARGS)" t nil)

(autoload 'magit-submodule-read-name-for-path "magit/lisp/magit-submodule" "\


\(fn PATH &optional PREFER-SHORT)" nil nil)

(autoload 'magit-submodule-register "magit/lisp/magit-submodule" "\
Register MODULES.

With a prefix argument act on all suitable modules.  Otherwise,
if the region selects modules, then act on those.  Otherwise, if
there is a module at point, then act on that.  Otherwise read a
single module from the user.

\(fn MODULES)" t nil)

(autoload 'magit-submodule-populate "magit/lisp/magit-submodule" "\
Create MODULES working directories, checking out the recorded commits.

With a prefix argument act on all suitable modules.  Otherwise,
if the region selects modules, then act on those.  Otherwise, if
there is a module at point, then act on that.  Otherwise read a
single module from the user.

\(fn MODULES)" t nil)

(autoload 'magit-submodule-update "magit/lisp/magit-submodule" "\
Update MODULES by checking out the recorded commits.

With a prefix argument act on all suitable modules.  Otherwise,
if the region selects modules, then act on those.  Otherwise, if
there is a module at point, then act on that.  Otherwise read a
single module from the user.

\(fn MODULES ARGS)" t nil)

(autoload 'magit-submodule-synchronize "magit/lisp/magit-submodule" "\
Synchronize url configuration of MODULES.

With a prefix argument act on all suitable modules.  Otherwise,
if the region selects modules, then act on those.  Otherwise, if
there is a module at point, then act on that.  Otherwise read a
single module from the user.

\(fn MODULES ARGS)" t nil)

(autoload 'magit-submodule-unpopulate "magit/lisp/magit-submodule" "\
Remove working directories of MODULES.

With a prefix argument act on all suitable modules.  Otherwise,
if the region selects modules, then act on those.  Otherwise, if
there is a module at point, then act on that.  Otherwise read a
single module from the user.

\(fn MODULES ARGS)" t nil)

(autoload 'magit-insert-modules "magit/lisp/magit-submodule" "\
Insert submodule sections.
Hook `magit-module-sections-hook' controls which module sections
are inserted, and option `magit-module-sections-nested' controls
whether they are wrapped in an additional section.

\(fn)" nil nil)

(autoload 'magit-insert-modules-overview "magit/lisp/magit-submodule" "\
Insert sections for all modules.
For each section insert the path and the output of `git describe --tags',
or, failing that, the abbreviated HEAD commit hash.

\(fn)" nil nil)

(autoload 'magit-insert-modules-unpulled-from-upstream "magit/lisp/magit-submodule" "\
Insert sections for modules that haven't been pulled from the upstream.
These sections can be expanded to show the respective commits.

\(fn)" nil nil)

(autoload 'magit-insert-modules-unpulled-from-pushremote "magit/lisp/magit-submodule" "\
Insert sections for modules that haven't been pulled from the push-remote.
These sections can be expanded to show the respective commits.

\(fn)" nil nil)

(autoload 'magit-insert-modules-unpushed-to-upstream "magit/lisp/magit-submodule" "\
Insert sections for modules that haven't been pushed to the upstream.
These sections can be expanded to show the respective commits.

\(fn)" nil nil)

(autoload 'magit-insert-modules-unpushed-to-pushremote "magit/lisp/magit-submodule" "\
Insert sections for modules that haven't been pushed to the push-remote.
These sections can be expanded to show the respective commits.

\(fn)" nil nil)

(autoload 'magit-list-submodules "magit/lisp/magit-submodule" "\
Display a list of the current repository's submodules.

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-submodule" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-subtree" "magit/lisp/magit-subtree.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-subtree.el
 (autoload 'magit-subtree-popup "magit-subtree" nil t)

(autoload 'magit-subtree-add "magit/lisp/magit-subtree" "\
Add REF from REPOSITORY as a new subtree at PREFIX.

\(fn PREFIX REPOSITORY REF ARGS)" t nil)

(autoload 'magit-subtree-add-commit "magit/lisp/magit-subtree" "\
Add COMMIT as a new subtree at PREFIX.

\(fn PREFIX COMMIT ARGS)" t nil)

(autoload 'magit-subtree-merge "magit/lisp/magit-subtree" "\
Merge COMMIT into the PREFIX subtree.

\(fn PREFIX COMMIT ARGS)" t nil)

(autoload 'magit-subtree-pull "magit/lisp/magit-subtree" "\
Pull REF from REPOSITORY into the PREFIX subtree.

\(fn PREFIX REPOSITORY REF ARGS)" t nil)

(autoload 'magit-subtree-push "magit/lisp/magit-subtree" "\
Extract the history of the subtree PREFIX and push it to REF on REPOSITORY.

\(fn PREFIX REPOSITORY REF ARGS)" t nil)

(autoload 'magit-subtree-split "magit/lisp/magit-subtree" "\
Extract the history of the subtree PREFIX.

\(fn PREFIX COMMIT ARGS)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-subtree" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-tag" "magit/lisp/magit-tag.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-tag.el
 (autoload 'magit-tag-popup "magit" nil t)

(autoload 'magit-tag "magit/lisp/magit-tag" "\
Create a new tag with the given NAME at REV.
With a prefix argument annotate the tag.

\(git tag [--annotate] NAME REV)

\(fn NAME REV &optional ARGS)" t nil)

(autoload 'magit-tag-delete "magit/lisp/magit-tag" "\
Delete one or more tags.
If the region marks multiple tags (and nothing else), then offer
to delete those, otherwise prompt for a single tag to be deleted,
defaulting to the tag at point.

\(git tag -d TAGS)

\(fn TAGS)" t nil)

(autoload 'magit-tag-prune "magit/lisp/magit-tag" "\
Offer to delete tags missing locally from REMOTE, and vice versa.

\(fn TAGS REMOTE-TAGS REMOTE)" t nil)

(autoload 'magit-tag-release "magit/lisp/magit-tag" "\
Create an opinionated release tag.

Assume version tags that match \"\\\\`v?[0-9]\\\\(\\\\.[0-9]\\\\)*\\\\'\".
Prompt for the name of the new tag using the highest existing tag
as initial input and call \"git tag --annotate --sign -m MSG\" TAG,
regardless of whether these arguments are enabled in the popup.
Given a TAG \"v1.2.3\" and a repository \"/path/to/foo-bar\", the
MESSAGE would be \"Foo-Bar 1.2.3\".

Because it is so opinionated, this command is not available from
the tag popup by default.

\(fn TAG)" t nil)

;;;***

;;;### (autoloads nil "magit/lisp/magit-utils" "magit/lisp/magit-utils.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-utils.el

(autoload 'magit-emacs-Q-command "magit/lisp/magit-utils" "\
Show a shell command that runs an uncustomized Emacs with only Magit loaded.
See info node `(magit)Debugging Tools' for more information.

\(fn)" t nil)

(autoload 'Info-follow-nearest-node--magit-gitman "magit/lisp/magit-utils" "\


\(fn FN &optional FORK)" nil nil)

(advice-add 'Info-follow-nearest-node :around 'Info-follow-nearest-node--magit-gitman)

(autoload 'org-man-export--magit-gitman "magit/lisp/magit-utils" "\


\(fn FN LINK DESCRIPTION FORMAT)" nil nil)

(advice-add 'org-man-export :around 'org-man-export--magit-gitman)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-utils" '("magit-" "whitespace-dont-turn-on-in-magit-mode")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-worktree" "magit/lisp/magit-worktree.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-worktree.el
 (autoload 'magit-worktree-popup "magit-worktree" nil t)

(autoload 'magit-worktree-checkout "magit/lisp/magit-worktree" "\
Checkout BRANCH in a new worktree at PATH.

\(fn PATH BRANCH)" t nil)

(autoload 'magit-worktree-branch "magit/lisp/magit-worktree" "\
Create a new BRANCH and check it out in a new worktree at PATH.

\(fn PATH BRANCH START-POINT &optional FORCE)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-worktree" '("magit-")))

;;;***

;;;### (autoloads nil "multiple-cursors/mc-edit-lines" "multiple-cursors/mc-edit-lines.el"
;;;;;;  (22727 57909 202748 801000))
;;; Generated autoloads from multiple-cursors/mc-edit-lines.el

(autoload 'mc/edit-lines "multiple-cursors/mc-edit-lines" "\
Add one cursor to each line of the active region.
Starts from mark and moves in straight down or up towards the
line point is on.

\(fn)" t nil)

(autoload 'mc/edit-ends-of-lines "multiple-cursors/mc-edit-lines" "\
Add one cursor to the end of each line in the active region.

\(fn)" t nil)

(autoload 'mc/edit-beginnings-of-lines "multiple-cursors/mc-edit-lines" "\
Add one cursor to the beginning of each line in the active region.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "multiple-cursors/mc-mark-more" "multiple-cursors/mc-mark-more.el"
;;;;;;  (22727 57910 706710 921000))
;;; Generated autoloads from multiple-cursors/mc-mark-more.el

(autoload 'mc/mark-next-like-this "multiple-cursors/mc-mark-more" "\
Find and mark the next part of the buffer matching the currently active region
With negative ARG, delete the last one instead.
With zero ARG, skip the last one and mark next.

\(fn ARG)" t nil)

(autoload 'mc/mark-next-word-like-this "multiple-cursors/mc-mark-more" "\


\(fn ARG)" t nil)

(autoload 'mc/mark-next-symbol-like-this "multiple-cursors/mc-mark-more" "\


\(fn ARG)" t nil)

(autoload 'mc/mark-previous-like-this "multiple-cursors/mc-mark-more" "\
Find and mark the previous part of the buffer matching the currently active region
With negative ARG, delete the last one instead.
With zero ARG, skip the last one and mark next.

\(fn ARG)" t nil)

(autoload 'mc/mark-previous-word-like-this "multiple-cursors/mc-mark-more" "\


\(fn ARG)" t nil)

(autoload 'mc/mark-previous-symbol-like-this "multiple-cursors/mc-mark-more" "\


\(fn ARG)" t nil)

(autoload 'mc/mark-next-lines "multiple-cursors/mc-mark-more" "\


\(fn ARG)" t nil)

(autoload 'mc/mark-previous-lines "multiple-cursors/mc-mark-more" "\


\(fn ARG)" t nil)

(autoload 'mc/unmark-next-like-this "multiple-cursors/mc-mark-more" "\
Deselect next part of the buffer matching the currently active region.

\(fn)" t nil)

(autoload 'mc/unmark-previous-like-this "multiple-cursors/mc-mark-more" "\
Deselect prev part of the buffer matching the currently active region.

\(fn)" t nil)

(autoload 'mc/skip-to-next-like-this "multiple-cursors/mc-mark-more" "\
Skip the current one and select the next part of the buffer matching the currently active region.

\(fn)" t nil)

(autoload 'mc/skip-to-previous-like-this "multiple-cursors/mc-mark-more" "\
Skip the current one and select the prev part of the buffer matching the currently active region.

\(fn)" t nil)

(autoload 'mc/mark-all-like-this "multiple-cursors/mc-mark-more" "\
Find and mark all the parts of the buffer matching the currently active region

\(fn)" t nil)

(autoload 'mc/mark-all-words-like-this "multiple-cursors/mc-mark-more" "\


\(fn)" t nil)

(autoload 'mc/mark-all-symbols-like-this "multiple-cursors/mc-mark-more" "\


\(fn)" t nil)

(autoload 'mc/mark-all-in-region "multiple-cursors/mc-mark-more" "\
Find and mark all the parts in the region matching the given search

\(fn BEG END)" t nil)

(autoload 'mc/mark-more-like-this-extended "multiple-cursors/mc-mark-more" "\
Like mark-more-like-this, but then lets you adjust with arrows key.
The adjustments work like this:

   <up>    Mark previous like this and set direction to 'up
   <down>  Mark next like this and set direction to 'down

If direction is 'up:

   <left>  Skip past the cursor furthest up
   <right> Remove the cursor furthest up

If direction is 'down:

   <left>  Remove the cursor furthest down
   <right> Skip past the cursor furthest down

The bindings for these commands can be changed. See `mc/mark-more-like-this-extended-keymap'.

\(fn)" t nil)

(autoload 'mc/mark-all-like-this-dwim "multiple-cursors/mc-mark-more" "\
Tries to guess what you want to mark all of.
Can be pressed multiple times to increase selection.

With prefix, it behaves the same as original `mc/mark-all-like-this'

\(fn ARG)" t nil)

(autoload 'mc/mark-all-like-this-in-defun "multiple-cursors/mc-mark-more" "\
Mark all like this in defun.

\(fn)" t nil)

(autoload 'mc/mark-all-words-like-this-in-defun "multiple-cursors/mc-mark-more" "\
Mark all words like this in defun.

\(fn)" t nil)

(autoload 'mc/mark-all-symbols-like-this-in-defun "multiple-cursors/mc-mark-more" "\
Mark all symbols like this in defun.

\(fn)" t nil)

(autoload 'mc/add-cursor-on-click "multiple-cursors/mc-mark-more" "\
Add a cursor where you click.

\(fn EVENT)" t nil)

(autoload 'mc/mark-sgml-tag-pair "multiple-cursors/mc-mark-more" "\
Mark the tag we're in and its pair for renaming.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "multiple-cursors/rectangular-region-mode"
;;;;;;  "multiple-cursors/rectangular-region-mode.el" (22799 12870
;;;;;;  527284 769000))
;;; Generated autoloads from multiple-cursors/rectangular-region-mode.el

(autoload 'set-rectangular-region-anchor "multiple-cursors/rectangular-region-mode" "\
Anchors the rectangular region at point.

Think of this one as `set-mark' except you're marking a rectangular region. It is
an exceedingly quick way of adding multiple cursors to multiple lines.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "php-eldoc/php-eldoc" "php-eldoc/php-eldoc.el"
;;;;;;  (21910 33729 740991 646000))
;;; Generated autoloads from php-eldoc/php-eldoc.el

(autoload 'php-eldoc-function "php-eldoc/php-eldoc" "\
Get function arguments for PHP function at point.

\(fn)" nil nil)

(add-hook 'php+-mode-hook '(lambda nil (set (make-local-variable 'eldoc-documentation-function) 'php-eldoc-function) (eldoc-mode)))

(add-hook 'php-mode-hook '(lambda nil (set (make-local-variable 'eldoc-documentation-function) 'php-eldoc-function) (eldoc-mode)))

;;;***

;;;### (autoloads nil "php-eldoc/php-extras-gen-eldoc" "php-eldoc/php-extras-gen-eldoc.el"
;;;;;;  (21910 33729 744991 553000))
;;; Generated autoloads from php-eldoc/php-extras-gen-eldoc.el

(autoload 'php-extras-generate-eldoc "php-eldoc/php-extras-gen-eldoc" "\
Regenerate PHP function argument hash table from php.net. This is slow!

\(fn)" t nil)

;;;***

;;;### (autoloads nil "keep-buffers/keep-buffers" "keep-buffers/keep-buffers.el"
;;;;;;  (22694 39808 0 0))
;;; Generated autoloads from keep-buffers/keep-buffers.el

(autoload 'keep-buffers-query "keep-buffers/keep-buffers" "\
The query function that disable deletion of buffers we protect.

\(fn)" nil nil)

;;;***

;;;### (autoloads nil "magit/lisp/git-commit" "magit/lisp/git-commit.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/git-commit.el

(defvar global-git-commit-mode t "\
Non-nil if Global Git-Commit mode is enabled.
See the `global-git-commit-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-git-commit-mode'.")

(custom-autoload 'global-git-commit-mode "magit/lisp/git-commit" nil)

(autoload 'global-git-commit-mode "magit/lisp/git-commit" "\
Edit Git commit messages.
This global mode arranges for `git-commit-setup' to be called
when a Git commit message file is opened.  That usually happens
when Git uses the Emacsclient as $GIT_EDITOR to have the user
provide such a commit message.

\(fn &optional ARG)" t nil)

(defconst git-commit-filename-regexp "/\\(\\(\\(COMMIT\\|NOTES\\|PULLREQ\\|TAG\\)_EDIT\\|MERGE_\\|\\)MSG\\|\\(BRANCH\\|EDIT\\)_DESCRIPTION\\)\\'")

(autoload 'git-commit-setup-check-buffer "magit/lisp/git-commit" "\


\(fn)" nil nil)

(autoload 'git-commit-setup "magit/lisp/git-commit" "\


\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/git-commit" '("git-commit-")))

;;;***

;;;### (autoloads nil "magit/lisp/git-rebase" "magit/lisp/git-rebase.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/git-rebase.el

(autoload 'git-rebase-mode "magit/lisp/git-rebase" "\
Major mode for editing of a Git rebase file.

Rebase files are generated when you run 'git rebase -i' or run
`magit-interactive-rebase'.  They describe how Git should perform
the rebase.  See the documentation for git-rebase (e.g., by
running 'man git-rebase' at the command line) for details.

\(fn)" t nil)

(defconst git-rebase-filename-regexp "/git-rebase-todo\\'")

(add-to-list 'auto-mode-alist (cons git-rebase-filename-regexp 'git-rebase-mode))

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/git-rebase" '("git-rebase-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit" "magit/lisp/magit.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from magit/lisp/magit.el
 (autoload 'magit-dispatch-popup "magit" nil t)
 (autoload 'magit-run-popup "magit" nil t)

(autoload 'magit-git-command "magit/lisp/magit" "\
Execute COMMAND asynchronously; display output.

Interactively, prompt for COMMAND in the minibuffer. \"git \" is
used as initial input, but can be deleted to run another command.

With a prefix argument COMMAND is run in the top-level directory
of the current working tree, otherwise in `default-directory'.

\(fn COMMAND)" t nil)

(autoload 'magit-git-command-topdir "magit/lisp/magit" "\
Execute COMMAND asynchronously; display output.

Interactively, prompt for COMMAND in the minibuffer. \"git \" is
used as initial input, but can be deleted to run another command.

COMMAND is run in the top-level directory of the current
working tree.

\(fn COMMAND)" t nil)

(autoload 'magit-shell-command "magit/lisp/magit" "\
Execute COMMAND asynchronously; display output.

Interactively, prompt for COMMAND in the minibuffer.  With a
prefix argument COMMAND is run in the top-level directory of
the current working tree, otherwise in `default-directory'.

\(fn COMMAND)" t nil)

(autoload 'magit-shell-command-topdir "magit/lisp/magit" "\
Execute COMMAND asynchronously; display output.

Interactively, prompt for COMMAND in the minibuffer.  COMMAND
is run in the top-level directory of the current working tree.

\(fn COMMAND)" t nil)

(autoload 'magit-version "magit/lisp/magit" "\
Return the version of Magit currently in use.
If optional argument PRINT-DEST is non-nil, output
stream (interactively, the echo area, or the current buffer with
a prefix argument), also print the used versions of Magit, Git,
and Emacs to it.

\(fn &optional PRINT-DEST)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit" '(#("magit-" 0 6 (fontified nil face font-lock-function-name-face)))))

;;;***

;;;### (autoloads nil "magit/lisp/magit-apply" "magit/lisp/magit-apply.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-apply.el

(autoload 'magit-stage-file "magit/lisp/magit-apply" "\
Stage all changes to FILE.
With a prefix argument or when there is no file at point ask for
the file to be staged.  Otherwise stage the file at point without
requiring confirmation.

\(fn FILE)" t nil)

(autoload 'magit-stage-modified "magit/lisp/magit-apply" "\
Stage all changes to files modified in the worktree.
Stage all new content of tracked files and remove tracked files
that no longer exist in the working tree from the index also.
With a prefix argument also stage previously untracked (but not
ignored) files.

\(fn &optional ALL)" t nil)

(autoload 'magit-unstage-file "magit/lisp/magit-apply" "\
Unstage all changes to FILE.
With a prefix argument or when there is no file at point ask for
the file to be unstaged.  Otherwise unstage the file at point
without requiring confirmation.

\(fn FILE)" t nil)

(autoload 'magit-unstage-all "magit/lisp/magit-apply" "\
Remove all changes from the staging area.

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-apply" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-bisect" "magit/lisp/magit-bisect.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-bisect.el
 (autoload 'magit-bisect-popup "magit-bisect" nil t)

(autoload 'magit-bisect-start "magit/lisp/magit-bisect" "\
Start a bisect session.

Bisecting a bug means to find the commit that introduced it.
This command starts such a bisect session by asking for a know
good and a bad commit.  To move the session forward use the
other actions from the bisect popup (\\<magit-status-mode-map>\\[magit-bisect-popup]).

\(fn BAD GOOD)" t nil)

(autoload 'magit-bisect-reset "magit/lisp/magit-bisect" "\
After bisecting, cleanup bisection state and return to original `HEAD'.

\(fn)" t nil)

(autoload 'magit-bisect-good "magit/lisp/magit-bisect" "\
While bisecting, mark the current commit as good.
Use this after you have asserted that the commit does not contain
the bug in question.

\(fn)" t nil)

(autoload 'magit-bisect-bad "magit/lisp/magit-bisect" "\
While bisecting, mark the current commit as bad.
Use this after you have asserted that the commit does contain the
bug in question.

\(fn)" t nil)

(autoload 'magit-bisect-skip "magit/lisp/magit-bisect" "\
While bisecting, skip the current commit.
Use this if for some reason the current commit is not a good one
to test.  This command lets Git choose a different one.

\(fn)" t nil)

(autoload 'magit-bisect-run "magit/lisp/magit-bisect" "\
Bisect automatically by running commands after each step.

Unlike `git bisect run' this can be used before bisecting has
begun.  In that case it behaves like `git bisect start; git
bisect run'.

\(fn CMDLINE &optional BAD GOOD)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-bisect" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-blame" "magit/lisp/magit-blame.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-blame.el

(autoload 'magit-blame-echo "magit/lisp/magit-blame" "\
For each line show the revision in which it was added.
Show the information about the chunk at point in the echo area
when moving between chunks.  Unlike other blaming commands, do
not turn on `read-only-mode'.

\(fn)" t nil)

(autoload 'magit-blame "magit/lisp/magit-blame" "\
For each line show the revision in which it was added.

\(fn)" t nil)

(autoload 'magit-blame-removal "magit/lisp/magit-blame" "\
For each line show the revision in which it was removed.

\(fn)" t nil)

(autoload 'magit-blame-reverse "magit/lisp/magit-blame" "\
For each line show the last revision in which it still exists.

\(fn)" t nil)
 (autoload 'magit-blame-popup "magit-blame" nil t)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-blame" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-commit" "magit/lisp/magit-commit.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-commit.el

(autoload 'magit-commit "magit/lisp/magit-commit" "\
Create a new commit on `HEAD'.
With a prefix argument, amend to the commit at `HEAD' instead.

\(git commit [--amend] ARGS)

\(fn &optional ARGS)" t nil)

(autoload 'magit-commit-amend "magit/lisp/magit-commit" "\
Amend the last commit.

\(git commit --amend ARGS)

\(fn &optional ARGS)" t nil)

(autoload 'magit-commit-extend "magit/lisp/magit-commit" "\
Amend the last commit, without editing the message.

With a prefix argument keep the committer date, otherwise change
it.  The option `magit-commit-extend-override-date' can be used
to inverse the meaning of the prefix argument.  
\(git commit
--amend --no-edit)

\(fn &optional ARGS OVERRIDE-DATE)" t nil)

(autoload 'magit-commit-reword "magit/lisp/magit-commit" "\
Reword the last commit, ignoring staged changes.

With a prefix argument keep the committer date, otherwise change
it.  The option `magit-commit-reword-override-date' can be used
to inverse the meaning of the prefix argument.

Non-interactively respect the optional OVERRIDE-DATE argument
and ignore the option.

\(git commit --amend --only)

\(fn &optional ARGS OVERRIDE-DATE)" t nil)

(autoload 'magit-commit-fixup "magit/lisp/magit-commit" "\
Create a fixup commit.

With a prefix argument the target COMMIT has to be confirmed.
Otherwise the commit at point may be used without confirmation
depending on the value of option `magit-commit-squash-confirm'.

\(fn &optional COMMIT ARGS)" t nil)

(autoload 'magit-commit-squash "magit/lisp/magit-commit" "\
Create a squash commit, without editing the squash message.

With a prefix argument the target COMMIT has to be confirmed.
Otherwise the commit at point may be used without confirmation
depending on the value of option `magit-commit-squash-confirm'.

\(fn &optional COMMIT ARGS)" t nil)

(autoload 'magit-commit-augment "magit/lisp/magit-commit" "\
Create a squash commit, editing the squash message.

With a prefix argument the target COMMIT has to be confirmed.
Otherwise the commit at point may be used without confirmation
depending on the value of option `magit-commit-squash-confirm'.

\(fn &optional COMMIT ARGS)" t nil)

(autoload 'magit-commit-instant-fixup "magit/lisp/magit-commit" "\
Create a fixup commit targeting COMMIT and instantly rebase.

\(fn &optional COMMIT ARGS)" t nil)

(autoload 'magit-commit-instant-squash "magit/lisp/magit-commit" "\
Create a squash commit targeting COMMIT and instantly rebase.

\(fn &optional COMMIT ARGS)" t nil)

(autoload 'magit-commit-reshelve "magit/lisp/magit-commit" "\
Change the committer date and possibly the author date of `HEAD'.

If you are the author of `HEAD', then both dates are changed,
otherwise only the committer date.  The current time is used
as the initial minibuffer input and the original author (if
that is you) or committer date is available as the previous
history element.

\(fn DATE)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-commit" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-diff" "magit/lisp/magit-diff.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-diff.el

(autoload 'magit-diff-popup "magit/lisp/magit-diff" "\
Popup console for diff commands.

\(fn ARG)" t nil)

(autoload 'magit-diff-buffer-file-popup "magit/lisp/magit-diff" "\
Popup console for diff commands.

This is a variant of `magit-diff-popup' which shows the same popup
but which limits the diff to the file being visited in the current
buffer.

\(fn)" t nil)

(autoload 'magit-diff-dwim "magit/lisp/magit-diff" "\
Show changes for the thing at point.

\(fn &optional ARGS FILES)" t nil)

(autoload 'magit-diff "magit/lisp/magit-diff" "\
Show differences between two commits.

REV-OR-RANGE should be a range or a single revision.  If it is a
revision, then show changes in the working tree relative to that
revision.  If it is a range, but one side is omitted, then show
changes relative to `HEAD'.

If the region is active, use the revisions on the first and last
line of the region as the two sides of the range.  With a prefix
argument, instead of diffing the revisions, choose a revision to
view changes along, starting at the common ancestor of both
revisions (i.e., use a \"...\" range).

\(fn REV-OR-RANGE &optional ARGS FILES)" t nil)

(autoload 'magit-diff-working-tree "magit/lisp/magit-diff" "\
Show changes between the current working tree and the `HEAD' commit.
With a prefix argument show changes between the working tree and
a commit read from the minibuffer.

\(fn &optional REV ARGS FILES)" t nil)

(autoload 'magit-diff-staged "magit/lisp/magit-diff" "\
Show changes between the index and the `HEAD' commit.
With a prefix argument show changes between the index and
a commit read from the minibuffer.

\(fn &optional REV ARGS FILES)" t nil)

(autoload 'magit-diff-unstaged "magit/lisp/magit-diff" "\
Show changes between the working tree and the index.

\(fn &optional ARGS FILES)" t nil)

(autoload 'magit-diff-unmerged "magit/lisp/magit-diff" "\
Show changes that are being merged.

\(fn &optional ARGS FILES)" t nil)

(autoload 'magit-diff-while-committing "magit/lisp/magit-diff" "\
While committing, show the changes that are about to be committed.
While amending, invoking the command again toggles between
showing just the new changes or all the changes that will
be committed.

\(fn &optional ARGS)" t nil)

(autoload 'magit-diff-buffer-file "magit/lisp/magit-diff" "\
Show diff for the blob or file visited in the current buffer.

\(fn)" t nil)

(autoload 'magit-diff-paths "magit/lisp/magit-diff" "\
Show changes between any two files on disk.

\(fn A B)" t nil)

(autoload 'magit-show-commit "magit/lisp/magit-diff" "\
Visit the revision at point in another buffer.
If there is no revision at point or with a prefix argument prompt
for a revision.

\(fn REV &optional ARGS FILES MODULE)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-diff" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-ediff" "magit/lisp/magit-ediff.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-ediff.el
 (autoload 'magit-ediff-popup "magit-ediff" nil t)

(autoload 'magit-ediff-resolve "magit/lisp/magit-ediff" "\
Resolve outstanding conflicts in FILE using Ediff.
FILE has to be relative to the top directory of the repository.

In the rare event that you want to manually resolve all
conflicts, including those already resolved by Git, use
`ediff-merge-revisions-with-ancestor'.

\(fn FILE)" t nil)

(autoload 'magit-ediff-stage "magit/lisp/magit-ediff" "\
Stage and unstage changes to FILE using Ediff.
FILE has to be relative to the top directory of the repository.

\(fn FILE)" t nil)

(autoload 'magit-ediff-compare "magit/lisp/magit-ediff" "\
Compare REVA:FILEA with REVB:FILEB using Ediff.

FILEA and FILEB have to be relative to the top directory of the
repository.  If REVA or REVB is nil, then this stands for the
working tree state.

If the region is active, use the revisions on the first and last
line of the region.  With a prefix argument, instead of diffing
the revisions, choose a revision to view changes along, starting
at the common ancestor of both revisions (i.e., use a \"...\"
range).

\(fn REVA REVB FILEA FILEB)" t nil)

(autoload 'magit-ediff-dwim "magit/lisp/magit-ediff" "\
Compare, stage, or resolve using Ediff.
This command tries to guess what file, and what commit or range
the user wants to compare, stage, or resolve using Ediff.  It
might only be able to guess either the file, or range or commit,
in which case the user is asked about the other.  It might not
always guess right, in which case the appropriate `magit-ediff-*'
command has to be used explicitly.  If it cannot read the user's
mind at all, then it asks the user for a command to run.

\(fn)" t nil)

(autoload 'magit-ediff-show-staged "magit/lisp/magit-ediff" "\
Show staged changes using Ediff.

This only allows looking at the changes; to stage, unstage,
and discard changes using Ediff, use `magit-ediff-stage'.

FILE must be relative to the top directory of the repository.

\(fn FILE)" t nil)

(autoload 'magit-ediff-show-unstaged "magit/lisp/magit-ediff" "\
Show unstaged changes using Ediff.

This only allows looking at the changes; to stage, unstage,
and discard changes using Ediff, use `magit-ediff-stage'.

FILE must be relative to the top directory of the repository.

\(fn FILE)" t nil)

(autoload 'magit-ediff-show-working-tree "magit/lisp/magit-ediff" "\
Show changes between `HEAD' and working tree using Ediff.
FILE must be relative to the top directory of the repository.

\(fn FILE)" t nil)

(autoload 'magit-ediff-show-commit "magit/lisp/magit-ediff" "\
Show changes introduced by COMMIT using Ediff.

\(fn COMMIT)" t nil)

(autoload 'magit-ediff-show-stash "magit/lisp/magit-ediff" "\
Show changes introduced by STASH using Ediff.
`magit-ediff-show-stash-with-index' controls whether a
three-buffer Ediff is used in order to distinguish changes in the
stash that were staged.

\(fn STASH)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-ediff" '("magit-ediff-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-extras" "magit/lisp/magit-extras.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-extras.el

(autoload 'magit-run-git-gui "magit/lisp/magit-extras" "\
Run `git gui' for the current git repository.

\(fn)" t nil)

(autoload 'magit-run-git-gui-blame "magit/lisp/magit-extras" "\
Run `git gui blame' on the given FILENAME and COMMIT.
Interactively run it for the current file and the `HEAD', with a
prefix or when the current file cannot be determined let the user
choose.  When the current buffer is visiting FILENAME instruct
blame to center around the line point is on.

\(fn COMMIT FILENAME &optional LINENUM)" t nil)

(autoload 'magit-run-gitk "magit/lisp/magit-extras" "\
Run `gitk' in the current repository.

\(fn)" t nil)

(autoload 'magit-run-gitk-branches "magit/lisp/magit-extras" "\
Run `gitk --branches' in the current repository.

\(fn)" t nil)

(autoload 'magit-run-gitk-all "magit/lisp/magit-extras" "\
Run `gitk --all' in the current repository.

\(fn)" t nil)

(autoload 'ido-enter-magit-status "magit/lisp/magit-extras" "\
Drop into `magit-status' from file switching.

To make this command available use something like:

  (add-hook \\='ido-setup-hook
            (lambda ()
              (define-key ido-completion-map
                (kbd \"C-x g\") \\='ido-enter-magit-status)))

Starting with Emacs 25.1 the Ido keymaps are defined just once
instead of every time Ido is invoked, so now you can modify it
like pretty much every other keymap:

  (define-key ido-common-completion-map
    (kbd \"C-x g\") \\='ido-enter-magit-status)

\(fn)" t nil)

(autoload 'magit-dired-jump "magit/lisp/magit-extras" "\
Visit file at point using Dired.
With a prefix argument, visit in another window.  If there
is no file at point, then instead visit `default-directory'.

\(fn &optional OTHER-WINDOW)" t nil)

(autoload 'magit-dired-log "magit/lisp/magit-extras" "\
Show log for all marked files, or the current file.

\(fn &optional FOLLOW)" t nil)

(autoload 'magit-do-async-shell-command "magit/lisp/magit-extras" "\
Open FILE with `dired-do-async-shell-command'.
Interactively, open the file at point.

\(fn FILE)" t nil)

(autoload 'magit-previous-line "magit/lisp/magit-extras" "\
Like `previous-line' but with Magit-specific shift-selection.

Magit's selection mechanism is based on the region but selects an
area that is larger than the region.  This causes `previous-line'
when invoked while holding the shift key to move up one line and
thereby select two lines.  When invoked inside a hunk body this
command does not move point on the first invocation and thereby
it only selects a single line.  Which inconsistency you prefer
is a matter of preference.

\(fn &optional ARG TRY-VSCROLL)" t nil)

(function-put 'magit-previous-line 'interactive-only '"use `forward-line' with negative argument instead.")

(autoload 'magit-next-line "magit/lisp/magit-extras" "\
Like `next-line' but with Magit-specific shift-selection.

Magit's selection mechanism is based on the region but selects
an area that is larger than the region.  This causes `next-line'
when invoked while holding the shift key to move down one line
and thereby select two lines.  When invoked inside a hunk body
this command does not move point on the first invocation and
thereby it only selects a single line.  Which inconsistency you
prefer is a matter of preference.

\(fn &optional ARG TRY-VSCROLL)" t nil)

(function-put 'magit-next-line 'interactive-only 'forward-line)

(autoload 'magit-clean "magit/lisp/magit-extras" "\
Remove untracked files from the working tree.
With a prefix argument also remove ignored files,
with two prefix arguments remove ignored files only.

\(git clean -f -d [-x|-X])

\(fn &optional ARG)" t nil)

(autoload 'magit-gitignore "magit/lisp/magit-extras" "\
Instruct Git to ignore FILE-OR-PATTERN.
With a prefix argument only ignore locally.

\(fn FILE-OR-PATTERN &optional LOCAL)" t nil)

(autoload 'magit-gitignore-locally "magit/lisp/magit-extras" "\
Instruct Git to locally ignore FILE-OR-PATTERN.

\(fn FILE-OR-PATTERN)" t nil)

(autoload 'magit-add-change-log-entry "magit/lisp/magit-extras" "\
Find change log file and add date entry and item for current change.
This differs from `add-change-log-entry' (which see) in that
it acts on the current hunk in a Magit buffer instead of on
a position in a file-visiting buffer.

\(fn &optional WHOAMI FILE-NAME OTHER-WINDOW)" t nil)

(autoload 'magit-add-change-log-entry-other-window "magit/lisp/magit-extras" "\
Find change log file in other window and add entry and item.
This differs from `add-change-log-entry-other-window' (which see)
in that it acts on the current hunk in a Magit buffer instead of
on a position in a file-visiting buffer.

\(fn &optional WHOAMI FILE-NAME)" t nil)

(autoload 'magit-edit-line-commit "magit/lisp/magit-extras" "\
Edit the commit that added the current line.

With a prefix argument edit the commit that removes the line,
if any.  The commit is determined using `git blame' and made
editable using `git rebase --interactive' if it is reachable
from `HEAD', or by checking out the commit (or a branch that
points at it) otherwise.

\(fn &optional TYPE)" t nil)

(autoload 'magit-reshelve-since "magit/lisp/magit-extras" "\
Change the author and committer dates of the commits since REV.

Ask the user for the first reachable commit whose dates should
be changed.  The read the new date for that commit.  The initial
minibuffer input and the previous history element offer good
values.  The next commit will be created one minute later and so
on.

This command is only intended for interactive use and should only
be used on highly rearranged and unpublished history.

\(fn REV)" t nil)

(autoload 'magit-copy-section-value "magit/lisp/magit-extras" "\
Save the value of the current section for later use.

Save the section value to the `kill-ring', and, provided that
the current section is a commit, branch, or tag section, push
the (referenced) revision to the `magit-revision-stack' for use
with `magit-pop-revision-stack'.

When the current section is a branch or a tag, and a prefix
argument is used, then save the revision at its tip to the
`kill-ring' instead of the reference name.

When the region is active, then save that to the `kill-ring',
like `kill-ring-save' would, instead of behaving as described
above.

\(fn)" t nil)

(autoload 'magit-copy-buffer-revision "magit/lisp/magit-extras" "\
Save the revision of the current buffer for later use.

Save the revision shown in the current buffer to the `kill-ring'
and push it to the `magit-revision-stack'.

This command is mainly intended for use in `magit-revision-mode'
buffers, the only buffers where it is always unambiguous exactly
which revision should be saved.

Most other Magit buffers usually show more than one revision, in
some way or another, so this command has to select one of them,
and that choice might not always be the one you think would have
been the best pick.

In such buffers it is often more useful to save the value of
the current section instead, using `magit-copy-section-value'.

When the region is active, then save that to the `kill-ring',
like `kill-ring-save' would, instead of behaving as described
above.

\(fn)" t nil)

(autoload 'magit-abort-dwim "magit/lisp/magit-extras" "\
Abort current operation.
Depending on the context, this will abort a merge, a rebase, a
patch application, a cherry-pick, a revert, or a bisect.

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-extras" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-log" "magit/lisp/magit-log.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-log.el

(autoload 'magit-log-buffer-file-popup "magit/lisp/magit-log" "\
Popup console for log commands.

This is a variant of `magit-log-popup' which shows the same popup
but which limits the log to the file being visited in the current
buffer.

\(fn)" t nil)

(autoload 'magit-log-current "magit/lisp/magit-log" "\
Show log for the current branch.
When `HEAD' is detached or with a prefix argument show log for
one or more revs read from the minibuffer.

\(fn REVS &optional ARGS FILES)" t nil)

(autoload 'magit-log "magit/lisp/magit-log" "\
Show log for one or more revs read from the minibuffer.
The user can input any revision or revisions separated by a
space, or even ranges, but only branches and tags, and a
representation of the commit at point, are available as
completion candidates.

\(fn REVS &optional ARGS FILES)" t nil)

(autoload 'magit-log-head "magit/lisp/magit-log" "\
Show log for `HEAD'.

\(fn &optional ARGS FILES)" t nil)

(autoload 'magit-log-branches "magit/lisp/magit-log" "\
Show log for all local branches and `HEAD'.

\(fn &optional ARGS FILES)" t nil)

(autoload 'magit-log-all-branches "magit/lisp/magit-log" "\
Show log for all local and remote branches and `HEAD'.

\(fn &optional ARGS FILES)" t nil)

(autoload 'magit-log-all "magit/lisp/magit-log" "\
Show log for all references and `HEAD'.

\(fn &optional ARGS FILES)" t nil)

(autoload 'magit-log-buffer-file "magit/lisp/magit-log" "\
Show log for the blob or file visited in the current buffer.
With a prefix argument or when `--follow' is part of
`magit-log-arguments', then follow renames.  When the region is
active, restrict the log to the lines that the region touches.

\(fn &optional FOLLOW BEG END)" t nil)

(autoload 'magit-log-trace-definition "magit/lisp/magit-log" "\
Show log for the definition at point.

\(fn FILE FN REV)" t nil)

(autoload 'magit-reflog-current "magit/lisp/magit-log" "\
Display the reflog of the current branch.

\(fn)" t nil)

(autoload 'magit-reflog "magit/lisp/magit-log" "\
Display the reflog of a branch.

\(fn REF)" t nil)

(autoload 'magit-reflog-head "magit/lisp/magit-log" "\
Display the `HEAD' reflog.

\(fn)" t nil)

(autoload 'magit-log-move-to-parent "magit/lisp/magit-log" "\
Move to the Nth parent of the current commit.

\(fn &optional N)" t nil)

(autoload 'magit-cherry "magit/lisp/magit-log" "\
Show commits in a branch that are not merged in the upstream branch.

\(fn HEAD UPSTREAM)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-log" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-remote" "magit/lisp/magit-remote.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-remote.el

(autoload 'magit-clone "magit/lisp/magit-remote" "\
Clone the REPOSITORY to DIRECTORY.
Then show the status buffer for the new repository.

\(fn REPOSITORY DIRECTORY)" t nil)
 (autoload 'magit-remote-popup "magit-remote" nil t)

(autoload 'magit-remote-add "magit/lisp/magit-remote" "\
Add a remote named REMOTE and fetch it.

\(fn REMOTE URL &optional ARGS)" t nil)

(autoload 'magit-remote-rename "magit/lisp/magit-remote" "\
Rename the remote named OLD to NEW.

\(fn OLD NEW)" t nil)

(autoload 'magit-remote-remove "magit/lisp/magit-remote" "\
Delete the remote named REMOTE.

\(fn REMOTE)" t nil)

(autoload 'magit-remote-prune "magit/lisp/magit-remote" "\
Remove stale remote-tracking branches for REMOTE.

\(fn REMOTE)" t nil)

(autoload 'magit-remote-prune-refspecs "magit/lisp/magit-remote" "\
Remove stale refspecs for REMOTE.

A refspec is stale if there no longer exists at least one branch
on the remote that would be fetched due to that refspec.  A stale
refspec is problematic because its existence causes Git to refuse
to fetch according to the remaining non-stale refspecs.

If only stale refspecs remain, then offer to either delete the
remote or to replace the stale refspecs with the default refspec.

Also remove the remote-tracking branches that were created due to
the now stale refspecs.  Other stale branches are not removed.

\(fn REMOTE)" t nil)

(autoload 'magit-remote-set-head "magit/lisp/magit-remote" "\
Set the local representation of REMOTE's default branch.
Query REMOTE and set the symbolic-ref refs/remotes/<remote>/HEAD
accordingly.  With a prefix argument query for the branch to be
used, which allows you to select an incorrect value if you fancy
doing that.

\(fn REMOTE &optional BRANCH)" t nil)

(autoload 'magit-remote-unset-head "magit/lisp/magit-remote" "\
Unset the local representation of REMOTE's default branch.
Delete the symbolic-ref \"refs/remotes/<remote>/HEAD\".

\(fn REMOTE)" t nil)

(autoload 'magit-remote-config-popup "magit/lisp/magit-remote" "\
Popup console for setting remote variables.

\(fn REMOTE)" t nil)
 (autoload 'magit-fetch-popup "magit-remote" nil t)

(autoload 'magit-fetch-from-pushremote "magit/lisp/magit-remote" "\
Fetch from the push-remote of the current branch.

\(fn ARGS)" t nil)

(autoload 'magit-fetch-from-upstream "magit/lisp/magit-remote" "\
Fetch from the upstream repository of the current branch.

\(fn ARGS)" t nil)

(autoload 'magit-fetch "magit/lisp/magit-remote" "\
Fetch from another repository.

\(fn REMOTE ARGS)" t nil)

(autoload 'magit-fetch-branch "magit/lisp/magit-remote" "\
Fetch a BRANCH from a REMOTE.

\(fn REMOTE BRANCH ARGS)" t nil)

(autoload 'magit-fetch-refspec "magit/lisp/magit-remote" "\
Fetch a REFSPEC from a REMOTE.

\(fn REMOTE REFSPEC ARGS)" t nil)

(autoload 'magit-fetch-all "magit/lisp/magit-remote" "\
Fetch from all remotes.

\(fn ARGS)" t nil)

(autoload 'magit-fetch-all-prune "magit/lisp/magit-remote" "\
Fetch from all remotes, and prune.
Prune remote tracking branches for branches that have been
removed on the respective remote.

\(fn)" t nil)

(autoload 'magit-fetch-all-no-prune "magit/lisp/magit-remote" "\
Fetch from all remotes.

\(fn)" t nil)

(autoload 'magit-fetch-modules "magit/lisp/magit-remote" "\
Fetch all submodules.

Option `magit-fetch-modules-jobs' controls how many submodules
are being fetched in parallel.  Also fetch the super-repository,
because `git-fetch' does not support not doing that.  With a
prefix argument fetch all remotes.

\(fn &optional ALL)" t nil)
 (autoload 'magit-pull-popup "magit-remote" nil t)
 (autoload 'magit-pull-and-fetch-popup "magit-remote" nil t)

(autoload 'magit-pull-from-pushremote "magit/lisp/magit-remote" "\
Pull from the push-remote of the current branch.

\(fn ARGS)" t nil)

(autoload 'magit-pull-from-upstream "magit/lisp/magit-remote" "\
Pull from the upstream of the current branch.

\(fn ARGS)" t nil)

(autoload 'magit-pull "magit/lisp/magit-remote" "\
Pull from a branch read in the minibuffer.

\(fn SOURCE ARGS)" t nil)
 (autoload 'magit-push-popup "magit-remote" nil t)

(autoload 'magit-push-current-to-pushremote "magit/lisp/magit-remote" "\
Push the current branch to `branch.<name>.pushRemote'.
If that variable is unset, then push to `remote.pushDefault'.

When `magit-push-current-set-remote-if-missing' is non-nil and
the push-remote is not configured, then read the push-remote from
the user, set it, and then push to it.  With a prefix argument
the push-remote can be changed before pushed to it.

\(fn ARGS &optional PUSH-REMOTE)" t nil)

(autoload 'magit-push-current-to-upstream "magit/lisp/magit-remote" "\
Push the current branch to its upstream branch.

When `magit-push-current-set-remote-if-missing' is non-nil and
the upstream is not configured, then read the upstream from the
user, set it, and then push to it.  With a prefix argument the
upstream can be changed before pushed to it.

\(fn ARGS &optional UPSTREAM)" t nil)

(autoload 'magit-push-current "magit/lisp/magit-remote" "\
Push the current branch to a branch read in the minibuffer.

\(fn TARGET ARGS)" t nil)

(autoload 'magit-push "magit/lisp/magit-remote" "\
Push an arbitrary branch or commit somewhere.
Both the source and the target are read in the minibuffer.

\(fn SOURCE TARGET ARGS)" t nil)

(autoload 'magit-push-refspecs "magit/lisp/magit-remote" "\
Push one or multiple REFSPECS to a REMOTE.
Both the REMOTE and the REFSPECS are read in the minibuffer.  To
use multiple REFSPECS, separate them with commas.  Completion is
only available for the part before the colon, or when no colon
is used.

\(fn REMOTE REFSPECS ARGS)" t nil)

(autoload 'magit-push-matching "magit/lisp/magit-remote" "\
Push all matching branches to another repository.
If multiple remotes exist, then read one from the user.
If just one exists, use that without requiring confirmation.

\(fn REMOTE &optional ARGS)" t nil)

(autoload 'magit-push-tags "magit/lisp/magit-remote" "\
Push all tags to another repository.
If only one remote exists, then push to that.  Otherwise prompt
for a remote, offering the remote configured for the current
branch as default.

\(fn REMOTE &optional ARGS)" t nil)

(autoload 'magit-push-tag "magit/lisp/magit-remote" "\
Push a tag to another repository.

\(fn TAG REMOTE &optional ARGS)" t nil)

(autoload 'magit-push-implicitly "magit/lisp/magit-remote" "\
Push somewhere without using an explicit refspec.

This command simply runs \"git push -v [ARGS]\".  ARGS are the
arguments specified in the popup buffer.  No explicit refspec
arguments are used.  Instead the behavior depends on at least
these Git variables: `push.default', `remote.pushDefault',
`branch.<branch>.pushRemote', `branch.<branch>.remote',
`branch.<branch>.merge', and `remote.<remote>.push'.

To add this command to the push popup add this to your init file:

  (with-eval-after-load \\='magit-remote
    (magit-define-popup-action \\='magit-push-popup ?P
      \\='magit-push-implicitly--desc
      \\='magit-push-implicitly ?p t))

The function `magit-push-implicitly--desc' attempts to predict
what this command will do.  The value it returns is displayed in
the popup buffer.

\(fn ARGS)" t nil)

(autoload 'magit-push-to-remote "magit/lisp/magit-remote" "\
Push to REMOTE without using an explicit refspec.
The REMOTE is read in the minibuffer.

This command simply runs \"git push -v [ARGS] REMOTE\".  ARGS
are the arguments specified in the popup buffer.  No refspec
arguments are used.  Instead the behavior depends on at least
these Git variables: `push.default', `remote.pushDefault',
`branch.<branch>.pushRemote', `branch.<branch>.remote',
`branch.<branch>.merge', and `remote.<remote>.push'.

To add this command to the push popup add this to your init file:

  (with-eval-after-load \\='magit-remote
    (magit-define-popup-action \\='magit-push-popup ?r
      \\='magit-push-to-remote--desc
      \\='magit-push-to-remote ?p t))

\(fn REMOTE ARGS)" t nil)
 (autoload 'magit-patch-popup "magit-remote" nil t)

(autoload 'magit-format-patch "magit/lisp/magit-remote" "\
Create patches for the commits in RANGE.
When a single commit is given for RANGE, create a patch for the
changes introduced by that commit (unlike 'git format-patch'
which creates patches for all commits that are reachable from
`HEAD' but not from the specified commit).

\(fn RANGE ARGS)" t nil)

(autoload 'magit-request-pull "magit/lisp/magit-remote" "\
Request upstream to pull from you public repository.

URL is the url of your publically accessible repository.
START is a commit that already is in the upstream repository.
END is the last commit, usually a branch name, which upstream
is asked to pull.  START has to be reachable from that commit.

\(fn URL START END)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-remote" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-sequence" "magit/lisp/magit-sequence.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-sequence.el

(autoload 'magit-sequencer-continue "magit/lisp/magit-sequence" "\
Resume the current cherry-pick or revert sequence.

\(fn)" t nil)

(autoload 'magit-sequencer-skip "magit/lisp/magit-sequence" "\
Skip the stopped at commit during a cherry-pick or revert sequence.

\(fn)" t nil)

(autoload 'magit-sequencer-abort "magit/lisp/magit-sequence" "\
Abort the current cherry-pick or revert sequence.
This discards all changes made since the sequence started.

\(fn)" t nil)
 (autoload 'magit-cherry-pick-popup "magit-sequence" nil t)

(autoload 'magit-cherry-pick "magit/lisp/magit-sequence" "\
Copy COMMITS from another branch onto the current branch.
Prompt for a commit, defaulting to the commit at point.  If
the region selects multiple commits, then pick all of them,
without prompting.

\(fn COMMITS &optional ARGS)" t nil)

(autoload 'magit-cherry-apply "magit/lisp/magit-sequence" "\
Apply the changes in COMMITS but do not commit them.
Prompt for a commit, defaulting to the commit at point.  If
the region selects multiple commits, then apply all of them,
without prompting.

\(fn COMMITS &optional ARGS)" t nil)

(autoload 'magit-cherry-harvest "magit/lisp/magit-sequence" "\
Move COMMITS from another BRANCH onto the current branch.
Remove the COMMITS from BRANCH and stay on the current branch.
If a conflict occurs, then you have to fix that and finish the
process manually.

\(fn COMMITS BRANCH &optional ARGS)" t nil)

(autoload 'magit-cherry-donate "magit/lisp/magit-sequence" "\
Move COMMITS from the current branch onto another existing BRANCH.
Remove COMMITS from the current branch and stay on that branch.
If a conflict occurs, then you have to fix that and finish the
process manually.

\(fn COMMITS BRANCH &optional ARGS)" t nil)

(autoload 'magit-cherry-spinout "magit/lisp/magit-sequence" "\
Move COMMITS from the current branch onto a new BRANCH.
Remove COMMITS from the current branch and stay on that branch.
If a conflict occurs, then you have to fix that and finish the
process manually.

\(fn COMMITS BRANCH START-POINT &optional ARGS)" t nil)

(autoload 'magit-cherry-spinoff "magit/lisp/magit-sequence" "\
Move COMMITS from the current branch onto a new BRANCH.
Remove COMMITS from the current branch and checkout BRANCH.
If a conflict occurs, then you have to fix that and finish
the process manually.

\(fn COMMITS BRANCH START-POINT &optional ARGS)" t nil)
 (autoload 'magit-revert-popup "magit-sequence" nil t)

(autoload 'magit-revert "magit/lisp/magit-sequence" "\
Revert COMMIT by creating a new commit.
Prompt for a commit, defaulting to the commit at point.  If
the region selects multiple commits, then revert all of them,
without prompting.

\(fn COMMIT &optional ARGS)" t nil)

(autoload 'magit-revert-no-commit "magit/lisp/magit-sequence" "\
Revert COMMIT by applying it in reverse to the worktree.
Prompt for a commit, defaulting to the commit at point.  If
the region selects multiple commits, then revert all of them,
without prompting.

\(fn COMMIT &optional ARGS)" t nil)
 (autoload 'magit-am-popup "magit-sequence" nil t)

(autoload 'magit-am-apply-patches "magit/lisp/magit-sequence" "\
Apply the patches FILES.

\(fn &optional FILES ARGS)" t nil)

(autoload 'magit-am-apply-maildir "magit/lisp/magit-sequence" "\
Apply the patches from MAILDIR.

\(fn &optional MAILDIR ARGS)" t nil)

(autoload 'magit-am-continue "magit/lisp/magit-sequence" "\
Resume the current patch applying sequence.

\(fn)" t nil)

(autoload 'magit-am-skip "magit/lisp/magit-sequence" "\
Skip the stopped at patch during a patch applying sequence.

\(fn)" t nil)

(autoload 'magit-am-abort "magit/lisp/magit-sequence" "\
Abort the current patch applying sequence.
This discards all changes made since the sequence started.

\(fn)" t nil)
 (autoload 'magit-rebase-popup "magit-sequence" nil t)

(autoload 'magit-rebase-onto-pushremote "magit/lisp/magit-sequence" "\
Rebase the current branch onto `branch.<name>.pushRemote'.
If that variable is unset, then rebase onto `remote.pushDefault'.

\(fn ARGS)" t nil)

(autoload 'magit-rebase-onto-upstream "magit/lisp/magit-sequence" "\
Rebase the current branch onto its upstream branch.

\(fn ARGS)" t nil)

(autoload 'magit-rebase "magit/lisp/magit-sequence" "\
Rebase the current branch onto a branch read in the minibuffer.
All commits that are reachable from `HEAD' but not from the
selected branch TARGET are being rebased.

\(fn TARGET ARGS)" t nil)

(autoload 'magit-rebase-subset "magit/lisp/magit-sequence" "\
Rebase a subset of the current branch's history onto a new base.
Rebase commits from START to `HEAD' onto NEWBASE.
START has to be selected from a list of recent commits.

\(fn NEWBASE START ARGS)" t nil)

(autoload 'magit-rebase-interactive "magit/lisp/magit-sequence" "\
Start an interactive rebase sequence.

\(fn COMMIT ARGS)" t nil)

(autoload 'magit-rebase-autosquash "magit/lisp/magit-sequence" "\
Combine squash and fixup commits with their intended targets.

\(fn ARGS)" t nil)

(autoload 'magit-rebase-edit-commit "magit/lisp/magit-sequence" "\
Edit a single older commit using rebase.

\(fn COMMIT ARGS)" t nil)

(autoload 'magit-rebase-reword-commit "magit/lisp/magit-sequence" "\
Reword a single older commit using rebase.

\(fn COMMIT ARGS)" t nil)

(autoload 'magit-rebase-remove-commit "magit/lisp/magit-sequence" "\
Remove a single older commit using rebase.

\(fn COMMIT ARGS)" t nil)

(autoload 'magit-rebase-continue "magit/lisp/magit-sequence" "\
Restart the current rebasing operation.
In some cases this pops up a commit message buffer for you do
edit.  With a prefix argument the old message is reused as-is.

\(fn &optional NOEDIT)" t nil)

(autoload 'magit-rebase-skip "magit/lisp/magit-sequence" "\
Skip the current commit and restart the current rebase operation.

\(fn)" t nil)

(autoload 'magit-rebase-edit "magit/lisp/magit-sequence" "\
Edit the todo list of the current rebase operation.

\(fn)" t nil)

(autoload 'magit-rebase-abort "magit/lisp/magit-sequence" "\
Abort the current rebase operation, restoring the original branch.

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-sequence" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-stash" "magit/lisp/magit-stash.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-stash.el
 (autoload 'magit-stash-popup "magit-stash" nil t)

(autoload 'magit-stash "magit/lisp/magit-stash" "\
Create a stash of the index and working tree.
Untracked files are included according to popup arguments.
One prefix argument is equivalent to `--include-untracked'
while two prefix arguments are equivalent to `--all'.

\(fn MESSAGE &optional INCLUDE-UNTRACKED)" t nil)

(autoload 'magit-stash-index "magit/lisp/magit-stash" "\
Create a stash of the index only.
Unstaged and untracked changes are not stashed.  The stashed
changes are applied in reverse to both the index and the
worktree.  This command can fail when the worktree is not clean.
Applying the resulting stash has the inverse effect.

\(fn MESSAGE)" t nil)

(autoload 'magit-stash-worktree "magit/lisp/magit-stash" "\
Create a stash of unstaged changes in the working tree.
Untracked files are included according to popup arguments.
One prefix argument is equivalent to `--include-untracked'
while two prefix arguments are equivalent to `--all'.

\(fn MESSAGE &optional INCLUDE-UNTRACKED)" t nil)

(autoload 'magit-stash-keep-index "magit/lisp/magit-stash" "\
Create a stash of the index and working tree, keeping index intact.
Untracked files are included according to popup arguments.
One prefix argument is equivalent to `--include-untracked'
while two prefix arguments are equivalent to `--all'.

\(fn MESSAGE &optional INCLUDE-UNTRACKED)" t nil)

(autoload 'magit-snapshot "magit/lisp/magit-stash" "\
Create a snapshot of the index and working tree.
Untracked files are included according to popup arguments.
One prefix argument is equivalent to `--include-untracked'
while two prefix arguments are equivalent to `--all'.

\(fn &optional INCLUDE-UNTRACKED)" t nil)

(autoload 'magit-snapshot-index "magit/lisp/magit-stash" "\
Create a snapshot of the index only.
Unstaged and untracked changes are not stashed.

\(fn)" t nil)

(autoload 'magit-snapshot-worktree "magit/lisp/magit-stash" "\
Create a snapshot of unstaged changes in the working tree.
Untracked files are included according to popup arguments.
One prefix argument is equivalent to `--include-untracked'
while two prefix arguments are equivalent to `--all'.

\(fn &optional INCLUDE-UNTRACKED)" t nil)

(autoload 'magit-stash-apply "magit/lisp/magit-stash" "\
Apply a stash to the working tree.
Try to preserve the stash index.  If that fails because there
are staged changes, apply without preserving the stash index.

\(fn STASH)" t nil)

(autoload 'magit-stash-drop "magit/lisp/magit-stash" "\
Remove a stash from the stash list.
When the region is active offer to drop all contained stashes.

\(fn STASH)" t nil)

(autoload 'magit-stash-clear "magit/lisp/magit-stash" "\
Remove all stashes saved in REF's reflog by deleting REF.

\(fn REF)" t nil)

(autoload 'magit-stash-branch "magit/lisp/magit-stash" "\
Create and checkout a new BRANCH from STASH.

\(fn STASH BRANCH)" t nil)

(autoload 'magit-stash-branch-here "magit/lisp/magit-stash" "\
Create and checkout a new BRANCH and apply STASH.
The branch is created using `magit-branch', using the current
branch or `HEAD' as the string-point.

\(fn STASH BRANCH)" t nil)

(autoload 'magit-stash-format-patch "magit/lisp/magit-stash" "\
Create a patch from STASH

\(fn STASH)" t nil)

(autoload 'magit-stash-list "magit/lisp/magit-stash" "\
List all stashes in a buffer.

\(fn)" t nil)

(autoload 'magit-stash-show "magit/lisp/magit-stash" "\
Show all diffs of a stash in a buffer.

\(fn STASH &optional ARGS FILES)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-stash" '("magit-")))

;;;***

;;;### (autoloads nil "magit/lisp/magit-wip" "magit/lisp/magit-wip.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from magit/lisp/magit-wip.el

(defvar magit-wip-after-save-mode nil "\
Non-nil if Magit-Wip-After-Save mode is enabled.
See the `magit-wip-after-save-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `magit-wip-after-save-mode'.")

(custom-autoload 'magit-wip-after-save-mode "magit/lisp/magit-wip" nil)

(autoload 'magit-wip-after-save-mode "magit/lisp/magit-wip" "\
Toggle Magit-Wip-After-Save-Local mode in all buffers.
With prefix ARG, enable Magit-Wip-After-Save mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Magit-Wip-After-Save-Local mode is enabled in all buffers where
`magit-wip-after-save-local-mode-turn-on' would do it.
See `magit-wip-after-save-local-mode' for more information on Magit-Wip-After-Save-Local mode.

\(fn &optional ARG)" t nil)

(defvar magit-wip-after-apply-mode nil "\
Non-nil if Magit-Wip-After-Apply mode is enabled.
See the `magit-wip-after-apply-mode' command
for a description of this minor mode.")

(custom-autoload 'magit-wip-after-apply-mode "magit/lisp/magit-wip" nil)

(autoload 'magit-wip-after-apply-mode "magit/lisp/magit-wip" "\
Commit to work-in-progress refs.

After applying a change using any \"apply variant\"
command (apply, stage, unstage, discard, and reverse) commit the
affected files to the current wip refs.  For each branch there
may be two wip refs; one contains snapshots of the files as found
in the worktree and the other contains snapshots of the entries
in the index.

\(fn &optional ARG)" t nil)

(defvar magit-wip-before-change-mode nil "\
Non-nil if Magit-Wip-Before-Change mode is enabled.
See the `magit-wip-before-change-mode' command
for a description of this minor mode.")

(custom-autoload 'magit-wip-before-change-mode "magit/lisp/magit-wip" nil)

(autoload 'magit-wip-before-change-mode "magit/lisp/magit-wip" "\
Commit to work-in-progress refs before certain destructive changes.

Before invoking a revert command or an \"apply variant\"
command (apply, stage, unstage, discard, and reverse) commit the
affected tracked files to the current wip refs.  For each branch
there may be two wip refs; one contains snapshots of the files
as found in the worktree and the other contains snapshots of the
entries in the index.

Only changes to files which could potentially be affected by the
command which is about to be called are committed.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "magit/lisp/magit-wip" '("magit-wip-")))

;;;***


;;;***

;;;### (autoloads nil "mo-git-blame/mo-git-blame" "mo-git-blame/mo-git-blame.el"
;;;;;;  (21910 33729 740991 646000))
;;; Generated autoloads from mo-git-blame/mo-git-blame.el

(autoload 'mo-git-blame-file "mo-git-blame/mo-git-blame" "\
Calls `git blame' for REVISION of FILE-NAME or `HEAD' if
REVISION is not given. Initializes the two windows that will show
the output of 'git blame' and the content.

If FILE-NAME is missing it will be read with `find-file' in
interactive mode.

ORIGINAL-FILE-NAME defaults to FILE-NAME if not given. This is
used for tracking renaming and moving of files during iterative
re-blaming.

With a numeric prefix argument or with NUM-LINES-TO-BLAME only
the NUM-LINES-TO-BLAME lines before and after point are blamed by
using git blame's `-L' option. Otherwise the whole file is
blamed.

\(fn &optional FILE-NAME REVISION ORIGINAL-FILE-NAME NUM-LINES-TO-BLAME)" t nil)

(autoload 'mo-git-blame-current "mo-git-blame/mo-git-blame" "\
Calls `mo-git-blame-file' for HEAD for the current buffer.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "notify/notify" "notify/notify.el" (21910 33729
;;;;;;  740991 646000))
;;; Generated autoloads from notify/notify.el

(autoload 'notify "notify/notify" "\
Notify TITLE, BODY via `notify-method'.
ARGS may be amongst :timeout, :icon, :urgency, :app and :category.

\(fn TITLE BODY &rest ARGS)" nil nil)

;;;***

;;;### (autoloads nil "php-mode/php-mode" "php-mode/php-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from php-mode/php-mode.el

(let ((loads (get 'php 'custom-loads))) (if (member '"php-mode/php-mode" loads) nil (put 'php 'custom-loads (cons '"php-mode/php-mode" loads))))

(defvar php-extra-constants 'nil "\
A list of additional strings to treat as PHP constants.")

(custom-autoload 'php-extra-constants "php-mode/php-mode" nil)

(if (version< emacs-version "24.4") (dolist (i '("php" "php5" "php7")) (add-to-list 'interpreter-mode-alist (cons i 'php-mode))) (add-to-list 'interpreter-mode-alist (cons "php\\(?:-?[3457]\\(?:\\.[0-9]+\\)*\\)?" 'php-mode)))

(define-obsolete-variable-alias 'php-available-project-root-files 'php-project-available-root-files "1.19.0")

(let ((loads (get 'php-faces 'custom-loads))) (if (member '"php-mode/php-mode" loads) nil (put 'php-faces 'custom-loads (cons '"php-mode/php-mode" loads))))

(autoload 'php-mode "php-mode/php-mode" "\
Major mode for editing PHP code.

\\{php-mode-map}

\(fn)" t nil)

(autoload 'php-current-class "php-mode/php-mode" "\
Insert current class name if cursor in class context.

\(fn)" t nil)

(autoload 'php-current-namespace "php-mode/php-mode" "\
Insert current namespace if cursor in namespace context.

\(fn)" t nil)

(add-to-list 'auto-mode-alist (cons (eval-when-compile (rx (or (: "." (or (: "php" (32 (in "s345t"))) "amk" "phtml")) (: "/" (or "Amkfile" ".php_cs" ".php_cs.dist"))) string-end)) 'php-mode) t)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "php-mode/php-mode" '("php-")))

;;;***

;;;### (autoloads nil "php-mode/php-mode-test" "php-mode/php-mode-test.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from php-mode/php-mode-test.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "php-mode/php-mode-test" '("php-mode-test-")))

;;;***

;;;### (autoloads nil "php-mode/php-project" "php-mode/php-project.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from php-mode/php-project.el

(defvar php-project-root 'auto "\
Method of searching for the top level directory.

`auto' (default)
      Try to search file in order of `php-project-available-root-files'.

SYMBOL
      Key of `php-project-available-root-files'.

STRING
      A file/directory name of top level marker.
      If the string is an actual directory path, it is set as the absolute path
      of the root directory, not the marker.")

(make-variable-buffer-local 'php-project-root)

(put 'php-project-root 'safe-local-variable #'(lambda (v) (or (stringp v) (assq v php-project-available-root-files))))

(defvar php-project-bootstrap-scripts nil "\
List of path to bootstrap php script file.

The ideal bootstrap file is silent, it only includes dependent files,
defines constants, and sets the class loaders.")

(make-variable-buffer-local 'php-project-bootstrap-scripts)

(put 'php-project-bootstrap-scripts 'safe-local-variable #'php-project--eval-bootstrap-scripts)

(defvar php-project-php-executable nil "\
Path to php executable file.")

(make-variable-buffer-local 'php-project-php-executable)

(put 'php-project-php-executable 'safe-local-variable #'(lambda (v) (and (stringp v) (file-executable-p v))))

(defvar php-project-phan-executable nil "\
Path to phan executable file.")

(make-variable-buffer-local 'php-project-phan-executable)

(put 'php-project-phan-executable 'safe-local-variable #'php-project--eval-bootstrap-scripts)

(defvar php-project-coding-style nil "\
Symbol value of the coding style of the project that PHP major mode refers to.

Typically it is `pear', `drupal', `wordpress', `symfony2' and `psr2'.")

(make-variable-buffer-local 'php-project-coding-style)

(put 'php-project-coding-style 'safe-local-variable #'symbolp)

(autoload 'php-project-get-bootstrap-scripts "php-mode/php-project" "\
Return list of bootstrap script.

\(fn)" nil nil)

(autoload 'php-project-get-root-dir "php-mode/php-project" "\
Return path to current PHP project.

\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "php-mode/php-project" '("php-project-")))

;;;***

;;;### (autoloads nil "psvn/psvn" "psvn/psvn.el" (21910 33729 748991
;;;;;;  459000))
;;; Generated autoloads from psvn/psvn.el

(autoload 'svn-checkout "psvn/psvn" "\
Run svn checkout REPOS-URL PATH.

\(fn REPOS-URL PATH)" t nil)
 (defalias 'svn-examine 'svn-status)

(autoload 'svn-status "psvn/psvn" "\
Examine the status of Subversion working copy in directory DIR.
If ARG is -, allow editing of the parameters. One could add -N to
run svn status non recursively to make it faster.
For every other non nil ARG pass the -u argument to `svn status', which
asks svn to connect to the repository and check to see if there are updates
there.

If there is no .svn directory, examine if there is CVS and run
`cvs-examine'. Otherwise ask if to run `dired'.

\(fn DIR &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "rainbow-mode/rainbow-mode" "rainbow-mode/rainbow-mode.el"
;;;;;;  (21910 33729 748991 459000))
;;; Generated autoloads from rainbow-mode/rainbow-mode.el

(autoload 'rainbow-mode "rainbow-mode/rainbow-mode" "\
Colorize strings that represent colors.
This will fontify with colors the string like \"#aabbcc\" or \"blue\".

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "sauron/sauron" "sauron/sauron.el" (21910 33729
;;;;;;  748991 459000))
;;; Generated autoloads from sauron/sauron.el

(autoload 'sauron-start "sauron/sauron" "\
Start sauron. If the optional parameter HIDDEN is non-nil,
don't show the sauron window.

\(fn &optional HIDDEN)" t nil)

(autoload 'sauron-start-hidden "sauron/sauron" "\
Start sauron, but don't show the window.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "scss-mode/scss-mode" "scss-mode/scss-mode.el"
;;;;;;  (22017 17772 297349 956000))
;;; Generated autoloads from scss-mode/scss-mode.el

(autoload 'scss-mode "scss-mode/scss-mode" "\
Major mode for editing SCSS files, http://sass-lang.com/
Special commands:
\\{scss-mode-map}

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

;;;***

;;;### (autoloads nil "second-sel/second-sel" "second-sel/second-sel.el"
;;;;;;  (21910 33729 748991 459000))
;;; Generated autoloads from second-sel/second-sel.el

(defvar secondary-selection-ring-max 60 "\
*Maximum length of `secondary-selection-ring'.
After the ring is maximally filled, adding a new element replaces the
oldest element.")

(custom-autoload 'secondary-selection-ring-max "second-sel/second-sel" t)

(defvar secondary-selection-yank-commands (if (boundp 'browse-kill-ring-yank-commands) browse-kill-ring-yank-commands '(yank icicle-yank-maybe-completing)) "\
*Commands that `yank-pop-commands' recognizes as yanking text.")

(custom-autoload 'secondary-selection-yank-commands "second-sel/second-sel" t)

(defvar secondary-selection-yank-secondary-commands '(mouse-yank-secondary secondary-dwim yank-secondary) "\
*Commands that yank the secondary selection.")

(custom-autoload 'secondary-selection-yank-secondary-commands "second-sel/second-sel" t)

(autoload 'secondary-dwim "second-sel/second-sel" "\
Do-What-I-Mean with the secondary selection.
Prefix arg:

 None: Yank secondary.
 Zero: Select secondary as region.
 > 0:  Move secondary to region.
 < 0:  Swap region and secondary.

Details:

No prefix arg: Yank the secondary selection at point.  Move point to
the end of the inserted text.  Leave mark where it was.

Zero arg: Select the secondary selection and pop to its buffer.

Non-zero arg: Move the secondary selection to this buffer's region.

Negative arg: Also go to where the secondary selection was and select
it as the region.  That is, swap the region and the secondary
selection.

\(fn ARG)" t nil)

(autoload 'yank-secondary "second-sel/second-sel" "\
Insert the secondary selection at point.
Moves point to the end of the inserted text.  Does not change mark.

Numeric prefix arg N means insert the Nth most recently yanked
secondary selection.  Plain `C-u' is the same as N=1.

You can also use `M-y' after this command to yank previous secondary
selections.  With no prefix arg, this always yanks the active
secondary selection (the one that is highlighted), not the last
selection yanked.

\(fn &optional ARG)" t nil)

(autoload 'isearch-yank-secondary "second-sel/second-sel" "\
Yank string from secondary-selection ring into search string.

\(fn)" t nil)

(autoload 'primary-to-secondary "second-sel/second-sel" "\
Make the region in the current buffer into the secondary selection.
Deactivate the region.  Do not move the cursor.

\(fn BEG END)" t nil)

(autoload 'secondary-swap-region "second-sel/second-sel" "\
Make the region into the secondary selection, and vice versa.
Pop to the buffer that has the secondary selection, and change it to
the region.  Leave behind the secondary selection in place of the
original buffer's region.

\(fn BEG END)" t nil)

(autoload 'secondary-to-primary "second-sel/second-sel" "\
Convert the secondary selection into the active region.
Select the secondary selection and pop to its buffer.

\(fn)" t nil)

(autoload 'yank-pop-commands "second-sel/second-sel" "\
`yank-pop' or `yank-pop-secondary', depending on previous command.
If previous command was a yank-secondary command, then
   `yank-pop-secondary'.
Else if previous command was a yank command, then `yank-pop'.
Else if `browse-kill-ring' is defined, then `browse-kill-ring'.
Suggestion: Bind this command to `M-y'.

\(fn &optional ARG)" t nil)

(autoload 'yank-pop-secondary "second-sel/second-sel" "\
Replace just-yanked secondary selection with a different one.
You can use this only immediately after a `yank-secondary' or a
`yank-pop-secondary'.

At such a time, the region contains a stretch of reinserted
previously-killed text.  `yank-pop-secondary' deletes that text and
inserts in its place a different stretch of killed text.

With no prefix argument, inserts the previous secondary selection.
With argument N, inserts the Nth previous (or Nth next, if negative).
The ring of secondary selections wraps around.

This command honors `yank-excluded-properties' and `yank-handler'.

\(fn &optional ARG)" t nil)

(autoload 'rotate-secondary-selection-yank-pointer "second-sel/second-sel" "\
Rotate the yanking point in the secondary selection ring.
With prefix arg, rotate that many kills forward or backward.

\(fn ARG)" t nil)

(autoload 'mouse-secondary-save-then-kill "second-sel/second-sel" "\
Extend or delete secondary selection and save in ring.
Adds the extended secondary selection to `secondary-selection-ring'.
Use this in a buffer where you have recently done `\\[mouse-start-secondary]'.
If you have already made a secondary selection in that buffer, this
command extends or retracts the selection to where you click.  If you
do this again in a different position, it extends or retracts again.
If you do this twice in the same position, it kills the selection.

\(fn CLICK)" t nil)

;;;***

;;;### (autoloads nil "smart-tabs-mode/smart-tabs-mode" "smart-tabs-mode/smart-tabs-mode.el"
;;;;;;  (22068 11712 450867 101000))
;;; Generated autoloads from smart-tabs-mode/smart-tabs-mode.el

(autoload 'smart-tabs-when "smart-tabs-mode/smart-tabs-mode" "\


\(fn CONDITION ADVICE-LIST)" nil t)

(put 'smart-tabs-when 'lisp-indent-function '1)

(autoload 'smart-tabs-create-advice-list "smart-tabs-mode/smart-tabs-mode" "\


\(fn ADVICE-LIST)" nil t)

(autoload 'smart-tabs-create-language-advice "smart-tabs-mode/smart-tabs-mode" "\
Create a cons cell containing the actions to take to enable
`smart-tabs-mode' for the language LANG. This usually involved enabling
`smart-tabs-mode' through `smart-tabs-mode-enable' and adding a lambda
function to the MODE-HOOK for the specified language. This macro
simplifies the creation of such a cons cell.

\(fn LANG MODE-HOOK ADVICE-LIST &rest BODY)" nil t)

(put 'smart-tabs-create-language-advice 'lisp-indent-function '2)

(autoload 'smart-tabs-mode "smart-tabs-mode/smart-tabs-mode" "\
Intelligently indent with tabs, align with spaces!

\(fn &optional ARG)" t nil)

(autoload 'smart-tabs-mode-enable "smart-tabs-mode/smart-tabs-mode" "\
Enable smart-tabs-mode.

\(fn)" nil nil)

(autoload 'smart-tabs-advice "smart-tabs-mode/smart-tabs-mode" "\


\(fn FUNCTION OFFSET)" nil t)

(autoload 'smart-tabs-insinuate "smart-tabs-mode/smart-tabs-mode" "\
Enable smart-tabs-mode for LANGUAGES.
LANGUAGES is a list of SYMBOL or NAME as defined in
'smart-tabs-insinuate-alist' alist or a language using standard named
indent function and indent level.

\(fn &rest LANGUAGES)" nil nil)

(autoload 'smart-tabs-add-language-support "smart-tabs-mode/smart-tabs-mode" "\
Add support for a language not already in the `smart-tabs-insinuate-alist'.

\(fn LANG MODE-HOOK ADVICE-LIST &rest BODY)" nil t)

(put 'smart-tabs-add-language-support 'lisp-indent-function '2)

;;;***

;;;### (autoloads nil "unbound/unbound" "unbound/unbound.el" (21910
;;;;;;  33729 752991 365000))
;;; Generated autoloads from unbound/unbound.el

(autoload 'describe-unbound-keys "unbound/unbound" "\
Display a list of unbound keystrokes of complexity no greater than MAX.
Keys are sorted by their complexity; `key-complexity' determines it.

\(fn MAX)" t nil)

;;;***

;;;### (autoloads nil "vcl-mode/vcl-mode" "vcl-mode/vcl-mode.el"
;;;;;;  (21910 33729 752991 365000))
;;; Generated autoloads from vcl-mode/vcl-mode.el

(let ((loads (get 'vcl 'custom-loads))) (if (member '"vcl-mode/vcl-mode" loads) nil (put 'vcl 'custom-loads (cons '"vcl-mode/vcl-mode" loads))))

(autoload 'vcl-mode "vcl-mode/vcl-mode" "\
Mode for Varnish Command Language

\(fn)" t nil)

;;;***

;;;### (autoloads nil "web-mode/web-mode" "web-mode/web-mode.el"
;;;;;;  (22126 49203 734108 423000))
;;; Generated autoloads from web-mode/web-mode.el

(autoload 'web-mode "web-mode/web-mode" "\
Major mode for editing web templates.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "wgrep/wgrep" "wgrep/wgrep.el" (21910 33729
;;;;;;  752991 365000))
;;; Generated autoloads from wgrep/wgrep.el

(autoload 'wgrep-setup "wgrep/wgrep" "\
Setup wgrep preparation.

\(fn)" nil nil)
(add-hook 'grep-setup-hook 'wgrep-setup)

;;;***

;;;### (autoloads nil "which-key/which-key" "which-key/which-key.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from which-key/which-key.el

(defvar which-key-mode nil "\
Non-nil if Which-Key mode is enabled.
See the `which-key-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `which-key-mode'.")

(custom-autoload 'which-key-mode "which-key/which-key" nil)

(autoload 'which-key-mode "which-key/which-key" "\
Toggle which-key-mode.

\(fn &optional ARG)" t nil)

(autoload 'which-key-setup-side-window-right "which-key/which-key" "\
Apply suggested settings for side-window that opens on right.

\(fn)" t nil)

(autoload 'which-key-setup-side-window-right-bottom "which-key/which-key" "\
Apply suggested settings for side-window that opens on right
if there is space and the bottom otherwise.

\(fn)" t nil)

(autoload 'which-key-setup-side-window-bottom "which-key/which-key" "\
Apply suggested settings for side-window that opens on
bottom.

\(fn)" t nil)

(autoload 'which-key-setup-minibuffer "which-key/which-key" "\
Apply suggested settings for minibuffer.
Do not use this setup if you use the paging commands. Instead use
`which-key-setup-side-window-bottom', which is nearly identical
but more functional.

\(fn)" t nil)

(autoload 'which-key-add-key-based-replacements "which-key/which-key" "\
Replace the description of KEY-SEQUENCE with REPLACEMENT.
KEY-SEQUENCE is a string suitable for use in `kbd'. REPLACEMENT
may either be a string, as in

\(which-key-add-key-based-replacements \"C-x 1\" \"maximize\")

a cons of two strings as in

\(which-key-add-key-based-replacements \"C-x 8\"
                                        '(\"unicode\" . \"Unicode keys\"))

or a function that takes a (KEY . BINDING) cons and returns a
replacement.

In the second case, the second string is used to provide a longer
name for the keys under a prefix.

MORE allows you to specifcy additional KEY REPLACEMENT pairs.  All
replacements are added to
`which-key-key-based-description-replacement-alist'.

\(fn KEY-SEQUENCE REPLACEMENT &rest MORE)" nil nil)

(autoload 'which-key-add-major-mode-key-based-replacements "which-key/which-key" "\
Functions like `which-key-add-key-based-replacements'.
The difference is that MODE specifies the `major-mode' that must
be active for KEY-SEQUENCE and REPLACEMENT (MORE contains
addition KEY-SEQUENCE REPLACEMENT pairs) to apply.

\(fn MODE KEY-SEQUENCE REPLACEMENT &rest MORE)" nil nil)

(autoload 'which-key-reload-key-sequence "which-key/which-key" "\
Simulate entering the key sequence KEY-SEQ.
KEY-SEQ should be a list of events as produced by
`listify-key-sequence'. If nil, KEY-SEQ defaults to
`which-key--current-key-list'. Any prefix arguments that were
used are reapplied to the new key sequence.

\(fn &optional KEY-SEQ)" nil nil)

(autoload 'which-key-show-standard-help "which-key/which-key" "\
Call the command in `which-key--prefix-help-cmd-backup'.
Usually this is `describe-prefix-bindings'.

\(fn &optional _)" t nil)

(autoload 'which-key-show-next-page-no-cycle "which-key/which-key" "\
Show next page of keys unless on the last page, in which case
call `which-key-show-standard-help'.

\(fn)" t nil)

(autoload 'which-key-show-previous-page-no-cycle "which-key/which-key" "\
Show previous page of keys unless on the first page, in which
case do nothing.

\(fn)" t nil)

(autoload 'which-key-show-next-page-cycle "which-key/which-key" "\
Show the next page of keys, cycling from end to beginning
after last page.

\(fn &optional _)" t nil)

(autoload 'which-key-show-previous-page-cycle "which-key/which-key" "\
Show the previous page of keys, cycling from beginning to end
after first page.

\(fn &optional _)" t nil)

(autoload 'which-key-show-top-level "which-key/which-key" "\
Show top-level bindings.

\(fn &optional _)" t nil)

(autoload 'which-key-show-major-mode "which-key/which-key" "\
Show top-level bindings in the map of the current major mode.

This function will also detect evil bindings made using
`evil-define-key' in this map. These bindings will depend on the
current evil state. 

\(fn)" t nil)

(autoload 'which-key-undo-key "which-key/which-key" "\
Undo last keypress and force which-key update.

\(fn &optional _)" t nil)

(autoload 'which-key-C-h-dispatch "which-key/which-key" "\
Dispatch C-h commands by looking up key in
`which-key-C-h-map'. This command is always accessible (from any
prefix) if `which-key-use-C-h-commands' is non nil.

\(fn)" t nil)

(autoload 'which-key-show-keymap "which-key/which-key" "\
Show the top-level bindings in KEYMAP using which-key. KEYMAP
is selected interactively from all available keymaps.

\(fn KEYMAP)" t nil)

(autoload 'which-key-show-full-keymap "which-key/which-key" "\
Show all bindings in KEYMAP using which-key. KEYMAP is
selected interactively from all available keymaps.

\(fn KEYMAP)" t nil)

(autoload 'which-key-show-minor-mode-keymap "which-key/which-key" "\
Show the top-level bindings in KEYMAP using which-key. KEYMAP
is selected interactively by mode in `minor-mode-map-alist'.

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "which-key/which-key" '(#("which-key-" 0 10 (fontified nil)))))

;;;***

;;;### (autoloads nil "winnow/winnow" "winnow/winnow.el" (23005 53170
;;;;;;  60126 770000))
;;; Generated autoloads from winnow/winnow.el

(autoload 'winnow-mode "winnow/winnow" "\
Filter compilation results by matching/excluding lines.

This is invaluable for excluding or limiting to matching `ag-mode' results.

\\{winnow-mode-map}

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "with-editor/with-editor" "with-editor/with-editor.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from with-editor/with-editor.el

(autoload 'with-editor-export-editor "with-editor/with-editor" "\
Teach subsequent commands to use current Emacs instance as editor.

Set and export the environment variable ENVVAR, by default
\"EDITOR\".  The value is automatically generated to teach
commands to use the current Emacs instance as \"the editor\".

This works in `shell-mode', `term-mode' and `eshell-mode'.

\(fn &optional (ENVVAR \"EDITOR\"))" t nil)

(autoload 'with-editor-export-git-editor "with-editor/with-editor" "\
Like `with-editor-export-editor' but always set `$GIT_EDITOR'.

\(fn)" t nil)

(autoload 'with-editor-export-hg-editor "with-editor/with-editor" "\
Like `with-editor-export-editor' but always set `$HG_EDITOR'.

\(fn)" t nil)

(defvar shell-command-with-editor-mode nil "\
Non-nil if Shell-Command-With-Editor mode is enabled.
See the `shell-command-with-editor-mode' command
for a description of this minor mode.")

(custom-autoload 'shell-command-with-editor-mode "with-editor/with-editor" nil)

(autoload 'shell-command-with-editor-mode "with-editor/with-editor" "\
Teach `shell-command' to use current Emacs instance as editor.

Teach `shell-command', and all commands that ultimately call that
command, to use the current Emacs instance as editor by executing
\"EDITOR=CLIENT COMMAND&\" instead of just \"COMMAND&\".

CLIENT is automatically generated; EDITOR=CLIENT instructs
COMMAND to use to the current Emacs instance as \"the editor\",
assuming no other variable overrides the effect of \"$EDITOR\".
CLIENT may be the path to an appropriate emacsclient executable
with arguments, or a script which also works over Tramp.

Alternatively you can use the `with-editor-async-shell-command',
which also allows the use of another variable instead of
\"EDITOR\".

\(fn &optional ARG)" t nil)

(autoload 'with-editor-async-shell-command "with-editor/with-editor" "\
Like `async-shell-command' but with `$EDITOR' set.

Execute string \"ENVVAR=CLIENT COMMAND\" in an inferior shell;
display output, if any.  With a prefix argument prompt for an
environment variable, otherwise the default \"EDITOR\" variable
is used.  With a negative prefix argument additionally insert
the COMMAND's output at point.

CLIENT is automatically generated; ENVVAR=CLIENT instructs
COMMAND to use to the current Emacs instance as \"the editor\",
assuming it respects ENVVAR as an \"EDITOR\"-like variable.
CLIENT may be the path to an appropriate emacsclient executable
with arguments, or a script which also works over Tramp.

Also see `async-shell-command' and `shell-command'.

\(fn COMMAND &optional OUTPUT-BUFFER ERROR-BUFFER ENVVAR)" t nil)

(autoload 'with-editor-shell-command "with-editor/with-editor" "\
Like `shell-command' or `with-editor-async-shell-command'.
If COMMAND ends with \"&\" behave like the latter,
else like the former.

\(fn COMMAND &optional OUTPUT-BUFFER ERROR-BUFFER ENVVAR)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "with-editor/with-editor" '("with-editor" "start-file-process--with-editor-process-filter" "server-" "shell-command--shell-command-with-editor-mode")))

;;;***

;;;### (autoloads nil "ws-trim/ws-trim" "ws-trim/ws-trim.el" (22168
;;;;;;  21846 835944 629000))
;;; Generated autoloads from ws-trim/ws-trim.el

(defvar ws-trim-method-hook '(ws-trim-leading ws-trim-trailing) "\
*The kind of trimming done by the WS Trim mode and functions.
A single or a list of functions which are run on each line that's
getting trimmed.  Supplied trim functions:

`ws-trim-trailing'        Delete trailing whitespace.
`ws-trim-leading-spaces'  Replace unnecessary leading spaces with tabs.
`ws-trim-leading-tabs'    Replace leading tabs with spaces.
`ws-trim-leading'         Replace leading tabs or spaces according to
                          `indent-tabs-mode'.  If it's nil, leading
                          tabs are replaced with spaces, otherwise
                          it's the other way around.
`ws-trim-tabs'            Replace all tabs with spaces.

This is a perfectly normal hook run by `run-hooks' and custom
functions can of course be used.  There's no inherent restriction to
just whitespace trimming either, for that matter.  Each function
should modify the current line and leave point somewhere on it.")

(autoload 'ws-trim-line "ws-trim/ws-trim" "\
Trim whitespace on the current line.
Do this according to the hook `ws-trim-method-hook'.  With a prefix
argument, ask for the trim method to use instead.

\(fn ARG)" t nil)

(autoload 'ws-trim-region "ws-trim/ws-trim" "\
Trim whitespace on each line in the region.
Do this according to the hook `ws-trim-method-hook'.  With a prefix
argument, ask for the trim method to use instead.

\(fn ARG)" t nil)

(autoload 'ws-trim-buffer "ws-trim/ws-trim" "\
Trim whitespace on each line in the buffer.
Do this according to the hook `ws-trim-method-hook'.  With a prefix
argument, ask for the trim method to use instead.

\(fn ARG)" t nil)

(defvar ws-trim-mode nil "\
If non-nil, WS Trim mode is active.
This mode automatically trims whitespace on text lines.  The kind of
trimming is specified by the hook `ws-trim-method-hook'.  You can
either trim every line in the buffer or just the lines you edit
manually, see the variable `ws-trim-level' for details.  This mode
runs the hook `ws-trim-mode-hook' when activated.

Please note that there are other common functions, e.g. `indent-to',
`newline-and-indent' (often bound to LFD or RET), `fill-paragraph',
and the variable `indent-tabs-mode', that also trims whitespace in
various circumstances.  They are entirely independent of this mode.

To automatically enable WS Trim mode in any major mode, put
`turn-on-ws-trim' in the major mode's hook, e.g. in your .emacs:

  (add-hook 'emacs-lisp-mode-hook 'turn-on-ws-trim)

You can also activate WS Trim mode automagically in all modes where
it's likely to be useful by putting the following in .emacs:

  (global-ws-trim-mode t)

Exactly when WS Trim is activated are by default controlled by a
heuristic, see the function `ws-trim-mode-heuristic' for details.  You
can get more control over the process through the variable
`global-ws-trim-modes'.

This variable automatically becomes buffer local when modified.  It
should not be set directly; use the commands `ws-trim-mode' or
`turn-on-ws-trim' instead.")

(defvar ws-trim-level 0 "\
*How thorough automatic whitespace trimming should be in WS Trim mode.
If 3 or greater, all lines in the buffer are kept trimmed at all
times (if the buffer is modifiable).
If 2, all lines in the buffer are trimmed when the buffer is modified
for the first time.
If 1, only modified lines are trimmed.
If 0, only single modified lines are trimmed, i.e. operations that
modify more than one line don't cause any trimming (newline is an
exception).

The current line is never trimmed on any level, unless the buffer is
about to be written.  In that case the current line is treated as any
other line.

The default level is 0, which is very restrictive.  This is
particularly useful when you edit files which are compared with diff
\(e.g. for patches), because parts that you don't change manually are
kept unchanged.  You can also do block operations over several lines
without risking strange side effects (e.g. paste patches into mails).

This variable automatically becomes buffer local when changed.  Use
the function `set-default' to set the value it defaults to in all new
buffers.  If you want even more control it's best to put a suitable
function onto `ws-trim-mode-hook'.  Changes of `ws-trim-level' might
not take effect immediately; it's best set when the mode is
initialized.")

(defvar ws-trim-mode-line-string " Trim" "\
*Modeline string for WS Trim mode.
Set to nil to remove the modeline indicator for ws-trim.")

(defvar ws-trim-mode-hook nil "\
A normal hook which is run when WS Trim mode is turned on.
This hook is run by `run-hooks' and can therefore be buffer local.

Some care might be necessary when putting functions on this hook due
to the somewhat strange circumstances under which it's run.
Specifically, anything put here might indirectly be run from
`post-command-hook' or `find-file-hooks'.  Don't worry about it if you
just want to do something simple, e.g. setting some variables.")

(autoload 'turn-on-ws-trim "ws-trim/ws-trim" "\
Unconditionally turn on WS Trim mode.
See the variable `ws-trim-mode' for further info on this mode.

\(fn)" t nil)

(autoload 'ws-trim-mode "ws-trim/ws-trim" "\
Toggle WS Trim mode, which automatically trims whitespace on lines.
A positive prefix argument turns the mode on, any other prefix turns
it off.

See the variable docstring for details about this mode.

\(fn &optional ARG)" t nil)

(defvar global-ws-trim-mode nil "\
If non-nil, automagically turn on WS Trim mode in many major modes.
How it's done is controlled by the variable `ws-trim-global-modes'.

This variable should not be changed directly; use the command
`global-ws-trim-mode' instead.")

(defvar ws-trim-global-modes 'guess "\
*Controls which major modes should have WS Trim mode turned on.
Global WS Trim mode must first be activated, which is done by the
command `global-ws-trim-mode'.

If nil, no modes turn on WS Trim mode.
If t, all modes turn on WS Trim mode.
If `guess', then a heuristic is used to determine whether WS Trim mode
should be activated in the mode in question.  See
`ws-trim-mode-heuristic' for details.
If a list, then all modes whose `major-mode' symbol names matches some
entry in it turn on WS Trim mode.
If a list begins with `not', all modes but the ones mentioned turn on
WS Trim mode.
If a list begins with `guess', then the remaining elements must in
turn be lists as above.  All modes not specified in any of these lists
will use the heuristic.  E.g:

  (setq ws-trim-global-modes '(guess (Info-mode) (not c-mode c++-mode)))

turns on WS Trim in Info-mode (God knows why), off in C mode and
C++ mode, and uses the heuristic for all other modes.")

(autoload 'global-ws-trim-mode "ws-trim/ws-trim" "\
Toggle Global WS Trim mode.
A positive prefix argument turns the mode on, any other prefix turns
it off.

When this mode is active, WS Trim mode is automagically turned on or
off in buffers depending on their major modes.  The behavior is
controlled by the `ws-trim-global-modes' variable.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "zenburn-theme/zenburn-theme" "zenburn-theme/zenburn-theme.el"
;;;;;;  (22323 6417 469634 984000))
;;; Generated autoloads from zenburn-theme/zenburn-theme.el

(and load-file-name (boundp 'custom-theme-load-path) (add-to-list 'custom-theme-load-path (file-name-as-directory (file-name-directory load-file-name))))

;;;***

;;;### (autoloads nil "ztree-diff/ztree-diff" "ztree-diff/ztree-diff.el"
;;;;;;  (21910 33729 756991 272000))
;;; Generated autoloads from ztree-diff/ztree-diff.el

(autoload 'ztreediff-mode "ztree-diff/ztree-diff" "\
A minor mode for displaying the difference of the directory trees in text mode.

\(fn &optional ARG)" t nil)

(autoload 'ztree-diff "ztree-diff/ztree-diff" "\
Creates an interactive buffer with the directory tree of the path given

\(fn DIR1 DIR2)" t nil)

;;;***

;;;### (autoloads nil "ztree-diff/ztree-dir" "ztree-diff/ztree-dir.el"
;;;;;;  (21910 33729 756991 272000))
;;; Generated autoloads from ztree-diff/ztree-dir.el

(autoload 'ztree-dir "ztree-diff/ztree-dir" "\
Creates an interactive buffer with the directory tree of the path given

\(fn PATH)" t nil)

;;;***

;;;### (autoloads nil "ztree-diff/ztree-view" "ztree-diff/ztree-view.el"
;;;;;;  (21910 33729 756991 272000))
;;; Generated autoloads from ztree-diff/ztree-view.el

(autoload 'ztree-mode "ztree-diff/ztree-view" "\
A major mode for displaying the directory tree in text mode.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("async/async-pkg.el" "magit/lisp/magit-autoloads.el"
;;;;;;  "magit/lisp/magit-core.el" "magit/lisp/magit-obsolete.el"
;;;;;;  "magit/lisp/magit-pkg.el") (0 0 0 0))

;;;***

(provide '.loaddefs)
;; Local Variables:
;; version-control: never
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; .loaddefs.el ends here
