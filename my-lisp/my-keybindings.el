;;;; * Silence compiler warnings

(eval-when-compile
  (defvar my-apropos-prefix)
  )

;;;; * Global bindings

;; C-z is a very useful prefix, and we almost never need `suspend-frame'.
(global-unset-key (kbd "C-z")) ; suspend-frame
(global-set-key (kbd "C-z C-z") 'suspend-frame)

;; The global binding for <menu> sometimes gets in the way when testing,
;; as that's a prefix binding in my custom keymap (see below).
(global-unset-key (kbd "<menu>"))

;; Global bindings, for when I'm happy for other modes to over-ride them.
(global-set-key (kbd "C-a") 'my-beginning-of-line-or-indentation)
(global-set-key (kbd "M-/") 'hippie-expand) ; In place of dabbrev-expand
(global-set-key (kbd "M-.") 'etags-select-find-tag)
(global-set-key (kbd "M-z") 'zap-up-to-char)
(with-eval-after-load "my-utilities"
  (global-set-key (kbd "M-w") 'my-copy-region-as-kill)
  (global-set-key (kbd "C-w") 'my-kill-region)
  (when (fboundp 'jp/yank)
    (global-set-key (kbd "C-y") 'jp/yank)
    (global-set-key (kbd "M-y") 'jp/yank-pop)))

;; Global bindings that I want to over-ride in some modes.
(global-set-key (kbd "C-c o") 'ff-find-other-file)
(global-set-key (kbd "<f5>")  'ff-find-other-file)

;; Remappings to alternative/custom commands.
(global-set-key [remap backward-up-list] 'backward-up-sexp)
(global-set-key [remap narrow-to-defun] 'my-narrow-to-defun)

;; Make emacs consistent with xkcd :)
;; (Too many inferred prefixes to put this in the minor mode
;; key map, as the map is displayed in the mode's docstring.)
(global-set-key (kbd "C-x M-c M-b u t t e r f l y") 'butterfly)

;;;; * Other key maps, etc

;; Use 'e' to enter wgrep mode (like editable occur buffers).
(eval-when-compile
  (defvar grep-mode-map))
(add-hook 'wgrep-setup-hook 'my-wgrep-setup-hook)
(defun my-wgrep-setup-hook ()
  (define-key grep-mode-map (kbd "e") 'wgrep-change-to-wgrep-mode))

(eval-after-load "iedit"
  '(define-key isearch-mode-map (kbd "C-;") 'iedit-mode))

;; In Magit, make TAB cycle sections by default.
(eval-after-load "magit"
  '(define-key magit-mode-map (kbd "TAB") 'magit-section-cycle))
;; ...but avoid expanding all branches in the refs buffer!
(eval-after-load "magit-refs"
  '(define-key magit-refs-mode-map (kbd "TAB") 'magit-section-toggle))

(eval-after-load "magit-diff"
  '(progn
     ;; Swap the meanings of RET and C-RET on diff hunks.
     ;; Note that the default RET bindings are [remap magit-visit-thing]
     ;; in the original keymaps, but I am only concerned with RET here.
     ;; Note also that in a terminal, C-RET sends C-j.
     ;; Using the same key formats here as magit-diff.el
     (define-key magit-file-section-map [return] 'magit-diff-visit-file-worktree)
     (define-key magit-file-section-map [C-return] 'magit-diff-visit-file)
     (define-key magit-file-section-map (kbd "C-j") 'magit-diff-visit-file)
     (define-key magit-hunk-section-map [return] 'magit-diff-visit-file-worktree)
     (define-key magit-hunk-section-map [C-return] 'magit-diff-visit-file)
     (define-key magit-hunk-section-map (kbd "C-j") 'magit-diff-visit-file)))

(eval-after-load "git-commit"
  '(progn
     (define-key git-commit-mode-map (kbd "s-[") 'git-commit-prev-message)
     (define-key git-commit-mode-map (kbd "s-]") 'git-commit-next-message)))

;; Second selection support
(global-set-key (kbd "C-M-y") 'secondary-dwim)
(define-key isearch-mode-map (kbd "C-M-y") 'isearch-yank-secondary)
;; (define-key esc-map "y" 'yank-pop-commands) ;; cua-paste-pop conflict
;; You might want to also use library `browse-kill-ring+.el'
;; (and `browse-kill-ring.el').  I do.  If you do that, then
;; load `second-sel.el' first.

;;;; * Translation keymaps

;; I want to be able to use my <menu> key in a terminal; so I have
;; <menu> mapped to <f8> via xmodmap (as terminals can send <f8>), and
;; here I map <f8> back to <menu> inside Emacs.  (I effectively lose
;; <f8> as a separate binding option, but I gain a far more convenient
;; key on the keyboard, and get consistency with my GUI emacs keys.)
(define-key key-translation-map (kbd "<f8>") (kbd "<menu>"))
;; Possibly better would be to send a custom escape sequence from the
;; terminal and handle that in `input-decode-map', but I don't know
;; whether there are any escape sequence ranges reserved for end users?
;;
;; ~/.xmonad/xmonad-session-rc
;; # Make <menu> send <f8> for terminal Emacs (see also my-keybindings.el).
;; # I would rather this *only* affect Emacs rather than be system-wide,
;; # but <menu> is more useful to me in Emacs than anywhere else, so this
;; # is acceptable.  Run xev to find out keycode for <menu>
;; # http://askubuntu.com/questions/54157/how-do-i-set-xmodmap-on-login
;; xmodmap -e "keycode 135 = F8"

;;;; * Help and documentation bindings

;; Custom 'apropos' key bindings. Prefix binding is: C-h C-a
(define-prefix-command 'my-apropos-prefix nil "Apropos (a,d,f,i,l,o,v,C-v)")
(define-key my-apropos-prefix (kbd "a")   'apropos)
(define-key my-apropos-prefix (kbd "C-a") 'apropos)
(define-key my-apropos-prefix (kbd "d")   'apropos-documentation)
(define-key my-apropos-prefix (kbd "c")   'my-apropos-command)
(define-key my-apropos-prefix (kbd "f")   'apropos-command)
(define-key my-apropos-prefix (kbd "i")   'info-apropos)
(define-key my-apropos-prefix (kbd "l")   'apropos-library)
(define-key my-apropos-prefix (kbd "o")   'my-apropos-user-option)
(define-key my-apropos-prefix (kbd "v")   'apropos-variable)
(define-key my-apropos-prefix (kbd "C-v") 'apropos-value)

;; Bind 'l' to [back] in Help mode, to match Info mode.
(add-hook 'help-mode-hook (lambda () (local-set-key (kbd "l") 'help-go-back)))

;;;; my-keys-minor-mode

;; Globalized minor mode: `my-keys-minor-mode'
;;
;; These bindings take precedence over major mode keymaps (as well as
;; other minor mode maps in general -- see `my-keys-have-priority'.)
;;
;; Note that reserved bindings (C-c <letter> and F5-F9) should be set
;; in the global keymap if over-riding them on a per-mode basis may
;; be desirable.

(defvar my-keys-local-minor-mode-map (make-sparse-keymap)
  "`my-keys-local-minor-mode' keymap.")
(let ((keymap my-keys-local-minor-mode-map))
  ;; Apropos
  (define-key keymap (kbd "C-h a")     'apropos-command)
  (define-key keymap (kbd "C-h C-a")   'my-apropos-prefix)

  ;; Use ibuffer in place of list-buffers
  (define-key keymap (kbd "C-x C-b")   'ibuffer)
  (define-key keymap (kbd "<menu> <menu>") 'ibuffer)
  (define-key keymap [remap ibuffer]   'my-ibuffer)
  (define-key keymap (kbd "M-<menu>")  'switch-to-buffer)

  ;; Whitespace
  (define-key keymap (kbd "C-x M-w")   'toggle-show-trailing-whitespace)
  (define-key keymap (kbd "C-x M-C-S-w") 'whitespace-cleanup)

  ;; Local occur
  (define-key keymap (kbd "M-s l")     'loccur) ; interactive loccur command
  (define-key keymap (kbd "M-s C-l")   'loccur-current) ; loccur of the current word
  (define-key keymap (kbd "M-s C-S-l") 'loccur-previous-match) ; loccur of the previously-found word

  ;; Context-sensitive *Help* buffer
  (define-key keymap (kbd "C-c h")     'my-contextual-help-toggle)

  ;; ELisp debugger
  (define-key keymap (kbd "C-c d")     'debug-on-entry)
  (define-key keymap (kbd "C-c D")     'cancel-debug-on-entry)

  ;; Kill ring / Yank assistance
  ;; (TODO: 'browse-kill-ring' in my-utilities)
  (define-key keymap (kbd "C-c y")     'my-yank-menu)
  (define-key keymap (kbd "C-x r M-w") 'my-copy-rectangle)

  ;; Multiple cursors
  (define-key keymap (kbd "s-SPC s-SPC") 'mc/edit-lines)
  (define-key keymap (kbd "s-SPC C-e") 'mc/edit-ends-of-lines)
  (define-key keymap (kbd "s-SPC C-a") 'mc/edit-beginnings-of-lines)
  ;; Rectangular region mode
  (define-key keymap (kbd "C-x r s-SPC") 'set-rectangular-region-anchor)
  ;; Mark more like this
  (define-key keymap (kbd "C->")       'mc/mark-next-like-this)
  (define-key keymap (kbd "C-<")       'mc/mark-previous-like-this)
  (define-key keymap (kbd "s-SPC h")   'mc/mark-all-like-this)
  (define-key keymap (kbd "s-SPC x")   'mc/mark-more-like-this-extended)
  (define-key keymap (kbd "s-SPC r")   'mc/mark-all-in-region)

  ;; Rectangle editing
  (define-key keymap (kbd "C-x r e")   'my-edit-rectangle)
  (define-key keymap (kbd "C-x r M-%") 'my-replace-string-rectangle)
  (define-key keymap (kbd "C-x r C-M-%") 'my-replace-regexp-rectangle)

  ;; iedit
  (define-key keymap (kbd "C-;")       'iedit-mode)

  ;; winner-mode. Add to default bindings, and integrate with
  ;; my-(backward|forward)-word-or-buffer-or-windows.
  (define-key keymap (kbd "C-c <C-left>") 'winner-undo)
  (define-key keymap (kbd "C-c <C-right>") 'winner-redo)

  ;; Miscellaneous frame/window/buffer manipulation
  (define-key keymap (kbd "M-o")       'expand-other-window)
  (define-key keymap (kbd "C-x M-k")   'kill-other-buffer)
  (define-key keymap (kbd "C-x M-2")   'split-window-vertically-change-buffer)
  (define-key keymap (kbd "C-c \\")    'toggle-window-split)
  (define-key keymap (kbd "C-c |")     'rotate-frame)
  (define-key keymap (kbd "C-c C-\\")  'transpose-frame)
  (define-key keymap (kbd "C-c w a")   'my-align-next-window)
  (define-key keymap (kbd "C-x 2")     'my-split-window-below)
  (define-key keymap (kbd "<f7>")      'my-other-frame)
  (define-key keymap (kbd "C-x 4 n n") 'my-narrow-to-region-indirect)
  (define-key keymap (kbd "C-x 4 n p") 'my-narrow-to-page-indirect)
  (define-key keymap (kbd "C-x 4 n d") 'my-narrow-to-defun-indirect)

  ;; Diff / Comparison, and Version control
  (define-key keymap (kbd "C-M-=")     'compare-windows)
  (define-key keymap (kbd "C-z =")     'my-diff-buffer-with-file)
  (define-key keymap (kbd "C-z C-=")   'ediff-current-file)
  (define-key keymap (kbd "C-x v C-=") 'vc-ediff)
  (define-key keymap (kbd "C-x v C-f") 'my-vc-visit-file-revision)
  (define-key keymap (kbd "C-x v C-l") 'my-vc-print-revision-log)
  (define-key keymap (kbd "C-x v <")   'vc-resolve-conflicts)

  ;; Completions
  (define-key keymap (kbd "C-c /")     'my-ido-hippie-expand)

  ;; WWW
  (define-key keymap (kbd "C-c w s")   'my-www-search)
  (define-key keymap (kbd "C-c w w")   (if (fboundp 'eww) 'eww 'my-eww))

  ;; Terminals / Shells / REPLs
  (define-key keymap (kbd "C-c s s")   'my-shell)
  (define-key keymap (kbd "C-c s a")   'my-ansi-terminal)
  (define-key keymap (kbd "C-c s d")   'my-drush-console)
  (define-key keymap (kbd "C-c s q")   'my-sql-console)
  (define-key keymap (kbd "C-c s h")   'my-ssh)
  (define-key keymap (kbd "C-c s !")   'my-terminal-run)

  ;; Miscellaneous (mine/third-party)
  (define-key keymap (kbd "s-/")       'avy-goto-char-timer)
  (define-key keymap (kbd "<menu> s")  'avy-goto-char-timer)
  (define-key keymap (kbd "<menu> d")  'sdcv-search)
  (define-key keymap (kbd "C-c v")     'my-copy-buffer-file-name)
  (define-key keymap (kbd "C-c r")     'rename-file-and-buffer)
  (define-key keymap (kbd "C-c W")     'my-write-copy-to-file)
  (define-key keymap (kbd "C-z n")     'my-scroll-one-line-ahead-repeatable)
  (define-key keymap (kbd "C-z p")     'my-scroll-one-line-back-repeatable)
  (define-key keymap (kbd "<C-left>")  'my-backward-word-or-buffer-or-windows)
  (define-key keymap (kbd "<C-right>") 'my-forward-word-or-buffer-or-windows)
  (define-key keymap (kbd "M-s /")     'my-multi-occur)
  (define-key keymap (kbd "M-s C-/")   'my-multi-occur-in-visible-buffers)
  (define-key keymap (kbd "C-c c")     'clone-line)
  (define-key keymap (kbd "C-M-z")     'zap-to-char-backwards)
  (define-key keymap (kbd "M-?")       'etags-stack-show)
  (define-key keymap (kbd "C-c i")     'imenu-ido-goto-symbol)
  (define-key keymap (kbd "C-z C-f")   'my-find-file-in-project)
  (define-key keymap (kbd "C-c m m")   'magit-status)
  (define-key keymap (kbd "C-c m M")   'magit-dispatch-popup)
  (define-key keymap (kbd "C-c m ?")   'magit-dispatch-popup)
  (define-key keymap (kbd "C-c m b")   'mo-git-blame-current)
  (define-key keymap (kbd "C-c m d")   'magit-diff-popup)
  (define-key keymap (kbd "C-c m l")   'magit-log-popup)
  (define-key keymap (kbd "C-c m f")   'magit-file-popup)
  (define-key keymap (kbd "<pause>")   'toggle-window-dedicated)
  (define-key keymap (kbd "C-c n")     'deft)
  (define-key keymap (kbd "S-M-SPC")   'my-extend-selection)
  (define-key keymap (kbd "C-c M-w")   'whitespace-toggle-options)
  (define-key keymap (kbd "C-c M-q")   'my-toggle-fill-paragraph)
  (define-key keymap (kbd "C-c x e")   'eval-and-replace)
  (define-key keymap (kbd "C-z C-M-%") 'my-replace-regexp-group)
  (define-key keymap (kbd "C-h u")     'describe-unbound-keys)
  (define-key keymap (kbd "M-C")       'my-capitalize-word)
  (define-key keymap (kbd "s-j")       'ace-jump-mode)
  (define-key keymap (kbd "s-;")       'my-insert-kbd)

  ;; Miscellaneous (standard commands and custom variants)
  (define-key keymap (kbd "C-x M-b")   'bury-buffer)
  (define-key keymap (kbd "M-L")       'goto-line)
  (define-key keymap (kbd "C-h C-f")   'find-function)
  (define-key keymap (kbd "C-h C-k")   'find-function-on-key)
  (define-key keymap (kbd "C-h C-v")   'find-variable)
  (define-key keymap (kbd "C-h C-l")   'find-library)
  (define-key keymap (kbd "C-h C-c")   'finder-commentary)
  (define-key keymap (kbd "C-x C-j")   'my-dired-jump)
  (define-key keymap (kbd "C-x 4 C-j") 'dired-jump-other-window)
  (define-key keymap (kbd "<f6>")      'rgrep)
  (define-key keymap (kbd "s-\\")      'toggle-truncate-lines)
  (define-key keymap (kbd "<menu> z")  'repeat)
  (when (fboundp 'cycle-spacing) ;; replace just-one-space in Emacs 24.4
    (define-key keymap (kbd "M-SPC")   'cycle-spacing))
  (define-key keymap (kbd "<s-insert>") 'org-capture)
  (define-key keymap (kbd "<s-home>") 'org-agenda)
  (define-key keymap (kbd "<XF86Calculator>") 'calc)
  (define-key keymap (kbd "<menu> z") 'repeat)
  ) ; end of key definitions

(define-minor-mode my-keys-local-minor-mode
  "A minor mode so that my key bindings take precedence over other modes.

We also have precedence over minor mode keymaps which appear later in the
`minor-mode-map-alist' variable (see `my-keys-have-priority'); however
`minor-mode-overriding-map-alist' and `emulation-mode-map-alists' keymaps
will still over-ride us.

TODO: Switch to using `emulation-mode-map-alists' ?

We set :init-value t, as this turns out to be the only reliable way to ensure
that the mode is enabled by default in all buffers save for the minibuffer.

With a :global minor mode, `minibuffer-setup-hook' was causing it to be
disabled everywhere (despite the local variable trick).  With a globalized
minor mode to selectively enable the mode everywhere other than the
minibuffer, new buffers in `fundamental-mode' are not processed (because
fundamental-mode is not actually called, so `after-change-major-mode-hook'
does not run, and therefore no globalized modes take effect).

\\{my-keys-local-minor-mode-map}"
  :init-value t
  :keymap 'my-keys-local-minor-mode-map)

(defun my-keys-minibuffer-setup-hook ()
  "Used in `minibuffer-setup-hook'."
  (my-keys-local-minor-mode -1))

(add-hook 'minibuffer-setup-hook 'my-keys-minibuffer-setup-hook)

;; An alternative would be to use `emulation-mode-map-alists' (which has
;; a higher priority than `minor-mode-map-alist').
;;
;; This variable holds a list of keymap alists to use for emulations
;; modes. It is intended for modes or packages using multiple
;; minor-mode keymaps. Each element is a keymap alist which has the
;; same format and meaning as minor-mode-map-alist, or a symbol with
;; a variable binding which is such an alist. The 'active' keymaps
;; in each alist are used before `minor-mode-map-alist' and
;; `minor-mode-overriding-map-alist'.

(defun my-keys-have-priority (&optional _file)
  "Give my keybindings priority over other minor modes.

As keymaps can be generated at compile time, we need to check this
every time we `load' a library.

Called via `after-load-functions', as well as `after-init-hook'."
  (unless (eq (caar minor-mode-map-alist) 'my-keys-local-minor-mode)
    (let ((mykeys (assq 'my-keys-local-minor-mode minor-mode-map-alist)))
      (assq-delete-all 'my-keys-local-minor-mode minor-mode-map-alist)
      (add-to-list 'minor-mode-map-alist mykeys))))

(add-hook 'after-load-functions 'my-keys-have-priority)
(add-hook 'after-init-hook      'my-keys-have-priority)

;;;; Custom aliases

(defalias 'll   'load-dot-emacs)
(defalias 'lll  'find-dot-emacs)
(defalias 'llll 'find-my-lisp-dir)
(defalias 'llle 'find-el-get-dir)
(defalias 'nm   'normal-mode) ;; Set the major mode for the current buffer.
(defalias 'rb   'revert-buffer)
(defalias 'rn   'rename-buffer)
(defalias 'ws   'whitespace-mode)
(defalias 'il   'lisp-interaction-mode)
(defalias 'el   'emacs-lisp-mode)
(defalias 'cg   'customize-group)
(defalias 'cv   'customize-variable)
(defalias 'co   'customize-option)
(defalias 'cf   'customize-face)
(defalias 'sx   'sx-tab-all-questions)

;;;; * Miscellaneous / Helpers

;; (defun my-keys-pass-through (arg)
;;   "Allow a key sequence to pass through to its next binding."
;;   (interactive)
;;   (let ((my-keys-local-minor-mode nil))
;;     (call-interactively (read-key-sequence))))

;; (global-set-key (kbd "s-x") 'my-keys-pass-through)

(defun my-describe-keymap (keymap)
  "Describe a keymap using `substitute-command-keys'."
  (interactive
   (list (completing-read
          "Keymap: " (let (maps)
                       (mapatoms (lambda (sym)
                                   (and (boundp sym)
                                        (keymapp (symbol-value sym))
                                        (push sym maps))))
                       maps)
          nil t)))
  (with-output-to-temp-buffer (format "*keymap: %s*" keymap)
    (princ (format "%s\n\n" keymap))
    (princ (substitute-command-keys (format "\\{%s}" keymap)))
    (with-current-buffer standard-output ;; temp buffer
      (setq help-xref-stack-item (list #'my-describe-keymap keymap)))))

(defun my-buffer-local-set-key (key command)
  ;; Helper intended for use in local variables. e.g.:
  ;; eval: (my-buffer-local-set-key (kbd "C-c f") 'foo)
  (interactive "KSet key buffer-locally: \nCSet key %s buffer-locally to command: ")
  (let ((oldmap (current-local-map))
        (newmap (make-sparse-keymap)))
    (when oldmap
      (set-keymap-parent newmap oldmap))
    (define-key newmap key command)
    (use-local-map newmap)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-keybindings)

;;; Local Variables:
;;; page-delimiter: "^;;;; "
;;; outline-regexp: ";;;; "
;;; eval: (outline-minor-mode 1)
;;; eval: (while (re-search-forward "^;;;; \\* " nil t) (outline-toggle-children))
;;; End:
