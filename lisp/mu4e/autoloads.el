;;; autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "mu4e" "mu4e.el" (0 0 0 0))
;;; Generated autoloads from mu4e.el

(autoload 'mu4e "mu4e" "\
If mu4e is not running yet, start it. Then, show the main
window, unless BACKGROUND (prefix-argument) is non-nil.

\(fn &optional BACKGROUND)" t nil)

;;;***

;;;### (autoloads nil "mu4e-actions" "mu4e-actions.el" (0 0 0 0))
;;; Generated autoloads from mu4e-actions.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-actions" '("mu4e")))

;;;***

;;;### (autoloads nil "mu4e-compose" "mu4e-compose.el" (0 0 0 0))
;;; Generated autoloads from mu4e-compose.el

(autoload 'mu4e~compose-mail "mu4e-compose" "\
This is mu4e's implementation of `compose-mail'.

\(fn &optional TO SUBJECT OTHER-HEADERS CONTINUE SWITCH-FUNCTION YANK-ACTION SEND-ACTIONS RETURN-ACTION)" nil nil)

(define-mail-user-agent 'mu4e-user-agent 'mu4e~compose-mail 'message-send-and-exit 'message-kill-buffer 'message-send-hook)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-compose" '("mu4e")))

;;;***

;;;### (autoloads nil "mu4e-context" "mu4e-context.el" (0 0 0 0))
;;; Generated autoloads from mu4e-context.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-context" '("mu4e")))

;;;***

;;;### (autoloads nil "mu4e-contrib" "mu4e-contrib.el" (0 0 0 0))
;;; Generated autoloads from mu4e-contrib.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-contrib" '("eshell/mu4e-attach" "mu4e-")))

;;;***

;;;### (autoloads nil "mu4e-draft" "mu4e-draft.el" (0 0 0 0))
;;; Generated autoloads from mu4e-draft.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-draft" '("mu4e")))

;;;***

;;;### (autoloads nil "mu4e-headers" "mu4e-headers.el" (0 0 0 0))
;;; Generated autoloads from mu4e-headers.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-headers" '("mu4e")))

;;;***

;;;### (autoloads nil "mu4e-lists" "mu4e-lists.el" (0 0 0 0))
;;; Generated autoloads from mu4e-lists.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-lists" '("mu4e")))

;;;***

;;;### (autoloads nil "mu4e-main" "mu4e-main.el" (0 0 0 0))
;;; Generated autoloads from mu4e-main.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-main" '("mu4e")))

;;;***

;;;### (autoloads nil "mu4e-mark" "mu4e-mark.el" (0 0 0 0))
;;; Generated autoloads from mu4e-mark.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-mark" '("mu4e")))

;;;***

;;;### (autoloads nil "mu4e-message" "mu4e-message.el" (0 0 0 0))
;;; Generated autoloads from mu4e-message.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-message" '("mu4e")))

;;;***

;;;### (autoloads nil "mu4e-meta" "mu4e-meta.el" (0 0 0 0))
;;; Generated autoloads from mu4e-meta.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-meta" '("mu4e-")))

;;;***

;;;### (autoloads nil "mu4e-proc" "mu4e-proc.el" (0 0 0 0))
;;; Generated autoloads from mu4e-proc.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-proc" '("mu4e~")))

;;;***

;;;### (autoloads nil "mu4e-speedbar" "mu4e-speedbar.el" (0 0 0 0))
;;; Generated autoloads from mu4e-speedbar.el

(autoload 'mu4e-speedbar-buttons "mu4e-speedbar" "\
Create buttons for any mu4e BUFFER.

\(fn BUFFER)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-speedbar" '("mu4e")))

;;;***

;;;### (autoloads nil "mu4e-utils" "mu4e-utils.el" (0 0 0 0))
;;; Generated autoloads from mu4e-utils.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-utils" '("mu4e" "with~mu4e-context-vars")))

;;;***

;;;### (autoloads nil "mu4e-vars" "mu4e-vars.el" (0 0 0 0))
;;; Generated autoloads from mu4e-vars.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-vars" '("mu4e")))

;;;***

;;;### (autoloads nil "mu4e-view" "mu4e-view.el" (0 0 0 0))
;;; Generated autoloads from mu4e-view.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mu4e-view" '("mu4e")))

;;;***

;;;### (autoloads nil "org-mu4e" "org-mu4e.el" (0 0 0 0))
;;; Generated autoloads from org-mu4e.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "org-mu4e" '("org")))

;;;***

;;;### (autoloads nil "org-old-mu4e" "org-old-mu4e.el" (0 0 0 0))
;;; Generated autoloads from org-old-mu4e.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "org-old-mu4e" '("org")))

;;;***

(provide 'autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; autoloads.el ends here
