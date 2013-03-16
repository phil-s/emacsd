;;;; * Useful links
;; http://www.masteringemacs.org/articles/2011/01/14/effective-editing-movement/
;; http://emacs-fu.blogspot.com/2009/04/dot-emacs-trickery.html
;; http://www.todesschaf.org/files/browse-kill-ring.el
;; http://www-sop.inria.fr/mimosa/Manuel.Serrano/flyspell/flyspell.html
;; http://stackoverflow.com/users/6148?sort=stats#sort-top
;; http://emacs-fu.blogspot.com/2011/02/keeping-your-secrets-secret.html
;; http://obsidianrook.com/devnotes/elisp-for-perl-programmers.html
;; http://stackoverflow.com/questions/5795451/how-to-detect-that-emacs-is-in-terminal-mode
;; http://www.emacswiki.org/emacs/Reference_Sheet_by_Aaron_Hawley
;; http://stackoverflow.com/questions/2500925/pipe-less-to-emacs
;; http://stackoverflow.com/questions/5147060/how-can-i-access-directory-local-variables-in-my-major-mode-hooks
;; http://irreal.org/blog/?p=330 ;; sort-columns is awesome
;; ;; Writing a callback operation for marked files in dired:
;; http://irreal.org/blog/?p=382
;; http://xahlee.blogspot.com/2011/12/emacs-convert-image-files-and-change.html
;; ;; Interactive command templates:
;; http://xahlee.org/emacs/elisp_idioms.html
;; ;; The TTY Demystified
;; http://www.linusakesson.net/programming/tty/
;; ;; Custom Flymake commands
;; http://stackoverflow.com/questions/9771339
;; ;; Invoking external interactive scripts
;; http://stackoverflow.com/questions/13674100/properly-invoking-an-interactive-script-from-elisp

