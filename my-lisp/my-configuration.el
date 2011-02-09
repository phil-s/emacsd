;; Set a preferred coding system?
;; (prefer-coding-system 'utf-8)

;; Put other files and dirs into .emacs.d
(setq bookmark-default-file "~/.emacs.d/bookmarks.bmk"
      eshell-directory-name "~/.emacs.d/eshell/")

;; Write backups to ~/.emacs.d/backup
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying      t  ; Don't de-link hard links
      version-control        t  ; Use version numbers on backups
      delete-old-versions    t  ; Automatically delete excess backups:
      kept-new-versions      20 ; how many of the newest versions to keep
      kept-old-versions      5) ; and how many of the old

;; No splash screen
(setq inhibit-startup-screen t)

;; Enable disabled commands
(put 'dired-find-alternate-file 'disabled nil)
(put 'downcase-region           'disabled nil)
(put 'narrow-to-region          'disabled nil)
(put 'scroll-left               'disabled nil)
(put 'upcase-region             'disabled nil)

;; Stop the cursor blinking
;; Cursor stretches to the current glyph's width
(blink-cursor-mode -1)
(setq x-stretch-cursor t)

;; Scroll-bar on the right-hand side
(menu-bar-right-scroll-bar)

;; Show time in mode line
(display-time-mode 1)

;; Highlight current line
(global-hl-line-mode 1)

;; Use subword-mode
(global-subword-mode 1)

;; Enable winner mode
;; "C-c <left>" and "C-c <right>" undo and re-do window changes.
(winner-mode 1)

;; Always add a final newline
(setq require-trailing-newline t)

;; Move by entire lines, not visual lines
(setq line-move-visual nil)

;; Do not overwrite the region by typing
(setq delete-active-region nil)

;; TODO: Idea: Implement a "recently-closed files" group in ibuffer.
;; Collapsed by default. Selecting a buffer from this list will
;; re-visit the file.

