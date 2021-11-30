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
  (defvar ediff-control-buffer)
  (defvar ediff-current-difference)
  (defvar ediff-mode-map)
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
  (defvar erc-track-exclude-types)
  (defvar eshell-directory-name)
  (defvar ffap-url-regexp)
  (defvar goto-address-mail-regexp)
  (defvar grep-find-ignored-files)
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
  (declare-function ediff-copy-diff "ediff-util")
  (declare-function ediff-get-region-contents "ediff-util")
  (declare-function ediff-setup-windows-plain "ediff-wind")
  (declare-function erc-log-mode "erc-log")
  (declare-function keep-buffers-mode "keep-buffers")
  (declare-function my-fortune-set-initial-scratch-message "my-utilities")
  (declare-function my-isearch-delete "my-configuration")
  (declare-function notify "notify")
  (declare-function outline-show-all "outline")
  (declare-function which-key-mode "which-key")
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

;; Partial workaround for X paste bug/hanging.
;; The paste fails :/ but at least we don't hang for long!
;; 25.1 shouldn't have this bug, based on:
;; http://debbugs.gnu.org/cgi/bugreport.cgi?bug=16737
(setq x-selection-timeout 1000)

;; Put other files and dirs into .emacs.d
(setq bookmark-default-file "~/.emacs.d/bookmarks.bmk"
      eshell-directory-name "~/.emacs.d/eshell/")

;; Write backups to ~/.emacs.d/backup
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying      t  ; Don't de-link hard links
      version-control        t  ; Use version numbers on backups
      delete-old-versions    t  ; Automatically delete excess backups:
      kept-new-versions      50 ; How many of the newest versions to keep...
      kept-old-versions      10 ; ...and how many of the old.
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

;; Auto-save for edit-server.el buffers.
(add-hook 'edit-server-start-hook 'my-edit-server-start-hook :append)
;; We :append because we expect other hook functions to potentially
;; change the major mode, and we want that to happen first.
(defun my-edit-server-start-hook ()
  "Enable auto-save for edit-server buffers."
  ;; Determine the directory to which the auto-saves will be written.
  (let ((default-directory (file-name-as-directory
                            (concat user-emacs-directory "edit-server"))))
    (auto-save-mode 1)))

