;;; .loaddefs.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "ace-jump-mode/ace-jump-mode" "ace-jump-mode/ace-jump-mode.el"
;;;;;;  (21349 56931 539320 380000))
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
;;;;;;  (21349 57592 396410 124000))
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

;;;### (autoloads nil "async/async" "async/async.el" (21982 28769
;;;;;;  105174 438000))
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
return value form the child process, pass the `ignore' symbol as
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

\(fn START-FUNC &optional FINISH-FUNC)" nil t)

;;;***

;;;### (autoloads nil "async/async-bytecomp" "async/async-bytecomp.el"
;;;;;;  (21982 28769 105174 438000))
;;; Generated autoloads from async/async-bytecomp.el

(autoload 'async-byte-recompile-directory "async/async-bytecomp" "\
Compile all *.el files in DIRECTORY asynchronously.
All *.elc files are systematically deleted before proceeding.

\(fn DIRECTORY &optional QUIET)" nil nil)

(defvar async-bytecomp-package-mode nil "\
Non-nil if Async-Bytecomp-Package mode is enabled.
See the command `async-bytecomp-package-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `async-bytecomp-package-mode'.")

(custom-autoload 'async-bytecomp-package-mode "async/async-bytecomp" nil)

(autoload 'async-bytecomp-package-mode "async/async-bytecomp" "\
Byte compile asynchronously packages installed with package.el.
Async compilation of packages can be controlled by
`async-bytecomp-allowed-packages'.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "async/dired-async" "async/dired-async.el"
;;;;;;  (21982 28769 105174 438000))
;;; Generated autoloads from async/dired-async.el

(defvar dired-async-mode nil "\
Non-nil if Dired-Async mode is enabled.
See the command `dired-async-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `dired-async-mode'.")

(custom-autoload 'dired-async-mode "async/dired-async" nil)

(autoload 'dired-async-mode "async/dired-async" "\
Do dired actions asynchronously.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "auto-compile/auto-compile" "auto-compile/auto-compile.el"
;;;;;;  (21128 51479 921843 213000))
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

;;;### (autoloads nil "delight/delight" "delight/delight.el" (21384
;;;;;;  30628 654909 885000))
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
the mode symbol is passed as the required feature. Both of these cases are
relevant to minor modes only.

For major modes you should specify the keyword :major as the value of FILE,
to prevent the mode being treated as a minor mode.

\(fn SPEC &optional VALUE FILE)" nil nil)

;;;***

;;;### (autoloads (dtrt-indent-mode dtrt-indent-mode) "dtrt-indent/dtrt-indent"
;;;;;;  "dtrt-indent/dtrt-indent.el" (20935 32282 720228 681000))
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

;;;### (autoloads (ediff-trees) "ediff-trees/ediff-trees" "ediff-trees/ediff-trees.el"
;;;;;;  (20935 32281 984228 683000))
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

;;;### (autoloads (fic-mode) "fic-mode/fic-mode" "fic-mode/fic-mode.el"
;;;;;;  (21346 60917 583825 761000))
;;; Generated autoloads from fic-mode/fic-mode.el

(autoload 'fic-mode "fic-mode/fic-mode" "\
Fic mode -- minor mode for highlighting FIXME/TODO in comments

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads (find-file-in-tags ffit-determine-dir-for-current-file)
;;;;;;  "find-file-in-tags/find-file-in-tags" "find-file-in-tags/find-file-in-tags.el"
;;;;;;  (20587 44126))
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

;;;### (autoloads (dbgp-proxy-unregister-exec dbgp-proxy-unregister
;;;;;;  dbgp-proxy-register-exec dbgp-proxy-register dbgp-exec dbgp-start)
;;;;;;  "geben/dbgp" "geben/dbgp.el" (20289 32888))
;;; Generated autoloads from geben/dbgp.el

