;; -*- lexical-binding: nil; -*-
(defvar my-early-init-load-start (current-time))

;; Replicate --debug-init (see also the end of init.el).
(setq debug-on-error t)

(defconst my-expected-emacs-major-version 30
  "The version of Emacs I expect to be using.
Do not automatically byte-compile in other versions of Emacs.")

;; Temporary performance measures, to reduce start-up time.
;; Avoid garbage collection during start-up.
;; (defvar my-gc-cons-threshold-normal gc-cons-threshold) ;; Currently 800K.
(defvar my-gc-cons-threshold-normal 8000000) ;; 8M (10x default).  Experimental.
(defvar my-gc-cons-threshold-large 10000000) ;; 10M; default is 0.8M
(defun my-gc-cons-threshold-set-large ()
  (setq gc-cons-threshold my-gc-cons-threshold-large))
(defun my-gc-cons-threshold-set-normal ()
  (setq gc-cons-threshold my-gc-cons-threshold-normal))
(my-gc-cons-threshold-set-large)
;; Revert that after start-up.
(add-hook 'emacs-startup-hook #'my-gc-cons-threshold-set-normal)
;; The outcome of https://emacsconf.org/2023/talks/gc/ was:
(setq gc-cons-percentage 0.2) ;; so just do that permanently.
;; Although Stefan says:
;; "FWIW, Emacs uses 0.5 for gc-cons-percentage when run in batch
;; mode, and I use that same value in my init file." (!)

;; Recompile .elc files automatically whenever necessary. Enable this early.
;; (Note that init.el does this too, in case it hasn't happened here.)
(require 'compile) ;; Keep for paranoia, while bug#69467 is open.  See also:
;; (browse-url (concat "https://" "github.com/emacscollective/auto-compile/issues/33"))
(setq load-prefer-newer t)
;; Only automatically byte-compile using my *expected* major version of Emacs.
(when (eql emacs-major-version my-expected-emacs-major-version)
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/el-get/auto-compile"))
  (require 'auto-compile)
  (auto-compile-on-save-mode 1)
  (auto-compile-on-load-mode 1))

;; Hide the tool bar.
(tool-bar-mode -1)

;; Scroll-bar on the right-hand side.
(set-scroll-bar-mode 'right)

;; No horizontal scroll bars.
(when (fboundp 'horizontal-scroll-bar-mode)
  (horizontal-scroll-bar-mode 0))

;; Setting the default font in early-init.el improves start time by ~200ms.
;;
;; Note that setting the default font in (custom-set-faces) makes
;; things super-funky during initialisation if that font doesn't exist
;; on the system.  I can possibly check for it with the following, but
;; in practice I install my fonts when I install Emacs, and shouldn't
;; need to waste time checking for this every time I start Emacs...
;;
;; (not (null (member "Droid Sans Mono Dotted" (font-family-list))))
;; (not (null (member "Atkinson Hyperlegible" (font-family-list))))
;;
;; N.b. The following end up saved to ~/.emacs.d/custom.el as well.
(custom-set-faces
 '(default ((t (:height 120 :family "Droid Sans Mono Dotted"))))
 ;; TODO: Decide whether to use the default font as the fixed-pitch
 ;; font, or if they should remain visibly distinct.
 ;; '(fixed-pitch ((t (:family "Droid Sans Mono Dotted"))))
 '(variable-pitch ((t (:family "Atkinson Hyperlegible"))))
 '(variable-pitch-text ((t (:inherit variable-pitch :height 1.25)))))

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

;; Configure visual theme.
(require 'my-theme (expand-file-name "~/.emacs.d/my-lisp/my-theme"))

(defvar my-early-init-load-end (current-time))

(defvar my-elpa-time -0.0)
(define-advice package-activate-all (:around (orig-fun &rest args) my-timer)
  (let ((before (current-time)))
    (apply orig-fun args)
    (setq my-elpa-time (time-to-seconds (time-since before)))))
