;;; autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
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

(register-definition-prefixes "mu4e-actions" '("mu4e"))

;;;***

;;;### (autoloads nil "mu4e-compose" "mu4e-compose.el" (0 0 0 0))
;;; Generated autoloads from mu4e-compose.el

(autoload 'mu4e~compose-mail "mu4e-compose" "\
This is mu4e's implementation of `compose-mail'.
Quoting its docstring:
Start composing a mail message to send.
This uses the user’s chosen mail composition package
as selected with the variable ‘mail-user-agent’.
The optional arguments TO and SUBJECT specify recipients
and the initial Subject field, respectively.

OTHER-HEADERS is an alist specifying additional
header fields.  Elements look like (HEADER . VALUE) where both
HEADER and VALUE are strings.

CONTINUE, if non-nil, says to continue editing a message already
being composed.  Interactively, CONTINUE is the prefix argument.

SWITCH-FUNCTION, if non-nil, is a function to use to
switch to and display the buffer used for mail composition.

YANK-ACTION, if non-nil, is an action to perform, if and when necessary,
to insert the raw text of the message being replied to.
It has the form (FUNCTION . ARGS).  The user agent will apply
FUNCTION to ARGS, to insert the raw text of the original message.
\(The user agent will also run ‘mail-citation-hook’, *after* the
original text has been inserted in this way.)

SEND-ACTIONS is a list of actions to call when the message is sent.
Each action has the form (FUNCTION . ARGS).

RETURN-ACTION, if non-nil, is an action for returning to the
caller.  It has the form (FUNCTION . ARGS).  The function is
called after the mail has been sent or put aside, and the mail
buffer buried.

\(fn &optional TO SUBJECT OTHER-HEADERS CONTINUE SWITCH-FUNCTION YANK-ACTION SEND-ACTIONS RETURN-ACTION)" nil nil)

(define-mail-user-agent 'mu4e-user-agent 'mu4e~compose-mail 'message-send-and-exit 'message-kill-buffer 'message-send-hook)

(register-definition-prefixes "mu4e-compose" '("mu4e"))

;;;***

;;;### (autoloads nil "mu4e-context" "mu4e-context.el" (0 0 0 0))
;;; Generated autoloads from mu4e-context.el

(register-definition-prefixes "mu4e-context" '("mu4e"))

;;;***

;;;### (autoloads nil "mu4e-contrib" "mu4e-contrib.el" (0 0 0 0))
;;; Generated autoloads from mu4e-contrib.el

(register-definition-prefixes "mu4e-contrib" '("eshell/mu4e-attach" "mu4e"))

;;;***

;;;### (autoloads nil "mu4e-draft" "mu4e-draft.el" (0 0 0 0))
;;; Generated autoloads from mu4e-draft.el

(register-definition-prefixes "mu4e-draft" '("mu4e"))

;;;***

;;;### (autoloads nil "mu4e-headers" "mu4e-headers.el" (0 0 0 0))
;;; Generated autoloads from mu4e-headers.el

(register-definition-prefixes "mu4e-headers" '("mu4e"))

;;;***

;;;### (autoloads nil "mu4e-icalendar" "mu4e-icalendar.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from mu4e-icalendar.el

(autoload 'mu4e-icalendar-setup "mu4e-icalendar" "\
Perform the necessary initialization to use mu4e-icalendar." nil nil)

(register-definition-prefixes "mu4e-icalendar" '("mu4e"))

;;;***

;;;### (autoloads nil "mu4e-lists" "mu4e-lists.el" (0 0 0 0))
;;; Generated autoloads from mu4e-lists.el

(register-definition-prefixes "mu4e-lists" '("mu4e"))

;;;***

;;;### (autoloads nil "mu4e-main" "mu4e-main.el" (0 0 0 0))
;;; Generated autoloads from mu4e-main.el

(register-definition-prefixes "mu4e-main" '("mu4e"))

;;;***

;;;### (autoloads nil "mu4e-mark" "mu4e-mark.el" (0 0 0 0))
;;; Generated autoloads from mu4e-mark.el

(register-definition-prefixes "mu4e-mark" '("mu4e"))

;;;***

;;;### (autoloads nil "mu4e-message" "mu4e-message.el" (0 0 0 0))
;;; Generated autoloads from mu4e-message.el

(register-definition-prefixes "mu4e-message" '("mu4e"))

;;;***

;;;### (autoloads nil "mu4e-meta" "mu4e-meta.el" (0 0 0 0))
;;; Generated autoloads from mu4e-meta.el

(register-definition-prefixes "mu4e-meta" '("mu4e-"))

;;;***

;;;### (autoloads nil "mu4e-org" "mu4e-org.el" (0 0 0 0))
;;; Generated autoloads from mu4e-org.el

(register-definition-prefixes "mu4e-org" '("mu4e"))

;;;***

;;;### (autoloads nil "mu4e-proc" "mu4e-proc.el" (0 0 0 0))
;;; Generated autoloads from mu4e-proc.el

(register-definition-prefixes "mu4e-proc" '("mu4e~"))

;;;***

;;;### (autoloads nil "mu4e-speedbar" "mu4e-speedbar.el" (0 0 0 0))
;;; Generated autoloads from mu4e-speedbar.el

(autoload 'mu4e-speedbar-buttons "mu4e-speedbar" "\
Create buttons for any mu4e BUFFER.

\(fn &optional BUFFER)" t nil)

(register-definition-prefixes "mu4e-speedbar" '("mu4e"))

;;;***

;;;### (autoloads nil "mu4e-utils" "mu4e-utils.el" (0 0 0 0))
;;; Generated autoloads from mu4e-utils.el

(register-definition-prefixes "mu4e-utils" '("mu4e" "with~mu4e-context-vars"))

;;;***

;;;### (autoloads nil "mu4e-vars" "mu4e-vars.el" (0 0 0 0))
;;; Generated autoloads from mu4e-vars.el

(register-definition-prefixes "mu4e-vars" '("mu4e"))

;;;***

;;;### (autoloads nil "mu4e-view" "mu4e-view.el" (0 0 0 0))
;;; Generated autoloads from mu4e-view.el

(register-definition-prefixes "mu4e-view" '("mu4e-view"))

;;;***

;;;### (autoloads nil "mu4e-view-common" "mu4e-view-common.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from mu4e-view-common.el

(register-definition-prefixes "mu4e-view-common" '("mu4e"))

;;;***

;;;### (autoloads nil "mu4e-view-gnus" "mu4e-view-gnus.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from mu4e-view-gnus.el

(register-definition-prefixes "mu4e-view-gnus" '("gnus-icalendar-event-from-handle" "mu4e"))

;;;***

;;;### (autoloads nil "mu4e-view-old" "mu4e-view-old.el" (0 0 0 0))
;;; Generated autoloads from mu4e-view-old.el

(register-definition-prefixes "mu4e-view-old" '("mu4e"))

;;;***

;;;### (autoloads nil "org-mu4e" "org-mu4e.el" (0 0 0 0))
;;; Generated autoloads from org-mu4e.el

(register-definition-prefixes "org-mu4e" '("org"))

;;;***

(provide 'autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; autoloads.el ends here
