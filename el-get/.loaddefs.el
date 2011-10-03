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

;;;### (autoloads (notify) "notify" "notify/notify.el" (20035 7410))
;;; Generated autoloads from notify/notify.el

(autoload 'notify "notify" "\
Notify TITLE, BODY via `notify-method'.
ARGS may be amongst :timeout, :icon, :urgency, :app and :category.

\(fn TITLE BODY &rest ARGS)" nil nil)

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

;;;***

(provide '.loaddefs)
;; Local Variables:
;; version-control: never
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; .loaddefs.el ends here
