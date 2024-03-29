;;;; * Bug reports:

;; Suggest the addition of loop-collect:
;; https://www.reddit.com/r/emacs/comments/6ndc80/list_comprehensions_in_elisp/dk9n6ka/
;;
;; (defmacro loop-collect (item &rest loop)
;;   "Emulate list comprehension syntax/order for `cl-loop'.
;;
;; \(loop-collect x for x in ...) => (cl-loop for x in ... collect x)"
;;   (require 'cl-macs)
;;   `(cl-loop ,@loop collect ,item))
;;
;; (loop-collect b for b being the buffers if (buffer-file-name b))
;;
;; (loop-collect (cons b (buffer-file-name b))
;;               for b being the buffers
;;               if (buffer-file-name b))

;; Emacs mode docstrings should indicate local/global/globalized-ness
;; The manual should also describe the differences.
;; Adapt my SO/ES answers on the subject.
;; http://emacs.stackexchange.com/a/20915
;; http://stackoverflow.com/a/6839968
;; http://emacs.stackexchange.com/a/24785
;; http://emacs.stackexchange.com/a/22511

;; dired '% R' binding doesn't allow \,(...) interactive replacements.

;;; http://stackoverflow.com/questions/2592095/how-do-i-create-an-empty-file-in-emacs/18885461#18885461

;; + Add new variable `standard-error' with value 'external-debugging-output
;; Re: bug#17390: 24.4.50; Doc bug: Batch Mode
;; + Fix existing documentation so that it isn't lying!:
;; > (info "(elisp) Batch Mode") says:
;; >     Any Lisp program output that would normally go to the echo
;; >     area, either using `message', or using `prin1', etc., with
;; >     `t' as the stream, goes instead to Emacs's standard error
;; >     descriptor when in batch mode.
;; + s/standard error/standard output/
;; + Add new variable `standard-error' with value 'external-debugging-output
;; + Update documentation to indicate the new `standard-error' facility.

;; Should there be any difference between `set-variable' and
;; `customize-set-value' ?! Could one become an alias for the other?
;; See also https://debbugs.gnu.org/cgi/bugreport.cgi?bug=21695
;;
;; (if I've understood correctly that `customize-set-variable' will cause
;; an update to your init file, and `customize-set-value' will not, in
;; which case `customize-set-value' would be the way to manage the values
;; in code without also bulking up your init file unnecessarily (i.e.
;; use `customize-set-value' instead of setq for user options??) It's
;; already the case that `set-variable' deals only with user options, and
;; so I can't see any reason for the current differences. i.e. No one
;; should be calling it non-interactively, and for interactive calls you
;; would invariably(?!) want the `customize-set-value' behaviour?

;; my-rectangles.el
;; rectangle editing
;; http://stackoverflow.com/a/11130708
;; but consider actually doing that via:
;; C-x r e runs the command my-edit-rectangle
;; in order to get line-wrapping behaviours?
;; (i.e. via replace-regexp-lax-whitespace. but maybe that's daft.)
;; etc...


;; Absolutely crazy that "Only useful in lexical-binding mode" is
;; relegated to a comment in the definition of `letrec` rather than
;; appearing in the docstring. In 24.5 at least. Search for any other
;; such comments in the code! => A couple of commented-out macros in
;; cconv.el are all I found: defmacro dlet, and defmacro llet.


;; Enhance `define-globalized-minor-mode' to create some *standard*
;; mechanism for specifying exceptions to the TURN-ON behaviour?
;; (Was that the thing I wanted to do??)  Maybe make TURN-ON &optional
;; and provide a functional default?  Or provide functionality which
;; is layered on top of that which is already provided?


;; ...and I need to review my S.O. and E.S. history -- there will be things
;; I've found over the years which could improve the documentation, or be
;; raised as bug fixes / feature requests.


;; GUI Emacs stops responding to keyboard input; still responds to mouse.
;; https://emacs.stackexchange.com/a/69360 suggests that this may be an
;; ibus issue, and restarting the service may resolve the problem:
;; $ ibus-daemon --xim -d -r
;; (n.b. "ibus-daemon --xim --panel disable" is what ps guax | grep ibus-daemon
;; tells me, so that command might not be quite right?)
;;
;; My own workaround for this was to create a terminal client frame, then
;; delete *all* GUI frames (and potentially delete the hidden daemon frame
;; too?!).  Once all pre-existing GUI-related frames were gone, I would be
;; able to create new functional ones.
;;
;; I don't think this has happened to me in years; however I mostly stopped
;; using --daemon several years ago, so maybe that's why I stopped seeing
;; this problem?


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
;; ;; How can i change the color of my cursor in gnome terminal?
;; http://askubuntu.com/questions/104609
;; ;; How to make terminal and X clipboards/selections interact.
;; https://elpa.gnu.org/packages/xclip.html
;; ;; Overlays.
;; https://emacs.stackexchange.com/q/2200/454

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
;; # Manual: sudo apt-get install -s autoconf automake g++ gcc gnu-standards libdbus-1-dev libfreetype6-dev libgif-dev libgnutls28-dev libjpeg-dev libmagickcore-dev libmagickwand-dev libncurses-dev libpng-dev libpoppler-glib-dev libpoppler-private-dev librsvg2-dev libtiff-dev libxaw7-dev libxft-dev libxml2-dev libxpm-dev libz-dev libjansson-dev libgccjit-7-dev make ncurses-term info texinfo texinfo-doc-nonfree ttf-ancient-fonts sdcv fortune-mod fortunes ispell ibritish wbritish meson gmime-3.0 libxapian-dev
;; # ^ Includes...
;; # Terminfo: ncurses-term
;; # PDF-tools packages: libpng-dev libz-dev libpoppler-glib-dev libpoppler-private-dev
;; # Fonts I use: ttf-ancient-fonts
;; # The 1913 + 1828 Webster’s Revised Unabridged Dictionary: sdcv
;; # mu (building): meson gmime-3.0 libxapian-dev

;; `org-mode' export to latex and/or pdf requires texlive packages
;; (which are large, so not including these in the default list).
;; sudo apt install texlive-latex-base texlive-latex-extra texlive-generic-recommended
;; # maybe also?: sudo apt install texlive
;;
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

;; Trash everything:
;; ([ -d .git ] && git clean -f -d -x -q && git pull || ([ -f Makefile ] && make distclean) || true)
;;
;; WARNING: git clean -f -d -x -q *silently deletes all untracked files and
;; directories*. If you have any untracked patches-in-progress, or similar,
;; that’s liable to ruin your day.  The purpose is to reset the working copy
;; to a pristine state, as if it were freshly cloned. If that’s not what you
;; want, please don’t run that command.

;; # mkdir -p ../usr/local && ./autogen.sh 2>&1 | tee ../autogen.out && ./configure --prefix=$(readlink -e ../usr/local) --with-x-toolkit=lucid --without-sound --program-transform-name='s/^ctags$/ctags_emacs/' 2>&1 | tee ../config.out && cp config.log ../ && make 2>&1 | tee ../make.out && make install 2>&1 | tee ../install.out && (alias reminder >/dev/null 2>&1 && reminder "Emacs build (and installation) successful" now >/dev/null || echo "Emacs build (and installation) successful") || (alias reminder >/dev/null 2>&1 && reminder "Failed to build/install Emacs" now >/dev/null || echo "Failed to build/install Emacs")

;; Without duplicate message strings (but logic flow is less obvious):
;; # mkdir -p ../usr/local && ./autogen.sh 2>&1 | tee ../autogen.out && ./configure --prefix=$(readlink -e ../usr/local) --with-x-toolkit=lucid --without-sound --program-transform-name='s/^ctags$/ctags_emacs/' 2>&1 | tee ../config.out && cp config.log ../ && make 2>&1 | tee ../make.out && make install 2>&1 | tee ../install.out && msg="Emacs build (and installation) successful" || msg="Failed to build/install Emacs" && msg="$msg ($(basename $(pwd)))" && alias reminder >/dev/null 2>&1 && reminder "$msg" now >/dev/null || echo "$msg"

;; Secondary build/install --with-native-compilation:
;;
;; # ./configure --prefix=$(readlink -e ../native-compilation/usr/local) --with-native-compilation --with-x-toolkit=lucid --without-sound --program-transform-name='s/^ctags$/ctags_emacs/' 2>&1 | tee ../native-compilation/config.out && cp config.log ../native-compilation/ && make 2>&1 | tee ../native-compilation/make.out && make install 2>&1 | tee ../native-compilation/install.out && (alias reminder >/dev/null 2>&1 && reminder "Emacs NC build (and installation) successful" now >/dev/null || echo "Emacs NC build (and installation) successful") || (alias reminder >/dev/null 2>&1 && reminder "Failed to build/install Emacs NC" now >/dev/null || echo "Failed to build/install Emacs NC")

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

;; .bashrc code for:
;; # Emacs term.el directory tracking support.
;; : ${HOSTNAME=$(uname -n)}
;; USER=$(whoami)
;; case $TERM in
;;     eterm*)
;;         cd()    { command cd    "$@"; printf '\033AnSiTc %s\n' "$PWD"; }
;;         pushd() { command pushd "$@"; printf '\033AnSiTc %s\n' "$PWD"; }
;;         popd()  { command popd  "$@"; printf '\033AnSiTc %s\n' "$PWD"; }
;;         printf '\033AnSiTc %s\n' "$PWD"
;;         printf '\033AnSiTh %s\n' "$HOSTNAME"
;;         printf '\033AnSiTu %s\n' "$USER"
;; esac

;;;; * Processes, sentinels, and filters
;;
;; Refer to:
;;  - (info "(elisp) Processes")
;;  - (info "(elisp) Sentinels")
;;  - (info "(elisp) Filter Functions")
;;
;; `term' has sentinel `term-sentinel' and process filter
;; `term-emulate-terminal'.  Each process has only a single sentinel
;; and a single filter; so if you set a custom function, you may need
;; it to take care of calling the standard function.
;;
;; In the case of `shell', it only calls `shell-mode' when (and after)
;; starting the inferior process, so we can use `shell-mode-hook' to
;; add a sentinel.
;;
;; `set-process-sentinel' will clobber any existing sentinel for that
;; process.  shell will always have a sentinel (exactly what it is can
;; vary), and we can call the original sentinel function within our
;; replacement sentinel, in order to piggy-back our new behaviour on
;; top of that.  e.g.:
;;
;; (add-hook 'shell-mode-hook 'my-shell-mode-hook)
;;
;; (defun my-shell-mode-hook ()
;;   "Custom `shell-mode' behaviours."
;;   ;; Kill the buffer when the shell process exits.
;;   (let* ((proc (get-buffer-process (current-buffer)))
;;          (original-sentinel (process-sentinel proc))
;;          (new-sentinel (apply-partially
;;                         (lambda (original-sentinel process signal)
;;                           ;; Call the original process sentinel first.
;;                           (funcall original-sentinel process signal)
;;                           ;; Kill the buffer on an exit signal.
;;                           (and (memq (process-status process) '(exit signal))
;;                                (buffer-live-p (process-buffer process))
;;                                (kill-buffer (process-buffer process))))
;;                         original-sentinel))
;;          (sym (make-symbol "my-shell-mode-sentinel")))
;;     (defalias sym new-sentinel
;;       "Call the original shell sentinel, and kill the buffer upon exit.")
;;     (set-process-sentinel proc sym)))
;;
;; (defun my-shell-mode-sentinel ()
;;   "This exists only to say:  See `my-shell-mode-hook' for the real code.")

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
;;
;; Also (but for existing bindings only):
;; (substitute-key-definition OLDDEF NEWDEF KEYMAP &optional OLDMAP)
;;
;; Replace OLDDEF with NEWDEF for any keys in KEYMAP now defined as OLDDEF.
;; In other words, OLDDEF is replaced with NEWDEF wherever it appears.
;; Alternatively, if optional fourth argument OLDMAP is specified, we redefine
;; in KEYMAP as NEWDEF those keys which are defined as OLDDEF in OLDMAP.
;;
;; If you don't specify OLDMAP, you can usually get the same results
;; in a cleaner way with command remapping, like this:
;;   (define-key KEYMAP [remap OLDDEF] NEWDEF)
;;
;; See also: (info "(elisp) Changing Key Bindings")
;; > The function ‘substitute-key-definition’ scans a keymap for keys that
;; > have a certain binding and rebinds them with a different binding.
;; > Another feature which is cleaner and can often produce the same results
;; > is to remap one command into another (*note Remapping Commands::).

;; Conditional definition/over-ride with fall-back:
;; http://endlessparentheses.com/define-context-aware-keys-in-emacs.html
;; http://stackoverflow.com/questions/16090517/elisp-conditionally-change-keybinding
;; http://stackoverflow.com/questions/2494096/emacs-key-binding-fallback

;; Emacs does have a way of almost completely ignoring an event, via
;; the `special-event-map' keymap.
;; M-: (info "(elisp) Special Events") RET
;;
;; (define-key special-event-map (kbd "<f2>") 'ignore)
;;
;; This can potentially also be used for things like transparent key
;; translations (i.e. no "X (translated from Y)" processing); but
;; that's probably a bad idea.
;;
;; (define-key special-event-map (kbd "<return>") 'my-ret-event)
;; (defun my-ret-event ()
;;   "Push `RET' onto `unread-command-events'."
;;   (interactive)
;;   (push '(t . ?\C-m) unread-command-events))

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
;;   C-x r i a           Insert contents of register 'a'
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

;; Watching for variable changes (Emacs 25.2? 26.1?)
;; Function `add-variable-watcher' can be used to call a function when
;; a symbol's value is changed.  This is used to implement the new
;; debugger command `debug-on-variable-change'.

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

;; Core dumps and gdb / C debugging
;;
;; Documentation: C-h C-d runs the command (view-emacs-debugging)
;;
;; First configure your system to actually save core dumps.
;; /proc/sys/kernel/core_pattern needs to be set to something reasonable,
;; and you need to set the core size limit in your shell like with ulimit -c.
;; You can test that your system is actually generating core dumps by sending
;; a running process a SIGABRT signal and then finding the core file.
;;
;; For the core dumps to be at all useful, you need to modify the CFLAGS used
;; by Emacs when the C code is compiled.  You need to compile with -ggdb and
;; -0g.  This leaves in the symbols, and optimizes the code for a "debugging
;; experience", meaning that it disables optimizations that interfere with
;; debugging.  I think you can just set the CFLAGS explicitly when you run make,
;; but you may have to actually edit the Makefile?
;;
;; Load the core-dump-with-debug-symbols into gdb the debugger and type bt to
;; get the back trace of where it was in the code when it crashed.  This trace
;; output is what's going to be super useful for Emacs developers when you
;; submit the bug.
;;
;; If you know C, you can actually go up and down stack frames, look at
;; variables, and reason about what went wrong and maybe even fix the bug
;; yourself.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; * Elisp executable scripts

;; Don't ever do this without good reason. But if you *really* need to...

;; There is an excellent overview at:
;; https://lunaryorn.com/blog/emacs-script-pitfalls/

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
;; ;; (defun stdout (msg args) (princ (format msg args)))
;; ;; (defun stderr (msg args) (princ (format msg args)
;; ;;                                 #'external-debugging-output))
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

;;;; * Sessions / Desktop

;; ;; To prepare a static start-up desktop file:
;; ;; 1. Run a separate temporary instance of Emacs, and within that:
;; ;; 2. M-x make-directory RET ~/.emacs.d/start RET
;; ;; 3. M-x desktop-change-dir RET ~/.emacs.d/start RET
;; ;; 4. Visit files, etc -- create the configuration you wish to store
;; ;; 5. M-x desktop-save-in-desktop-dir
;; ;; 6. Quit the temporary instance of Emacs
;; ;; 7. Add the following to your regular init file
;; (let (desktop-dirname)
;;   (desktop-read "~/.emacs.d/start")
;;   (desktop-release-lock))

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
;;; Face remapping: C-h i g (elisp) Face Remapping RET
;;; e.g.: (face-remap-add-relative 'default :family "Monospace")
;;;
;;;
;;; Never forget that modifying a (quote)d argument == self-modifying code!
;;; http://stackoverflow.com/q/16670989/324105
;;;
;;; hideshow.el seems really useful!  I ought to know how to use it.
;;;
;;; Look into http://nullprogram.com/tags/elfeed/
;;; And Email solutions for Emacs. (mu4e? notmuch? wanderlust? gnus?? mew??)
;;;
;;; (set-)terminal-parameter is a thing.
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

;; Initialise third-party libraries and ELPA packages
(require 'my-externals)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Basic configuration
(require 'my-configuration)

;; Custom utilities
(require 'my-utilities)
(require 'my-rectangles)

;; White space
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

;; Email.
(require 'my-mail)

;; Configure visual theme
(require 'my-theme)

;; Session management
(require 'my-session)

;; Project support
(require 'my-projects)

;; Org-Mode
(require 'my-org)

;; Bug fix for SHR/EWW.
;; This is shr.el from Emacs 27.2 and byte-compiled in Emacs 28.2.
;; The shr.el in Emacs 28 is buggy wrt fragment links.  Fixed in 29.
(when (eql emacs-major-version 28)
  (load-library "shr-27.2"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Start server (but don't restart).
(require 'server)
(unless (server-running-p)
  (server-start)
  ;; Also start in this instance a server for the Edit With Emacs
  ;; browser extension.
  (when (require 'edit-server nil :noerror)
    (edit-server-start)))

;; Log start and uptime to `my-emacs-uptime-log'.
(my-log-emacs-start-time)
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
   (my-gc-cons-threshold-set-normal)))

;;; Local Variables:
;;; page-delimiter: ";;;; "
;;; outline-regexp: ";;;; "
;;; eval:(outline-minor-mode 1)
;;; eval:(while (re-search-forward "^;;;; \\* " nil t) (outline-toggle-children))
;;; End:
