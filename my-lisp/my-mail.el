;; -*- lexical-binding: nil; -*-
;; Silence compiler warnings
(eval-when-compile
  (defvar ecomplete-auto-select)
  (defvar ecomplete-database)
  (defvar mu4e-bookmarks)
  (defvar mu4e-completing-read-function)
  (defvar mu4e-confirm-quit)
  (defvar mu4e-header-info-custom)
  (defvar mu4e-header-info-custom)
  (defvar mu4e-headers-date-format)
  (defvar mu4e-headers-fields)
  (defvar mu4e-headers-mode-map)
  (defvar mu4e-headers-time-format)
  (defvar mu4e-view-actions)
  (defvar mu4e-view-actions)
  (defvar mu4e-view-html-plaintext-ratio-heuristic)
  (defvar mu4e-view-mode-map)
  (defvar mu4e-view-show-addresses)
  (defvar org-agenda-include-diary)
  (defvar org-log-done)
  (defvar shr-use-colors)
  (declare-function ecomplete-add-item "ecomplete")
  (declare-function ecomplete-completion-table "ecomplete")
  (declare-function ecomplete-get-item "ecomplete")
  (declare-function ecomplete-get-matches "ecomplete")
  (declare-function ecomplete-highlight-match-line "ecomplete")
  (declare-function ecomplete-save "ecomplete")
  (declare-function mu4e-view-raw-message "mu4e-view")
  (declare-function mu4e~write-body-to-html "mu4e-actions")
  )

