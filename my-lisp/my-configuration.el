;; Consider switching variable set function for defcustom variables
;; From: (setq VAR VALUE) to: (customize-set-variable 'VAR VALUE "COMMENT")

;; Silence compiler warnings
(eval-when-compile
  (defvar apropos-do-all)
  (defvar bookmark-default-file)
  (defvar calendar-date-style)
  (defvar cua--region-keymap)
  (defvar cua-delete-selection)
  (defvar dired-dnd-protocol-alist)
  (defvar dired-dwim-target)
  (defvar dired-guess-shell-alist-user)
  (defvar dired-mode-map)
  (defvar dired-omit-files)
  (defvar ediff-split-window-function)
  (defvar ediff-window-setup-function)
  (defvar erc-log-channels-directory)
  (defvar erc-log-write-after-insert)
  (defvar erc-log-write-after-send)
  (defvar erc-prompt)
  (defvar erc-save-buffer-on-part)
  (defvar erc-save-queries-on-quit)
  (defvar erc-server-reconnect-attempts)
  (defvar erc-server-reconnect-timeout)
  (defvar eshell-directory-name)
  (defvar ffap-url-regexp)
  (defvar goto-address-mail-regexp)
  (defvar ibuffer-formats)
  (defvar linum-format)
  (defvar require-trailing-newline)
  (defvar sauron-nick-insensitivity)
  (defvar sauron-scroll-to-bottom)
  (defvar sauron-separate-frame)
  (defvar tramp-default-method)
  (defvar tramp-default-user)
  (declare-function delight "delight")
  (declare-function dired-details-install "dired-details")
  (declare-function dired-dnd-protocol-alist "dired")
  (declare-function dired-dwim-target "dired")
  (declare-function dired-find-file "dired")
  (declare-function dired-mode-map "dired")
  (declare-function keep-buffers-mode "keep-buffers")
  (declare-function my-isearch-delete "my-configuration")
  (declare-function notify "notify")
  )

;; Set a preferred coding system
;; http://www.masteringemacs.org/articles/2012/08/09/working-coding-systems-unicode-emacs/
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8) ;; also see `my-frame-config'
(set-keyboard-coding-system 'utf-8)
(set-locale-environment "en_NZ.UTF-8")
(setq-default buffer-file-coding-system 'utf-8)
(when (boundp 'default-buffer-file-coding-system) ;; obsolete since 23.2
  (setq default-buffer-file-coding-system 'utf-8))
;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
;; Latin-4 facilitates macron accents (e.g. a- => ā).
;; n.b. If `current-language-environment' is customized, it clobbers this.
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

