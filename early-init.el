(defvar my-early-init-load-start (current-time))

;; Replicate --debug-init (see also the end of init.el).
(setq debug-on-error t)

;; Recompile .elc files automatically whenever necessary. Enable this early.
;; (Note that init.el does this too, in case it hasn't happened here.)
(require 'compile) ;; Keep for paranoia, while bug#69467 is open.  See also:
;; (browse-url (concat "https://" "github.com/emacscollective/auto-compile/issues/33"))
(setq load-prefer-newer t)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/el-get/auto-compile"))
(require 'auto-compile)
(auto-compile-on-save-mode 1)
(auto-compile-on-load-mode 1)

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

;; Make the tab bar icons scale to the height of the tab bar.
;; The magic sauce is the introduction of :height (1.0 . em)
;; which is fixed upstream for Emacs 30 as part of bug#62562.
;; To refresh icons after making changes to these, eval:
;; (tab-bar--load-buttons)
(when (< emacs-major-version 30)
  (require 'icons)
  (define-icon tab-bar-new nil
    `((image "tabs/new.xpm"
             :height (1.0 . em)
             :margin ,tab-bar-button-margin
             :ascent center)
      ;; (emoji "➕")
      ;; (symbol "＋")
      (text " + "))
    "Icon for creating a new tab."
    :version "29.1"
    :help-echo "New tab")
  (define-icon tab-bar-close nil
    `((image "tabs/close.xpm"
             :height (1.0 . em)
             :margin ,tab-bar-button-margin
             :ascent center)
      ;; (emoji " ❌")
      ;; (symbol "✕") ;; "ⓧ"
      (text " x"))
    "Icon for closing the clicked tab."
    :version "29.1"
    :help-echo "Click to close tab"))

(defvar my-early-init-time-elapsed
  (time-to-seconds (time-since my-early-init-load-start))
  "Seconds spent processing early-init.el")
