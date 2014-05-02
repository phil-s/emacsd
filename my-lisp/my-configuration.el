;; Set a preferred coding system
;; http://www.masteringemacs.org/articles/2012/08/09/working-coding-systems-unicode-emacs/
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-locale-environment "en_NZ.UTF-8")
(setq-default buffer-file-coding-system 'utf-8)
(when (boundp 'default-buffer-file-coding-system) ;; obsolete since 23.2
  (setq default-buffer-file-coding-system 'utf-8))
;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
;; Latin-4 facilitates macron accents (e.g. a- => ā).
(setq default-input-method "latin-4-postfix")

;; Put other files and dirs into .emacs.d
(setq bookmark-default-file "~/.emacs.d/bookmarks.bmk"
      eshell-directory-name "~/.emacs.d/eshell/")

;; Write backups to ~/.emacs.d/backup
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying      t  ; Don't de-link hard links
      version-control        t  ; Use version numbers on backups
      delete-old-versions    t  ; Automatically delete excess backups:
      kept-new-versions      20 ; How many of the newest versions to keep...
      kept-old-versions      5  ; ...and how many of the old.
      vc-make-backup-files   t) ; Make backups even for files under VCS.

(defvar my-non-file-buffer-auto-save-dir (file-name-directory user-init-file)
  "Directory in which to store auto-save files for non-file buffers,
when `auto-save-mode' is invoked manually.")

(defadvice auto-save-mode (around use-my-non-file-buffer-auto-save-dir)
  "Use a standard location for auto-save files for non-file buffers"
  (if (and (not buffer-file-name)
           (called-interactively-p 'any))
      (let ((default-directory my-non-file-buffer-auto-save-dir))
        ad-do-it)
    ad-do-it))
(ad-activate 'auto-save-mode)

;; No splash screen
(setq inhibit-startup-screen t)

;; Enable disabled commands
(put 'dired-find-alternate-file 'disabled nil)
(put 'downcase-region           'disabled nil)
(put 'narrow-to-page            'disabled nil)
(put 'narrow-to-region          'disabled nil)
(put 'scroll-left               'disabled nil)
(put 'upcase-region             'disabled nil)

;; Visible bell is much less annoying these days!
(setq visible-bell t)

;; Stop the cursor blinking
;; Cursor stretches to the current glyph's width
(blink-cursor-mode -1)
(setq x-stretch-cursor t)

;; Hide the tool bar
(tool-bar-mode -1)

;; Scroll-bar on the right-hand side
(set-scroll-bar-mode 'right)

;; Retain point when scrolling off-screen and back
(setq scroll-preserve-screen-position t)

;; Ignore case when searching and matching, and when reading
;; buffer names and file names
(setq case-fold-search t
      read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t)

;; Place killed text into the clipboard
(setq x-select-enable-clipboard t)

;; Save the clipboard to the kill ring if it would be clobbered
(setq save-interprogram-paste-before-kill t)

;; Show time in mode line
(require 'time)
(setq display-time-24hr-format t)
(display-time-mode 1)

;; Delay fontification to improve scrolling performance in large buffers
(setq jit-lock-defer-time 0.05)

;; Highlight current line
(global-hl-line-mode 1)

;; Use subword-mode
(global-subword-mode 1)

;; Protect important buffers
(when (require 'keep-buffers nil t)
  (keep-buffers-mode 1))

;; Ask for confirmation when exiting
(setq confirm-kill-emacs 'y-or-n-p)

;; A much larger message history
(setq message-log-max 10000)

;; Increase maximum length of history lists
(setq history-length 100)

;; Make scripts executable
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; Streamline parent directory creation when saving files.
(add-hook 'before-save-hook 'my-before-save-create-directory-maybe)

;; Enable winner mode
;; "C-c <left>" and "C-c <right>" undo and re-do window changes.
(winner-mode 1)

;; The arguments to `pop-to-buffer' have changed in Emacs 24.
;; I suspect this code is simply defunct now, and can be removed.
;; ;; Improve the dedicated window facility.
;; ;; See also: `toggle-window-dedicated'
;; ;; http://stackoverflow.com/questions/5151620
;; (defadvice pop-to-buffer (before cancel-other-window first)
;;   (ad-set-arg 1 nil))
;; (ad-activate 'pop-to-buffer)

;; Always add a final newline
(setq require-trailing-newline t)

;; Move by entire lines, not visual lines
(setq line-move-visual nil)

;; Do not overwrite the region by typing
(setq delete-active-region nil)

;; Recursive minibuffers lets us do neat things such as interactively
;; building command arguments using other commands.
(setq enable-recursive-minibuffers t)
(minibuffer-depth-indicate-mode 1)

;; Smarter line breaks when filling: Don't break a line after the
;; first word of a sentence, or before the last word of a paragraph.
(add-to-list 'fill-nobreak-predicate 'fill-single-word-nobreak-p)

;; TODO: Idea: Implement a "recently-closed files" group in ibuffer.
;; Collapsed by default. Selecting a buffer from this list will
;; re-visit the file.

;; Fix bug in Emacs 23.3.
;; This bug prevents ibuffer groups from working.
;; http://lists.gnu.org/archive/html/bug-gnu-emacs/2011-06/msg00117.html
(when (and (equal emacs-major-version 23)
           (equal emacs-minor-version 3))
  (eval-after-load "ibuf-ext"
    '(defun ibuffer-filter-disable ()
       "Disable all filters currently in effect in this buffer."
       (interactive)
       (setq ibuffer-filtering-qualifiers nil
             ) ;ibuffer-filter-groups nil
       (let ((buf (ibuffer-current-buffer)))
         (ibuffer-update nil t)
         (when buf
           (ibuffer-jump-to-buffer (buffer-name buf)))))))

;; Configure ibuffer columns
(setq ibuffer-formats '((mark modified read-only " " (name 30 60 :left :elide) " " (size 9 -1 :right) " " (mode 16 16 :left :elide) " " filename-and-process) (mark " " (name 16 -1) " " filename)))

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

;; Make ibuffer text smaller by default
;; TODO: Find how to make C-x 0 resets to this same smaller size.
;; (an issue since fixing a previous bug)
;;(autoload 'text-scale-mode "face-remap")
(add-hook 'ibuffer-mode-hook 'my-ibuffer-mode-hook)
(defun my-ibuffer-mode-hook ()
  (require 'face-remap)
  (let ((text-scale-mode-amount -1))
    (text-scale-mode)))

(defadvice ibuffer-do-print (before print-buffer-query activate)
  "Require user confirmation before printing current/marked buffers."
  (unless (y-or-n-p "Print buffer(s)? ")
    (error "Cancelled")))

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

;; Set titlebar text to buffer name, along with the file/directory path
;; as appropriate, image dimensions, which-function, etc...
(setq frame-title-format
      '(buffer-file-name
        ("%b (Emacs) %f" my-image-dimensions
         (which-func-mode (" " which-func-format)))
        (dired-directory
         (:eval (concat (buffer-name) " (Emacs) " dired-directory))
         ("%b (Emacs)"))))

;; Don't display which-function in the mode line.
(eval-after-load "which-func"
  '(setq mode-line-misc-info
         (assq-delete-all 'which-func-mode mode-line-misc-info)))

;; Prevent C-z minimizing frames
;;(defun iconify-or-deiconify-frame nil)

;; By default, raise an existing frame with buffer B in
;; preference to opening another copy in the current buffer.
(setq-default display-buffer-reuse-frames t)

;; Full-screen by default.
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(defun my-frame-config (frame)
  "Custom behaviours for new frames."
  (with-selected-frame frame
    ;; do things
    ))
;; Run now, for non-daemon Emacs...
(my-frame-config (selected-frame))
;; ...and later, for new frames / emacsclient
(add-hook 'after-make-frame-functions 'my-frame-config)

;; Show a marker in the left fringe for lines not in the buffer
(setq-default indicate-empty-lines t)
(when (boundp 'default-indicate-empty-lines) ;; obsolete since 23.2
  (setq default-indicate-empty-lines t))

;; Show approx buffer size in modeline
;; (size-indication-mode 1)

;; Shorter mode names text in the mode line.
(delight '((abbrev-mode " Abv" abbrev)
           (smart-tab-mode " \\t" smart-tab)
           (eldoc-mode nil eldoc)
           (ws-trim-mode nil ws-trim)
           (rainbow-mode)
           (emacs-lisp-mode "Elisp" lisp-mode)
           (lisp-interaction-mode "Elisp:Int" lisp-mode)))

;; Make URLs in comments/strings clickable
(add-hook 'find-file-hooks 'goto-address-prog-mode)
;; But not email addresses. This is a hack to never match anything.
;; (submit patch to enable email addresses to be disabled separately?)
(setq goto-address-mail-regexp "$^")

;; Use system trash (for emacs 23)
(setq delete-by-moving-to-trash t)

;; Highlight the matching parenthesis
(show-paren-mode t)
(require 'highlight-parentheses nil 'noerror)

;; Make apropos searches also find unbound symbols.
;; See my-keybindings.el for various custom apropos bindings.
(setq apropos-do-all t)

;; Better buffer naming when filenames conflict
(require 'uniquify)
(setq uniquify-buffer-name-style   'reverse
      uniquify-separator           "|"
      uniquify-after-kill-buffer-p t ; rename after killing uniquified
      uniquify-ignore-buffers-re   "^\\*") ; don't muck with special buffers

;; Increase the default undo limits
(when (< undo-limit 160000)
  (setq undo-limit 160000))
(when (< undo-strong-limit 240000)
  (setq undo-strong-limit 240000))

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

;; Guess the target directory (as prompt) when one is needed.
(setq dired-dwim-target t)

;; Do not omit .. in dired -- it's useful.
(setq dired-omit-files "^\\.?#\\|^\\.$")

;; Enable RET during an isearch in dired to immediately visit the file.
;; http://stackoverflow.com/questions/4471835/emacs-dired-mode-and-isearch
(add-hook 'isearch-mode-end-hook 'my-isearch-mode-end-hook)
(defun my-isearch-mode-end-hook ()
  "Make RET, during an isearch in dired, visit the file at point."
  (when (and (eq major-mode 'dired-mode)
             (not isearch-mode-end-hook-quit)
             (eq last-input-event ?\r))
    (dired-find-file)))

;; This wasn't working from `dired-load-hook'.
(eval-after-load "dired"
  '(progn
     ;; Enable dired-x by default
     (require 'dired-x)
     ;; Set dired-x global variables here.  For example:
     ;; (setq dired-guess-shell-gnutar "gtar")
     ;; (setq dired-x-hands-off-my-keys nil)

     ;; dired-details hides unwanted information by default
     (require 'dired-details)
     (dired-details-install)
     (define-key dired-mode-map (kbd "<tab>") 'dired-details-toggle)))

(add-hook 'dired-mode-hook 'my-dired-mode-hook)
(defun my-dired-mode-hook ()
  (local-set-key (kbd "<backtab>") 'dired-omit-mode)
  (local-set-key (kbd "<f5>") 'dired-omit-mode)
  (dired-omit-mode 1))

;; Use ControlMaster with TRAMP by default
(setq tramp-default-method "scpc"
      tramp-default-user   "phil")

;; Enable directory local variables with remote files.
(defadvice hack-dir-local-variables (around my-remote-dir-local-variables)
  "Allow dir-locals.el with remote files, by temporarily redefining
`file-remote-p' to return nil unconditionally."
  (require 'cl)
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

;; Sauron (keeping an eye on things)
(setq sauron-separate-frame nil
      sauron-scroll-to-bottom nil
      sauron-nick-insensitivity 0)

;; erc-mode (for IRC)
(eval-after-load "erc"
  '(progn
     ;; Add the following modules:
     ;; dcc: Provide Direct Client-to-Client support
     ;; keep-place: Leave point above un-viewed text
     ;; ;; log: Save buffers in logs
     (setq erc-modules (nconc erc-modules '(dcc keep-place))) ;; log
     (erc-update-modules)))

(add-hook 'erc-mode-hook 'my-erc-mode-hook)
(defun my-erc-mode-hook ()
  (hide-trailing-whitespace)
  (setq-local page-delimiter ;; e.g. [Fri Jan  5 2013]
              (rx (sequence
                   "[" (or "Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun")
                   " " (or "Jan" "Feb" "Mar" "Apr" "May" "Jun"
                           "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")
                   " " (optional " ") (repeat 1 2 digit)
                   " " (= 4 digit) "]"))))

(eval-after-load "which-func"
  '(add-to-list 'which-func-non-auto-modes 'erc-mode))

(add-hook 'erc-text-matched-hook 'my-notify-erc)
(declare-function 'erc-default-target "erc")
(defun my-notify-erc (match-type nickuserhost message)
  "Notify when a message is received."
  (notify (format "%s in %s"
                  ;; Username of sender
                  (car (split-string nickuserhost "!"))
                  ;; Channel
                  (or (erc-default-target) "#unknown"))
          ;; Remove duplicate spaces
          (replace-regexp-in-string " +" " " message)
          :icon "emacs-snapshot"
          :timeout -1))

;; Git
(add-hook 'magit-mode-hook 'my-magit-mode-hook)
(defun my-magit-mode-hook ()
  (hide-trailing-whitespace))

;; Term mode
(eval-after-load "term"
  '(progn
     ;; Default terminal history is much too small.
     (setq-default term-buffer-maximum-size 65535)
     ;; Enable terminal history in line mode (term-mode-map).
     (define-key term-mode-map (kbd "<C-up>") 'term-send-up)
     (define-key term-mode-map (kbd "<C-down>") 'term-send-down)
     ;; Disable killing and yanking in char mode (term-raw-map).
     (mapc
      (lambda (func)
        (eval `(define-key term-raw-map [remap ,func] 'my-interactive-ding)))
      '(backward-kill-paragraph
        backward-kill-sentence backward-kill-sexp backward-kill-word
        bookmark-kill-line kill-backward-chars kill-backward-up-list
        kill-forward-chars kill-line kill-paragraph kill-rectangle
        kill-region kill-sentence kill-sexp kill-visual-line
        kill-whole-line kill-word subword-backward-kill subword-kill
        yank yank-pop yank-rectangle))
     ;; Terminal buffer configuration.
     (add-hook 'term-mode-hook 'my-term-mode-hook)
     (defun my-term-mode-hook ()
       (subword-mode 0)
       (setq show-trailing-whitespace nil)
       (set (make-local-variable 'global-hl-line-mode) nil))))

;; Shell mode
(add-hook 'shell-mode-hook 'my-shell-mode-hook)
(defun my-shell-mode-hook ()
  (hide-trailing-whitespace)
  (ansi-color-for-comint-mode-on))

;; Don't intersperse stderr output with stdout
(setq shell-command-default-error-buffer "*stderr*")

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

;; Don't use a separate control frame for ediff, as it's not working
;; very well with my current config & window manager.
;; See also `ediff-setup-control-frame' and my full-screen by default
;; config above, which modifies `default-frame-alist'.
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; Default to side-by-side comparisons in ediff.
(setq ediff-split-window-function 'split-window-horizontally)

;; Use ediff instead of diff when typing 'd' in `save-some-buffers'
;; See variable `save-some-buffers-action-alist'
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
(defun my-revert-buffer (&optional ignore-auto noconfirm preserve-modes)
  "Revert buffer from file in an undo-able manner."
  (interactive)
  (when (buffer-file-name)
    ;; Based upon `delphi-save-state':
    ;; Ensure that any buffer modifications do not have any side
    ;; effects beyond the actual content changes.
    (let ((buffer-read-only nil)
          (inhibit-read-only t)
          (before-change-functions nil)
          (after-change-functions nil))
      (unwind-protect
          (progn
            ;; Prevent triggering `ask-user-about-supersession-threat'
            (set-visited-file-modtime)
            ;; Kill buffer contents and insert from associated file.
            (widen)
            (kill-region (point-min) (point-max))
            (insert-file-contents (buffer-file-name))
            ;; Mark buffer as unmodified.
            (set-buffer-modified-p nil))))))

(defadvice ask-user-about-supersession-threat
  (around my-supersession-revert-buffer)
  "Use my-revert-buffer in place of revert-buffer."
  (let ((real-revert-buffer (symbol-function 'revert-buffer)))
    (fset 'revert-buffer 'my-revert-buffer)
    ;; Note that `ask-user-about-supersession-threat' calls
    ;; (signal 'file-supersession ...), so we need to handle
    ;; the error in order to restore revert-buffer.
    (unwind-protect
        ad-do-it
      (fset 'revert-buffer real-revert-buffer))))
(ad-activate 'ask-user-about-supersession-threat)

;; See: http://stackoverflow.com/questions/9748521
(defadvice save-buffer (around my-save-buffer-mini-window-size)
  "Don't increase the height of the echo area when saving a file
when the file path is too long to show on one line."
  (let ((message-truncate-lines t))
    ad-do-it))
(ad-activate 'save-buffer)

;; Make linum's format calculation more efficient
(defvar my-linum-format-string "%4d")

(add-hook 'linum-before-numbering-hook 'my-linum-get-format-string)

(defun my-linum-get-format-string ()
  (let* ((width (length (number-to-string
                         (count-lines (point-min) (point-max)))))
         (format (concat "%" (number-to-string width) "d")))
    (setq my-linum-format-string format)))

(setq linum-format 'my-linum-format)

(defun my-linum-format (line-number)
  (propertize (format my-linum-format-string line-number) 'face 'linum))

;; By default, don't show continuation lines in grep results.
(add-hook 'grep-mode-hook 'my-grep-mode-hook)
(defun my-grep-mode-hook ()
  (setq truncate-lines t)
  (local-set-key (kbd "<f5>") 'toggle-truncate-lines))

;; ;; Don't grep for images or documents. (?)
;; (eval-after-load "grep"
;;   '(setq grep-find-ignored-files
;;          (nconc grep-find-ignored-files
;;                 '("*.png" "*.gif" "*.jpg" "*.jpeg" "*.tiff"
;;                   "*.pdf" "*.doc"))))

;; www / web / eww
(add-hook 'eww-mode-hook 'my-eww-mode-hook)
(defun my-eww-mode-hook ()
  (setq show-trailing-whitespace nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-configuration)
