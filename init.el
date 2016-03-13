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
;; ;; Online reference for all standard Emacs variables and functions:
;; http://bruce-connor.github.io/emacs-online-documentation/
;; ;; Elisp package development and testing:
;; http://emacs.stackexchange.com/a/2324/454

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

;;;; * Compiling
;; Sources:
;; git clone git://git.savannah.gnu.org/emacs.git
;; https://ftp.gnu.org/gnu/emacs/
;; https://alpha.gnu.org/gnu/emacs/

;; Pre-requisites:
;; # Auto?: sudo apt-get build-dep emacs24
;; # Manual: sudo apt-get install -s autoconf automake g++ gcc libdbus-1-dev libfreetype6-dev libgif-dev libgnutls-dev libjpeg-dev libmagickcore-dev libmagickwand-dev libncurses-dev libpng-dev libpoppler-glib-dev libpoppler-private-dev librsvg2-dev libtiff-dev libxaw7-dev libxft-dev libxml2-dev libxpm-dev libz-dev make ncurses-term ttf-ancient-fonts

;; # PDF-tools packages: libpng-dev libz-dev libpoppler-glib-dev libpoppler-private-dev

;; Truetype font support packages: libxft-dev libfreetype6-dev
;; My preferred font is a variant of Droid Sans Mono (droid-fonts package)
;; which I have committed here in ~/.emacs.d/ for safe keeping.
;; Installation:
;; mkdir -p ~/.fonts/truetype
;; xzcat ~/.emacs.d/DroidSansMonoDotted.ttf.xz >~/.fonts/truetype/DroidSansMonoDotted.ttf
;; # or system-wide in: /usr/share/fonts/truetype/
;; sudo fc-cache -f -v # refresh the system font cache
;;
;; Other unicode glyphs are in Symbola: sudo apt-get install ttf-ancient-fonts
;; eterm-color support: sudo apt-get install ncurses-term
;; Include libgtk2.0-dev iff using the GTK toolkit instead of lucid.

;; From git repository working copy, or extracted tarball:
;; Assumes we're installing to ../usr/local relative to build dir.

;; WARNING: git clean -f -d -x -q *silently deletes all untracked files and
;; directories*. If you have any untracked patches-in-progress, or similar,
;; that’s liable to ruin your day.  The purpose is to reset the working copy
;; to a pristine state, as if it were freshly cloned. If that’s not what you
;; want, please don’t run that command.

;; # ([ -d .git ] && git clean -f -d -x -q && git pull || ([ -f Makefile ] && make distclean) || true) && ./autogen.sh && ./configure --prefix=$(readlink -e ../usr/local) --with-x-toolkit=lucid --without-sound 2>&1 | tee ../config.out && cp config.log ../ && make && make install && (alias reminder >/dev/null 2>&1 && reminder "Emacs build (and installation) successful" now >/dev/null || echo "Emacs build (and installation) successful") || (alias reminder >/dev/null 2>&1 && reminder "Failed to build/install Emacs" now >/dev/null || echo "Failed to build/install Emacs")

;; Without duplicate message strings (but logic flow is less obvious):
;; # ([ -d .git ] && git clean -f -d -x -q && git pull || ([ -f Makefile ] && make distclean) || true) && ./autogen.sh && ./configure --prefix=$(readlink -e ../usr/local) --with-x-toolkit=lucid --without-sound 2>&1 | tee ../config.out && cp config.log ../ && make && make install && msg="Emacs build (and installation) successful" || msg="Failed to build/install Emacs" && msg="$msg ($(basename $(pwd)))" && alias reminder >/dev/null 2>&1 && reminder "$msg" now >/dev/null || echo "$msg"

;;
;; Configuration options:
;; # ./configure --help

;;;; * Integration
;; TERM / eterm-color
;;
;; http://www.emacswiki.org/emacs/AnsiTermHints
;;
;; The Emacs Wiki explains that you should copy (or symlink) the eterm-color
;; and eterm-color.ti files from the /usr/share/emacs/xx.x/etc/e directory
;; on your local system to the ~/.terminfo/e/ directory (or alternatively,
;; system-wide at /usr/share/terminfo/e/).
;;
;; Of course you can also do likewise on any remote host you connect to.
;;
;; On Debian-based systems you administer, you can apt-get install
;; ncurses-term, which includes /usr/share/terminfo/e/eterm-color.

