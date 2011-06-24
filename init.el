;;;; Useful links
;; http://www.masteringemacs.org/articles/2011/01/14/effective-editing-movement/;; http://emacs-fu.blogspot.com/2009/04/dot-emacs-trickery.html
;; http://www.todesschaf.org/files/browse-kill-ring.el
;; http://www-sop.inria.fr/mimosa/Manuel.Serrano/flyspell/flyspell.html
;; http://stackoverflow.com/users/6148?sort=stats#sort-top
;; http://emacs-fu.blogspot.com/2011/02/keeping-your-secrets-secret.html

;; Example of running Emacs remotely with local display:
;; ssh -Y (user)@(host) -f "source ~/.ssh/environment && emacsclient -a '' -c"

;;;; Keybinding reference
;; http://www.nongnu.org/emacs-tiny-tools/keybindings/
;; http://www.gnu.org/software/emacs/elisp/html_node/Key-Binding-Conventions.html
;; http://www.masteringemacs.org/articles/2011/02/08/mastering-key-bindings-emacs/

;; Don't define C-c <letter>, or F5-F9 as keys in Lisp programs.
;; Sequences consisting of C-c and a letter (either upper or lower
;; case) are reserved for users; Function keys <F5> through <F9>
;; without modifier keys are also reserved for users to define.
;; These are the only sequences reserved for users.

