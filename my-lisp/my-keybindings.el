;; Use a global minor mode in preference to using (global-set-key),
;; so that my custom keys take precedence over major mode keymaps.

(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

(define-key my-keys-minor-mode-map (kbd "C-c r")     'rename-file-and-buffer)
(define-key my-keys-minor-mode-map (kbd "C-x M-b")   'bury-buffer)
(define-key my-keys-minor-mode-map (kbd "C-o")       'other-window)
(define-key my-keys-minor-mode-map (kbd "M-o")       'expand-other-window)
(define-key my-keys-minor-mode-map (kbd "C-x M-k")   'kill-other-buffer)
(define-key my-keys-minor-mode-map (kbd "C-x M-2")   'split-window-vertically-change-buffer)
(define-key my-keys-minor-mode-map (kbd "M-l")       'goto-line)
(define-key my-keys-minor-mode-map (kbd "M-n")       'scroll-one-line-ahead)
(define-key my-keys-minor-mode-map (kbd "M-p")       'scroll-one-line-back)
(define-key my-keys-minor-mode-map (kbd "<C-left>")  'my-backward-word-or-buffer)
(define-key my-keys-minor-mode-map (kbd "<C-right>") 'my-forward-word-or-buffer)
(define-key my-keys-minor-mode-map (kbd "M-.")       'etags-select-find-tag)
(define-key my-keys-minor-mode-map (kbd "M-?")       'etags-stack-show)
(define-key my-keys-minor-mode-map (kbd "M-s /")     'my-multi-occur-in-matching-buffers)
(define-key my-keys-minor-mode-map (kbd "C-c i")     'imenu-ido-goto-symbol)
(define-key my-keys-minor-mode-map (kbd "C-c c")     'clone-line)
(define-key my-keys-minor-mode-map (kbd "C-h C-f")   'find-function)
(define-key my-keys-minor-mode-map (kbd "C-h C-v")   'find-variable)
(define-key my-keys-minor-mode-map (kbd "C-c \\")    'toggle-window-split)
(define-key my-keys-minor-mode-map (kbd "C-x C-j")   'dired-jump)

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my custom key bindings take precedence over major modes.

\\{my-keys-minor-mode-map}"
  t nil 'my-keys-minor-mode-map)

(my-keys-minor-mode 1)

;; Disable my custom keys in the minibuffer
(add-hook 'minibuffer-setup-hook (lambda () (my-keys-minor-mode 0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-keybindings)