;; No splash screen or start-up message.
(setq inhibit-startup-screen t)
(eval '(setq inhibit-startup-echo-area-message "phil"))

;; Set `initial-scratch-message'.
;; (Deferred until my-utilities.el has loaded.)
(add-hook 'after-init-hook #'my-fortune-set-initial-scratch-message)

;; Restore traditional `yow' functionality.
(setq yow-file (expand-file-name "~/.emacs.d/yow.lines"))
(autoload 'yow "yow"
  "Return or display a random Zippy quotation.  With prefix arg, insert it."
  :interactive)
(autoload 'insert-zippyism "yow"
  "Prompt with completion for a known Zippy quotation, and insert it at point."
  :interactive)
(autoload 'apropos-zippy "yow"
  "Return a list of all Zippy quotes matching REGEXP."
  :interactive)
(autoload 'psychoanalyze-pinhead "yow"
  "Zippy goes to the analyst."
  :interactive)

;; Enable disabled commands
(put 'dired-find-alternate-file 'disabled nil)
(put 'downcase-region           'disabled nil)
(put 'erase-buffer              'disabled nil)
(put 'list-timers               'disabled nil)
(put 'narrow-to-page            'disabled nil)
(put 'narrow-to-region          'disabled nil)
(put 'scroll-left               'disabled nil)
(put 'set-goal-column           'disabled nil)
(put 'upcase-region             'disabled nil)
(put 'magit-diff-edit-hunk-commit 'disabled nil)

;; Stop the cursor blinking
;; Cursor stretches to the current glyph's width
(blink-cursor-mode -1)
(setq x-stretch-cursor t)

;; Things that I'm now doing in early-init.el in 27+.
(when (< emacs-major-version 27)
  ;; Hide the tool bar
  (tool-bar-mode -1)

  ;; Scroll-bar on the right-hand side
  (set-scroll-bar-mode 'right)

  ;; No horizontal scroll bars.
  (when (fboundp 'horizontal-scroll-bar-mode)
    (horizontal-scroll-bar-mode 0))

  ;; Per-frame/terminal configuration.
  (defun my-frame-behaviours (&optional frame)
    "Make frame- and/or terminal-local changes."
    (with-selected-frame (or frame (selected-frame))
      ;; do things
      (unless window-system
        (set-frame-parameter frame 'menu-bar-lines 0)
        (set-terminal-coding-system 'utf-8))
      ))
  ;; Run now, for non-daemon Emacs...
  (my-frame-behaviours)
  ;; ...and later, for new frames / emacsclient
  (add-hook 'after-make-frame-functions 'my-frame-behaviours)
  ) ;; End of early-init.el code for Emacs 26 and earlier.

;; Retain point when scrolling off-screen and back
(setq scroll-preserve-screen-position t)

;; Disable bi-directional display support for performance reasons.
;; The performance implications of this feature are probably very
;; minor in most cases; but the likes of bug #23801, when combined
;; with being fairly confident that this is a feature I will never
;; need, makes a strong case for disabling it by default.
(setq-default bidi-display-reordering nil)

;; Ignore case when searching and matching, and when reading
;; buffer names and file names
(setq case-fold-search t
      read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t)

;; Place killed text into the clipboard
(setq select-enable-clipboard t)

;; Save the clipboard to the kill ring if it would be clobbered
(setq save-interprogram-paste-before-kill t)

;; Show time in mode line
(require 'time)
(setq display-time-24hr-format t)
(display-time-mode 1)

;; Use day/month/year format in calendar
(setq calendar-date-style 'european)

;; The week begins on Monday, not Sunday.
;; (It's right there in the name: WeekEND.)
(setq calendar-week-start-day 1)

;; Make the `zap-up-to-char' command available.
(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR."
  :interactive)

;; Use stealth fontification.
;; n.b. This approach requires much more time for fontification to be
;; completed, and performance can be a little sluggish in the interim,
;; but this is a better solution to the annoying 'flash' of jit
;; fontification than incurring the unreasonable delay which comes
;; with invoking font-lock-fontify-buffer up-front.
(setq jit-lock-stealth-time 0.25
      jit-lock-chunk-size 2048)

;; Highlight current line, except in certain major modes.
(global-hl-line-mode 1)

(defun my-global-hl-line-mode-inhibit ()
  "Inhibit `global-hl-line-mode' buffer-locally."
  (setq-local global-hl-line-mode nil))

(dolist (name '(calendar term))
  (add-hook (intern (format "%s-mode-hook" name))
            #'my-global-hl-line-mode-inhibit))

;; Use subword-mode
(global-subword-mode 1)

;; Protect important buffers
(when (require 'keep-buffers nil t)
  (keep-buffers-mode 1))

;; Ask for confirmation when exiting
(setq confirm-kill-emacs 'y-or-n-p)

;; Enable M-x kill-process (to kill the current buffer's process).
;; (This is not normally a command, but it is useful as one.)
(put 'kill-process 'interactive-form
     '(interactive
       (let ((proc (get-buffer-process (current-buffer))))
         (if (process-live-p proc)
             (unless (yes-or-no-p (format "Kill %S? " proc))
               (error "Process not killed"))
           (error (format "Buffer %s has no process" (buffer-name))))
         (list proc))))

;; A much larger message history
(setq message-log-max 10000)

;; Increase maximum length of history lists
(setq history-length 100)

;; Default to spaces for indentation, and a tab width of 4 spaces.
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Make scripts executable
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; Streamline parent directory creation when saving files.
(add-hook 'before-save-hook 'my-before-save-create-directory-maybe)

;; Enable winner mode
;; "C-c <left>" and "C-c <right>" undo and re-do window changes.
(winner-mode 1)

;; Windmove.
(windmove-default-keybindings) ;default modifier is <SHIFT>
;; Use framemove, integrated with windmove.
(when (require 'framemove nil :noerror)
  (setq framemove-hook-into-windmove t))
;; Windmove Display.  Use the indicated window for the *next* command.
(global-set-key (kbd "<menu> <left>")   'windmove-display-left)
(global-set-key (kbd "<menu> <right>")  'windmove-display-right)
(global-set-key (kbd "<menu> <up>")     'windmove-display-up)
(global-set-key (kbd "<menu> <down>")   'windmove-display-down)
(global-set-key (kbd "<menu> <kp-insert>") 'windmove-display-same-window)
;; Not sure which set I'll like best, so try both.
;; (They're both a little awkward, tbh.)
(global-set-key (kbd "<s-left>")  'windmove-display-left)
(global-set-key (kbd "<s-right>") 'windmove-display-right)
(global-set-key (kbd "<s-up>")    'windmove-display-up)
(global-set-key (kbd "<s-down>")  'windmove-display-down)
(global-set-key (kbd "<s-kp-insert>") 'windmove-display-same-window)

;; `switch-to-buffer' should display the buffer at its previous
;; position in the selected window, provided the buffer is currently
;; displayed in some other window on any visible or iconified frame.
(setq switch-to-buffer-preserve-window-point 'already-displayed)

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

;; Enable the which-key library.
(which-key-mode 1)

;; Recursive minibuffers lets us do neat things such as interactively
;; building command arguments using other commands.
(setq enable-recursive-minibuffers t)
(minibuffer-depth-indicate-mode 1)

;; M-< in minibuffer initially moves only to the end-of-prompt.
(setq minibuffer-beginning-of-buffer-movement t)

;; Do not use the new 'pretty' quoting that makes quotes unsearchable
;; and unusable in verbatim copy/paste scenarios.  The old style was
;; never a problem, so let's not introduce issues for the sake of
;; accommodating a new approach that we don't need.
(setq text-quoting-style 'grave)

;; Avoid garbage collection in the minibuffer, for improved responsiveness.
(add-hook 'minibuffer-setup-hook #'my-gc-cons-threshold-set-large)
(add-hook 'minibuffer-exit-hook #'my-gc-cons-threshold-set-normal)

;; This behaviour was regularly annoying.
;; Should probably remove, but just commenting for now.
;; ;; Smarter line breaks when filling: Don't break a line after the
;; ;; first word of a sentence, or before the last word of a paragraph.
;; (add-to-list 'fill-nobreak-predicate 'fill-single-word-nobreak-p)

;; `display-fill-column-indicator-mode' (27+).
(when (fboundp 'global-display-fill-column-indicator-mode)
  (global-display-fill-column-indicator-mode 1))

;; Do smart things when creating new files.
;; See `auto-insert-alist'.
(add-hook 'find-file-hook 'auto-insert)
;; (setq auto-insert-query nil)

;; If SIGUSR1 is received, start a server.
;; Connect to it with: "emacsclient -s server<PID>" for a given process ID.
;; This socket will be visible in `server-socket-dir'.
(define-key special-event-map [sigusr1] 'sigusr1-handler)
(defun sigusr1-handler ()
  "Handler for SIGUSR1 signal.

Can be tested with (signal-process (emacs-pid) 'sigusr1)"
  (interactive)
  (require 'server)
  (let ((newname (format "server%d" (emacs-pid))))
    (unless (equal server-name newname)
      (message "Changed `server-name' from %s to %s"
               server-name
               (setq server-name newname))))
  (server-force-delete)
  (server-start))

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
  "Used in `ibuffer-mode-hook'."
  (require 'face-remap)
  (let ((text-scale-mode-amount -1))
    (text-scale-mode)))

(defadvice ibuffer-do-print (before print-buffer-query activate)
  "Require user confirmation before printing current/marked buffers."
  (unless (y-or-n-p "Print buffer(s)? ")
    (error "Cancelled")))

;; ;; ibuffer auto-revert support.
;; ;; http://emacs.stackexchange.com/a/2179/454
;; ;; n.b. ibuffer already sets `revert-buffer-function' to `ibuffer-update'.
;; (defun my-ibuffer-stale-p (&optional noconfirm)
;;   "Re-use the variable that's used for `ibuffer-auto-mode'."
;;   (frame-or-buffer-changed-p 'ibuffer-auto-buffers-changed))
;;
;; (defun my-ibuffer-auto-revert-setup ()
;;   (require 'ibuf-ext)
;;   (setq-local buffer-stale-function 'my-ibuffer-stale-p)
;;   (setq-local auto-revert-verbose nil)
;;   (auto-revert-mode 1))
;;
;; (add-hook 'ibuffer-mode-hook 'my-ibuffer-auto-revert-setup)

;; Enable find-file-at-point key-bindings.
;; See also: `my-copy-buffer-file-name'.
(ffap-bindings) ; see variable `ffap-bindings'
(setq ffap-url-regexp nil) ; disable URL features in ffap
;; ffap.el changed significantly in 27.1
(if (< emacs-major-version 27)
    (progn
      (defadvice ffap-alternate-file (around my-ffap-alternate-file-fallback)
        "Provide fall-back to old C-x C-v behaviour, if no `ffap-file-at-point'.
n.b. ffap-alternate-file is intended for interactive use only."
        (if (ffap-guesser)
            ad-do-it
          (call-interactively 'find-alternate-file)))
      (ad-activate 'ffap-alternate-file))
  ;; Emacs 27+
  (defadvice ffap-read-file-or-url (around my-ffap-alternate-file-fallback)
    "Provide fall-back to old C-x C-v behaviour, if no `ffap-file-at-point'."
    (unless (ad-get-arg 1)
      (when (eq this-command 'ffap-alternate-file)
        (ad-set-arg 1 (buffer-file-name))))
    ad-do-it)
  (ad-activate 'ffap-read-file-or-url))

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
  "Used in `cua-mode-hook'."
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

;; This is no longer helpful, as I don't have window titles any more.
;; ;; Don't display which-function in the mode line.
;; (eval-after-load "which-func"
;;   '(setq mode-line-misc-info
;;          (assq-delete-all 'which-func-mode mode-line-misc-info)))

;; Prevent C-z minimizing frames
;;(defun iconify-or-deiconify-frame nil)

;; By default, raise an existing frame with buffer B in
;; preference to opening another copy in the current buffer.
(setq-default display-buffer-reuse-frames t)

;; Full-screen by default.
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; The visible bell is usually fine, but still horrid in certain terminals.
;; We can make a nicer version.
(defun my-visible-bell ()
  "A friendlier visual bell effect."
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil #'invert-face 'mode-line))

(define-minor-mode my-visible-bell-mode
  "Use `my-visible-bell' as the `ring-bell-function'."
  :global t
  (let ((this 'my-visible-bell-mode))
    (if my-visible-bell-mode
        (progn
          (put this 'visible-bell-backup visible-bell)
          (put this 'ring-bell-function-backup ring-bell-function)
          (setq visible-bell nil
                ring-bell-function #'my-visible-bell))
      ;; Restore the original values when disabling.
      (setq visible-bell (get this 'visible-bell-backup)
            ring-bell-function (get this 'ring-bell-function-backup)))))

(setq visible-bell t)
(my-visible-bell-mode 1)

;; I no longer like the default visible bell in GUI Emacs, so the following
;; no longer applies. However, it's useful to retain the details in case I
;; ever want to switch back...
;;
;; ;; In GUI Emacs I prefer the default visible-bell, so I'd ideally like to
;; ;; switch automatically depending on the currently-focused frame.
;; ;; Unfortunately these variables aren't terminal-local, which makes it more
;; ;; awkward. My current approach is to use `focus-in-hook', which doesn't
;; ;; catch all situations, but certainly accounts for many (and if you don't
;; ;; switch between GUI and terminal frames, it should be fine in any case).
;; (defun my-configure-visible-bell (&optional frame)
;;   "Use the nicest visual bell for the given FRAME type."
;;   (with-selected-frame (or frame (selected-frame))
;;     (if window-system
;;         (setq visible-bell t
;;               ring-bell-function nil)
;;       (setq visible-bell nil
;;             ring-bell-function #'my-visible-bell))))
;;
;; ;; Run now, for non-daemon Emacs...
;; (my-configure-visible-bell)
;; ;; ...and later, for new frames / emacsclient
;; (add-hook 'after-make-frame-functions 'my-configure-visible-bell)
;; ;; ...and whenever a frame gains input focus.
;; (add-hook 'focus-in-hook 'my-configure-visible-bell)

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
                             (if lexical-binding "dynamic" "lexical")))))
      ;; Mode name for `re-builder', including a syntax indicator.
      (reb-mode-name
       '("Regexp[" (:eval (symbol-name reb-re-syntax)) "]"))
      (reb-lisp-mode-name
       '("Regexp[" (:eval (cond ((eq reb-re-syntax 'rx) "rx-to-string")
                                (t (symbol-name reb-re-syntax))) "]"))))
  (delight `(;; Override specified mode names in the mode line.
             (abbrev-mode " Abv" abbrev)
             (auto-revert-mode " Rvt" autorevert)
             (eldoc-mode nil eldoc)
             (elisp-slime-nav-mode " ." elisp-slime-nav)
             (lexbind-mode)
             (magit-auto-revert-mode " MRvt" magit)
             (magit-wip-after-apply-mode nil magit-wip)
             (magit-wip-after-save-local-mode nil magit-wip)
             (magit-wip-before-change-mode nil magit-wip)
             (my-contextual-help-mode nil my-programming)
             (rainbow-mode)
             (smart-tab-mode " \\t" smart-tab)
             (which-key-mode nil which-key)
             (ws-trim-mode nil ws-trim)
             ;; Major modes
             (emacs-lisp-mode ("Elisp" ,my-lexbind-indicator) :major)
             (lisp-interaction-mode ("iElisp" ,my-lexbind-indicator) :major)
             (reb-mode ,reb-mode-name :major)
             (reb-lisp-mode ,reb-lisp-mode-name :major)
             )))

;; Display the hostname in the mode-line
(add-to-list 'mode-line-misc-info (list "@" 'system-name) :append)

;; Display the hostname and time in the minibuffer window.
(defun my-minibuffer-line-justify-right (text)
  "Return a string of `window-width' length with TEXT right-aligned."
  (with-selected-window (minibuffer-window)
    (format (format "%%%ds" ;; terminals appear to need 1 column fewer.
                    (if window-system (window-width) (1- (window-width))))
            text)))

;; https://old.reddit.com/r/emacs/comments/jzh7on shows the following,
;; which copes with changes to the frame width.
;;
;; (let* ((str "I'm right aligned!")
;;        (width (string-width str)))
;;   (message
;;    (concat
;;     (propertize
;;      " "
;;      'display
;;      `(space :align-to (- right-fringe ,width)))
;;     str))))

(defun my-minibuffer-line-config ()
  "Require and configure the `minibuffer-line' library."
  (when (require 'minibuffer-line nil :noerror)
    (setq minibuffer-line-refresh-interval 5
          minibuffer-line-format
          '("" (:eval (my-minibuffer-line-justify-right
                       (concat system-name
                               " | "
                               (format-time-string "%F %R"))))))
    (set-face-attribute 'minibuffer-line nil :inherit 'unspecified)
    (set-face-attribute 'minibuffer-line nil :foreground "dark gray")
    (minibuffer-line-mode 1)))

;; Assume `minibuffer-line' is installed as an ELPA package.
(add-hook 'after-init-hook 'my-minibuffer-line-config)

;; Use Pale Moon as the default web browser.
(setq browse-url-browser-function 'browse-url-palemoon)

;; Do not expose certain information in HTTP request headers
(setq url-privacy-level '(emacs email lastloc))
(url-setup-privacy-info)

(defvar my-non-matching-regexp "\\`\\b\\B"
  "A regexp which will efficiently never match any text.")

;; Make URLs in comments/strings clickable
(add-hook 'find-file-hook 'goto-address-prog-mode)
;; But not email addresses. This is a hack to never match anything.
;; (submit patch to enable email addresses to be disabled separately?)
(setq goto-address-mail-regexp my-non-matching-regexp)

;; Enable visiting URLs with C-x C-f
(url-handler-mode 1)

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
(when (< undo-limit 320000)
  (setq undo-limit 320000))
(when (< undo-strong-limit 480000)
  (setq undo-strong-limit 480000))
(when (< undo-outer-limit 48000000)
  (setq undo-outer-limit 48000000))

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

;; Make the avy library use more keys.
(setq avy-keys
      (nconc '(?\r)
             (number-sequence ?a ?z)
             (number-sequence ?1 ?9)
             '(?0)))

;;; Dired

;; Don't allow dragging and dropping files into dired
(setq dired-dnd-protocol-alist nil)

;; Guess the target directory (as prompt) when one is needed.
(setq dired-dwim-target t)

;; Make dired commands like `dired-mark-files-containing-regexp'
;; search the saved file content rather than unsaved buffer text.
(setq dired-always-read-filesystem t)

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

;; Recognise saved dired buffers.
;; Supports both 'ls' and 'find+ls' dired buffers.
;; Regexp is fairly specific, to avoid false-positives.
(add-to-list 'magic-mode-alist
             (cons (rx (seq (seq bos "  /" (+ not-newline) ":\n  ")
                            (or (seq "total used in directory"
                                     (+ not-newline) "\n" (+ space))
                                (seq "find " (+ not-newline) " -ls\n"
                                     (regexp " +[0-9]+ +[0-9]+ +")))
                            (regexp "[-d]\\(?:[-r][-w][-xs]\\)\\{3\\}")
                            (regexp " +[0-9]+ ")))
                   #'my-dired-virtual-mode))

(defun my-dired-virtual-mode ()
  "Enable `dired-virtual-mode' without marking the buffer as modified."
  (with-silent-modifications
    (dired-virtual-mode)))

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
  (customize-set-value 'dired-details-hidden-string "| ")

  (define-key dired-mode-map (kbd "M-k") 'dired-kill-subdir)
  (define-key dired-mode-map (kbd "<tab>") 'dired-details-toggle))

(eval-after-load "dired" '(my-dired-load-hook))

(add-hook 'dired-mode-hook 'my-dired-mode-hook)
(defun my-dired-mode-hook ()
  "Used in `dired-mode-hook'."
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
  "Used in `outline-minor-mode-hook'."
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

(with-eval-after-load "erc"
  ;; Add the following modules:
  ;; dcc: Provide Direct Client-to-Client support
  ;; keep-place: Leave point above un-viewed text
  ;; ;; log: Save buffers in logs
  ;; ;; using `erc-log-mode' instead (see below).
  ;; ;; (is that the same thing?)
  (dolist (module '(dcc keep-place)) ;; log
    (add-to-list 'erc-modules module))
  (erc-update-modules))

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

;; Stop displaying channels in the mode line for no good reason.
(setq erc-track-exclude-types
      '("JOIN" "KICK" "NICK" "PART" "QUIT" "MODE" "333" "353"))

(defun my-erc-prompt ()
  "Prompt generator function assigned to the `erc-prompt' variable."
  (concat "[" (buffer-name) "]>"))

(add-hook 'erc-mode-hook 'my-erc-mode-hook)
(defun my-erc-mode-hook ()
  "Used in `erc-mode-hook'."
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

;; ;; Do not break lines with newlines.
;; ;; This means text can automatically reflow if the window is resized.
;; ;; (n.b. GNU screen apparently does not like this being non-nil.)
;; (setq term-suppress-hard-newline t)
;; Unfortunately my custom shell prompt also does not play nicely with
;; this being non-nil when editing wrapped lines, so I've set this
;; out again for now.

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
  "Used in `term-mode-hook'."
  ;; https://lists.gnu.org/archive/html/bug-gnu-emacs/2016-04/msg00611.html
  (setq bidi-paragraph-direction 'left-to-right) ;; ^ HUGE performance improvement
  (subword-mode 0))

;; Shell mode
(add-hook 'shell-mode-hook 'my-shell-mode-hook)
(defun my-shell-mode-hook ()
  "Used in `shell-mode-hook'."
  (ansi-color-for-comint-mode-on))

;; Don't intersperse stderr output with stdout
(setq shell-command-default-error-buffer "*stderr*")

;; Do not show the `async-shell-command' output buffer unless/until
;; there is output to show.
(setq async-shell-command-display-buffer nil)

;; Do not erase the output buffer between shell commands.
;; Always set point to the start of the most-recent output.
(setq shell-command-dont-erase-buffer '(beg-last-out))

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
(setq ediff-window-setup-function #'ediff-setup-windows-plain)

;; Default to side-by-side comparisons in ediff.
(setq ediff-split-window-function #'split-window-horizontally)

;; Expand any collapsed text sections in ediff buffers.
(add-hook 'ediff-prepare-buffer-hook #'my-outline-show-all)

(defun my-outline-show-all ()
  "Call `outline-show-all' if the function has been defined."
  (when (fboundp 'outline-show-all)
    (outline-show-all)))

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

;; Make "d" in a merge conflict concatenate A and B together.
(defun my-ediff-copy-both-to-C ()
  "Concatenate variants A and B together as C."
  (interactive)
  (ediff-copy-diff
   ediff-current-difference nil 'C nil
   (concat (ediff-get-region-contents ediff-current-difference
                                      'A ediff-control-buffer)
           (ediff-get-region-contents ediff-current-difference
                                      'B ediff-control-buffer))))
(defun my-ediff-keymap-setup-hook ()
  "Used in `ediff-keymap-setup-hook'."
  (define-key ediff-mode-map "d" 'my-ediff-copy-both-to-C))

(add-hook 'ediff-keymap-setup-hook 'my-ediff-keymap-setup-hook)

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
  "Used in `grep-mode-hook'."
  (setq truncate-lines t)
  (local-set-key (kbd "<f5>") 'toggle-truncate-lines))

;; Don't rgrep/lgrep within certain file types. Will I regret this? :\
(with-eval-after-load "grep"
  (unless (member "*.vmdk" grep-find-ignored-files)
    (setq grep-find-ignored-files
          ;; List of file names which `rgrep' and `lgrep' shall exclude.
          ;; If an element is a cons cell, the car is called on the search
          ;; directory to determine whether cdr should not be excluded.
          (nconc grep-find-ignored-files
                 '("*.vmdk" "*.box") ;; Virtual Machine disks
                 '("*.png" "*.gif" "*.jpg" "*.jpeg" "*.tiff") ;; Images
                 '("*.pdf" "*.doc") ;; Binary documents
                 ))))

;; ;; www / web / eww
(add-hook 'eww-mode-hook 'my-eww-mode-hook)
(defun my-eww-mode-hook ()
  "Used in `eww-mode-hook'."
  (visual-line-mode 1)
  (when (fboundp 'adaptive-wrap-prefix-mode)
    (adaptive-wrap-prefix-mode 1)))

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

;; Use `eww' for `posix-manual-entry'.
(setq posix-manual-url-browser-function 'eww-browse-url)

;; Workaround for security problem.  See the release announcement:
;; https://lists.gnu.org/archive/html/emacs-devel/2017-09/msg00211.html
(when (version< emacs-version "25.3")
  (eval-after-load "enriched"
    '(defun enriched-decode-display-prop (start end &optional param)
       (list start end))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-configuration)
