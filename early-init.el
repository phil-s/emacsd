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