(autoload 'dbgp-start "geben/dbgp" "\
Start a new DBGp listener listening to PORT.

\(fn PORT)" t nil)

(autoload 'dbgp-exec "geben/dbgp" "\
Start a new DBGp listener listening to PORT.

\(fn PORT &rest SESSION-PARAMS)" nil nil)

(autoload 'dbgp-proxy-register "geben/dbgp" "\
Register a new DBGp listener to an external DBGp proxy.
The proxy should be found at PROXY-IP-OR-ADDR / PROXY-PORT.
This creates a new DBGp listener and register it to the proxy
associating with the IDEKEY.

\(fn PROXY-IP-OR-ADDR PROXY-PORT IDEKEY MULTI-SESSION-P &optional SESSION-PORT)" t nil)

(autoload 'dbgp-proxy-register-exec "geben/dbgp" "\
Register a new DBGp listener to an external DBGp proxy.
The proxy should be found at IP-OR-ADDR / PORT.
This create a new DBGp listener and register it to the proxy
associating with the IDEKEY.

\(fn IP-OR-ADDR PORT IDEKEY MULTI-SESSION-P SESSION-PORT &rest SESSION-PARAMS)" nil nil)

(autoload 'dbgp-proxy-unregister "geben/dbgp" "\
Unregister the DBGp listener associated with IDEKEY from a DBGp proxy.
After unregistration, it kills the listener instance.

\(fn IDEKEY &optional PROXY-IP-OR-ADDR PROXY-PORT)" t nil)

(autoload 'dbgp-proxy-unregister-exec "geben/dbgp" "\
Unregister PROXY from a DBGp proxy.
After unregistration, it kills the listener instance.

\(fn PROXY)" nil nil)

;;;***

;;;### (autoloads (deft) "deft/deft" "deft/deft.el" (20289 32888))
;;; Generated autoloads from deft/deft.el

(autoload 'deft "deft/deft" "\
Switch to *Deft* buffer and load files.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "ediff-binary-hexl/ediff-binary-hexl" "ediff-binary-hexl/ediff-binary-hexl.el"
;;;;;;  (20289 32888))
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

;;;### (autoloads (find-file-in-project) "ffip/find-file-in-project"
;;;;;;  "ffip/find-file-in-project.el" (21346 5180 344357 317000))
;;; Generated autoloads from ffip/find-file-in-project.el

(autoload 'find-file-in-project "ffip/find-file-in-project" "\
Prompt with a completing list of all files in the project to find one.

The project's scope is defined as the first directory containing
an `.emacs-project' file. You can override this by locally
setting the `ffip-project-root' variable.

\(fn)" t nil)

;;;***

;;;### (autoloads (git-commit-mode) "git-modes/git-commit-mode" "git-modes/git-commit-mode.el"
;;;;;;  (21346 60918 155825 758000))
;;; Generated autoloads from git-modes/git-commit-mode.el

(autoload 'git-commit-mode "git-modes/git-commit-mode" "\
Major mode for editing git commit messages.

This mode helps with editing git commit messages both by
providing commands to do common tasks, and by highlighting the
basic structure of and errors in git commit messages.

\(fn)" t nil)

(dolist (pattern '("/COMMIT_EDITMSG\\'" "/NOTES_EDITMSG\\'" "/MERGE_MSG\\'" "/TAG_EDITMSG\\'" "/PULLREQ_EDITMSG\\'")) (add-to-list 'auto-mode-alist (cons pattern 'git-commit-mode)))

;;;***

;;;### (autoloads (git-rebase-mode) "git-modes/git-rebase-mode" "git-modes/git-rebase-mode.el"
;;;;;;  (21346 60918 155825 758000))
;;; Generated autoloads from git-modes/git-rebase-mode.el

(autoload 'git-rebase-mode "git-modes/git-rebase-mode" "\
Major mode for editing of a Git rebase file.

Rebase files are generated when you run 'git rebase -i' or run
`magit-interactive-rebase'.  They describe how Git should perform
the rebase.  See the documentation for git-rebase (e.g., by
running 'man git-rebase' at the command line) for details.

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("/git-rebase-todo\\'" . git-rebase-mode))

;;;***

;;;### (autoloads (gitattributes-mode) "git-modes/gitattributes-mode"
;;;;;;  "git-modes/gitattributes-mode.el" (21346 60918 159825 759000))
;;; Generated autoloads from git-modes/gitattributes-mode.el

(autoload 'gitattributes-mode "git-modes/gitattributes-mode" "\
A major mode for editing .gitattributes files.
\\{gitattributes-mode-map}

\(fn)" t nil)

(dolist (pattern '("/\\.gitattributes\\'" "/\\.git/info/attributes\\'" "/git/attributes\\'")) (add-to-list 'auto-mode-alist (cons pattern #'gitattributes-mode)))

;;;***

;;;### (autoloads (gitconfig-mode) "git-modes/gitconfig-mode" "git-modes/gitconfig-mode.el"
;;;;;;  (21346 60918 159825 759000))
;;; Generated autoloads from git-modes/gitconfig-mode.el

(autoload 'gitconfig-mode "git-modes/gitconfig-mode" "\
A major mode for editing .gitconfig files.

\(fn)" t nil)

(dolist (pattern '("/\\.gitconfig\\'" "/\\.git/config\\'" "/git/config\\'" "/\\.gitmodules\\'")) (add-to-list 'auto-mode-alist (cons pattern 'gitconfig-mode)))

;;;***

;;;### (autoloads (gitignore-mode) "git-modes/gitignore-mode" "git-modes/gitignore-mode.el"
;;;;;;  (21346 60918 159825 759000))
;;; Generated autoloads from git-modes/gitignore-mode.el

(autoload 'gitignore-mode "git-modes/gitignore-mode" "\
A major mode for editing .gitignore files.

\(fn)" t nil)

(dolist (pattern (list "/\\.gitignore\\'" "/\\.git/info/exclude\\'" "/git/ignore\\'")) (add-to-list 'auto-mode-alist (cons pattern 'gitignore-mode)))

;;;***

;;;### (autoloads (iedit-mode) "iedit/iedit" "iedit/iedit.el" (20289
;;;;;;  32888))
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
;;;;;;  (21140 36471 866143 792000))
;;; Generated autoloads from image-dimensions-minor-mode/image-dimensions-minor-mode.el

(autoload 'image-dimensions-minor-mode "image-dimensions-minor-mode/image-dimensions-minor-mode" "\
Displays the image dimensions in the mode line.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads (jump-char-backward jump-char-forward) "jump-char/jump-char"
;;;;;;  "jump-char/jump-char.el" (20935 42616 504202 907000))
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

;;;### (autoloads (lexbind-mode lexbind-modeline-content lexbind-lexscratch
;;;;;;  lexbind-toggle-lexical-binding) "lexbind-mode/lexbind-mode"
;;;;;;  "lexbind-mode/lexbind-mode.el" (20935 32281 984228 683000))
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

;;;### (autoloads (key-chord-define key-chord-define-global key-chord-mode)
;;;;;;  "key-chord/key-chord" "key-chord/key-chord.el" (20935 32281
;;;;;;  984228 683000))
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

;;;### (autoloads (macrostep-expand macrostep-mode) "macrostep/macrostep"
;;;;;;  "macrostep/macrostep.el" (21620 4491 312635 949000))
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

;;;### (autoloads (mc/edit-beginnings-of-lines mc/edit-ends-of-lines
;;;;;;  mc/edit-lines) "multiple-cursors/mc-edit-lines" "multiple-cursors/mc-edit-lines.el"
;;;;;;  (20802 24771 412829 899000))
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

;;;### (autoloads (mc/mark-sgml-tag-pair mc/add-cursor-on-click mc/mark-all-symbols-like-this-in-defun
;;;;;;  mc/mark-all-words-like-this-in-defun mc/mark-all-like-this-in-defun
;;;;;;  mc/mark-all-like-this-dwim mc/mark-more-like-this-extended
;;;;;;  mc/mark-all-in-region mc/mark-all-symbols-like-this mc/mark-all-words-like-this
;;;;;;  mc/mark-all-like-this mc/skip-to-previous-like-this mc/skip-to-next-like-this
;;;;;;  mc/unmark-previous-like-this mc/unmark-next-like-this mc/mark-previous-lines
;;;;;;  mc/mark-next-lines mc/mark-previous-symbol-like-this mc/mark-previous-word-like-this
;;;;;;  mc/mark-previous-like-this mc/mark-next-symbol-like-this
;;;;;;  mc/mark-next-word-like-this mc/mark-next-like-this) "multiple-cursors/mc-mark-more"
;;;;;;  "multiple-cursors/mc-mark-more.el" (20935 34277 528223 706000))
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

;;;### (autoloads (set-rectangular-region-anchor) "multiple-cursors/rectangular-region-mode"
;;;;;;  "multiple-cursors/rectangular-region-mode.el" (20802 24771
;;;;;;  412829 899000))
;;; Generated autoloads from multiple-cursors/rectangular-region-mode.el

(autoload 'set-rectangular-region-anchor "multiple-cursors/rectangular-region-mode" "\
Anchors the rectangular region at point.

Think of this one as `set-mark' except you're marking a rectangular region. It is
an exceedingly quick way of adding multiple cursors to multiple lines.

\(fn)" t nil)

;;;***

;;;### (autoloads (php-eldoc-function) "php-eldoc/php-eldoc" "php-eldoc/php-eldoc.el"
;;;;;;  (20935 32282 20228 681000))
;;; Generated autoloads from php-eldoc/php-eldoc.el

(autoload 'php-eldoc-function "php-eldoc/php-eldoc" "\
Get function arguments for PHP function at point.

\(fn)" nil nil)

(add-hook 'php+-mode-hook '(lambda nil (set (make-local-variable 'eldoc-documentation-function) 'php-eldoc-function) (eldoc-mode)))

(add-hook 'php-mode-hook '(lambda nil (set (make-local-variable 'eldoc-documentation-function) 'php-eldoc-function) (eldoc-mode)))

;;;***

;;;### (autoloads (php-extras-generate-eldoc) "php-eldoc/php-extras-gen-eldoc"
;;;;;;  "php-eldoc/php-extras-gen-eldoc.el" (20935 32282 24228 681000))
;;; Generated autoloads from php-eldoc/php-extras-gen-eldoc.el

(autoload 'php-extras-generate-eldoc "php-eldoc/php-extras-gen-eldoc" "\
Regenerate PHP function argument hash table from php.net. This is slow!

\(fn)" t nil)

;;;***

;;;### (autoloads (rainbow-delimiters-mode) "rainbow-delimiters/rainbow-delimiters"
;;;;;;  "rainbow-delimiters/rainbow-delimiters.el" (20289 32888))
;;; Generated autoloads from rainbow-delimiters/rainbow-delimiters.el

(autoload 'rainbow-delimiters-mode "rainbow-delimiters/rainbow-delimiters" "\
Color nested parentheses, brackets, and braces according to their depth.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads (geben geben-mode) "geben/geben" "geben/geben.el"
;;;;;;  (20289 32888))
;;; Generated autoloads from geben/geben.el

(autoload 'geben-mode "geben/geben" "\
Minor mode for debugging source code with GEBEN.
The geben-mode buffer commands:
\\{geben-mode-map}

\(fn &optional ARG)" t nil)

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

;;;***

;;;### (autoloads (keep-buffers-query) "keep-buffers/keep-buffers"
;;;;;;  "keep-buffers/keep-buffers.el" (20289 32888))
;;; Generated autoloads from keep-buffers/keep-buffers.el

(autoload 'keep-buffers-query "keep-buffers/keep-buffers" "\
The query function that disable deletion of buffers we protect.

\(fn)" nil nil)

;;;***

;;;### (autoloads nil "magit/lisp/git-commit" "magit/lisp/git-commit.el"
;;;;;;  (21982 32429 187605 266000))
;;; Generated autoloads from magit/lisp/git-commit.el

(defvar global-git-commit-mode t "\
Non-nil if Global-Git-Commit mode is enabled.
See the command `global-git-commit-mode' for a description of this minor mode.
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

;;;***

;;;### (autoloads nil "magit/lisp/git-rebase" "magit/lisp/git-rebase.el"
;;;;;;  (21982 32429 187605 266000))
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

;;;***

;;;### (autoloads nil "magit/lisp/magit" "magit/lisp/magit.el" (21982
;;;;;;  32429 199605 474000))
;;; Generated autoloads from magit/lisp/magit.el

(autoload 'magit-status "magit/lisp/magit" "\
Show the status of the current Git repository in a buffer.
With a prefix argument prompt for a repository to be shown.
With two prefix arguments prompt for an arbitrary directory.
If that directory isn't the root of an existing repository
then offer to initialize it as a new repository.

\(fn &optional DIRECTORY)" t nil)

(autoload 'magit-status-internal "magit/lisp/magit" "\


\(fn DIRECTORY &optional SWITCH-FUNCTION)" nil nil)
 (autoload 'magit-show-refs-popup "magit" nil t)

(autoload 'magit-show-refs-head "magit/lisp/magit" "\
List and compare references in a dedicated buffer.
Refs are compared with `HEAD'.

\(fn &optional ARGS)" t nil)

(autoload 'magit-show-refs-current "magit/lisp/magit" "\
List and compare references in a dedicated buffer.
Refs are compared with the current branch or `HEAD' if
it is detached.

\(fn &optional ARGS)" t nil)

(autoload 'magit-show-refs "magit/lisp/magit" "\
List and compare references in a dedicated buffer.
Refs are compared with a branch read form the user.

\(fn &optional REF ARGS)" t nil)

(autoload 'magit-find-file "magit/lisp/magit" "\
View FILE from REV.
Switch to a buffer visiting blob REV:FILE,
creating one if none already exists.

\(fn REV FILE)" t nil)

(autoload 'magit-find-file-other-window "magit/lisp/magit" "\
View FILE from REV, in another window.
Like `magit-find-file', but create a new window or reuse an
existing one.

\(fn REV FILE)" t nil)

(autoload 'magit-dired-jump "magit/lisp/magit" "\
Visit file at point using Dired.
With a prefix argument, visit in other window.  If there
is no file at point then instead visit `default-directory'.

\(fn &optional OTHER-WINDOW)" t nil)

(autoload 'magit-init "magit/lisp/magit" "\
Initialize a Git repository, then show its status.

If the directory is below an existing repository, then the user
has to confirm that a new one should be created inside.  If the
directory is the root of the existing repository, then the user
has to confirm that it should be reinitialized.

Non-interactively DIRECTORY is (re-)initialized unconditionally.

\(fn DIRECTORY)" t nil)
 (autoload 'magit-branch-popup "magit" nil t)

(autoload 'magit-checkout "magit/lisp/magit" "\
Checkout REVISION, updating the index and the working tree.
If REVISION is a local branch then that becomes the current
branch.  If it is something else then `HEAD' becomes detached.
Checkout fails if the working tree or the staging area contain
changes.

\(git checkout REVISION).

\(fn REVISION)" t nil)

(autoload 'magit-branch-and-checkout "magit/lisp/magit" "\
Create and checkout BRANCH at branch or revision START-POINT.

\(git checkout [ARGS] -b BRANCH START-POINT).

\(fn BRANCH START-POINT &optional ARGS)" t nil)

(autoload 'magit-branch-delete "magit/lisp/magit" "\
Delete one or multiple branches.
If the region marks multiple branches, then offer to delete
those, otherwise prompt for a single branch to be deleted,
defaulting to the branch at point.

\(fn BRANCHES &optional FORCE)" t nil)

(autoload 'magit-branch-set-upstream "magit/lisp/magit" "\
Change the UPSTREAM branch of BRANCH.

\(fn BRANCH UPSTREAM)" t nil)

(autoload 'magit-branch-unset-upstream "magit/lisp/magit" "\
Unset the upstream branch of BRANCH.

\(fn BRANCH)" t nil)

(autoload 'magit-branch-rename "magit/lisp/magit" "\
Rename branch OLD to NEW.
With prefix, forces the rename even if NEW already exists.

\(git branch -m|-M OLD NEW).

\(fn OLD NEW &optional FORCE)" t nil)

(autoload 'magit-branch-edit-description "magit/lisp/magit" "\
Edit the description of BRANCH.

\(fn BRANCH)" t nil)
 (autoload 'magit-merge-popup "magit" nil t)

(autoload 'magit-merge "magit/lisp/magit" "\
Merge commit REV into the current branch; using default message.

Unless there are conflicts or a prefix argument is used create a
merge commit using a generic commit message and without letting
the user inspect the result.  With a prefix argument pretend the
merge failed to give the user the opportunity to inspect the
merge.

\(git merge --no-edit|--no-commit [ARGS] REV)

\(fn REV &optional ARGS NOCOMMIT)" t nil)

(autoload 'magit-merge-editmsg "magit/lisp/magit" "\
Merge commit REV into the current branch; and edit message.
Perform the merge and prepare a commit message but let the user
edit it.

\(git merge --edit [ARGS] rev)

\(fn REV &optional ARGS)" t nil)

(autoload 'magit-merge-nocommit "magit/lisp/magit" "\
Merge commit REV into the current branch; pretending it failed.
Pretend the merge failed to give the user the opportunity to
inspect the merge and change the commit message.

\(git merge --no-commit [ARGS] rev)

\(fn REV &optional ARGS)" t nil)

(autoload 'magit-merge-preview "magit/lisp/magit" "\
Preview result of merging REV into the current branch.

\(fn REV)" t nil)

(autoload 'magit-merge-abort "magit/lisp/magit" "\
Abort the current merge operation.

\(git merge --abort)

\(fn)" t nil)

(autoload 'magit-reset-index "magit/lisp/magit" "\
Reset the index to COMMIT.
Keep the head and working tree as-is, so if COMMIT refers to the
head this effectivley unstages all changes.

\(git reset COMMIT)

\(fn COMMIT)" t nil)

(autoload 'magit-reset "magit/lisp/magit" "\
Reset the head and index to COMMIT, but not the working tree.
With a prefix argument also reset the working tree.

\(git reset --mixed|--hard COMMIT)

\(fn COMMIT &optional HARD)" t nil)

(autoload 'magit-reset-head "magit/lisp/magit" "\
Reset the head and index to COMMIT, but not the working tree.

\(git reset --mixed COMMIT)

\(fn COMMIT)" t nil)

(autoload 'magit-reset-soft "magit/lisp/magit" "\
Reset the head to COMMIT, but not the index and working tree.

\(git reset --soft REVISION)

\(fn COMMIT)" t nil)

(autoload 'magit-reset-hard "magit/lisp/magit" "\
Reset the head, index, and working tree to COMMIT.

\(git reset --hard REVISION)

\(fn COMMIT)" t nil)
 (autoload 'magit-tag-popup "magit" nil t)

(autoload 'magit-tag "magit/lisp/magit" "\
Create a new tag with the given NAME at REV.
With a prefix argument annotate the tag.

\(git tag [--annotate] NAME REV)

\(fn NAME REV &optional ARGS)" t nil)

(autoload 'magit-tag-delete "magit/lisp/magit" "\
Delete one or more tags.
If the region marks multiple tags (and nothing else), then offer
to delete those, otherwise prompt for a single tag to be deleted,
defaulting to the tag at point.

\(git tag -d TAGS)

\(fn TAGS)" t nil)
 (autoload 'magit-notes-popup "magit" nil t)
 (autoload 'magit-submodule-popup "magit" nil t)

(autoload 'magit-submodule-add "magit/lisp/magit" "\
Add the repository at URL as a submodule.
Optional PATH is the path to the submodule relative to the root
of the superproject. If it is nil then the path is determined
based on URL.

\(fn URL &optional PATH)" t nil)

(autoload 'magit-submodule-setup "magit/lisp/magit" "\
Clone and register missing submodules and checkout appropriate commits.

\(fn)" t nil)

(autoload 'magit-submodule-init "magit/lisp/magit" "\
Register submodules listed in \".gitmodules\" into \".git/config\".

\(fn)" t nil)

(autoload 'magit-submodule-update "magit/lisp/magit" "\
Clone missing submodules and checkout appropriate commits.
With a prefix argument also register submodules in \".git/config\".

\(fn &optional INIT)" t nil)

(autoload 'magit-submodule-sync "magit/lisp/magit" "\
Update each submodule's remote URL according to \".gitmodules\".

\(fn)" t nil)

(autoload 'magit-submodule-fetch "magit/lisp/magit" "\
Fetch all submodules.
With a prefix argument fetch all remotes.

\(fn &optional ALL)" t nil)

(autoload 'magit-submodule-deinit "magit/lisp/magit" "\
Unregister the submodule at PATH.

\(fn PATH)" t nil)

(defvar global-magit-file-buffer-mode nil "\
Non-nil if Global-Magit-File-Buffer mode is enabled.
See the command `global-magit-file-buffer-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-magit-file-buffer-mode'.")

(custom-autoload 'global-magit-file-buffer-mode "magit/lisp/magit" nil)

(autoload 'global-magit-file-buffer-mode "magit/lisp/magit" "\
Toggle Magit-File-Buffer mode in all buffers.
With prefix ARG, enable Global-Magit-File-Buffer mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Magit-File-Buffer mode is enabled in all buffers where
`magit-file-buffer-mode-turn-on' would do it.
See `magit-file-buffer-mode' for more information on Magit-File-Buffer mode.

\(fn &optional ARG)" t nil)
 (autoload 'magit-dispatch-popup "magit" nil t)
 (autoload 'magit-run-popup "magit" nil t)

(autoload 'magit-git-command "magit/lisp/magit" "\
Execute a Git subcommand asynchronously, displaying the output.
With a prefix argument run Git in the root of the current
repository, otherwise in `default-directory'.

\(fn ARGS DIRECTORY)" t nil)

(autoload 'magit-git-command-topdir "magit/lisp/magit" "\
Execute a Git subcommand asynchronously, displaying the output.
Run Git in the top-level directory of the current repository.

\(fn)" t nil)

(autoload 'magit-shell-command "magit/lisp/magit" "\
Execute a shell command asynchronously, displaying the output.
With a prefix argument run the command in the root of the current
repository, otherwise in `default-directory'.

\(fn ARGS DIRECTORY)" t nil)

(autoload 'magit-shell-command-topdir "magit/lisp/magit" "\
Execute a shell command asynchronously, displaying the output.
Run the command in the top-level directory of the current repository.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "magit/lisp/magit-apply" "magit/lisp/magit-apply.el"
;;;;;;  (21982 32429 187605 266000))
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
\('git add --update|--all .').

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

;;;***

;;;### (autoloads nil "magit/lisp/magit-bisect" "magit/lisp/magit-bisect.el"
;;;;;;  (21982 32429 187605 266000))
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

\(fn CMDLINE)" t nil)

;;;***

;;;### (autoloads nil "magit/lisp/magit-blame" "magit/lisp/magit-blame.el"
;;;;;;  (21982 32429 187605 266000))
;;; Generated autoloads from magit/lisp/magit-blame.el
 (autoload 'magit-blame-popup "magit-blame" nil t)

(autoload 'magit-blame "magit/lisp/magit-blame" "\
Display edit history of FILE up to REVISION.

Interactively blame the file being visited in the current buffer.
If the buffer visits a revision of that file, then blame up to
that revision, otherwise blame the file's full history, including
uncommitted changes.

If Magit-Blame mode is already turned on then blame recursively, by
visiting REVISION:FILE (using `magit-find-file'), where revision
is the revision before the revision that added the lines at
point.

ARGS is a list of additional arguments to pass to `git blame';
only arguments available from `magit-blame-popup' should be used.

\(fn REVISION FILE &optional ARGS)" t nil)

;;;***

;;;### (autoloads nil "magit/lisp/magit-commit" "magit/lisp/magit-commit.el"
;;;;;;  (21982 32429 187605 266000))
;;; Generated autoloads from magit/lisp/magit-commit.el

(autoload 'magit-commit "magit/lisp/magit-commit" "\
Create a new commit on HEAD.
With a prefix argument amend to the commit at HEAD instead.

\(git commit [--amend] ARGS)

\(fn &optional ARGS)" t nil)

(autoload 'magit-commit-amend "magit/lisp/magit-commit" "\
Amend the last commit.

\(git commit --amend ARGS)

\(fn &optional ARGS)" t nil)

(autoload 'magit-commit-extend "magit/lisp/magit-commit" "\
Amend the last commit, without editing the message.
With a prefix argument do change the committer date, otherwise
don't.  The option `magit-commit-extend-override-date' can be
used to inverse the meaning of the prefix argument.

\(git commit --amend --no-edit)

\(fn &optional ARGS OVERRIDE-DATE)" t nil)

(autoload 'magit-commit-reword "magit/lisp/magit-commit" "\
Reword the last commit, ignoring staged changes.

With a prefix argument do change the committer date, otherwise
don't.  The option `magit-commit-rewrite-override-date' can be
used to inverse the meaning of the prefix argument.

Non-interactively respect the optional OVERRIDE-DATE argument
and ignore the option.

\(git commit --amend --only)

\(fn &optional ARGS OVERRIDE-DATE)" t nil)

(autoload 'magit-commit-fixup "magit/lisp/magit-commit" "\
Create a fixup commit.
With a prefix argument the target commit has to be confirmed.
Otherwise the commit at point may be used without confirmation
depending on the value of option `magit-commit-squash-confirm'.

\(git commit --no-edit --fixup=COMMIT [ARGS])

\(fn &optional COMMIT ARGS CONFIRM)" t nil)

(autoload 'magit-commit-squash "magit/lisp/magit-commit" "\
Create a squash commit, without editing the squash message.
With a prefix argument the target commit has to be confirmed.
Otherwise the commit at point may be used without confirmation
depending on the value of option `magit-commit-squash-confirm'.

\(git commit --no-edit --squash=COMMIT [ARGS])

\(fn &optional COMMIT ARGS CONFIRM)" t nil)

(autoload 'magit-commit-augment "magit/lisp/magit-commit" "\
Create a squash commit, editing the squash message.
With a prefix argument the target commit has to be confirmed.
Otherwise the commit at point may be used without confirmation
depending on the value of option `magit-commit-squash-confirm'.

\(git commit --squash=COMMIT [ARGS])

\(fn &optional COMMIT ARGS CONFIRM)" t nil)

(autoload 'magit-commit-instant-fixup "magit/lisp/magit-commit" "\
Create a fixup commit and instantly rebase.

\(git commit --no-edit --fixup=COMMIT ARGS;
 git rebase -i COMMIT^ --autosquash --autostash)

\(fn &optional COMMIT ARGS)" t nil)

(autoload 'magit-commit-instant-squash "magit/lisp/magit-commit" "\
Create a squash commit and instantly rebase.

\(git commit --no-edit --squash=COMMIT ARGS;
 git rebase -i COMMIT^ --autosquash --autostash)

\(fn &optional COMMIT ARGS)" t nil)

;;;***

;;;### (autoloads nil "magit/lisp/magit-diff" "magit/lisp/magit-diff.el"
;;;;;;  (21982 32429 191605 335000))
;;; Generated autoloads from magit/lisp/magit-diff.el

(autoload 'magit-diff-dwim "magit/lisp/magit-diff" "\
Show changes for the thing at point.

\(fn &optional ARGS FILES)" t nil)

(autoload 'magit-diff "magit/lisp/magit-diff" "\
Show differences between two commits.

RANGE should be a range (A..B or A...B) but can also be a single
commit.  If one side of the range is omitted, then it defaults
to HEAD.  If just a commit is given, then changes in the working
tree relative to that commit are shown.

If the region is active, use the revisions on the first and last
line of the region.  With a prefix argument, instead of diffing
the revisions, choose a revision to view changes along, starting
at the common ancestor of both revisions (i.e., use a \"...\"
range).

\(fn RANGE &optional ARGS FILES)" t nil)

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

(autoload 'magit-diff-unpushed "magit/lisp/magit-diff" "\
Show unpushed changes.

\(fn &optional ARGS FILES)" t nil)

(autoload 'magit-diff-unpulled "magit/lisp/magit-diff" "\
Show unpulled changes.

\(fn &optional ARGS FILES)" t nil)

(autoload 'magit-diff-while-committing "magit/lisp/magit-diff" "\
While committing, show the changes that are about to be committed.
While amending, invoking the command again toggles between
showing just the new changes or all the changes that will
be commited.

\(fn &optional ARGS FILES)" t nil)

(autoload 'magit-diff-paths "magit/lisp/magit-diff" "\
Show changes between any two files on disk.

\(fn A B)" t nil)

(autoload 'magit-show-commit "magit/lisp/magit-diff" "\
Show the commit at point.
If there is no commit at point or with a prefix argument prompt
for a commit.

\(fn COMMIT &optional NOSELECT MODULE ARGS FILES)" t nil)

;;;***

;;;### (autoloads nil "magit/lisp/magit-ediff" "magit/lisp/magit-ediff.el"
;;;;;;  (21982 32429 191605 335000))
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
repository.  If REVA or REVB is nil then this stands for the
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
Show changes between HEAD and working tree using Ediff.
FILE must be relative to the top directory of the repository.

\(fn FILE)" t nil)

(autoload 'magit-ediff-show-commit "magit/lisp/magit-ediff" "\
Show changes introduced by COMMIT using Ediff.

\(fn COMMIT)" t nil)

;;;***

;;;### (autoloads nil "magit/lisp/magit-extras" "magit/lisp/magit-extras.el"
;;;;;;  (21982 32429 191605 335000))
;;; Generated autoloads from magit/lisp/magit-extras.el

(autoload 'magit-run-git-gui "magit/lisp/magit-extras" "\
Run `git gui' for the current git repository.

\(fn)" t nil)

(autoload 'magit-run-git-gui-blame "magit/lisp/magit-extras" "\
Run `git gui blame' on the given FILENAME and COMMIT.
Interactively run it for the current file and the HEAD, with a
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

;;;***

;;;### (autoloads nil "magit/lisp/magit-log" "magit/lisp/magit-log.el"
;;;;;;  (21982 32429 191605 335000))
;;; Generated autoloads from magit/lisp/magit-log.el

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
Show log for the file visited in the current buffer.
With a prefix argument or when `--follow' is part of
`magit-log-arguments', then follow renames.

\(fn &optional FOLLOW)" t nil)

(autoload 'magit-reflog-current "magit/lisp/magit-log" "\
Display the reflog of the current branch.

\(fn)" t nil)

(autoload 'magit-reflog "magit/lisp/magit-log" "\
Display the reflog of a branch.

\(fn REF)" t nil)

(autoload 'magit-reflog-head "magit/lisp/magit-log" "\
Display the `HEAD' reflog.

\(fn)" t nil)

(autoload 'magit-cherry "magit/lisp/magit-log" "\
Show commits in a branch that are not merged in the upstream branch.

\(fn HEAD UPSTREAM)" t nil)

;;;***

;;;### (autoloads nil "magit/lisp/magit-remote" "magit/lisp/magit-remote.el"
;;;;;;  (21982 32429 195605 405000))
;;; Generated autoloads from magit/lisp/magit-remote.el

(autoload 'magit-clone "magit/lisp/magit-remote" "\
Clone the REPOSITORY to DIRECTORY.
Then show the status buffer for the new repository.

\(fn REPOSITORY DIRECTORY)" t nil)
 (autoload 'magit-remote-popup "magit-remote" nil t)

(autoload 'magit-remote-add "magit/lisp/magit-remote" "\
Add a remote named REMOTE and fetch it.

\(fn REMOTE URL)" t nil)

(autoload 'magit-remote-rename "magit/lisp/magit-remote" "\
Rename the remote named OLD to NEW.

\(fn OLD NEW)" t nil)

(autoload 'magit-remote-set-url "magit/lisp/magit-remote" "\
Change the url of the remote named REMOTE to URL.

\(fn REMOTE URL)" t nil)

(autoload 'magit-remote-remove "magit/lisp/magit-remote" "\
Delete the remote named REMOTE.

\(fn REMOTE)" t nil)
 (autoload 'magit-fetch-popup "magit-remote" nil t)

(autoload 'magit-fetch-current "magit/lisp/magit-remote" "\
Fetch from the upstream repository of the current branch.
If `HEAD' is detached or if the upstream is not configured,
then read the remote.

\(fn REMOTE &optional ARGS)" t nil)

(autoload 'magit-fetch "magit/lisp/magit-remote" "\
Fetch from another repository.

\(fn REMOTE &optional ARGS)" t nil)

(autoload 'magit-fetch-all "magit/lisp/magit-remote" "\
Fetch from all configured remotes.

\(fn &optional ARGS)" t nil)
 (autoload 'magit-pull-popup "magit-remote" nil t)

(autoload 'magit-pull-current "magit/lisp/magit-remote" "\
Fetch and merge into current branch.

\(fn REMOTE BRANCH &optional ARGS)" t nil)

(autoload 'magit-pull "magit/lisp/magit-remote" "\
Fetch from another repository and merge a fetched branch.

\(fn REMOTE BRANCH &optional ARGS)" t nil)
 (autoload 'magit-push-popup "magit-remote" nil t)

(autoload 'magit-push-current "magit/lisp/magit-remote" "\
Push the current branch to its upstream branch.
If the upstream isn't set, then read the remote branch.

\(fn BRANCH REMOTE &optional REMOTE-BRANCH ARGS)" t nil)

(autoload 'magit-push "magit/lisp/magit-remote" "\
Push a branch to its upstream branch.
If the upstream isn't set, then read the remote branch.

\(fn BRANCH REMOTE &optional REMOTE-BRANCH ARGS)" t nil)

(autoload 'magit-push-elsewhere "magit/lisp/magit-remote" "\
Push a branch or commit to some remote branch.
Read the local and remote branch.

\(fn BRANCH REMOTE REMOTE-BRANCH &optional ARGS)" t nil)

(autoload 'magit-push-quickly "magit/lisp/magit-remote" "\
Push the current branch to some remote.
When the Git variable `magit.pushRemote' is set, then push to
that remote.  If that variable is undefined or the remote does
not exist, then push to \"origin\".  If that also doesn't exist
then raise an error.  The local branch is pushed to the remote
branch with the same name.

\(fn &optional ARGS)" t nil)

(autoload 'magit-push-implicitly "magit/lisp/magit-remote" "\
Push without explicitly specifing what to push.
This runs `git push -v'.  What is being pushed depends on various
Git variables as described in the `git-push(1)' and `git-config(1)'
manpages.

\(fn &optional ARGS)" t nil)

(autoload 'magit-push-matching "magit/lisp/magit-remote" "\
Push all matching branches to another repository.
If multiple remotes exit, then read one from the user.
If just one exists, use that without requiring confirmation.

\(fn REMOTE &optional ARGS)" t nil)

(autoload 'magit-push-tag "magit/lisp/magit-remote" "\
Push a tag to another repository.

\(fn TAG REMOTE &optional ARGS)" t nil)
 (autoload 'magit-patch-popup "magit-remote" nil t)

(autoload 'magit-format-patch "magit/lisp/magit-remote" "\
Create patches for the commits in RANGE.
When a single commit is given for RANGE, create a patch for the
changes introduced by that commit (unlike 'git format-patch'
which creates patches for all commits that are reachable from
HEAD but not from the specified commit).

\(fn RANGE ARGS)" t nil)

(autoload 'magit-request-pull "magit/lisp/magit-remote" "\
Request upstream to pull from you public repository.

URL is the url of your publically accessible repository.
START is a commit that already is in the upstream repository.
END is the last commit, usually a branch name, which upstream
is asked to pull.  START has to be reachable from that commit.

\(fn URL START END)" t nil)

;;;***

;;;### (autoloads nil "magit/lisp/magit-sequence" "magit/lisp/magit-sequence.el"
;;;;;;  (21982 32429 195605 405000))
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
Cherry-pick COMMIT.
Prompt for a commit, defaulting to the commit at point.  If
the region selects multiple commits, then pick all of them,
without prompting.

\(fn COMMIT &optional ARGS)" t nil)

(autoload 'magit-cherry-apply "magit/lisp/magit-sequence" "\
Apply the changes in COMMIT but do not commit them.
Prompt for a commit, defaulting to the commit at point.  If
the region selects multiple commits, then apply all of them,
without prompting.

\(fn COMMIT &optional ARGS)" t nil)
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

(autoload 'magit-rebase "magit/lisp/magit-sequence" "\
Start a non-interactive rebase sequence.
All commits not in UPSTREAM are rebased.

\(git rebase UPSTREAM[^] [ARGS])

\(fn UPSTREAM &optional ARGS)" t nil)

(autoload 'magit-rebase-subset "magit/lisp/magit-sequence" "\
Start a non-interactive rebase sequence.
Commits from START to `HEAD' onto NEWBASE.  START has to be
selected from a list of recent commits.

\(git rebase --onto NEWBASE START[^] [ARGS])

\(fn NEWBASE START &optional ARGS)" t nil)

(autoload 'magit-rebase-interactive "magit/lisp/magit-sequence" "\
Start an interactive rebase sequence.

\(git rebase -i COMMIT[^] [ARGS])

\(fn COMMIT &optional ARGS)" t nil)

(autoload 'magit-rebase-autosquash "magit/lisp/magit-sequence" "\
Combine squash and fixup commits with their intended targets.

\(git rebase -i COMMIT[^] --autosquash [ARGS])

\(fn COMMIT &optional ARGS)" t nil)

(autoload 'magit-rebase-edit-commit "magit/lisp/magit-sequence" "\
Edit a single older commit using rebase.

\(fn COMMIT &optional ARGS)" t nil)

(autoload 'magit-rebase-reword-commit "magit/lisp/magit-sequence" "\
Reword a single older commit using rebase.

\(fn COMMIT &optional ARGS)" t nil)

(autoload 'magit-rebase-continue "magit/lisp/magit-sequence" "\
Restart the current rebasing operation.

\(fn)" t nil)

(autoload 'magit-rebase-skip "magit/lisp/magit-sequence" "\
Skip the current commit and restart the current rebase operation.

\(fn)" t nil)

(autoload 'magit-rebase-edit "magit/lisp/magit-sequence" "\
Edit the todo list of the current rebase operation.

\(fn)" t nil)

(autoload 'magit-rebase-abort "magit/lisp/magit-sequence" "\
Abort the current rebase operation, restoring the original branch.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "magit/lisp/magit-stash" "magit/lisp/magit-stash.el"
;;;;;;  (21982 32429 195605 405000))
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
Unstaged and untracked changes are not stashed.

\(fn MESSAGE)" t nil)

(autoload 'magit-stash-worktree "magit/lisp/magit-stash" "\
Create a stash of the working tree only.
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
Create a snapshot of the working tree only.
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

(autoload 'magit-stash-list "magit/lisp/magit-stash" "\
List all stashes in a buffer.

\(fn)" t nil)

(autoload 'magit-stash-show "magit/lisp/magit-stash" "\
Show all diffs of a stash in a buffer.

\(fn STASH &optional NOSELECT ARGS FILES)" t nil)

;;;***

;;;### (autoloads nil "magit/lisp/magit-wip" "magit/lisp/magit-wip.el"
;;;;;;  (21982 32429 195605 405000))
;;; Generated autoloads from magit/lisp/magit-wip.el

(defvar magit-wip-after-save-mode nil "\
Non-nil if Magit-Wip-After-Save mode is enabled.
See the command `magit-wip-after-save-mode' for a description of this minor mode.
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
See the command `magit-wip-after-apply-mode' for a description of this minor mode.")

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
See the command `magit-wip-before-change-mode' for a description of this minor mode.")

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

;;;***


;;;***

;;;### (autoloads (mo-git-blame-current mo-git-blame-file) "mo-git-blame/mo-git-blame"
;;;;;;  "mo-git-blame/mo-git-blame.el" (20289 32888))
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

;;;### (autoloads (notify) "notify/notify" "notify/notify.el" (20289
;;;;;;  32888))
;;; Generated autoloads from notify/notify.el

(autoload 'notify "notify/notify" "\
Notify TITLE, BODY via `notify-method'.
ARGS may be amongst :timeout, :icon, :urgency, :app and :category.

\(fn TITLE BODY &rest ARGS)" nil nil)

;;;***

;;;### (autoloads (php-mode php-extra-constants php) "php-mode/php-mode"
;;;;;;  "php-mode/php-mode.el" (21345 65296 244409 7000))
;;; Generated autoloads from php-mode/php-mode.el

(let ((loads (get 'php 'custom-loads))) (if (member '"php-mode/php-mode" loads) nil (put 'php 'custom-loads (cons '"php-mode/php-mode" loads))))

(defvar php-extra-constants 'nil "\
A list of additional strings to treat as PHP constants.")

(custom-autoload 'php-extra-constants "php-mode/php-mode" t)

(add-to-list 'interpreter-mode-alist (cons "php" 'php-mode))

(autoload 'php-mode "php-mode/php-mode" "\
Major mode for editing PHP code.

\\{php-mode-map}

\(fn)" t nil)

(dolist (pattern '("\\.php[s345t]?\\'" "\\.phtml\\'" "Amkfile" "\\.amk$")) (add-to-list 'auto-mode-alist `(,pattern . php-mode) t))

;;;***

;;;### (autoloads (svn-status svn-checkout) "psvn/psvn" "psvn/psvn.el"
;;;;;;  (20289 32888))
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

;;;### (autoloads (rainbow-mode) "rainbow-mode/rainbow-mode" "rainbow-mode/rainbow-mode.el"
;;;;;;  (20289 32888))
;;; Generated autoloads from rainbow-mode/rainbow-mode.el

(autoload 'rainbow-mode "rainbow-mode/rainbow-mode" "\
Colorize strings that represent colors.
This will fontify with colors the string like \"#aabbcc\" or \"blue\".

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads (sauron-start-hidden sauron-start) "sauron/sauron"
;;;;;;  "sauron/sauron.el" (20935 33430 820225 816000))
;;; Generated autoloads from sauron/sauron.el

(autoload 'sauron-start "sauron/sauron" "\
Start sauron. If the optional parameter HIDDEN is non-nil,
don't show the sauron window.

\(fn &optional HIDDEN)" t nil)

(autoload 'sauron-start-hidden "sauron/sauron" "\
Start sauron, but don't show the window.

\(fn)" t nil)

;;;***

;;;### (autoloads (mouse-secondary-save-then-kill rotate-secondary-selection-yank-pointer
;;;;;;  yank-pop-secondary yank-pop-commands secondary-to-primary
;;;;;;  secondary-swap-region primary-to-secondary isearch-yank-secondary
;;;;;;  yank-secondary secondary-dwim secondary-selection-yank-secondary-commands
;;;;;;  secondary-selection-yank-commands secondary-selection-ring-max)
;;;;;;  "second-sel/second-sel" "second-sel/second-sel.el" (20289
;;;;;;  32888))
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

;;;### (autoloads (describe-unbound-keys) "unbound/unbound" "unbound/unbound.el"
;;;;;;  (20802 24771 420829 903000))
;;; Generated autoloads from unbound/unbound.el

(autoload 'describe-unbound-keys "unbound/unbound" "\
Display a list of unbound keystrokes of complexity no greater than MAX.
Keys are sorted by their complexity; `key-complexity' determines it.

\(fn MAX)" t nil)

;;;***

;;;### (autoloads ((quote vcl-mode) vcl) "vcl-mode/vcl-mode" "vcl-mode/vcl-mode.el"
;;;;;;  (20802 24771 420829 903000))
;;; Generated autoloads from vcl-mode/vcl-mode.el

(let ((loads (get 'vcl 'custom-loads))) (if (member '"vcl-mode/vcl-mode" loads) nil (put 'vcl 'custom-loads (cons '"vcl-mode/vcl-mode" loads))))

(autoload 'vcl-mode "vcl-mode/vcl-mode" "\
Mode for Varnish Command Language

\(fn)" t nil)

;;;***

;;;### (autoloads (web-mode) "web-mode/web-mode" "web-mode/web-mode.el"
;;;;;;  (20935 34456 976223 257000))
;;; Generated autoloads from web-mode/web-mode.el

(autoload 'web-mode "web-mode/web-mode" "\
Major mode for editing web templates.

\(fn)" t nil)

;;;***

;;;### (autoloads (wgrep-setup) "wgrep/wgrep" "wgrep/wgrep.el" (20802
;;;;;;  24771 420829 903000))
;;; Generated autoloads from wgrep/wgrep.el

(autoload 'wgrep-setup "wgrep/wgrep" "\
Setup wgrep preparation.

\(fn)" nil nil)
(add-hook 'grep-setup-hook 'wgrep-setup)

;;;***

;;;### (autoloads (global-ws-trim-mode ws-trim-mode turn-on-ws-trim
;;;;;;  ws-trim-buffer ws-trim-region ws-trim-line) "ws-trim/ws-trim"
;;;;;;  "ws-trim/ws-trim.el" (21055 32063 742797 205000))
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
;;;;;;  (20935 32282 32228 681000))
;;; Generated autoloads from zenburn-theme/zenburn-theme.el

(and load-file-name (boundp 'custom-theme-load-path) (add-to-list 'custom-theme-load-path (file-name-as-directory (file-name-directory load-file-name))))

;;;***

;;;### (autoloads nil "ztree-diff/ztree-diff" "ztree-diff/ztree-diff.el"
;;;;;;  (21423 24092 470872 188000))
;;; Generated autoloads from ztree-diff/ztree-diff.el

(autoload 'ztreediff-mode "ztree-diff/ztree-diff" "\
A minor mode for displaying the difference of the directory trees in text mode.

\(fn &optional ARG)" t nil)

(autoload 'ztree-diff "ztree-diff/ztree-diff" "\
Creates an interactive buffer with the directory tree of the path given

\(fn DIR1 DIR2)" t nil)

;;;***

;;;### (autoloads nil "ztree-diff/ztree-dir" "ztree-diff/ztree-dir.el"
;;;;;;  (21423 24092 470872 188000))
;;; Generated autoloads from ztree-diff/ztree-dir.el

(autoload 'ztree-dir "ztree-diff/ztree-dir" "\
Creates an interactive buffer with the directory tree of the path given

\(fn PATH)" t nil)

;;;***

;;;### (autoloads nil "ztree-diff/ztree-view" "ztree-diff/ztree-view.el"
;;;;;;  (21423 24092 470872 188000))
;;; Generated autoloads from ztree-diff/ztree-view.el

(autoload 'ztree-mode "ztree-diff/ztree-view" "\
A major mode for displaying the directory tree in text mode.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("async/async-pkg.el" "async/async-test.el"
;;;;;;  "async/smtpmail-async.el" "dash/dash-functional.el" "dash/dash.el"
;;;;;;  "el-get/el-get-install.el" "el-get/el-get.el"
;;;;;;  "macrostep/macrostep-test.el" "magit/lisp/magit-autoloads.el"
;;;;;;  "magit/lisp/magit-core.el" "magit/lisp/magit-git.el" "magit/lisp/magit-mode.el"
;;;;;;  "magit/lisp/magit-popup.el" "magit/lisp/magit-process.el"
;;;;;;  "magit/lisp/magit-section.el" "magit/lisp/magit-utils.el"
;;;;;;  "magit/lisp/magit-version.el" "magit/lisp/with-editor.el"
;;;;;;  "sauron/sauron-dbus.el" "sauron/sauron-erc.el"
;;;;;;  "sauron/sauron-identica.el" "sauron/sauron-jabber.el" "sauron/sauron-notifications.el"
;;;;;;  "sauron/sauron-org.el" "sauron/sauron-twittering.el" "smartrep/smartrep.el"
;;;;;;  "smartrep/test-smartrep.el" "wgrep/wgrep-test.el" "ztree-diff/ztree-diff-model.el"
;;;;;;  "ztree-diff/ztree-pkg.el" "ztree-diff/ztree-util.el") (21423
;;;;;;  24092 835278 967000))

;;;***

(provide '.loaddefs)
;; Local Variables:
;; version-control: never
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; .loaddefs.el ends here
