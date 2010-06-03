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
;;   C-x (       or F3      Begins recording
;;                  F3      Insert counter (if recording has already commenced)
;;   C-x )       or F4      Ends recording
;;   C-x e       or F4      Executes the last recorded keyboard macro
;;   C-x C-k e              Edit a keyboard macro (RET for most recent)
;;
;; If find yourself using lots of macros, you can even save them to your
;; .emacs and name them (for later use).
;;
;; For more documentation, see the info page:
;;   C-h K C-x (

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
(defun load_dot_emacs ()
  "load ~/.emacs"
  (interactive)
  (load user-init-file))
(defun find_dot_emacs ()
  "find-file ~/.emacs"
  (interactive)
  (find-file user-init-file))
(defalias 'll 'load_dot_emacs)
(defalias 'lll 'find_dot_emacs)

;; Find my third-party and custom lisp libraries
(add-to-list 'load-path
             (file-name-as-directory
              (expand-file-name "~/.emacs.d/lisp")))
(add-to-list 'load-path
             (file-name-as-directory
              (expand-file-name "~/.emacs.d/my-lisp")))

;; ELPA -- Emacs Lisp Package Archive
(require 'my-elpa)

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
 '(current-language-environment "Latin-1")
 '(default-input-method "latin-1-prefix")
 '(desktop-files-not-to-save "^$")
 '(dnd-protocol-alist (quote (("^file:///" . dnd-open-local-file) ("^file://" . dnd-open-file) ("^file:[A-Za-z]%3a" . dnd-open-local-file-fix-url) ("^file:" . dnd-open-local-file) ("^\\(https?\\|ftp\\|file\\|nfs\\)://" . dnd-open-file))))
 '(global-font-lock-mode t nil (font-lock))
 '(history-length 100)
 '(ibuffer-formats (quote ((mark modified read-only " " (name 30 30 :left :elide) " " (size 9 -1 :right) " " (mode 16 16 :left :elide) " " filename-and-process) (mark " " (name 16 -1) " " filename))))
 '(inhibit-eol-conversion nil)
 '(read-file-name-completion-ignore-case t)
 '(tool-bar-mode nil)
 '(vc-svn-global-switches (quote ("--username phils" "--password password"))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;; Basic configuration
(require 'my-configuration)

;; Custom utilities
(require 'my-utilities)
(global-set-key (kbd "C-x M-b") 'bury-buffer)
(global-set-key (kbd "C-o")     'other-window)
(global-set-key (kbd "M-o")     'expand-other-window)
(global-set-key (kbd "C-x M-k") 'kill-other-buffer)
(global-set-key (kbd "C-x M-2") 'split-window-vertically-change-buffer)
(global-set-key (kbd "M-l")     'goto-line)
(global-set-key (kbd "M-n")     'scroll-one-line-ahead)
(global-set-key (kbd "M-p")     'scroll-one-line-back)
(global-set-key (kbd "C-c r")   'rename-file-and-buffer)

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

;; Configure other miscellaneous libraries
(require 'my-libraries)

;; Configure visual theme
(require 'my-theme)

;; Housing
;; (defvar workspace-dir "/scpc:phil@hnzc-dev-5:/home/phil/Plone/")
;; (load "ifind-mode.el")

(put 'dired-find-alternate-file 'disabled nil)
