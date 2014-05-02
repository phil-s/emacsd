;; C-z is a very useful prefix, and we almost never need `suspend-frame'.
(global-unset-key (kbd "C-z")) ; suspend-frame
(global-set-key (kbd "C-z C-z") 'suspend-frame)

;; Global bindings, for when I'm happy for other modes to over-ride them.
(global-set-key (kbd "C-a") 'my-beginning-of-line-or-indentation)
(global-set-key (kbd "M-/") 'hippie-expand) ; In place of dabbrev-expand

;; Global bindings that I want to over-ride in some modes.
(global-set-key (kbd "C-c o") 'ff-find-other-file)
(global-set-key (kbd "<f5>")  'ff-find-other-file)

;; Remapped commands. Simpler when there are multiple bindings.
(global-set-key [remap narrow-to-defun] 'my-narrow-to-defun)

;; Custom 'apropos' key bindings
(define-prefix-command 'Apropos-Prefix nil "Apropos (a,d,f,i,l,v,C-v)")
(define-key Apropos-Prefix (kbd "a")   'apropos)
(define-key Apropos-Prefix (kbd "C-a") 'apropos)
(define-key Apropos-Prefix (kbd "d")   'apropos-documentation)
(define-key Apropos-Prefix (kbd "f")   'apropos-command)
(define-key Apropos-Prefix (kbd "c")   'apropos-command)
(define-key Apropos-Prefix (kbd "i")   'info-apropos)
(define-key Apropos-Prefix (kbd "l")   'apropos-library)
(define-key Apropos-Prefix (kbd "v")   'apropos-variable)
(define-key Apropos-Prefix (kbd "C-v") 'apropos-value)

;; Bind 'l' to [back] in Help mode, to match Info mode.
(add-hook 'help-mode-hook (lambda () (local-set-key (kbd "l") 'help-go-back)))

;; Use 'e' to enter wgrep mode (like editable occur buffers).
(add-hook 'wgrep-setup-hook 'my-wgrep-setup-hook)
(defun my-wgrep-setup-hook ()
  (define-key grep-mode-map (kbd "e") 'wgrep-change-to-wgrep-mode))

;; iedit (additional)
(define-key isearch-mode-map (kbd "C-;") 'iedit-mode)

;; Second selection support
(global-set-key (kbd "C-M-y") 'secondary-dwim)
(define-key isearch-mode-map (kbd "C-M-y") 'isearch-yank-secondary)
;; (define-key esc-map "y" 'yank-pop-commands) ;; cua-paste-pop conflict
;; You might want to also use library `browse-kill-ring+.el'
;; (and `browse-kill-ring.el').  I do.  If you do that, then
;; load `second-sel.el' first.

(global-set-key (kbd "M-y") 'jp/yank-pop)
(global-set-key (kbd "C-y") 'jp/yank)

;;
;; Global minor mode: `my-keys-minor-mode'
;;
;; These bindings take precedence over major mode keymaps (as well as
;; other minor mode maps in general -- see the advice to `load' below.)
;;
;; Note that reserved bindings (C-c <letter> and F5-F9) should be set
;; in the global keymap if over-riding them on a per-mode basis may
;; be desirable.

(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")
(let ((keymap my-keys-minor-mode-map))
  ;; Apropos
  (define-key keymap (kbd "C-h a")     'apropos-command)
  (define-key keymap (kbd "C-h C-a")   'Apropos-Prefix)

  ;; Use ibuffer in place of list-buffers
  (define-key keymap (kbd "C-x C-b")   'ibuffer)
  (define-key keymap (kbd "<menu>")    'ibuffer)
  (define-key keymap (kbd "M-<menu>")  'switch-to-buffer)

  ;; Whitespace
  (define-key keymap (kbd "C-x M-w")   'toggle-show-trailing-whitespace)
  (define-key keymap (kbd "C-x M-C-S-w") 'whitespace-cleanup)

  ;; Local occur
  (define-key keymap (kbd "M-s l")     'loccur) ; interactive loccur command
  (define-key keymap (kbd "M-s C-l")   'loccur-current) ; loccur of the current word
  (define-key keymap (kbd "M-s C-S-l") 'loccur-previous-match) ; loccur of the previously-found word

  ;; Context-sensitive *Help* buffer
  (define-key keymap (kbd "C-c h")     'rgr/toggle-context-help)

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

  ;; Replicate windmove bindings, so that they can't get clobbered
  (define-key keymap (kbd "<S-up>")    'windmove-up)
  (define-key keymap (kbd "<S-down>")  'windmove-down)
  (define-key keymap (kbd "<S-left>")  'windmove-left)
  (define-key keymap (kbd "<S-right>") 'windmove-right)

  ;; Miscellaneous frame/window/buffer manipulation
  (define-key keymap (kbd "M-o")       'expand-other-window)
  (define-key keymap (kbd "C-x M-k")   'kill-other-buffer)
  (define-key keymap (kbd "C-x M-2")   'split-window-vertically-change-buffer)
  (define-key keymap (kbd "C-c \\")    'toggle-window-split)
  (define-key keymap (kbd "C-c C-\\")  'transpose-frame)
  (define-key keymap (kbd "C-c w a")   'my-align-next-window)
  (define-key keymap (kbd "C-x 2")     'my-split-window-below)
  (define-key keymap (kbd "<f7>")      'other-frame)

  ;; Diff / Comparison
  (define-key keymap (kbd "C-M-=")     'compare-windows)
  (define-key keymap (kbd "C-z =")     'diff-current-buffer-with-disk)
  (define-key keymap (kbd "C-z C-=")   'ediff-current-file)
  (define-key keymap (kbd "C-x v C-=") 'vc-ediff)

  ;; Completions
  (define-key keymap (kbd "C-c /")     'my-ido-hippie-expand)

  ;; WWW
  (define-key keymap (kbd "C-c w s")   'my-www-search)
  (define-key keymap (kbd "C-c w w")   'my-render-url) ;; use 'eww in 24.4

  ;; Terminals / Shells / REPLs
  (define-key keymap (kbd "C-c s s")   'my-shell)
  (define-key keymap (kbd "C-c s a")   'my-ansi-terminal)
  (define-key keymap (kbd "C-c s d")   'my-drush-console)
  (define-key keymap (kbd "C-c s q")   'my-sql-console)

  ;; Miscellaneous (mine/third-party)
  (define-key keymap (kbd "C-c v")     'my-copy-buffer-file-name)
  (define-key keymap (kbd "C-c r")     'rename-file-and-buffer)
  (define-key keymap (kbd "C-c W")     'my-write-copy-to-file)
  (define-key keymap (kbd "M-n")       'scroll-one-line-ahead)
  (define-key keymap (kbd "M-p")       'scroll-one-line-back)
  (define-key keymap (kbd "<C-left>")  'my-backward-word-or-buffer-or-windows)
  (define-key keymap (kbd "<C-right>") 'my-forward-word-or-buffer-or-windows)
  (define-key keymap (kbd "M-s /")     'my-multi-occur)
  (define-key keymap (kbd "M-s C-/")   'my-multi-occur-in-visible-buffers)
  (define-key keymap (kbd "C-c c")     'clone-line)
  (define-key keymap (kbd "C-M-z")     'zap-to-char-backwards)
  (define-key keymap (kbd "M-.")       'etags-select-find-tag)
  (define-key keymap (kbd "M-?")       'etags-stack-show)
  (define-key keymap (kbd "C-c i")     'imenu-ido-goto-symbol)
  (define-key keymap (kbd "C-c C-f")   'my-find-file-in-project)
  (define-key keymap (kbd "C-c m m")   'magit-status)
  (define-key keymap (kbd "C-c m b")   'mo-git-blame-current)
  (define-key keymap (kbd "C-c m l")   'magit-key-mode-popup-logging)
  (define-key keymap (kbd "<pause>")   'toggle-window-dedicated)
  (define-key keymap (kbd "C-c n")     'deft)
  (define-key keymap (kbd "S-M-SPC")   'my-extend-selection)
  (define-key keymap (kbd "C-c M-w")   'whitespace-toggle-options)
  (define-key keymap (kbd "C-c M-q")   'my-toggle-fill-paragraph)
  (define-key keymap (kbd "C-c x e")   'eval-and-replace)
  (define-key keymap (kbd "C-z C-M-%") 'my-replace-regexp-group)
  (define-key keymap (kbd "C-h u")     'describe-unbound-keys)
  (define-key keymap (kbd "M-C")       'my-capitalize-word)

  ;; Miscellaneous (standard commands)
  (define-key keymap (kbd "C-x M-b")   'bury-buffer)
  (define-key keymap (kbd "M-L")       'goto-line)
  (define-key keymap (kbd "C-h C-f")   'find-function)
  (define-key keymap (kbd "C-h C-k")   'find-function-on-key)
  (define-key keymap (kbd "C-h C-v")   'find-variable)
  (define-key keymap (kbd "C-h C-l")   'find-library)
  (define-key keymap (kbd "C-x C-j")   'dired-jump)
  (define-key keymap (kbd "<f6>")      'rgrep)
  (define-key keymap (kbd "C-x v <")   'vc-resolve-conflicts)
  )

;; Make emacs consistent with xkcd :)
;; (Too many inferred prefixes to put this in the minor mode
;; key map, as the map is displayed in the mode's docstring.)
(global-set-key (kbd "C-x M-c M-b u t t e r f l y") 'butterfly)

;; Custom aliases
(defalias 'll   'load-dot-emacs)
(defalias 'lll  'find-dot-emacs)
(defalias 'llll 'find-my-lisp-dir)
(defalias 'llle 'find-el-get-dir)
(defalias 'nm   'normal-mode) ;; Set the major mode for the current buffer.
(defalias 'rb   'revert-buffer)
(defalias 'ws   'whitespace-mode)

(defun my-keybindings-after-init-hook ()
  "Define and enable our minor mode after the init file has been loaded.
We want this to be our final initialisation step, to ensure that
my-keys-minor-mode is first in `minor-mode-map-alist', and therefore
takes precedence over other minor mode keymaps.

We also advise `load', to try to retain this priority subsequent
to the loading of other minor modes.

An alternative would be to use `emulation-mode-map-alists', which has
a higher priority than minor-mode-map-alist:

This variable holds a list of keymap alists to use for emulations
modes. It is intended for modes or packages using multiple
minor-mode keymaps. Each element is a keymap alist which has the
same format and meaning as minor-mode-map-alist, or a symbol with
a variable binding which is such an alist. The 'active' keymaps
in each alist are used before minor-mode-map-alist and
minor-mode-overriding-map-alist."

  (define-minor-mode my-keys-minor-mode
    "A minor mode so that my custom key bindings take precedence over major modes.

We also have precedence over minor mode keymaps which appear later in the
`minor-mode-map-alist' variable, however `emulation-mode-map-alists' keymaps
will over-ride us.

TODO: Switch to using emulation-mode-map-alists

\\{my-keys-minor-mode-map}"
    :init-value t
    :global     t
    :keymap     my-keys-minor-mode-map)

;; Disable my custom keys in the minibuffer
  (defun my-keys-minor-mode-minibuffer-setup-hook ()
    (set (make-local-variable 'my-keys-minor-mode) 0)
    (my-keys-minor-mode 0))
  (add-hook 'minibuffer-setup-hook 'my-keys-minor-mode-minibuffer-setup-hook)

  (defadvice load (after give-my-keybindings-priority)
    "Try to ensure that my keybindings always have priority."
    (unless (eq (car (car minor-mode-map-alist)) 'my-keys-minor-mode)
      (let ((mykeys (assq 'my-keys-minor-mode minor-mode-map-alist)))
        (assq-delete-all 'my-keys-minor-mode minor-mode-map-alist)
        (add-to-list 'minor-mode-map-alist mykeys))))
  (ad-activate 'load))

(add-hook 'after-init-hook 'my-keybindings-after-init-hook)

;; ;; Disable this keymap in term-mode
;; (add-hook 'term-mode-hook 'my-term-mode-keys-hook)
;; (defun my-term-mode-keys-hook ()
;;   (make-local-variable 'minor-mode-map-alist)
;;   (assq-delete-all 'my-keys-minor-mode minor-mode-map-alist))


;; (defun my-keys-pass-through (arg)
;;   "Allow a key sequence to pass through to its next binding."
;;   (interactive)
;;   (let ((my-keys-minor-mode nil))
;;     (call-interactively (read-key-sequence))))

;; (global-set-key (kbd "s-x") 'my-keys-pass-through)

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