;;;; * Keybinding reference
;; http://www.nongnu.org/emacs-tiny-tools/keybindings/
;; http://www.gnu.org/software/emacs/elisp/html_node/Key-Binding-Conventions.html
;; http://www.masteringemacs.org/articles/2011/02/08/mastering-key-bindings-emacs/
;; http://emacs.stackexchange.com/questions/3815/key-translation/3839#3839

;; Don't define C-c <letter>, or F5-F9 as keys in Lisp programs.
;; Sequences consisting of C-c and a letter (either upper or lower
;; case) are reserved for users; Function keys <F5> through <F9>
;; without modifier keys are also reserved for users to define.
;; These are the only sequences reserved for users.

;; Remapping Commands:
;; E.g.: globally remap all key binds that point to kill-line to my-kill-line.
;; (define-key (current-global-map) [remap kill-line] 'my-kill-line)

;; Conditional definition/over-ride with fall-back:
;; http://endlessparentheses.com/define-context-aware-keys-in-emacs.html
;; http://stackoverflow.com/questions/16090517/elisp-conditionally-change-keybinding
;; http://stackoverflow.com/questions/2494096/emacs-key-binding-fallback

;; Query bindings for keys:
;; (lookup-key KEYMAP KEY &optional ACCEPT-DEFAULT)
;; (key-binding KEY &optional ACCEPT-DEFAULT NO-REMAP POSITION) ;; dominant binding
;; (minor-mode-key-binding KEY &optional ACCEPT-DEFAULT) ;; discover keymap(s)
;; (global-key-binding KEYS &optional ACCEPT-DEFAULT)
;; (local-key-binding KEYS &optional ACCEPT-DEFAULT)
;; http://stackoverflow.com/q/18801018/324105
;;
;; Query key sequence used to invoke current command:
;; (this-single-command-keys)
;; (this-command-keys)
;; (this-command-keys-vector)
;; (clear-this-command-keys)
;;
;; Display keys for command:
;; (substitute-command-keys)

;; Terminal emulators:
;; For non-standard terminals, the input-decode-map keymap can be used
;; to define mappings between terminal codes and normal emacs keys.
;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Translation-Keymaps.html
;; http://stackoverflow.com/a/4360658/324105
;; http://unix.stackexchange.com/a/79561

;; Buffer-local keymaps / Minor mode keymap over-rides:
;; http://stackoverflow.com/a/13102821/324105
;;
;; (add-hook '<major-mode>-hook
;;   (lambda ()
;;     (let ((oldmap (cdr (assoc '<minor-mode> minor-mode-map-alist)))
;;           (newmap (make-sparse-keymap)))
;;       (set-keymap-parent newmap oldmap)
;;       (define-key newmap [<thekeyIwanttohide>] nil)
;;       (make-local-variable 'minor-mode-overriding-map-alist)
;;       (push `(<minor-mode> . ,newmap) minor-mode-overriding-map-alist))))

;; Dynamic bindings. A function returns the command to call. If the function
;; returns nil, Emacs treats it as if no binding exists in that keymap.
;; http://paste.lisp.org/display/304865
;; http://endlessparentheses.com/define-context-aware-keys-in-emacs.html
;; e.g.:
;; (define-key <map> <key>
;;   `(menu-item "" <my-cmd> :filter ,(lambda (cmd) (if <my-predicate> cmd))))
;;
;; TODO: Use to replace the likes of `my-backward-word-or-buffer-or-windows' !

;; In Windows you can add this to to your .emacs to enable hyper and super:
;; (setq w32-apps-modifier 'hyper)
;; (setq w32-lwindow-modifier 'super)
;; (setq w32-rwindow-modifier 'hyper)
;; In X you'll have to play around with xmodmap or your own tool of choice.

;; Modifier key events can be sent in software with the sequence C-x @ <c>
;; where <c> represents the modifier required. See C-x @ C-h for the list.
;; e.g. "C-x @ m x" is equivalent to "M-x". Most useful for Super & Hyper.

;; To create functions which facilitate a 'repeating' key, use:
;; http://stackoverflow.com/q/17201738/324105
;; `set-temporary-overlay-map' < 24.4; `set-transient-map' >= 24.4
;; (set-temporary-overlay-map
;;  (let ((map (make-sparse-keymap)))
;;    (define-key map (kbd "=") 'foo)
;;    map)))

;;;; * Keyboard macros
;;   C-x (          or F3  Begin recording.
;;                     F3  Insert counter (if recording has already commenced).
;;   C-u <n> C-x (  or F3  Begin recording with initial counter value <n>.
;;   C-x )          or F4  End recording.
;;   C-u <n> C-x )  or F4  End recording, then execute the macro <n>-1 times.
;;   C-x e          or F4  Execute the last recorded keyboard macro.
;;       e          or F4  Additional e or F4 presses repeat the macro.
;;   C-u <n> C-x e  or F4  Execute the last recorded keyboard macro <n> times.
;;   C-x C-k r             Apply the last macro to each line of the region.
;;   C-x C-k e             Edit a keyboard macro (RET for most recent).
;;   C-x C-k b             Set a key-binding.
;;
;; If you find yourself using lots of macros, you can even name them
;; for later use, and save them to your init file.
;;   M-x name-last-kbd-macro RET (name) RET
;;   M-x insert-kbd-macro RET (name) RET
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

;;;; * Unicode
;; C-x 8 C-h
;; http://ergoemacs.org/emacs/emacs_n_unicode.html
;; If you need to type these chars often, call set-input-method and
;; give “latin-9-prefix”. That will allow you to type these chars
;; without typing C-x 8 first.
;; C-\ calls toggle-input-method.

;;;; * Printing objects

;; prin1 - Output a printed representation of the argument with quoting.
;;         Output will be readable if possible.
;;
;; prin1-char - Return a string representation of the argument, which
;;              must be a character.
;;
;; prin1-to-string - Return a string representation of the argument with
;;                   quoting. Like prin1 but returns the string rather than
;;                   outputting it. Output will be readable if possible.
;;
;; princ - Output the printed representation of the argument
;;         without quoting.
;;
;; princ-list (OBSOLETE) - Print all arguments with princ followed by
;;              a newline. Use mapc and princ instead.
;;
;; print - Output the printed representaton of the argument with newlines
;;         around it. Output will be quoted and readable if possible.
;;
;; print-buffer - Paginate and print buffer contents.
;;
;; print-diary-entries - Print a hard copy of the diary display.
;;
;; print-help-return-message (OBSOLETE) - use help-print-return-message instead.
;;
;; print-region - Paginate and print the region contents.
;;
;; pp - Output a pretty-printed representation of the argument with quoting.
;;      Output will be readable if possible. See also pp-* functions.

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

;; M-: (info "(elisp) Debugging") RET

;; Standard debugger:
;; M-x debug-on-entry FUNCTION
;; M-x cancel-debug-on-entry &optional FUNCTION
;; debug &rest DEBUGGER-ARGS
;; M-x toggle-debug-on-error
;; M-x toggle-debug-on-quit
;; setq debug-on-signal
;; setq debug-on-next-call
;; setq debug-on-event
;; setq debug-on-message REGEXP

;; Spinning:
;; setq debug-on-quit t
;; When the problem occurs, hit C-g for a backtrace.

;; "If your instance hangs and won't respond to C-g, you can issue
;; 'pkill -SIGUSR2 emacs' to force it to stop whatever it's doing."
;; (n.b. this didn't work the one time I tried it).

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

;; CPU & Memory ('Native Profiler')
;; M-x profiler-start
;; M-x profiler-report
;; M-x profiler-reset
;; M-x profiler-stop
;; M-x profiler-*

;; Dope -- DOtemacs ProfilEr.. A per-sexp-evaltime profiler.
;; https://raw.github.com/emacsmirror/dope/master/dope.el
;; M-x dope-quick-start will show a little introduction tutorial.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; * Elisp executable scripts

;; Don't ever do this without good reason. But if you *really* need to...

;; There is an excellent overview at:
;; http://www.lunaryorn.com/2014/08/12/emacs-script-pitfalls.html

;; "n.b. secure text input by reading directly from the TTY is
;; currently impossible in any released version from Emacs:
;; `read-passwd' reads from standard input in batch mode and exposes the
;; password input on the terminal. A patch to hide input on batch mode
;; is committed to Emacs trunk, but as of now, it will not be part of
;; upcoming Emacs 24.4. Be careful what you read from standard input!"

;; --batch vs --script
;; M-: (info "(emacs) Initial Options") RET
;; M-: (info "(elisp) Batch Mode") RET

;; Processing command-line arguments (boiler-plate)
;; http://stackoverflow.com/questions/6238331/#6259330 (and others)
;;
;; #!/bin/sh
;; ":"; exec emacs -Q --script "$0" -- "$@" # -*-emacs-lisp-*-
;; (pop argv) ; Remove the "--" argument
;; ;; (setq debug-on-error t) ; if a backtrace is wanted
;; ;; (defun stdout (string args) (princ (format string args)))
;; ;; (defun stderr (string args) (message string args)) ; n.b. auto newline.
;; ;; [script body]
;; (kill-emacs 0) ; Always exit explicitly. This returns the desired exit
;;                ; status, and also avoids the need to (setq argv nil).

;; Processing command-line arguments (example)
;; Based on http://www.lunaryorn.com/2014/08/12/emacs-script-pitfalls.html
;;
;; #!/bin/sh
;; ":"; exec emacs -Q --script "$0" -- "$@" # -*-emacs-lisp-*-
;; (pop argv) ; Remove the "--" argument
;; (setq version "1.0")
;; (let ((greeting "Hello %s!")
;;       options-done
;;       names)
;;   (while argv
;;     (let ((option (pop argv)))
;;       (cond
;;        (options-done (push option names))
;;        ;; Don't process options after "--"
;;        ((string= option "--") (setq options-done t))
;;        ((string= option "--greeting")
;;         (setq greeting (pop argv)))
;;        ;; --greeting=Foo
;;        ((string-match "\\`--greeting=\\(\\(?:.\\|\n\\)*\\)\\'" option)
;;         (setq greeting (match-string 1 option)))
;;        ((string= option "--version")
;;         (princ (format "Version %s\n" version))
;;         (kill-emacs 0))
;;        ((string-prefix-p "--" option)
;;         (message "Unknown option: %s" option)
;;         (kill-emacs 1))
;;        (t (push option names)))
;;
;;       (unless (> (length greeting) 0)
;;         (message "Missing argument for --greeting!")
;;         (kill-emacs 1))))
;;
;;   (unless names
;;     (message "Missing names!")
;;     (kill-emacs 1))
;;
;;   (dolist (name (nreverse names))
;;     (princ (format greeting name))
;;     (terpri)) ; newline
;;
;;   (kill-emacs 0))


;; Processing with STDIN and STDOUT via --script:
;; http://stackoverflow.com/questions/2879746/#2906967
;; For STDERR see also bug#17390: 24.4.50; Doc bug: Batch Mode
;; http://debbugs.gnu.org/cgi/bugreport.cgi?bug=17390
;; (currently `message' alone writes to stderr)
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

;; Configure tramp-default-proxies-alist
;; or M-: (info "(tramp) Ad-hoc multi-hops") RET

;; sudo on remote host:
;; C-x C-f /ssh:you@remotehost|sudo:remotehost:/path/to/file RET
;; Important: Do NOT use "sudo::"  ^^^^^^^^^^^^ (always specify the host)
;; (You can still use sudo:: on localhost)
;;
;; As this still uses the proxy mechanism underneath,
;; `tramp-default-proxies-alist' should now include the
;; value ("remotehost" "root" "/ssh:you@remotehost:")
;;
;; Meaning that the proxy /ssh:you@remotehost: is going to be used
;; whenever you request a file as root@remotehost.

;; Remote shell emacsclient talking to local emacs server
;; http://snarfed.org/emacsclient_in_tramp_remote_shells
;; http://blog.habnab.it/blog/2013/06/25/emacsclient-and-tramp/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; * Load or evaluate this file (and other files)

;; Other libraries:
;;
;; M-x load-library
;; M-x locate-library
;; M-x list-load-path-shadows

;; How to relocate user directory using dummy init.el:
;; http://stackoverflow.com/a/21769015/324105
;; (setq user-emacs-directory "~/fake/.emacs.d/")
;; (load (locate-user-emacs-file "init.el"))

;; Using $HOME to run alternative/side-by-side configurations:
;; http://stackoverflow.com/a/21569451/324105

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
;;;
;;; Never forget that modifying a (quote)d argument == self-modifying code!
;;; http://stackoverflow.com/q/16670989/324105
;;;
;;; Look into http://nullprogram.com/tags/elfeed/
;;; And Email solutions for Emacs. (mu4e? notmuch? wanderlust? gnus?? mew??)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; M-s w     : isearch-forward-word
;; M-s a C-s : (ibuffer) isearch across all marked buffers. (M-C-s for regexps)
;; M-m       : back-to-indentation
;; M-S-SPC   : my-extend-selection
;; M-C       : my-capitalize-word
;; C-c w s   : my-www-search
;; C-c n     : deft
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

;; Temporary performance measures, to reduce start-up time.
;; Avoid garbage collection during start-up.
(defvar my-gc-cons-threshold-normal gc-cons-threshold)
(defvar my-gc-cons-threshold-large 10000000) ;; 10M; default is 0.8M
(defun my-gc-cons-threshold-set-large ()
  (setq gc-cons-threshold my-gc-cons-threshold-large))
(defun my-gc-cons-threshold-set-normal ()
  (setq gc-cons-threshold my-gc-cons-threshold-normal))
(my-gc-cons-threshold-set-large)
;; Disable non-local file handlers during start-up
(defvar my-original-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Recompile .elc files automatically whenever necessary. Enable this early.
(add-to-list 'load-path (expand-file-name "~/.emacs.d/el-get/packed"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/el-get/auto-compile"))
(setq load-prefer-newer t)
(require 'auto-compile)
(auto-compile-on-save-mode 1)
(auto-compile-on-load-mode 1)

;; Load 'customized' variables and faces.
(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(load custom-file)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Find my third-party and custom lisp libraries
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/my-lisp"))

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

;; ;; Added by Package.el.  This must come before configurations of
;; ;; installed packages.  Don't delete this line.  If you don't want it,
;; ;; just comment it out by adding a semicolon to the start of the line.
;; (setq package-enable-at-startup nil)
;; (package-initialize)

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

;; Org-Mode
(require 'my-org)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Start server (but don't restart).
(require 'server)
(unless (server-running-p)
  (server-start))

;; Log uptime to `my-emacs-uptime-log'.
(add-hook 'kill-emacs-hook 'my-log-emacs-uptime)

;; Display the time taken to start Emacs.
(let ((my-init-time (time-to-seconds (time-since my-init-load-start))))
  (add-hook 'after-init-hook
            `(lambda ()
               (message "Init time was %.2fs (%.2fs in %s)."
                        (time-to-seconds (time-since before-init-time))
                        ,my-init-time
                        (file-name-nondirectory user-init-file)))))

;; Revert the temporary performance measures put in place at the start
;; of this file.
(add-hook
 'emacs-startup-hook
 (lambda ()
   (my-gc-cons-threshold-set-normal)
   (setq file-name-handler-alist my-original-file-name-handler-alist)
   (makunbound 'my-original-file-name-handler-alist)))

;;; Local Variables:
;;; page-delimiter: ";;;; "
;;; outline-regexp: ";;;; "
;;; eval:(outline-minor-mode 1)
;;; eval:(while (re-search-forward "^;;;; \\* " nil t) (outline-toggle-children))
;;; End:
