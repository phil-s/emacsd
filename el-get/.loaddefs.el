;;; .loaddefs.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (dbgp-proxy-unregister-exec dbgp-proxy-unregister
;;;;;;  dbgp-proxy-register-exec dbgp-proxy-register dbgp-exec dbgp-start)
;;;;;;  "dbgp" "geben/dbgp.el" (20106 20538))
;;; Generated autoloads from geben/dbgp.el

(autoload 'dbgp-start "dbgp" "\
Start a new DBGp listener listening to PORT.

\(fn PORT)" t nil)

(autoload 'dbgp-exec "dbgp" "\
Start a new DBGp listener listening to PORT.

\(fn PORT &rest SESSION-PARAMS)" nil nil)

(autoload 'dbgp-proxy-register "dbgp" "\
Register a new DBGp listener to an external DBGp proxy.
The proxy should be found at PROXY-IP-OR-ADDR / PROXY-PORT.
This creates a new DBGp listener and register it to the proxy
associating with the IDEKEY.

\(fn PROXY-IP-OR-ADDR PROXY-PORT IDEKEY MULTI-SESSION-P &optional SESSION-PORT)" t nil)

(autoload 'dbgp-proxy-register-exec "dbgp" "\
Register a new DBGp listener to an external DBGp proxy.
The proxy should be found at IP-OR-ADDR / PORT.
This create a new DBGp listener and register it to the proxy
associating with the IDEKEY.

\(fn IP-OR-ADDR PORT IDEKEY MULTI-SESSION-P SESSION-PORT &rest SESSION-PARAMS)" nil nil)

(autoload 'dbgp-proxy-unregister "dbgp" "\
Unregister the DBGp listener associated with IDEKEY from a DBGp proxy.
After unregistration, it kills the listener instance.

\(fn IDEKEY &optional PROXY-IP-OR-ADDR PROXY-PORT)" t nil)

(autoload 'dbgp-proxy-unregister-exec "dbgp" "\
Unregister PROXY from a DBGp proxy.
After unregistration, it kills the listener instance.

\(fn PROXY)" nil nil)

;;;***

;;;### (autoloads (deft) "deft/deft" "deft/deft.el" (20142 13239))
;;; Generated autoloads from deft/deft.el

(autoload 'deft "deft/deft" "\
Switch to *Deft* buffer and load files.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "ediff-binary-hexl/ediff-binary-hexl" "ediff-binary-hexl/ediff-binary-hexl.el"
;;;;;;  (20192 19149))
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
;;;;;;  "ffip/find-file-in-project.el" (20220 2082))
;;; Generated autoloads from ffip/find-file-in-project.el

(autoload 'find-file-in-project "ffip/find-file-in-project" "\
Prompt with a completing list of all files in the project to find one.

The project's scope is defined as the first directory containing
an `.emacs-project' file. You can override this by locally
setting the `ffip-project-root' variable.

\(fn)" t nil)

;;;***

;;;### (autoloads (iedit-mode) "iedit/iedit" "iedit/iedit.el" (20142
;;;;;;  13087))
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

;;;### (autoloads (rainbow-delimiters-mode) "rainbow-delimiters/rainbow-delimiters"
;;;;;;  "rainbow-delimiters/rainbow-delimiters.el" (20141 54317))
;;; Generated autoloads from rainbow-delimiters/rainbow-delimiters.el

(autoload 'rainbow-delimiters-mode "rainbow-delimiters/rainbow-delimiters" "\
Color nested parentheses, brackets, and braces according to their depth.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads (rebase-mode) "magit/rebase-mode" "magit/rebase-mode.el"
;;;;;;  (20106 20538))
;;; Generated autoloads from magit/rebase-mode.el

(autoload 'rebase-mode "magit/rebase-mode" "\
Major mode for editing of a Git rebase file.

Rebase files are generated when you run 'git rebase -i' or run
`magit-interactive-rebase'.  They describe how Git should perform
the rebase.  See the documentation for git-rebase (e.g., by
running 'man git-rebase' at the command line) for details.

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("git-rebase-todo" . rebase-mode))

;;;***

;;;### (autoloads (geben geben-mode) "geben" "geben/geben.el" (20106
;;;;;;  20538))
;;; Generated autoloads from geben/geben.el

(autoload 'geben-mode "geben" "\
Minor mode for debugging source code with GEBEN.
The geben-mode buffer commands:
\\{geben-mode-map}

\(fn &optional ARG)" t nil)

(autoload 'geben "geben" "\
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

;;;### (autoloads (keep-buffers-query) "keep-buffers" "keep-buffers/keep-buffers.el"
;;;;;;  (20106 20520))
;;; Generated autoloads from keep-buffers/keep-buffers.el

(autoload 'keep-buffers-query "keep-buffers" "\
The query function that disable deletion of buffers we protect.

\(fn)" nil nil)

;;;***

;;;### (autoloads (magit-status) "magit/magit" "magit/magit.el" (20142
;;;;;;  14392))
;;; Generated autoloads from magit/magit.el

(autoload 'magit-status "magit/magit" "\
Open a Magit status buffer for the Git repository containing
DIR.  If DIR is not within a Git repository, offer to create a
Git repository in DIR.

Interactively, a prefix argument means to ask the user which Git
repository to use even if `default-directory' is under Git control.
Two prefix arguments means to ignore `magit-repo-dirs' when asking for
user input.

\(fn DIR)" t nil)

;;;***

;;;### (autoloads (mo-git-blame-current mo-git-blame-file) "mo-git-blame"
;;;;;;  "mo-git-blame/mo-git-blame.el" (20106 20538))
;;; Generated autoloads from mo-git-blame/mo-git-blame.el

(autoload 'mo-git-blame-file "mo-git-blame" "\
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

(autoload 'mo-git-blame-current "mo-git-blame" "\
Calls `mo-git-blame-file' for HEAD for the current buffer.

\(fn)" t nil)

;;;***

;;;### (autoloads (notify) "notify" "notify/notify.el" (20106 19964))
;;; Generated autoloads from notify/notify.el

(autoload 'notify "notify" "\
Notify TITLE, BODY via `notify-method'.
ARGS may be amongst :timeout, :icon, :urgency, :app and :category.

\(fn TITLE BODY &rest ARGS)" nil nil)

;;;***

;;;### (autoloads (php-mode php-file-patterns php) "php-mode" "php-mode/php-mode.el"
;;;;;;  (20123 29196))
;;; Generated autoloads from php-mode/php-mode.el

(let ((loads (get 'php 'custom-loads))) (if (member '"php-mode" loads) nil (put 'php 'custom-loads (cons '"php-mode" loads))))

(add-to-list 'interpreter-mode-alist (cons "php" 'php-mode))

(defvar php-file-patterns '("\\.php[s345t]?\\'" "\\.phtml\\'" "\\.inc\\'") "\
List of file patterns for which to automatically invoke `php-mode'.")

(custom-autoload 'php-file-patterns "php-mode" nil)

(autoload 'php-mode "php-mode" "\
Major mode for editing PHP code.

\\{php-mode-map}

\(fn)" t nil)

;;;***

;;;### (autoloads (svn-status svn-checkout) "psvn/psvn" "psvn/psvn.el"
;;;;;;  (20141 54317))
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

;;;### (autoloads (rainbow-mode) "rainbow-mode" "rainbow-mode/rainbow-mode.el"
;;;;;;  (20106 20538))
;;; Generated autoloads from rainbow-mode/rainbow-mode.el

(autoload 'rainbow-mode "rainbow-mode" "\
Colorize strings that represent colors.
This will fontify with colors the string like \"#aabbcc\" or \"blue\".

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads (mouse-secondary-save-then-kill rotate-secondary-selection-yank-pointer
;;;;;;  yank-pop-secondary yank-pop-commands secondary-to-primary
;;;;;;  secondary-swap-region primary-to-secondary isearch-yank-secondary
;;;;;;  yank-secondary secondary-dwim secondary-selection-yank-secondary-commands
;;;;;;  secondary-selection-yank-commands secondary-selection-ring-max)
;;;;;;  "second-sel/second-sel" "second-sel/second-sel.el" (20202
;;;;;;  24401))
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

;;;### (autoloads (global-ws-trim-mode ws-trim-mode turn-on-ws-trim
;;;;;;  ws-trim-buffer ws-trim-region ws-trim-line) "ws-trim/ws-trim"
;;;;;;  "ws-trim/ws-trim.el" (20281 33373))
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

;;;### (autoloads (color-theme-zenburn) "zenburn" "color-theme-zenburn/zenburn.el"
;;;;;;  (20034 29893))
;;; Generated autoloads from color-theme-zenburn/zenburn.el

(autoload 'color-theme-zenburn "zenburn" "\
Just some alien fruit salad to keep you in the zone.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("color-theme/color-theme-autoloads.el"
;;;;;;  "el-get/el-get-install.el" "el-get/el-get.el" "sauron/sauron-dbus.el"
;;;;;;  "sauron/sauron-erc.el" "sauron/sauron-org.el" "sauron/sauron.el"
;;;;;;  "gpicker/gpicker.el")
;;;;;;  (20229 17115 934208))

;;;***

(provide '.loaddefs)
;; Local Variables:
;; version-control: never
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; .loaddefs.el ends here