;; Remapping Commands:
;; E.g.: globally remap all key binds that point to kill-line to my-kill-line.
;; (define-key (current-global-map) [remap kill-line] 'my-kill-line)

;; On non-standard terminals, the input-decode-map keymap can be used
;; to define mappings between terminal codes and normal emacs keys.
;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Translation-Keymaps.html
;; http://stackoverflow.com/questions/4351044/binding-m-up-m-down-in-emacs-23-1-1/4360658#4360658

;; In Windows you can add this to to your .emacs to enable hyper and super:
;; (setq w32-apps-modifier 'hyper)
;; (setq w32-lwindow-modifier 'super)
;; (setq w32-rwindow-modifier 'hyper)
;; In X you'll have to play around with xmodmap or your own tool of choice.

;;;; Macros
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

;;;; Registers
;;   C-x r x a           Copy region to register 'a'
;;   C-x r g a           Insert contents of register 'a'
;;   C-x r SPC a         point-to-register 'a'
;;   C-x r j a           jump-to-register 'a'
;;
;; Remember that killing doesn't affect the registers, which
;; can make this useful for killing and replacing.

;;;; Multiple windows and frames
;; C-x 1     : Single window on this buffer
;; C-x 2     : Split windows horizontally
;; C-x 3     : Split windows vertically
;; C-x 4 ... : Operations on other-window
;; C-x 5 ... : Operations on other-frame
;; C-x 6 ... : 2C (two columns) operations

;;;; Determining running environment and platform capabilities in Emacs.
;; http://brain-break.blogspot.com/2010/08/determining-running-environment-and.html

;; ;; Check variables:
;; ;;
;; emacs-major-version
;; emacs-minor-version
;; window-system            ;'nil' if in terminal, 'w32' if native Windows build,
;;                          ;'x' if under X Window
;; window-system-version    ;for windows only
;; operating-system-release ;release of the operating system Emacs is running on
;; system-configuration     ;like configuration triplet: cpu-manufacturer-os
;; system-name              ;host name of the machine you are running on
;; system-time-locale
;; system-type              ;indicating the type of operating system:
;;                          ;'gnu' (GNU Hurd), 'gnu/linux', 'gnu/kfreebsd'
;;                          ;(FreeBSD), 'darwin' (GNU-Darwin, Mac OS X),
;;                          ;'ms-dos', 'windows-nt', 'cygwin'
;; system-uses-terminfo
;; window-size-fixed
;;
;; ;; Check functions:
;; ;;
;; (fboundp ...)            ;return t if SYMBOL's function definition is not void
;; (featurep ...)           ;returns t if FEATURE is present in this Emacs
;; (display-graphic-p)      ;return non-nil if DISPLAY is a graphic display;
;;                          ;graphical displays are those which are capable of
;;                          ;displaying several frames and several different
;;                          ;fonts at once
;; (display-multi-font-p)   ;same as 'display-graphic-p'
;; (display-multi-frame-p)  ;same as 'display-graphic-p'
;; (display-color-p)        ;return t if DISPLAY supports color
;; (display-images-p)       ;return non-nil if DISPLAY can display images
;; (display-grayscale-p)    ;return non-nil if frames on DISPLAY can display
;;                          ;shades of gray
;; (display-mouse-p)        ;return non-nil if DISPLAY has a mouse available
;; (display-popup-menus-p)  ;return non-nil if popup menus are supported on
;;                          ;DISPLAY
;; (display-selections-p)   ;return non-nil if DISPLAY supports selections

;; ;; Run those checks as below:
;; ;;
;; (when window-system ...)
;; (when (eq window-system 'x) ...)
;; (when (>= emacs-major-version 22) ...)
;; (when (fboundp '...) ...)
;; (when (featurep '...) ...)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; Load or evaluate this file
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Quick notes:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; M-s w     : isearch-forward-word
;; M-s a C-s : (ibuffer) isearch across all marked buffers. (M-C-s for regexps)
;; M-m       : back-to-indentation
;; C-x r x   : Copy region to register
;; C-x r g   : Insert contents of register
;; C-x r SPC : point-to-register
;; C-x r j   : jump-to-register
;; C-x 4 ... : Operations on other-window
;; C-x 5 ... : Operations on other-frame
;; C-x 6 ... : 2C (two columns) operations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Initialisation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; Basic customisations.
;;
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(confirm-kill-emacs (quote y-or-n-p))
 '(current-language-environment "Latin-1")
 '(default-input-method "latin-1-prefix")
 '(dnd-protocol-alist (quote (("^file:///" . dnd-open-local-file) ("^file://" . dnd-open-file) ("^file:[A-Za-z]%3a" . dnd-open-local-file-fix-url) ("^file:" . dnd-open-local-file) ("^\\(https?\\|ftp\\|file\\|nfs\\)://" . dnd-open-file))))
 '(fic-highlighted-words (quote ("FIXME" "TODO" "KLUDGE")))
 '(global-font-lock-mode t nil (font-lock))
 '(grep-find-ignored-files (quote (".#*" "*.o" "*~" "*.bin" "*.lbin" "*.so" "*.a" "*.ln" "*.blg" "*.bbl" "*.elc" "*.lof" "*.glo" "*.idx" "*.lot" "*.fmt" "*.tfm" "*.class" "*.fas" "*.lib" "*.mem" "*.x86f" "*.sparcf" "*.fasl" "*.ufsl" "*.fsl" "*.dxl" "*.pfsl" "*.dfsl" "*.p64fsl" "*.d64fsl" "*.dx64fsl" "*.lo" "*.la" "*.gmo" "*.mo" "*.toc" "*.aux" "*.cp" "*.fn" "*.ky" "*.pg" "*.tp" "*.vr" "*.cps" "*.fns" "*.kys" "*.pgs" "*.tps" "*.vrs" "*.pyc" "*.pyo" "*.png" "*.gif" "*.jpg" "*.jpeg" "*.tiff" "*.pdf" "*.doc" "")))
 '(history-length 100)
 '(ibuffer-saved-filter-groups (quote (("housing" ("Scratch" (mode . lisp-interaction-mode)) ("Shells" (mode . shell-mode)) ("*Awooga*! SVN Externals!" (filename . "/phil/hnzc-web/hnzc/src")) ("HNZC intranet (r2) eggs" (filename . "hnzc-dev-5:/home/phil/hnzc-intranet/buildout-cache")) ("Find an expert" (filename . "housing.intranet.noticeboard")) ("Directory" (filename . "housing.intranet.directory")) ("Projects" (filename . "housing.intranet.projects")) ("HNZC intranet (r2)" (filename . "hnzc-dev-5:/home/phil/hnzc-intranet")) ("HNZC website (intranet files)" (filename . "/phil/hnzc-web/hnzc/site/intranet/")) ("HNZC website" (filename . "/phil/hnzc-web/")) ("HNZC-dev5 other" (filename . "/scpc:phil@hnzc-dev-5:")) ("Emacs" (filename . "emacs"))))))
 '(ibuffer-saved-filters (quote (("gnus" ((or (mode . message-mode) (mode . mail-mode) (mode . gnus-group-mode) (mode . gnus-summary-mode) (mode . gnus-article-mode)))) ("programming" ((or (mode . emacs-lisp-mode) (mode . cperl-mode) (mode . c-mode) (mode . java-mode) (mode . idl-mode) (mode . lisp-mode)))))))
 '(inhibit-eol-conversion nil)
 '(js-indent-level 2)
 '(read-buffer-completion-ignore-case t)
 '(read-file-name-completion-ignore-case t)
 '(safe-local-variable-values (quote ((css-indent-offset . 2) (js-indent-level . 2) (drupal-p . t) (eval progn (outline-minor-mode) (outline-toggle-children) (let ((n 6)) (while (> n 0) (setq n (1- n)) (call-interactively (quote outline-next-visible-heading)) (outline-toggle-children)))) (eval hide-body))))
 '(svn-log-edit-show-diff-for-commit t)
 '(tool-bar-mode nil)
 '(tramp-remote-path (quote (tramp-default-remote-path "/usr/sbin" "/usr/local/bin" "/local/bin" "/local/freeware/bin" "/local/gnu/bin" "/usr/freeware/bin" "/usr/pkg/bin" "/usr/contrib/bin" "/usr/bin")))
 '(vc-svn-global-switches (quote ("--username" "phils" "--password" "password"))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(whitespace-newline ((t (:foreground "grey32" :weight normal))))
 '(whitespace-space ((((class color) (background dark)) (:foreground "grey30")))))
;; WARNING: my-theme.el over-rides (custom-set-faces) for the 'user
;; theme, to set the default font face. Custom faces set in the above
;; call will be over-ridden.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Find my third-party and custom lisp libraries
(add-to-list 'load-path (file-name-as-directory
                         (expand-file-name "~/.emacs.d/lisp")))
(add-to-list 'load-path (file-name-as-directory
                         (expand-file-name "~/.emacs.d/my-lisp")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Custom key-bindings.
;; Do this first, so that our keymap is available to other config files.
(require 'my-keybindings)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; System-specific configuration
(cond ((eq system-type 'windows-nt) ; Win32 / Cygwin integration
       (require 'my-win32))) ; Assumes Emacs was launched via Cygwin!

;; Note also the window-system variable. This is useful when you want to
;; choose between some x only option, or a terminal, or macos setting.
;; (if (equal (window-system) 'x)
;;     (require 'my-x-window-system))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Initialise third-party packages

;; ELPA -- Emacs Lisp Package Archive
;; TODO: Make el-get take care of ELPA?
(require 'my-elpa)

;; Other packages, via el-get
(require 'my-externals)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; Configure other miscellaneous libraries
(require 'my-libraries)

;; Configure visual theme
(require 'my-theme)

;; Session management
(require 'my-session)

;; Project support
(require 'my-projects)

;; Support for development on local machine
(require 'my-local)

;;; Local Variables:
;;; eval:(progn (outline-minor-mode) (outline-toggle-children) (let ((n 6)) (while (> n 0) (setq n (1- n)) (call-interactively 'outline-next-visible-heading) (outline-toggle-children))))
;;; End:
