;; Keybinding reference
;; http://www.nongnu.org/emacs-tiny-tools/keybindings/

;; http://emacs-fu.blogspot.com/2009/04/dot-emacs-trickery.html
;; http://www.todesschaf.org/files/browse-kill-ring.el
;; http://www-sop.inria.fr/mimosa/Manuel.Serrano/flyspell/flyspell.html
;; http://stackoverflow.com/users/6148?sort=stats#sort-top

;; http://www.gnu.org/software/emacs/elisp/html_node/Key-Binding-Conventions.html
;; Don't define C-c <letter>, or F5-F9 as keys in Lisp programs.
;; Sequences consisting of C-c and a letter (either upper or lower
;; case) are reserved for users; Function keys <F5> through <F9>
;; without modifier keys are also reserved for users to define.
;; These are the only sequences reserved for users.

;; Macros
;;   C-x (       or F3     Begins recording.
;;                  F3     Insert counter (if recording has already commenced).
;;   C-x )       or F4     Ends recording.
;;   C-x e       or F4     Executes the last recorded keyboard macro.
;;                         Repeated e or F4 presses repeats the macro.
;;   C-x C-k e             Edit a keyboard macro (RET for most recent).
;;   C-x C-k b             Set a key-binding.
;;
;; If find yourself using lots of macros, you can even name them
;; for later use, and save them to your init file.
;;   M-x name-last-kbd-macro (name) RET
;;   M-x insert-kbd-macro (name) RET
;;
;; For more documentation, see the info page:
;;   C-h k C-x (

;; Registers
;;   C-x r x a           Copy region to register 'a'
;;   C-x r g a           Insert contents of register 'a'
;;
;; Remember that killing doesn't affect the registers, which
;; can make this useful for killing and replacing.

;; Multiple windows and frames
;; C-x 1     : Single window on this buffer
;; C-x 2     : Split windows horizontally
;; C-x 3     : Split windows vertically
;; C-x 4 ... : Operations on other-window
;; C-x 5 ... : Operations on other-frame
;; C-x 6 ... : 2C (two columns) operations

;; Load or evaluate .emacs
(defun load-dot-emacs ()
  "load ~/.emacs"
  (interactive)
  (load user-init-file))
(defun find-dot-emacs ()
  "find-file ~/.emacs"
  (interactive)
  (find-file user-init-file))
(defun find-my-lisp ()
  "dired ~/.emacs.d/my-lisp"
  (interactive)
  (dired (concat (file-name-directory user-init-file) "my-lisp/")))
(defalias 'll 'load-dot-emacs)
(defalias 'lll 'find-dot-emacs)
(defalias 'llll 'find-my-lisp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Find my third-party and custom lisp libraries
(add-to-list 'load-path (file-name-as-directory
                         (expand-file-name "~/.emacs.d/lisp")))
(add-to-list 'load-path (file-name-as-directory
                         (expand-file-name "~/.emacs.d/my-lisp")))

;; ELPA -- Emacs Lisp Package Archive
(require 'my-elpa)

;; Other packages, via el-get
;; TODO: Make el-get take care of itself? (And ELPA too?)
(require 'my-externals)

;;
;; Basic customisations
;;
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(confirm-kill-emacs (quote y-or-n-p))
 '(cua-mode t nil (cua-base))
 '(current-language-environment "Latin-1")
 '(default-input-method "latin-1-prefix")
 '(display-time-mode t)
 '(dnd-protocol-alist (quote (("^file:///" . dnd-open-local-file) ("^file://" . dnd-open-file) ("^file:[A-Za-z]%3a" . dnd-open-local-file-fix-url) ("^file:" . dnd-open-local-file) ("^\\(https?\\|ftp\\|file\\|nfs\\)://" . dnd-open-file))))
 '(global-font-lock-mode t nil (font-lock))
 '(history-length 100)
 '(ibuffer-formats (quote ((mark modified read-only " " (name 30 60 :left :elide) " " (size 9 -1 :right) " " (mode 16 16 :left :elide) " " filename-and-process) (mark " " (name 16 -1) " " filename))))
 '(ibuffer-saved-filter-groups (quote (("housing" ("HNZC website" (filename . "site/website")) ("HNZC-dev5:~/Plone" (filename . "/scpc:phil@hnzc-dev-5:/home/phil/Plone")) ("HNZC-dev5 other" (filename . "/scpc:phil@hnzc-dev-5:")) ("Emacs" (filename . "emacs"))))))
 '(ibuffer-saved-filters (quote (("gnus" ((or (mode . message-mode) (mode . mail-mode) (mode . gnus-group-mode) (mode . gnus-summary-mode) (mode . gnus-article-mode)))) ("programming" ((or (mode . emacs-lisp-mode) (mode . cperl-mode) (mode . c-mode) (mode . java-mode) (mode . idl-mode) (mode . lisp-mode)))))))
 '(inhibit-eol-conversion nil)
 '(js-indent-level 2)
 '(read-buffer-completion-ignore-case t)
 '(read-file-name-completion-ignore-case t)
 '(recentf-max-menu-items 20)
 '(recentf-save-file "~/.emacs.d/recentf")
 '(safe-local-variable-values (quote ((my-safe-eval hide-body))))
 '(scroll-bar-mode (quote right))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(vc-svn-global-switches (quote ("--username phils" "--password password"))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#3f3f3f" :foreground "#dcdccc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 121 :width normal :foundry "unknown" :family "WenQuanYi Micro Hei Mono"))))
 '(whitespace-newline ((t (:foreground "grey32" :weight normal))))
 '(whitespace-space ((((class color) (background dark)) (:foreground "grey30")))))
;; Warning: Under Win32 (NTEmacs), my-theme.el over-rides custom-set-faces
;; for the 'user theme, to set the default font face. Custom faces set
;; in the above call will be over-ridden in Win32.

;; Local variable helpers
(defun my-safe-eval ()
  "Files can specify a my-safe-eval local variable to avoid
always being asked for eval confirmation. Emacs will ask once
for a given value, which is all we need. Usage example:
;;; Local Variables:
;;; mode:outline-minor
;;; my-safe-eval:(hide-body)
;;; End:"
  (eval (bound-and-true-p my-safe-eval)))
(add-hook 'find-file-hook 'my-safe-eval)

;; Basic configuration
(require 'my-configuration)

;; Custom utilities
(require 'my-utilities)

;; Indentation and white space
(require 'my-indentation)
(require 'my-whitespace)

;; Programming language support
(require 'my-programming)
;;(require 'my-other-programming)

;; Non-programming text modes
(require 'my-text)

;; Win32 / Cygwin integration
(when (eq system-type 'windows-nt)
  (require 'my-win32))
;; Note also the window-system variable. This is useful when you want to
;; choose between some x only option, or a terminal, or macos setting.

;; Configure other miscellaneous libraries
(require 'my-libraries)

;; Configure visual theme
(require 'my-theme)

;; Session management
(require 'my-session)

;; Support for development on local machine
(require 'my-local)

;; Key-bindings
(global-set-key (kbd "C-c r")   'rename-file-and-buffer)
(global-set-key (kbd "C-x M-b") 'bury-buffer)
(global-set-key (kbd "C-o")     'other-window)
(global-set-key (kbd "M-o")     'expand-other-window)
(global-set-key (kbd "C-x M-k") 'kill-other-buffer)
(global-set-key (kbd "C-x M-2") 'split-window-vertically-change-buffer)
(global-set-key (kbd "M-l")     'goto-line)
(global-set-key (kbd "M-n")     'scroll-one-line-ahead)
(global-set-key (kbd "M-p")     'scroll-one-line-back)
(global-set-key (kbd "M-.")     'etags-select-find-tag)
(global-set-key (kbd "M-?")     'etags-stack-show)
(global-set-key (kbd "M-s /")   'my-multi-occur-in-matching-buffers)
(global-set-key (kbd "C-c i")   'imenu-ido-goto-symbol)
(global-set-key (kbd "C-c c")   'clone-line)
(global-set-key (kbd "C-h C-f") 'find-function)




;; Determining running environment and platform capabilities in Emacs.
;; http://brain-break.blogspot.com/2010/08/determining-running-environment-and.html

;;;; Check variables:
;;;;
;;emacs-major-version
;;emacs-minor-version
;;window-system            ;'nil' if in terminal, 'w32' if native Windows build,
;;                         ;'x' if under X Window
;;window-system-version    ;for windows only
;;operating-system-release ;release of the operating system Emacs is running on
;;system-configuration     ;like configuration triplet: cpu-manufacturer-os
;;system-name              ;host name of the machine you are running on
;;system-time-locale
;;system-type              ;indicating the type of operating system:
;;                         ;'gnu' (GNU Hurd), 'gnu/linux', 'gnu/kfreebsd'
;;                         ;(FreeBSD), 'darwin' (GNU-Darwin, Mac OS X),
;;                         ;'ms-dos', 'windows-nt', 'cygwin'
;;system-uses-terminfo
;;window-size-fixed

;;;; Check functions:
;;;;
;;(fboundp ...)            ;return t if SYMBOL's function definition is not void
;;(featurep ...)           ;returns t if FEATURE is present in this Emacs
;;(display-graphic-p)      ;return non-nil if DISPLAY is a graphic display;
;;                         ;graphical displays are those which are capable of
;;                         ;displaying several frames and several different
;;                         ;fonts at once
;;(display-multi-font-p)   ;same as 'display-graphic-p'
;;(display-multi-frame-p)  ;same as 'display-graphic-p'
;;(display-color-p)        ;return t if DISPLAY supports color
;;(display-images-p)       ;return non-nil if DISPLAY can display images
;;(display-grayscale-p)    ;return non-nil if frames on DISPLAY can display
;;                         ;shades of gray
;;(display-mouse-p)        ;return non-nil if DISPLAY has a mouse available
;;(display-popup-menus-p)  ;return non-nil if popup menus are supported on
;;                         ;DISPLAY
;;(display-selections-p)   ;return non-nil if DISPLAY supports selections

;;;; Run those checks as below:
;;;;
;;(when window-system ...)
;;(when (eq window-system 'x) ...)
;;(when (>= emacs-major-version 22) ...)
;;(when (fboundp '...) ...)
;;(when (featurep '...) ...)