;; mu4e
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(autoload 'mu4e "mu4e" nil t)
(autoload 'mu4e-icalendar-setup "mu4e-icalendar")
(autoload 'mu4e~compose-mail "mu4e-compose")
(define-mail-user-agent 'mu4e-user-agent
  'mu4e~compose-mail
  'message-send-and-exit
  'message-kill-buffer
  'message-send-hook)

;; Use the original/old message view.
(setq mu4e-view-use-old t)

;; Don't show threads.
(setq mu4e-headers-show-threads nil)

(with-eval-after-load "mu4e-view"
  (define-key mu4e-view-active-urls-keymap
    (kbd "C-c RET") #'mu4e~view-browse-url-from-binding)
  (define-key mu4e-view-mode-map (kbd "<home>") nil)
  (define-key mu4e-view-mode-map (kbd "<end>") nil))

(add-hook 'mu4e-view-mode-hook 'my-mu4e-view-mode-hook)
(defun my-mu4e-view-mode-hook ()
  "Custom `mu4e-view-mode' behaviours.  Used in `mu4e-view-mode-hook'."
  (setq tab-width 8)
  (setq-local shr-use-colors nil)
  (my-adaptive-visual-line-mode 1)
  (delete-trailing-whitespace))

(add-hook 'mu4e-compose-mode-hook 'my-mu4e-compose-mode-hook)
(defun my-mu4e-compose-mode-hook ()
  "Custom `mu4e-compose-mode' behaviours.  Used in `mu4e-compose-mode-hook'."
  (when (require 'jinx nil :noerror)
    (jinx-mode 1)
    (local-set-key (kbd "M-$") #'jinx-correct)))

(with-eval-after-load "mu4e-headers"
  (define-key mu4e-headers-mode-map (kbd "`") #'mu4e-view-raw-message))

(add-hook 'mu4e-headers-mode-hook 'my-mu4e-headers-mode-hook)
(defun my-mu4e-headers-mode-hook ()
  "Custom `mu4e-headers-mode' behaviours.  Used in `mu4e-headers-mode-hook'."
  ;; Account for the fringe and other spacing in the header line.
  (header-line-indent-mode 1)
  (push (propertize " " 'display '(space :align-to header-line-indent-width))
        header-line-format)
  ;; Ensure the header line scales with the headers themselves.
  (face-remap-add-relative 'header-line '(:inherit default)))

(setq mu4e-bookmarks
      '(("flag:unread AND NOT flag:trashed AND NOT maildir:\"/Trash\""
         "Unread messages"      ?u)
        ("date:today..now AND NOT flag:trashed AND NOT maildir:\"/Trash\""
         "Today's messages"     ?t)
        ("date:7d..now AND NOT flag:trashed AND NOT maildir:\"/Trash\""
         "Last 7 days"          ?w)
        ("mime:image/* AND NOT flag:trashed AND NOT maildir:\"/Trash\""
         "Messages with images" ?p)
        ("maildir:\"/INBOX\" AND NOT flag:trashed AND NOT maildir:\"/Trash\""
         "Inbox"                ?i))
      ;; headers listing
      mu4e-headers-time-format "%X"
      mu4e-headers-date-format "%x %X"
      mu4e-headers-fields
      '((:human-date . 18)
        (:flags . 6)
        (:mailing-list . 10)
        (:from . 22)
        (:subject))
      ;; viewing mail
      mu4e-view-show-addresses t
      mu4e-view-html-plaintext-ratio-heuristic most-positive-fixnum
      ;; misc
      mu4e-completing-read-function 'ido-completing-read
      mu4e-confirm-quit nil
      )

(with-eval-after-load "mu4e-view"
  ;; Fix mouse bindings: `mu4e~view-browse-url-from-binding' is bound to
  ;; [mouse-1] *and* [down-mouse-1], so clicking opens the URL twice.
  (define-key mu4e-view-active-urls-keymap [down-mouse-1] nil)
  ;; Actions.
  (setq mu4e-view-actions
        (remove '("view as pdf" . mu4e-action-view-as-pdf)
                mu4e-view-actions))
  (dolist (action '(("browser view" . mu4e-action-view-in-browser)
                    ("pdf view" . mu4e-action-view-as-pdf)
                    ("eww view" . my-mu4e-view-in-eww)))
    (add-to-list 'mu4e-view-actions action :append)))

(defun my-mu4e-view-in-eww (msg)
  ;; http://disq.us/p/2g3gq62
  "Display current message in EWW browser."
  (eww-browse-url (concat "file://" (mu4e~write-body-to-html msg))))

(with-eval-after-load 'mu4e-thread-folding
  ;; Adjust keybindings.
  (define-key mu4e-headers-mode-map (kbd "<S-right>") nil)
  (define-key mu4e-headers-mode-map (kbd "<S-left>") nil)
  (define-key mu4e-headers-mode-map (kbd "<M-right>") 'mu4e-headers-unfold-all)
  (define-key mu4e-headers-mode-map (kbd "<M-left>") 'mu4e-headers-fold-all)
  ;; The prefix string is displayed over the header line and it is
  ;; thus recommended to have an empty field at the start.
  (with-eval-after-load 'mu4e-headers
    (add-to-list 'mu4e-header-info-custom
                 '(:empty . (:name "Empty"
                                   :shortname ""
                                   :function (lambda (msg) "  "))))
    (setq mu4e-headers-fields
          (cons '(:empty . 2)
                (assq-delete-all :empty mu4e-headers-fields)))))

;; ecomplete
;;
;; "A simpler way [than BBDB and the like] to store email addresses
;; and insert them with completion when composing new messages."
;; -- https://www.reddit.com/r/emacs/comments/sl33w6
(setq message-mail-alias-type 'ecomplete)

;; ;; "If you prefer to use the standard completion-at-point instead of
;; ;; ecomplete's handicrafted UI (works well with Orderless or flex
;; ;; completion styles) you can use the following:"
;; (setq message-mail-alias-type 'ecomplete
;;       message-self-insert-commands nil
;;       message-expand-name-standard-ui t)

;; Helpers.
;; https://github.com/oantolin/emacs-config/blob/master/my-lisp/ecomplete-extras.el
(defun my-mail--name+address (email)
  "Return a pair of the name and address for an EMAIL."
  (let (name)
    (when (string-match "^\\(.*\\) <\\(.*\\)>$" email)
      (setq name (match-string 1 email)
            email (match-string 2 email)))
    (cons name email)))

(defun my-mail-add-to-ecomplete-database (email)
  "Add email address to ecomplete's database."
  (interactive "sEmail address: ")
  (pcase-let ((`(,name . ,email) (my-mail--name+address email)))
    (unless name (setq name (read-string "Name: ")))
    (ecomplete-add-item
     'mail email
     (format (cond ((equal name "") "%s%s")
                   ((string-match-p "^\\(?:[A-Za-z0-9 ]*\\|\".*\"\\)$" name)
                    "%s <%s>")
                   (t "\"%s\" <%s>"))
             name email))
    (ecomplete-save)))

(defun my-mail-remove-from-ecomplete-database (email)
  "Remove email address from ecomplete's database."
  (interactive
   (list (completing-read "Email address: "
                          (ecomplete-completion-table 'mail))))
  (when-let ((email (cdr (my-mail--name+address email)))
             (entry (ecomplete-get-item 'mail email)))
    (setf (cdr (assq 'mail ecomplete-database))
          (remove entry (cdr (assq 'mail ecomplete-database))))
    (ecomplete-save)))

;; Override.

;; Whether `message-display-abbrev' should automatically select a sole option.
;; Added in Emacs 29.
(setq ecomplete-auto-select t)

(when (< emacs-major-version 29)
  (defcustom ecomplete-auto-select t
    "Whether `message-display-abbrev' should automatically select a sole option."
    :group 'ecomplete
    :type 'boolean)

  (advice-add 'ecomplete-display-matches
              :override #'my-mail-ecomplete-display-matches))

(defun my-mail-ecomplete-display-matches (type word &optional choose)
  "Display the top-rated elements TYPE that match WORD.
If CHOOSE, allow the user to choose interactively between the
matches.

Auto-select when `ecomplete-auto-select' is non-nil and there is
only a single completion option available."
  (let* ((matches (ecomplete-get-matches type word))
         (match-list (and matches (split-string matches "\n")))
         (max-lines (and matches (- (length match-list) 2)))
         (line 0)
         (message-log-max nil)
         command highlight)
    (if (not matches)
	(progn
	  (message "No ecomplete matches")
	  nil)
      (if (not choose)
	  (progn
	    (message "%s" matches)
	    nil)
        (if (and ecomplete-auto-select
                 (eql 0 max-lines))
            ;; Auto-select when only one option is available.
            (nth 0 match-list)
          ;; Interactively choose from the filtered completions.
          (let ((local-map (make-sparse-keymap))
                (prev-func (lambda () (setq line (max (1- line) 0))))
                (next-func (lambda () (setq line (min (1+ line) max-lines))))
                selected)
            (define-key local-map (kbd "RET")
              (lambda () (setq selected (nth line match-list))))
	    (define-key local-map (kbd "M-n") next-func)
	    (define-key local-map (kbd "<down>") next-func)
	    (define-key local-map (kbd "M-p") prev-func)
	    (define-key local-map (kbd "<up>") prev-func)
            (let ((overriding-local-map local-map))
              (setq highlight (ecomplete-highlight-match-line matches line))
              (while (and (null selected)
			  (setq command (read-key-sequence highlight))
			  (lookup-key local-map command))
	        (apply (key-binding command) nil)
	        (setq highlight (ecomplete-highlight-match-line matches line))))
	    (message (or selected "Abort"))
            selected))))))

;;; Local mail settings go in my-local.el

;; ;; Email address.
;; (setq user-full-name "Firstname Lastname"
;;       user-mail-address "me@example.com")
;;
;; ;; SMTP
;; (setq send-mail-function #'smtpmail-send-it
;;       smtpmail-smtp-server "mail.example.com"
;;       smtpmail-smtp-service 465
;;       smtpmail-stream-type 'ssl
;;       smtpmail-smtp-user "me@example.com"
;;       )
;;
;; ;; mu4e
;; (setq mu4e-maildir "/home/me/Maildir/EXAMPLE"
;;       mu4e-attachment-dir "/home/me/Maildir/attachments"
;;       ;; imap folders
;;       mu4e-drafts-folder "/Drafts"
;;       mu4e-refile-folder "/Archives"
;;       mu4e-sent-folder "/Sent"
;;       mu4e-trash-folder "/Trash" ;; despite what Thunderbird displays.
;;       ;; mbsync
;;       mu4e-change-filenames-when-moving t
;;       mu4e-get-mail-command "mbsync --pull EXAMPLE"
;;       mu4e-update-interval 300 ;; seconds
;;       )


;; ~/.mbsyncrc:

;; IMAPAccount EXAMPLE-account
;; # Address to connect to
;; Host mail.example.com
;; Port 993
;; User me@example.com
;; # Pass ***************
;; # To store the password in an encrypted file use PassCmd instead of Pass
;; PassCmd "gpg2 -q --for-your-eyes-only --no-tty -d ~/.mailpass.gpg"
;; #
;; # Use SSL
;; SSLType IMAPS
;; # The following line should work. If get certificate errors, uncomment the two following lines and read the "Troubleshooting" section.
;; CertificateFile /etc/ssl/certs/ca-certificates.crt
;; #CertificateFile ~/.cert/imap.gmail.com.pem
;; #CertificateFile ~/.cert/Equifax_Secure_CA.pem
;; #
;; # Don't hammer the servers too hard.
;; PipelineDepth 50
;;
;; IMAPStore EXAMPLE-imap
;; Account EXAMPLE-account
;;
;; MaildirStore EXAMPLE-maildir
;; Subfolders Verbatim
;; # The trailing "/" is important
;; Path ~/Maildir/EXAMPLE/
;; Inbox ~/Maildir/EXAMPLE/Inbox
;;
;; Channel EXAMPLE
;; Master :EXAMPLE-imap:
;; Slave :EXAMPLE-maildir:
;; # Include everything
;; Patterns *
;; # Automatically create missing mailboxes, both locally and on the server
;; Create Both
;; # Save the synchronization state files in the relevant directory
;; SyncState *


(provide 'my-mail)





;; I added highlighting to the marking, because it's unnecessarily
;; hard to see which lines are marked, otherwise.  This is naively
;; using the same face -- 'error -- for all mark types, but mostly
;; I'm only marking things in one way (and usually to trash or delete
;; them), so as a quick workaround this is absolutely fine.
;;
;; (defun mu4e-mark-at-point (mark target)
;;   "Mark (or unmark) message at point.
;; MARK specifies the mark-type. For `move'-marks and `trash'-marks
;; the TARGET argument is non-nil and specifies to which
;; maildir the message is to be moved/trashed. The function works in
;; both headers buffers and message buffers.
;;
;; The following marks are available, and the corresponding props:
;;
;;    MARK       TARGET    description
;;    ----------------------------------------------------------
;;    `refile'    y        mark this message for archiving
;;    `something' n        mark this message for *something* (decided later)
;;    `delete'    n        remove the message
;;    `flag'      n        mark this message for flagging
;;    `move'      y        move the message to some folder
;;    `read'      n        mark the message as read
;;    `trash'     y        trash the message to some folder
;;    `unflag'    n        mark this message for unflagging
;;    `untrash'   n        remove the `trashed' flag from a message
;;    `unmark'    n        unmark this message
;;    `unread'    n        mark the message as unread
;;    `action'    y        mark the message for some action."
;;   (interactive)
;;   (let* ((msg (mu4e-message-at-point))
;;          (docid (mu4e-message-field msg :docid))
;;          ;; get a cell with the mark char and the 'target' 'move' already has a
;;          ;; target (the target folder) the other ones get a pseudo "target", as
;;          ;; info for the user.
;;          (markdesc (cdr (or (assq mark mu4e-marks)
;;                             (mu4e-error "Invalid mark %S" mark))))
;;          (get-markkar
;;           (lambda (char)
;;             (if (listp char)
;;                 (if mu4e-use-fancy-chars (cdr char) (car char))
;;               char)))
;;          (markkar (funcall get-markkar (plist-get markdesc :char)))
;;          (target (mu4e~mark-get-dyn-target mark target))
;;          (show-fct (plist-get markdesc :show-target))
;;          (shown-target (if show-fct
;;                            (funcall show-fct target)
;;                          (if target (format "%S" target)))))
;;     (unless docid (mu4e-warn "No message on this line"))
;;     (unless (eq major-mode 'mu4e-headers-mode)
;;       (mu4e-error "Not in headers-mode"))
;;     (save-excursion
;;       (when (mu4e~headers-mark docid markkar)
;;         ;; update the hash -- remove everything current, and if add the new
;;         ;; stuff, unless we're unmarking
;;         (remhash docid mu4e~mark-map)
;;         ;; remove possible mark overlays
;;         (remove-overlays (line-beginning-position) (line-end-position) 'mu4e-mark t)
;;         (remove-overlays (line-beginning-position) (line-end-position) 'face 'error)
;;         ;; now, let's set a mark (unless we were unmarking)
;;         (unless (eql mark 'unmark)
;;           (puthash docid (cons mark target) mu4e~mark-map)
;;           ;; when we have a target (ie., when moving), show the target folder in
;;           ;; an overlay
;;           (when (and shown-target mu4e-headers-show-target)
;;             (let* ((targetstr (propertize (concat "-> " shown-target " ")
;;                                           'face 'mu4e-system-face))
;;                    ;; mu4e~headers-goto-docid docid t \will take us just after
;;                    ;; the docid cookie and then we skip the mu4e~mark-fringe
;;                    (start (+ (length mu4e~mark-fringe)
;;                              (mu4e~headers-goto-docid docid t)))
;;                    (overlay (make-overlay start (+ start (length targetstr)))))
;;               (overlay-put overlay 'display targetstr)
;;               (overlay-put overlay 'mu4e-mark t)
;;               (overlay-put overlay 'evaporate t)
;;               (overlay-put (make-overlay start (line-end-position))
;;                            'face 'error)
;;               docid)))))))
