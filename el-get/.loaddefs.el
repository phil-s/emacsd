;;; .loaddefs.el --- automatically extracted autoloads
;;
;;; Code:



;;;### (autoloads (dbgp-proxy-unregister-exec dbgp-proxy-unregister
;;;;;;  dbgp-proxy-register-exec dbgp-proxy-register dbgp-exec dbgp-start)
;;;;;;  "dbgp" "geben/dbgp.el" (19376 40618))
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

;;;### (autoloads (deft) "deft" "deft/deft.el" (20078 30406))
;;; Generated autoloads from deft/deft.el

(autoload 'deft "deft" "\
Switch to *Deft* buffer and load files.

\(fn)" t nil)

;;;***
;;;### (autoloads (find-file-in-project) "find-file-in-project" "find-file-in-project/find-file-in-project.el"
;;;;;;  (20033 60655))
;;; Generated autoloads from find-file-in-project/find-file-in-project.el

(autoload 'find-file-in-project "find-file-in-project" "\
Prompt with a completing list of all files in the project to find one.

The project's scope is defined as the first directory containing
any of the files in the `.ffip-project-files' list. You can
override this by locally setting the `ffip-project-root' variable.

\(fn)" t nil)

;;;***

;;;### (autoloads (geben geben-mode) "geben" "geben/geben.el" (20040
;;;;;;  33441))
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
;;;;;;  (20087 46707))
;;; Generated autoloads from keep-buffers/keep-buffers.el

(autoload 'keep-buffers-query "keep-buffers" "\
The query function that disable deletion of buffers we protect.

\(fn)" nil nil)

;;;***

;;;### (autoloads (magit-status) "magit" "magit/magit.el" (20068
;;;;;;  18897))
;;; Generated autoloads from magit/magit.el

(autoload 'magit-status "magit" "\
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
;;;;;;  "mo-git-blame/mo-git-blame.el" (20052 31423))
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
;;;### (autoloads (notify) "notify" "notify/notify.el" (20035 7410))
;;; Generated autoloads from notify/notify.el

(autoload 'notify "notify" "\
Notify TITLE, BODY via `notify-method'.
ARGS may be amongst :timeout, :icon, :urgency, :app and :category.

\(fn TITLE BODY &rest ARGS)" nil nil)

;;;***

;;;### (autoloads (rebase-mode) "rebase-mode" "magit/rebase-mode.el"
;;;;;;  (20035 12561))
;;; Generated autoloads from magit/rebase-mode.el

(autoload 'rebase-mode "rebase-mode" "\
Major mode for editing of a Git rebase file.

Rebase files are generated when you run 'git rebase -i' or run
`magit-interactive-rebase'.  They describe how Git should perform
the rebase.  See the documentation for git-rebase (e.g., by
running 'man git-rebase' at the command line) for details.

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("git-rebase-todo" . rebase-mode))

;;;***
;;;### (autoloads (color-theme-zenburn) "zenburn" "color-theme-zenburn/zenburn.el"
;;;;;;  (20032 36496))
;;; Generated autoloads from color-theme-zenburn/zenburn.el

(autoload 'color-theme-zenburn "zenburn" "\
Just some alien fruit salad to keep you in the zone.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("color-theme/color-theme-autoloads.el"
;;;;;;  "el-get/el-get-install.el" "el-get/el-get.el") (20033 60655
;;;;;;  852902))
;;;;;;  "magit/50magit.el" "magit/magit-bisect.el" "magit/magit-pkg.el"
;;;;;;  "magit/magit-stgit.el" "magit/magit-svn.el" "magit/magit-topgit.el"

;;;***

(provide '.loaddefs)
;; Local Variables:
;; version-control: never
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; .loaddefs.el ends here
