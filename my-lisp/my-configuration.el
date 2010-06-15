;; Put other files and dirs into .emacs.d
(setq bookmark-default-file "~/.emacs.d/bookmarks.bmk")
(setq eshell-directory-name "~/.emacs.d/eshell/")

;; Write backups to ~/.emacs.d/backup
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying    t  ; Don't de-link hard links
      version-control      t  ; Use version numbers on backups
      delete-old-versions  t  ; Automatically delete excess backups:
      kept-new-versions    20 ; how many of the newest versions to keep
      kept-old-versions    5  ; and how many of the old
      )

;; Automatically save and restore sessions
(setq desktop-dirname "~/.emacs.d/desktop/")
(setq desktop-base-file-name "emacs.desktop")
(setq desktop-base-lock-name "lock")
(setq desktop-path (list desktop-dirname))
(setq desktop-save t)
(setq desktop-files-not-to-save "^$")
(desktop-save-mode 1)

;; No splash screen
(setq inhibit-startup-screen t)

;; Enable disabled commands
(put 'narrow-to-region  'disabled nil)
(put 'scroll-left       'disabled nil)
(put 'downcase-region   'disabled nil)
(put 'upcase-region     'disabled nil)

;; Stop the cursor blinking
;; Cursor stretches to the current glyph's width
(blink-cursor-mode -1)
(setq x-stretch-cursor t)

;; Scroll-bar on the right-hand side
(menu-bar-right-scroll-bar)

;; Highlight current line
(global-hl-line-mode 1)

;; Always add a final newline
(setq require-trailing-newline t)

;; Move by entire lines, not visual lines
(setq line-move-visual nil)

;; Use ibuffer-list-buffers in place of list-buffers
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Advise ibuffer
(defadvice ibuffer (around ibuffer-point-to-most-recent) ()
  "Open ibuffer with cursor pointed to most recent buffer name"
  (let ((recent-buffer-name (buffer-name)))
    ad-do-it
    (ibuffer-jump-to-buffer recent-buffer-name)))
(ad-activate 'ibuffer)

;; Use CUA selection mode (enhanced rectangle editing)
(cua-selection-mode t)
;; C-RET + cursor movement
;; RET to cycle corners
;; typing inserts before/after rectangle
;; C-RET to exit
;; M-n to generate sequence
;; http://trey-jackson.blogspot.com/2008/10/emacs-tip-26-cua-mode-specifically.html

;; titlebar = buffer unless filename
(setq frame-title-format '(buffer-name "%f" ("%b")))

;; Prevent C-z minimizing frames
;(defun iconify-or-deiconify-frame nil)

;; Show a marker in the left fringe for lines not in the buffer
(setq default-indicate-empty-lines t)

;; Show approx buffer size in modeline
(size-indication-mode t)

;; Make URLs in comments/strings clickable
(add-hook 'find-file-hooks 'goto-address-prog-mode)

;; Use system trash (for emacs 23)
(setq delete-by-moving-to-trash t)

;; Highlight the matching parenthesis
(show-paren-mode t)
(require 'highlight-parentheses)

;; Make apropos searches also find unbound symbols, and
;; set new key-bindings for various other apropos commands.
(setq apropos-do-all t)
(global-set-key (kbd "C-h a") 'apropos-command)
(define-prefix-command 'Apropos-Prefix nil "Apropos (a,d,f,v,C-v)")
(global-set-key (kbd "C-h C-a") 'Apropos-Prefix)
(define-key Apropos-Prefix (kbd "a")   'apropos)
(define-key Apropos-Prefix (kbd "C-a") 'apropos)
(define-key Apropos-Prefix (kbd "d")   'apropos-documentation)
(define-key Apropos-Prefix (kbd "f")   'apropos-command)
(define-key Apropos-Prefix (kbd "v")   'apropos-variable)
(define-key Apropos-Prefix (kbd "C-v") 'apropos-value)

;; Use hippie-expand instead of dabbrev-expand
(global-set-key (kbd "M-/") 'hippie-expand)

;; Alias 'M-x find-dired' to simply 'M-x find'
(defalias 'find 'find-dired)

;; Better buffer naming when filenames conflict
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "|")
(setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

;; Make large files read-only, and disable undo for the buffer
(defun my-find-file-check-make-large-file-read-only-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (> (buffer-size) (* 1024 1024))
    (setq buffer-read-only t)
    (buffer-disable-undo)
    (message "Buffer is set to read-only because it is large.  Undo also
disabled.")))
(add-hook 'find-file-hooks
          'my-find-file-check-make-large-file-read-only-hook)

;; Don't allow dragging and dropping files into dired
(setq dired-dnd-protocol-alist nil)

;; Use ControlMaster with TRAMP by default
(setq tramp-default-method "scpc")
(setq tramp-default-user "phil")

;; Align with spaces only
(defadvice align-regexp (around align-regexp-with-spaces)
  "Never use tabs for alignment."
  (let ((indent-tabs-mode nil))
    ad-do-it))
(ad-activate 'align-regexp)

;; Shell mode
(add-hook
 'shell-mode-hook
 (function (lambda ()
             "Custom shell-mode hook"
             (hide-trailing-whitespace)
             (ansi-color-for-comint-mode-on))))

;; Also, emacs doesn't deal with my usual cygwin prompt, so put:
;; export PS1="\n\u@\h \w\n\$ "
;; into ~/.emacs.d/init_bash.sh

;; Kill ring / Yank assistance
(global-set-key (kbd "C-c y") '(lambda ()
                                 (interactive)
                                 (popup-menu 'yank-menu)))

(when (require 'browse-kill-ring nil 'noerror)
  ;; Either...
  ;; make it the default behaviour:
  ;;(browse-kill-ring-default-keybindings)
  ;;
  ;; or use a custom key binding:
  (global-set-key (kbd "C-c k") 'browse-kill-ring)
  )


;; Don't truncate echo area output
;; (setq eval-expression-print-length nil)

;; Re-format long tool-tips to make them readable
;; (setq x-max-tooltip-size '(80 . 40))
;; (require 'my-tooltips.el)

;; Make emacs consistent with xkcd :)
(global-set-key (kbd "C-x M-c M-b u t t e r f l y") 'butterfly)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-configuration)