;; Enable ibuffer-filter-by-filename to filter on directory names too.
(eval-after-load "ibuf-ext"
  '(define-ibuffer-filter filename
     "Toggle current view to buffers with file or directory name matching QUALIFIER."
     (:description "filename"
      :reader (read-from-minibuffer "Filter by file/directory name (regexp): "))
     (ibuffer-awhen (or (buffer-local-value 'buffer-file-name buf)
                        (buffer-local-value 'dired-directory buf))
       (string-match qualifier it))))

;; Ensure ibuffer opens with point at the current buffer's entry.
(defadvice ibuffer
  (around ibuffer-point-to-most-recent)
  "Open ibuffer with cursor pointed to most recent buffer name."
  (let ((recent-buffer-name (buffer-name)))
    ad-do-it
    (ibuffer-jump-to-buffer recent-buffer-name)))
(ad-activate 'ibuffer)

;; Enable find-file-at-point key-bindings.
(ffap-bindings) ; see variable `ffap-bindings'
(setq ffap-url-regexp nil) ; disable URL features in ffap
(defadvice ffap-alternate-file (around my-ffap-alternate-file-fallback)
  "Provide fall-back to old C-x C-v behaviour, if no fap.
n.b. ffap-alternate-file is intended for interactive use only.
See also: `my-copy-buffer-file-name'."
  (if (ffap-guesser)
      ad-do-it
    (call-interactively 'find-alternate-file)))
(ad-activate 'ffap-alternate-file)

;; Use CUA selection mode (enhanced rectangle editing)
(setq cua-delete-selection nil) ; typing should not delete the region.
(cua-selection-mode t)
;; C-RET + cursor movement
;; RET to cycle corners
;; typing inserts before/after rectangle
;; C-RET to exit
;; M-n to generate sequence
;; http://trey-jackson.blogspot.com/2008/10/emacs-tip-26-cua-mode-specifically.html

;; Deleting should not delete the region.
(delete-selection-mode 0) ;; doesn't stop cua-selection-mode :/ Undo its changes:
(add-hook 'cua-mode-hook 'my-cua-mode-hook)
;;(remove-hook 'cua-mode-hook 'my-cua-mode-hook)
(defun my-cua-mode-hook ()
  (define-key cua--region-keymap
    [remap delete-backward-char] 'delete-backward-char)
  (define-key cua--region-keymap
    [remap backward-delete-char] 'backward-delete-char)
  (define-key cua--region-keymap
    [remap backward-delete-char-untabify] 'backward-delete-char-untabify)
  (define-key cua--region-keymap
    [remap delete-char] 'delete-char))

;; titlebar = buffer unless filename
(setq frame-title-format '(buffer-name "%f" ("%b")))

;; Prevent C-z minimizing frames
;(defun iconify-or-deiconify-frame nil)

;; By default, raise an existing frame with buffer B in
;; preference to opening another copy in the current buffer.
(setq-default display-buffer-reuse-frames t)

;; Show a marker in the left fringe for lines not in the buffer
(if (version< emacs-version "23.2")
    (setq default-indicate-empty-lines t) ; deprecated
  (setq-default indicate-empty-lines t))

;; Show approx buffer size in modeline
(size-indication-mode t)

;; Make URLs in comments/strings clickable
(add-hook 'find-file-hooks 'goto-address-prog-mode)

;; Use system trash (for emacs 23)
(setq delete-by-moving-to-trash t)

;; Highlight the matching parenthesis
(show-paren-mode t)
(require 'highlight-parentheses)

;; Make apropos searches also find unbound symbols.
;; See my-keybindings.el for various custom apropos bindings.
(setq apropos-do-all t)

;; Alias 'M-x find-dired' to simply 'M-x find'
(defalias 'find 'find-dired)

;; Better buffer naming when filenames conflict
(require 'uniquify)
(setq uniquify-buffer-name-style   'reverse
      uniquify-separator           "|"
      uniquify-after-kill-buffer-p t ; rename after killing uniquified
      uniquify-ignore-buffers-re   "^\\*") ; don't muck with special buffers

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

;; ;; Interactively Do Things
;; (require 'ido)
;; (ido-mode t)
;; (setq ido-enable-flex-matching t) ;; enable fuzzy matching

;; Don't allow dragging and dropping files into dired
(setq dired-dnd-protocol-alist nil)

;; Enable RET during an isearch in dired to immediately visit the file.
;; http://stackoverflow.com/questions/4471835/emacs-dired-mode-and-isearch
(add-hook 'isearch-mode-end-hook 'my-isearch-mode-end-hook)
(defun my-isearch-mode-end-hook ()
  "Make RET, during an isearch in dired, visit the file at point."
  (when (and (eq major-mode 'dired-mode)
             (not isearch-mode-end-hook-quit)
             (eq last-input-event ?\r))
    (dired-find-file)))

;; Use ControlMaster with TRAMP by default
(setq tramp-default-method "scpc"
      tramp-default-user   "phil")

;; Enable directory local variables with remote files.
(defadvice hack-dir-local-variables (around my-remote-dir-local-variables)
  "Allow dir-locals.el with remote files, by temporarily redefining
`file-remote-p' to return nil unconditionally."
  (flet ((file-remote-p (&rest) nil))
    ad-do-it))
(ad-activate 'hack-dir-local-variables)

;; Align with spaces only
(defadvice align-regexp (around align-regexp-with-spaces)
  "Never use tabs for alignment."
  (let ((indent-tabs-mode nil))
    ad-do-it))
(ad-activate 'align-regexp)

;; Enable <backtab> (kbd "S-TAB") for toggling visibility
;; in outline-minor-mode
(add-hook 'outline-minor-mode-hook 'my-outline-minor-mode-hook)
(defun my-outline-minor-mode-hook ()
  (local-set-key (kbd "<backtab>") 'outline-toggle-children))

;; Org mode
(defadvice smart-tab-mode-on
  (after disable-smart-tab-for-modes)
  "Disable smart-tab-mode in the specified major modes (to counter-act global-smart-tab-mode)."
  (if (equal major-mode 'org-mode)
      (smart-tab-mode-off)))
(ad-activate 'smart-tab-mode-on)

;; Shell mode
(add-hook 'shell-mode-hook  #'(lambda ()
                                "Custom shell-mode hook"
                                (hide-trailing-whitespace)
                                (ansi-color-for-comint-mode-on)))

;; Also, emacs doesn't deal with my usual cygwin prompt, so put:
;; export PS1="\n\u@\h \w\n\$ "
;; into ~/.emacs.d/init_bash.sh

;; Don't truncate echo area output
;; (setq eval-expression-print-length nil)

;; Re-format long tool-tips to make them readable
;; (setq x-max-tooltip-size '(80 . 40))
;; (require 'my-tooltips.el)

;; Format completion lists in columns rather than rows
(setq completions-format 'vertical)

;; Use ediff instead of diff in `save-some-buffers'
(eval-after-load "files"
  '(progn
     (setcdr (assq ?d save-some-buffers-action-alist)
             `(,(lambda (buf)
                  (if (null (buffer-file-name buf))
                      (message "Not applicable: no file")
                    (add-hook 'ediff-after-quit-hook-internal
                              'my-save-some-buffers-with-ediff-quit t)
                    (save-excursion
                      (set-buffer buf)
                      (let ((enable-recursive-minibuffers t))
                        (ediff-current-file)
                        (recursive-edit))))
                  ;; Return nil to ask about BUF again.
                  nil)
               ,(purecopy "view changes in this buffer")))

     (defun my-save-some-buffers-with-ediff-quit ()
       "Remove ourselves from the ediff quit hook, and
return to the save-some-buffers minibuffer prompt."
       (remove-hook 'ediff-after-quit-hook-internal
                    'my-save-some-buffers-with-ediff-quit)
       (exit-recursive-edit))))


;; Allow buffer reverts to be undone
;; (defun my-revert-buffer (&optional ignore-auto noconfirm preserve-modes)
;;   "Revert buffer from file in an undo-able manner."
;;   (interactive)
;;   (when (buffer-file-name)
;;     ;; Based upon `delphi-save-state':
;;     ;; Ensure that any buffer modifications do not have any side
;;     ;; effects beyond the actual content changes.
;;     (let ((buffer-read-only nil)
;;           (inhibit-read-only t)
;;           (before-change-functions nil)
;;           (after-change-functions nil)
;;           (my-supersession-revert-buffer-active t))
;;       ;; Disable any queries about editing obsolete files.
;;       (unwind-protect
;;           (progn
;;             (widen)
;;             (kill-region (point-min) (point-max))
;;             (insert-file-contents (buffer-file-name)))))))

;; (defadvice ask-user-about-supersession-threat
;;   (around my-supersession-revert-buffer)
;;   ;; Avoid re-entry, when my-revert-buffer makes changes
;;   ;; to the buffer.
;;   (if (not (boundp 'my-supersession-revert-buffer-active))
;;       (let ((my-supersession-revert-buffer-active t)
;;             (real-revert-buffer (symbol-function 'revert-buffer)))
;;         (fset 'revert-buffer (symbol-function 'my-revert-buffer))
;;         ;; Note that ask-user-about-supersession-threat calls
;;         ;; (signal 'file-supersession ...), so we need to handle
;;         ;; the error in order to restore revert-buffer
;;         (unwind-protect
;;             ad-do-it
;;           (fset 'revert-buffer real-revert-buffer)))))

;; (ad-activate 'ask-user-about-supersession-threat)




;; Make emacs consistent with xkcd :)
(global-set-key (kbd "C-x M-c M-b u t t e r f l y") 'butterfly)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-configuration)