;; No splash screen or start-up message.
(setq inhibit-startup-screen t)
(eval '(setq inhibit-startup-echo-area-message "phil"))

;; Enable disabled commands
(put 'dired-find-alternate-file 'disabled nil)
(put 'downcase-region           'disabled nil)
(put 'narrow-to-page            'disabled nil)
(put 'narrow-to-region          'disabled nil)
(put 'scroll-left               'disabled nil)
(put 'set-goal-column           'disabled nil)
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

;; Use day/month/year format in calendar
(setq calendar-date-style 'european)

;; Use stealth fontification.
;; n.b. This approach requires much more time for fontification to be
;; completed, and performance can be a little sluggish in the interim,
;; but this is a better solution to the annoying 'flash' of jit
;; fontification than incurring the unreasonable delay which comes
;; with invoking font-lock-fontify-buffer up-front.
(setq jit-lock-stealth-time 0.25
      jit-lock-chunk-size 2048)

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

;; This behaviour was regularly annoying.
;; Should probably remove, but just commenting for now.
;; ;; Smarter line breaks when filling: Don't break a line after the
;; ;; first word of a sentence, or before the last word of a paragraph.
;; (add-to-list 'fill-nobreak-predicate 'fill-single-word-nobreak-p)

;; ibuffer config.
(eval-when-compile
  (defvar ibuffer-filtering-qualifiers)
  (defvar ibuffer-filtering-alist)
  (declare-function ibuffer-current-buffer "ibuffer")
  (declare-function ibuffer-update "ibuffer")
  (declare-function ibuffer-jump-to-buffer "ibuf-ext")
  (declare-function ibuffer-push-filter "ibuf-ext")
  (declare-function text-scale-mode "face-remap"))

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
(eval-when-compile
  (declare-function text-scale-mode "face-remap"))
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
        ("%b (Emacs) %f" image-dimensions-minor-mode-dimensions
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

(defun my-terminal-visible-bell ()
  "A friendlier visual bell effect."
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil 'invert-face 'mode-line))

(defun my-visible-bell-activate ()
  "Use `my-terminal-visible-bell' as the `ring-bell-function'."
  (interactive)
  (setq visible-bell nil
        ring-bell-function 'my-terminal-visible-bell))

(defun my-configure-visible-bell ()
  "Use a nicer visual bell in terminals."
  ;; (if window-system
  ;;     (setq visible-bell t
  ;;           ring-bell-function nil)
  ;;   (my-visible-bell-activate))

  ;; standard visible-bell is awful under xmonad, so just use:
  (my-visible-bell-activate)
  )

;; (defun my-configure-visible-bell ()
;;   "Use a nicer visual bell in terminals."
;;   (if window-system
;;       (setq visible-bell t
;;             ring-bell-function nil)
;;     (setq visible-bell nil
;;           ring-bell-function 'my-terminal-visible-bell)))

(add-hook 'focus-in-hook 'my-configure-visible-bell)

;; Per-frame/terminal configuration.
(defun my-frame-config (frame)
  "Custom behaviours for new frames."
  (with-selected-frame frame
    ;; do things
    (my-configure-visible-bell)
    (unless window-system
      (set-terminal-coding-system 'utf-8))
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
(let ((my-lexbind-indicator
       ;; Indicate/toggle dynamic/lexical binding in elisp buffers.
       '(:propertize
         (lexical-binding ":Lex" ":Dyn")
         mouse-face mode-line-highlight
         local-map (keymap (mode-line
                            keymap (down-mouse-1
                                    "Toggle" . lexbind-toggle-lexical-binding)))
         help-echo (lambda (window object pos)
                     (format "Switch to %s binding"
                             (if lexical-binding "dynamic" "lexical"))))))
  ;; Override specified mode names in the mode line.
  (delight `((abbrev-mode " Abv" abbrev)
             (smart-tab-mode " \\t" smart-tab)
             (eldoc-mode nil eldoc)
             (elisp-slime-nav-mode " ." elisp-slime-nav)
             (ws-trim-mode nil ws-trim)
             (rainbow-mode)
             (lexbind-mode)
             (auto-revert-mode " Rvt" autorevert)
             (magit-auto-revert-mode " MRvt" magit)
             (dired-mode "Dired" :major)
             (emacs-lisp-mode
              ("Elisp" ,my-lexbind-indicator) :major)
             (lisp-interaction-mode
              ("iElisp" ,my-lexbind-indicator) :major))))

;; Display the hostname in the mode-line
;; I tend to run enough emacs instances to make this valuable.
(defvar my-hostname
  (shell-command-to-string "printf @%s \"$(hostname)\"")
  "Local hostname")

(add-to-list 'mode-line-misc-info 'my-hostname :append)

;; Use Firefox as the default web browser
(setq browse-url-browser-function 'browse-url-firefox)

;; Make URLs in comments/strings clickable
(add-hook 'find-file-hook 'goto-address-prog-mode)
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
(add-hook 'find-file-hook
          'my-find-file-check-make-large-file-read-only-hook)

;; ;; Interactively Do Things
;; (require 'ido)
;; (ido-mode t)
;; (setq ido-enable-flex-matching t) ;; enable fuzzy matching

(when (fboundp 'with-isearch-suspended)
  (define-key isearch-mode-map (kbd "<C-backspace>") #'my-isearch-delete)
  (defun my-isearch-delete ()
    "Delete the failed portion of the search string.

If the current search is successful, then only delete the last char."
    (interactive)
    (with-isearch-suspended
     (setq isearch-new-string
           (substring isearch-string 0 (or (isearch-fail-pos)
                                           (1- (length isearch-string))))
           isearch-new-message
           (mapconcat 'isearch-text-char-description isearch-new-string "")))))

;;; Dired

;; Don't allow dragging and dropping files into dired
(setq dired-dnd-protocol-alist nil)

;; Guess the target directory (as prompt) when one is needed.
(setq dired-dwim-target t)

;; Do not omit .. in dired -- it's useful.
(setq dired-omit-files "^\\.?#\\|^\\.$")
;;
;; ...except when we are inserting sub-directories,
;; as it just makes things messy in those cases.
(defadvice dired-insert-subdir (before my-dired-omit-parents)
  "Omit parent .. directories if inserting subdirectories."
  (setq-local dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$"))
(ad-activate 'dired-insert-subdir)

;; Override the default suggested commands for '!' binding.
(setq dired-guess-shell-alist-user
      '(("\\.pdf\\'" "evince")
        ("\\.ps\\'" "evince")))

;; Recursive-deleting multiple directories in dired is just a bit
;; painful with the default yes-or-no-p prompt every time.
;; TODO: Investigate a single top-level yes-or-no-p confirmation
;; for *all* recursive deletions.

;; Enable RET during an isearch in dired to immediately visit the file.
;; http://stackoverflow.com/questions/4471835/emacs-dired-mode-and-isearch
(add-hook 'isearch-mode-end-hook 'my-isearch-mode-end-hook)
(defun my-isearch-mode-end-hook ()
  "Make RET, during an isearch in dired, visit the file at point."
  (when (and (eq major-mode 'dired-mode)
             (not isearch-mode-end-hook-quit)
             (eq last-input-event ?\r))
    (dired-find-file)))

;; n.b. We bind C-x C-j to `my-dired-jump' in my-keys-minor-mode, so
;; this won't really be used. The custom function facilitates using
;; C-u C-x C-j instead of typing 'a' on the '..' entry in a dired
;; buffer (and of course works with non-directory buffers too).
(autoload 'dired-jump "dired-x"
  "Jump to Dired buffer corresponding to current buffer." t)

(autoload 'dired-jump-other-window "dired-x"
  "Like \\[dired-jump] (dired-jump) but in other window." t)

(autoload 'dired-omit-mode "dired-x"
  "Toggle omission of uninteresting files in Dired (Dired-Omit mode).")

(defun my-dired-load-hook ()
  "Would be used with `dired-load-hook', but that's broken for me.

`dired-load-hook' is unreliable. (Report a it as a bug?)
`dired-load-hook' does not get called when `dired' is autoloaded!?
Info node \"(dired-x) Installation\" indicates that it should work.

n.b. It works in a sandbox, so it seems that something in my config breaks it."
  (require 'dired-x)
  ;; Set dired-x global variables here.  For example:
  ;; (setq dired-guess-shell-gnutar "gtar")
  ;; (setq dired-x-hands-off-my-keys nil)

  ;; dired-details hides unwanted information by default.
  ;; n.b. Recent versions of Emacs include `dired-hide-details-mode',
  ;; so in time we could switch to that.
  (require 'dired-details)
  (dired-details-install)

  (define-key dired-mode-map (kbd "M-k") 'dired-kill-subdir)
  (define-key dired-mode-map (kbd "<tab>") 'dired-details-toggle))

(eval-after-load "dired" '(my-dired-load-hook))

(add-hook 'dired-mode-hook 'my-dired-mode-hook)
(defun my-dired-mode-hook ()
  (local-set-key (kbd "<backtab>") 'dired-omit-mode)
  (local-set-key (kbd "<f5>") 'dired-omit-mode)
  (dired-omit-mode 1))

;; Use ControlMaster with TRAMP by default
(setq tramp-default-method "ssh"
      tramp-default-user   "phil")

;; Enable directory local variables with remote files.
(defadvice hack-dir-local-variables (around my-remote-dir-local-variables)
  "Allow dir-locals.el with remote files, by temporarily redefining
`file-remote-p' to return nil unconditionally."
  (require 'cl-lib)
  (cl-letf (((symbol-function 'file-remote-p)
             (lambda (&rest _) nil)))
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
(eval-when-compile
  (defvar erc-modules)
  (declare-function erc-default-target "erc")
  (declare-function erc-update-modules "erc"))

(eval-after-load "erc"
  '(progn
     ;; Add the following modules:
     ;; dcc: Provide Direct Client-to-Client support
     ;; keep-place: Leave point above un-viewed text
     ;; ;; log: Save buffers in logs
     ;; ;; using `erc-log-mode' instead (see below).
     ;; ;; (is that the same thing?)
     (setq erc-modules (nconc erc-modules '(dcc keep-place))) ;; log
     (erc-update-modules)))

;; Auto-log (and restore!?) channels
(setq-default erc-enable-logging t)
(setq erc-save-buffer-on-part nil
      erc-save-queries-on-quit nil
      erc-log-write-after-send t
      erc-log-write-after-insert t
      ;; erc-log-insert-log-on-open t ;; So bad. Why?
      erc-log-channels-directory (file-name-as-directory
                                  (concat user-emacs-directory "erc"))
      erc-server-reconnect-attempts 12
      erc-server-reconnect-timeout 5
      erc-prompt 'my-erc-prompt
      )

(defun my-erc-prompt ()
  "Prompt generator function assigned to the `erc-prompt' variable."
  (concat "[" (buffer-name) "]>"))

(add-hook 'erc-mode-hook 'my-erc-mode-hook)
(defun my-erc-mode-hook ()
  (erc-log-mode 1)
  (setq-local page-delimiter ;; e.g. [Fri Jan  5 2013]
              (rx (sequence
                   "[" (or "Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun")
                   " " (or "Jan" "Feb" "Mar" "Apr" "May" "Jun"
                           "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")
                   " " (optional " ") (repeat 1 2 digit)
                   " " (= 4 digit) "]"))))

(eval-when-compile
  (defvar which-func-non-auto-modes))
(eval-after-load "which-func"
  '(add-to-list 'which-func-non-auto-modes 'erc-mode))

(add-hook 'erc-text-matched-hook 'my-notify-erc)
(eval-when-compile
  (declare-function erc-default-target "erc"))
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

;; Use `erc-disconnected-hook' instead?
(defadvice erc-display-message (before sauron-notify-disconnect)
  "Make Sauron announce any permanent disconnection."
  (let ((msg (ad-get-arg 3)))
    (when (and (eq msg 'disconnected-noreconnect)
               (featurep 'sauron))
      (sauron-add-event
       'erc 5 (propertize (replace-regexp-in-string
                           "\\`[[:space:]\n]+" ""
                           (erc-format-message 'disconnected-noreconnect))
                          'face 'warning)))))
(ad-activate 'erc-display-message)

;; Term mode
(eval-when-compile
  (defvar term-mode-map)
  (defvar term-raw-map)
  (declare-function term-send-raw-string "term"))

(eval-after-load "term"
  '(progn
     ;; Default terminal history is much too small.
     (setq-default term-buffer-maximum-size 65535)
     ;; Enable terminal history in line mode (term-mode-map).
     (define-key term-mode-map (kbd "<C-up>") 'term-send-up)
     (define-key term-mode-map (kbd "<C-down>") 'term-send-down)
     ;; Enable ESC-x as a substitute for M-x (which sends term-send-raw-meta)
     (define-key term-raw-map (kbd "<escape> x") 'execute-extended-command)
     ;; Fix forward/backward word when (term-in-char-mode).
     (define-key term-raw-map (kbd "<C-left>")
       (lambda () (interactive) (term-send-raw-string "\eb")))
     (define-key term-raw-map (kbd "<M-left>")
       (lambda () (interactive) (term-send-raw-string "\eb")))
     (define-key term-raw-map (kbd "<C-right>")
       (lambda () (interactive) (term-send-raw-string "\ef")))
     (define-key term-raw-map (kbd "<M-right>")
       (lambda () (interactive) (term-send-raw-string "\ef")))
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
        yank yank-pop yank-rectangle))))

;; Terminal buffer configuration.
(add-hook 'term-mode-hook 'my-term-mode-hook)
(defun my-term-mode-hook ()
  (subword-mode 0)
  (set (make-local-variable 'global-hl-line-mode) nil))

;; Shell mode
(add-hook 'shell-mode-hook 'my-shell-mode-hook)
(defun my-shell-mode-hook ()
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
                    (with-current-buffer buf
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

;; ;; www / web / eww
;; (add-hook 'eww-mode-hook 'my-eww-mode-hook)
;; (defun my-eww-mode-hook ()
;;   )

;; Show image dimensions in the mode line. See also frame-title-format.
(eval-after-load 'image-mode '(require 'image-dimensions-minor-mode))

;; Always open man pages in the same window.
(add-to-list 'display-buffer-alist
             (cons (lambda (buffer alist)
                     (with-current-buffer buffer
                       (eq major-mode 'Man-mode)))
                   (cons 'display-buffer-reuse-major-mode-window
                         '((inhibit-same-window . nil)
                           (reusable-frames . visible)
                           (inhibit-switch-frame . nil)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-configuration)
