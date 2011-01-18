;; Custom 'apropos' key bindings
(define-prefix-command 'Apropos-Prefix nil "Apropos (a,d,f,l,v,C-v)")
(define-key Apropos-Prefix (kbd "a")   'apropos)
(define-key Apropos-Prefix (kbd "C-a") 'apropos)
(define-key Apropos-Prefix (kbd "d")   'apropos-documentation)
(define-key Apropos-Prefix (kbd "f")   'apropos-command)
(define-key Apropos-Prefix (kbd "l")   'apropos-library)
(define-key Apropos-Prefix (kbd "v")   'apropos-variable)
(define-key Apropos-Prefix (kbd "C-v") 'apropos-value)

;; Use a global minor mode in preference to using (global-set-key),
;; so that my custom keys take precedence over major mode keymaps.

(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")
(let ((keymap my-keys-minor-mode-map))
  ;; Apropos
  (define-key keymap (kbd "C-h a")     'apropos-command)
  (define-key keymap (kbd "C-h C-a")   'Apropos-Prefix)
  ;; Use ibuffer in place of list-buffers
  (define-key keymap (kbd "C-x C-b")   'ibuffer)
  ;; Use hippie-expand in place of dabbrev-expand
  (define-key keymap (kbd "M-/")       'hippie-expand)
  ;; Whitespace
  (define-key keymap (kbd "C-x M-w")   'toggle-show-trailing-whitespace)
  (define-key keymap (kbd "C-x M-C-S-w") 'delete-trailing-whitespace)
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
  (define-key keymap (kbd "C-c y")     'my-yank-menu)
  ;; (TODO: 'browse-kill-ring' in my-utilities)

  ;; Miscellaneous
  (define-key keymap (kbd "C-c r")     'rename-file-and-buffer)
  (define-key keymap (kbd "C-x M-b")   'bury-buffer)
  (define-key keymap (kbd "C-o")       'other-window)
  (define-key keymap (kbd "M-o")       'expand-other-window)
  (define-key keymap (kbd "C-x M-k")   'kill-other-buffer)
  (define-key keymap (kbd "C-x M-2")   'split-window-vertically-change-buffer)
  (define-key keymap (kbd "M-l")       'goto-line)
  (define-key keymap (kbd "M-n")       'scroll-one-line-ahead)
  (define-key keymap (kbd "M-p")       'scroll-one-line-back)
  (define-key keymap (kbd "<C-left>")  'my-backward-word-or-buffer)
  (define-key keymap (kbd "<C-right>") 'my-forward-word-or-buffer)
  (define-key keymap (kbd "M-.")       'etags-select-find-tag)
  (define-key keymap (kbd "M-?")       'etags-stack-show)
  (define-key keymap (kbd "M-s /")     'my-multi-occur-in-matching-buffers)
  (define-key keymap (kbd "C-c i")     'imenu-ido-goto-symbol)
  (define-key keymap (kbd "C-c c")     'clone-line)
  (define-key keymap (kbd "C-h C-f")   'find-function)
  (define-key keymap (kbd "C-h C-v")   'find-variable)
  (define-key keymap (kbd "C-c \\")    'toggle-window-split)
  (define-key keymap (kbd "C-x C-j")   'dired-jump)
  (define-key keymap (kbd "C-M-z")     'zap-to-char-backwards)
)

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my custom key bindings take precedence over major modes.

\\{my-keys-minor-mode-map}"
  t nil 'my-keys-minor-mode-map)

(my-keys-minor-mode 1)

;; Disable my custom keys in the minibuffer
(add-hook 'minibuffer-setup-hook (lambda () (my-keys-minor-mode 0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-keybindings)