;; ;; Dynamic function definition without macro:
;; (let ((name "my-function"))
;;   (defalias (intern name)
;;     `(lambda () ,(format "Docstring for %s" name) (interactive)
;;        (message "Hello from %s" ,name))))

;; Example of running Emacs remotely with local display:
;; ssh -Y (user)@(host) -f "source ~/.ssh/environment && emacsclient -a '' -c"

;; Search & replace over many files:
;; 1) Find and mark in dired:
;; * M-x find-grep-dired RET (dir) RET (pattern) RET
;; * Mark files with dired commands (e.g. 't' to mark all)
;;
;; 2) Search & replace:
;; a) 'Q' to initiate search and replace across marked files.
;;    or:
;; b) (i)   'F' to open all files in visible buffers, then
;;    (ii)  'M-s C-/' for my-multi-occur-in-visible-buffers
;;    (iii) 'e' in occur-mode to edit. 'C-c C-c' to end.

;;;; * Keybinding reference
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

;; Interrogate bindings:
;; (lookup-key KEYMAP KEY &optional ACCEPT-DEFAULT)
;; (key-binding KEY &optional ACCEPT-DEFAULT NO-REMAP POSITION) ;; dominant binding
;; (minor-mode-key-binding KEY &optional ACCEPT-DEFAULT) ;; discover keymap(s)
;; (global-key-binding KEYS &optional ACCEPT-DEFAULT)
;; (local-key-binding KEYS &optional ACCEPT-DEFAULT)

;; On non-standard terminals, the input-decode-map keymap can be used
;; to define mappings between terminal codes and normal emacs keys.
;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Translation-Keymaps.html
;; http://stackoverflow.com/questions/4351044/binding-m-up-m-down-in-emacs-23-1-1/4360658#4360658

;; Buffer-local keymaps / Minor mode keymap over-rides:
;; http://stackoverflow.com/a/13102821/324105

;; In Windows you can add this to to your .emacs to enable hyper and super:
;; (setq w32-apps-modifier 'hyper)
;; (setq w32-lwindow-modifier 'super)
;; (setq w32-rwindow-modifier 'hyper)
;; In X you'll have to play around with xmodmap or your own tool of choice.

;; Modifier key events can be sent in software with the sequence C-x @ <c>
;; where <c> represents the modifier required. See C-x @ C-h for the list.
;; e.g. "C-x @ m x" is equivalent to "M-x". Most useful for Super & Hyper.

;;;; * Keyboard macros
;;   C-x (         or F3   Begins recording.
;;                    F3   Insert counter (if recording has already commenced).
;;   C-x )         or F4   Ends recording.
;;   C-x e         or F4   Executes the last recorded keyboard macro.
;;                         Additional e or F4 presses repeat the macro.
;;   C-u <n> C-x ) or F4   End macro and repeat an additional <n>-1 times.
;;   C-x C-k e             Edit a keyboard macro (RET for most recent).
;;   C-x C-k b             Set a key-binding.
;;
;; If find yourself using lots of macros, you can even name them
;; for later use, and save them to your init file.
;;   M-x name-last-kbd-macro (name) RET
;;   M-x insert-kbd-macro (name) RET
;;
;; For more documentation:
;;   C-h k C-x (
;;   M-: (info "(emacs) Keyboard Macros") RET

;;;; * Registers
;;   C-x r x a           Copy region to register 'a'
;;   C-x r g a           Insert contents of register 'a'
;;   C-x r SPC a         point-to-register 'a'
;;   C-x r j a           jump-to-register 'a'
;;
;; Remember that killing doesn't affect the registers, which
;; can make this useful for killing and replacing.

;;;; * Multiple windows and frames
;; C-x 1     : Single window on this buffer
;; C-x 2     : Split windows horizontally
;; C-x 3     : Split windows vertically
;; C-x 4 ... : Operations on other-window
;; C-x 5 ... : Operations on other-frame
;; C-x 6 ... : 2C (two columns) operations

;;;; * Determining running environment and platform capabilities in Emacs.
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

;;;; * Debugging, Tracing, and Profiling

;; Standard debugger:
;; M-x debug-on-entry FUNCTION
;; M-x cancel-debug-on-entry &optional FUNCTION
;; debug &rest DEBUGGER-ARGS

;; Edebug -- a source-level debugger for Emacs Lisp
;; M-x edebug-defun (C-u C-M-x) Cancel with eval-defun (C-M-x)
;; M-x edebug-all-defs -- Toggle edebugging of all definitions
;; M-x edebug-all-forms -- Toggle edebugging of all forms
;; M-x edebug-eval-top-level-form

;; Tracing:
;; M-x trace-function FUNCTION &optional BUFFER
;; M-x untrace-function FUNCTION
;; M-x untrace-all

;; Timing and benchmarking:
;; (benchmark-run &optional REPETITIONS &rest FORMS)

;; Emacs Lisp Profiler (ELP)
;; M-x elp-instrument-package
;; M-x elp-instrument-list
;; M-x elp-instrument-function
;; M-x elp-reset-*
;; M-x elp-results
;; M-x elp-restore-all
;;
;; There's a built-in profiler called ELP. You can try something like
;; M-x elp-instrument-package, enter "vc", and then try finding a
;; file. Afterwards, M-x elp-results will show you a profile report.
;; (Note that if the time is instead being spent in non-vc-related
;; functions, this technique will not show it, but you can instrument
;; further packages if you like.)
;;
;; See also:
;; http://cx4a.org/hack/emacs-native-profiler.html

;; Spinning:
;; Set debug-on-quit to t
;; When the problem happens, hit C-g for a backtrace.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; * Elisp executable scripts

;; --batch vs --script
;; M-: (info "(emacs) Initial Options") RET
;; M-: (info "(elisp) Batch Mode") RET

;; Passing additional command-line arguments to Emacs:
;; http://stackoverflow.com/questions/6238331/#6259330
;;
;; #!/bin/sh
;; ":"; exec emacs --no-site-file --script "$0" "$@" # -*-emacs-lisp-*-
;; (print (+ 2 2))

;; Processing with STDIN and STDOUT via --script:
;; http://stackoverflow.com/questions/2879746/#2906967
;;
;; #!/usr/local/bin/emacs --script
;; ;;-*- mode: emacs-lisp;-*-
;;
;; (defun process (string)
;;   "just reverse the string"
;;   (concat (nreverse (string-to-list string))))
;;
;; (condition-case nil
;;     (let (line)
;;       ;; commented out b/c not relevant for `cat`, but potentially useful
;;       ;; (princ "argv is ")
;;       ;; (princ argv)
;;       ;; (princ "\n")
;;       ;; (princ "command-line-args is" )
;;       ;; (princ command-line-args)
;;       ;; (princ "\n")
;;
;;       (while (setq line (read-from-minibuffer ""))
;;         (princ (process line))
;;         (princ "\n")))
;;   (error nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; * Tramp

;; sudo multihop/proxy

;; (add-to-list 'tramp-default-proxies-alist
;;              '("scmp-qa\\'" "\\`root\\'" "/ssh:%h:"))))

;; (require 'tramp)
;; (add-to-list 'tramp-default-proxies-alist
;;              '(nil "\\`root\\'" "/ssh:%h:"))
;; (add-to-list 'tramp-default-proxies-alist
;;              '((regexp-quote (system-name)) nil nil))
;;
;; Then you can edit remote root files with 【Ctrl+x ctrl+f】
;; /sudo:root@remote-host:<path-to-root-owned-file>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; * Load or evaluate this file (and other files)

;; Other libraries:
;;
;; M-x load-library
;; M-x locate-library
;; M-x list-load-path-shadows

;; My libraries:
;; See also: custom aliases in my-keybindings.el

(defun load-dot-emacs ()
  "Load and evaluate init file."
  (interactive)
  (load user-init-file))
(defun find-dot-emacs ()
  "Visit init file."
  (interactive)
  (find-file user-init-file))
(defun find-my-lisp-dir ()
  "Dired ~/.emacs.d/my-lisp"
  (interactive)
  (dired (concat (file-name-directory user-init-file) "my-lisp/")))
(defun find-el-get-dir ()
  "Dired ~/.emacs.d/my-lisp"
  (interactive)
  (dired (concat (file-name-directory user-init-file) "el-get/")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Quick notes:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; M-s w     : isearch-forward-word
;; M-s a C-s : (ibuffer) isearch across all marked buffers. (M-C-s for regexps)
;; M-m       : back-to-indentation
;; M-S-SPC   : my-extend-selection
;; M-C       : my-capitalize-word
;; C-c w s   : my-www-search
;; C-c n     : deft
;; C-x z     : repeat
;; C-x M-:   : repeat-complex-command
;; C-x r x   : copy region to register
;; C-x r g   : insert contents of register
;; C-x r SPC : point-to-register
;; C-x r j   : jump-to-register
;; C-x 4 ... : operations on other-window
;; C-x 5 ... : operations on other-frame
;; C-x 6 ... : 2C (two columns) operations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Write/modify some Drupal YASnippets!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; find-file library:
;;
;; This package features a function called ff-find-other-file, which performs
;; the following function:
;;
;;     When in a .c file, find the first corresponding .h file in a set
;;     of directories and display it, and vice-versa from the .h file.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add a byte-compilation section:
;;  * Macro expansion at compile time
;;  * (elisp) Declaring Functions
;;  * eval-and-compile / eval-when-compile
;;  * dont-compile
;;  * displaying-byte-compile-warnings
;;  ...?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Initialisation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar my-init-load-start (current-time))

(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(load custom-file)

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

;; Support for development on local machine
(require 'my-local)

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
(require 'my-rectangles)

;; Indentation and white space
(require 'my-indentation)
(require 'my-whitespace)

;; Programming language support
(require 'my-programming)
;;(require 'my-other-programming)

;; Non-programming text modes
(require 'my-text)

;; Version control systems
(require 'my-version-control)

;; Configure other miscellaneous libraries
(require 'my-libraries)

;; Configure visual theme
(require 'my-theme)

;; Session management
(require 'my-session)

;; Project support
(require 'my-projects)

(message "Init file loaded in %ds"
         (destructuring-bind (hi lo &rest ignore) (current-time)
           (- (+ hi lo) (+ (first my-init-load-start)
                           (second my-init-load-start)))))

;;; Local Variables:
;;; outline-regexp: ";;;; "
;;; eval:(progn (outline-minor-mode 1) (while (re-search-forward "^;;;; \\* " nil t) (outline-toggle-children)))
;;; End:
