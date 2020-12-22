;; mu4e
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/mu4e"))
(load-file (expand-file-name "~/.emacs.d/lisp/mu4e/autoloads.el"))

(add-hook 'mu4e-view-mode-hook 'my-mu4e-view-mode-hook)
(defun my-mu4e-view-mode-hook ()
  "Custom `mu4e-view-mode' behaviours."
  (setq-local shr-use-colors nil)
  (visual-line-mode 1)
  (delete-trailing-whitespace))

(with-eval-after-load "mu4e-headers"
  (define-key mu4e-headers-mode-map (kbd "`") #'mu4e-view-raw-message))

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
      ;; viewing mail
      mu4e-view-show-addresses t
      mu4e-view-html-plaintext-ratio-heuristic most-positive-fixnum
      ;; misc
      mu4e-completing-read-function 'ido-completing-read
      mu4e-confirm-quit nil
      )


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
