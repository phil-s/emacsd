;;; psysh.el --- Comint-based integration for the "PsySH" REPL for PHP.
;;
;; Author: Phil Sainty
;; Created: April 2018
;; Version: 0.3

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; To start the repl:  M-x run-psysh
;;
;; To configure:  M-x customize-group RET psysh
;;
;; "C-d" exits the psysh process, as usual.
;; "g" will restart the process when it is not running.
;;
;; Customize `ansi-color-names-vector' if you find any colours hard
;; to see.  Alternatively, call `ansi-color-for-comint-mode-filter'
;; in `psysh-mode-hook' to filter the colour codes from the output;
;; or you can prevent PsySH from generating colour codes at all by
;; setting 'colorMode' in `psysh-config'.

;; 'tabCompletion' 	You can disable tab completion if you want to. Not sure why you’d want to.
;; Default: true
;; Is the TAB key binding an issue here?  We probably want that ^ ??
;; I expect I just inherited this from Mickey's article:
;; (define-key map "\t" 'completion-at-point)
;; And I should actually send a tab to the inferior process instead?

;; TODO:
;; Use `make-nearby-temp-file' if it is fboundp (available in 26.1).
;; Or was there a `temporary-directory' var/func that I can use?


;; Comint code based upon:
;; https://www.masteringemacs.org/article/comint-writing-command-interpreter

(require 'comint)
(require 'subr-x)
(require 'tramp)
(require 'cc-mode) ;; `c-mode-syntax-table' is guaranteed to be available.
(require 'php-mode nil :noerror) ;; Derives from c-mode; mightn't be installed.

(defvar psysh-process-name "psysh"
  "Name for the comint process.")

(defvar psysh-buffer-name "*PsySH*"
  "Name for the comint buffer, or derive from `psysh-process-name'.")

(defvar psysh-run-psysh-function 'psysh-run-psysh
  "This affects the `run-psysh' command, including when restarting.

Setting this value buffer-locally is an easy way for wrapper
libraries to ensure that the correct function will be called when
interactively restarting the process.")

(defgroup psysh nil
  "PsySH REPL for PHP"
  :tag "PsySH"
  :prefix "psysh"
  :group 'php)

(defcustom psysh-command "psysh"
  "Command and arguments used by `run-psysh'.

This string is processed by `split-string-and-unquote' to establish
the command and its arguments.  No shell quoting of special characters
is needed, but you may need to double-quote arguments which would
otherwise be split."
  :type 'string
  :group 'psysh)

(defcustom psysh-prompt-main ">>> "
  "The REPL's main input prompt."
  :type 'string
  :group 'psysh)

(defcustom psysh-prompt-continuation "... "
  "The REPL's input continuation prompt."
  :type 'string
  :group 'psysh)

(defcustom psysh-prompt-regexp (rx-to-string
                                `(seq bol (or ,psysh-prompt-main
                                              ,psysh-prompt-continuation))
                                :nogroup)
  "Regexp matching any REPL prompt.

Defaults to matching either of `psysh-prompt-main' or
`psysh-prompt-continuation'."
  :type 'string
  :group 'psysh)

(defvar psysh-remap-php-send-region)
(defvar php-mode-map)

(defun psysh-remap-php-send-region-setter (&optional option value)
  "Adds or removes remapping for `php-send-region' in `php-mode-map'."
  (when option
    (set option value))
  (with-eval-after-load "php-mode"
    (define-key php-mode-map [remap php-send-region]
      (if psysh-remap-php-send-region
          'psysh-send-region
        nil))))

(defcustom psysh-remap-php-send-region t
  "Whether to remap bindings for `php-send-region' to `psysh-send-region'."
  :type '(choice (const :tag "Remap to psysh-send-region" t)
                 (const :tag "Do not remap" nil))
  :set #'psysh-remap-php-send-region-setter
  :group 'psysh)

(defcustom psysh-history-file nil
  "If non-nil, name of the file to read/write input history.

`comint-input-ring-file-name' will be set to this value, and the file will
be read from and written to automatically."
  :type `(choice (const :tag "Do not save input history" nil)
                 (file :tag "File"
                       :value ,(locate-user-emacs-file
                                ".psysh-history")))
  :group 'psysh)

(define-widget 'psysh-text-widget 'text
  "Defined due to Emacs bug #31309."
  ;; We could use :type (widget-convert 'text :format "%{%t%}: %v") in
  ;; the `psysh-config' definition without defining a named
  ;; widget -- but that necessitates the loading of wid-edit.el, which
  ;; is not reasonable when it might not be otherwise needed.
  :format "%{%t%}: %v")

(defcustom psysh-config
  ;; `describe-variable' only displays this nicely since Emacs 26.1,
  ;; but `customize-option' will display it nicely in older versions.
  ;; Using a 2-space indent to minimise the chances of `indent-tabs-mode'
  ;; creating inconsistent indentation, as a 4-space `tab-width' is
  ;; quite common.
  ;;
  ;; TODO: There is some kind of bug with the text widget which causes
  ;; the *first* (only?) use of RET to go awry.  That is very annoying.
  ;; Investigate...
  "<?php
return array(
  'pager' => 'cat', # Comint provides a dumb terminal.
  'useReadline' => false, # No need for this in Emacs.
  'requireSemicolons' => false, # More convenient, but may cause issues.
  'startupMessage' => '<fg=blue>Emacs:</> M-x customize-group RET psysh RET',
  'errorLoggingLevel' => E_ALL,
  'warnOnMultipleConfigs' => true,
  // 'colorMode' => \\Psy\\Configuration::COLOR_MODE_DISABLED,
);"
  "PHP code for the PsySH config file.

The PSYSH_CONFIG environment variable will point to a temporary
file containing this configuration, when psysh is invoked.

Refer to URL `http://github.com/bobthecow/psysh/wiki/Config-options'
for details of all the available config options.

At minimum the 'pager' value should be set to 'cat', as the comint
buffer provides only a dumb terminal.

If you set `psysh-comint-input-sender' to use the default comint
sender then you may wish to set 'requireSemicolons' => true, as
otherwise PsySH can send the input to PHP earlier than you had
intended.  For example, the following code would be submitted
immediately following the first method call, meaning that the
attempted second method call is treated as an entirely new PHP
statement, resulting in a parse error.

$object->method1()
       ->method2();

With 'requireSemicolons' enabled, the behaviour will be correct.
That setting does make it more awkward to use `psysh-send-region'
on arbitrary fragments of code, however.

If `psysh-comint-input-sender' is configured to use the custom
sender, then all input is manipulated into a single line, and
consequently 'requireSemicolons' is not necessary."
  ;; See also https://github.com/bobthecow/psysh/issues/361
  :type 'psysh-text-widget
  :group 'psysh)

(defcustom psysh-initial-input nil
  ;; `describe-variable' only displays this nicely since Emacs 26.1,
  ;; but `customize-option' will display it nicely in older versions.
  "Initial input to send to PsySH.

For example you could send 'help' to display the help text automatically
when invoking the REPL.

You may enter multiple lines.  Enter one command per line."
  :type '(choice (const :tag "No initial input" nil)
                 (psysh-text-widget :tag "Commands"))
  :group 'psysh)

(defcustom psysh-comint-input-sender t
  "How to send input to PsySH.

nil means use the default comint sender.
A function symbol means use that function as the sender.
Any other non-nil value means use the custom PsySH sender.

The custom PsySH sender manipulates all the input into a single
line of PHP, which circumvents some PsySH bugs, but unfortunately
also makes it more likely that you will trigger others.  In
particular, PHP input exceeding 1024 characters may (or may not)
produce bugs/errors.

Refer to URL `https://github.com/bobthecow/psysh/issues/496'

If you use the default comint sender then you may also wish to
set 'requireSemicolons' => true, in `psysh-config'."
  :type '(choice (const :tag "Standard comint sender" nil)
                 (const :tag "PsySH sender" t)
                 (function :tag "Custom function"
                           :value comint-simple-send))
  :group 'psysh)

(defvar psysh-mode-map
  (let ((map (nconc (make-sparse-keymap) comint-mode-map)))
    (define-key map "\t" 'completion-at-point)
    (define-key map "\C-m" 'psysh-comint-send-input-maybe)
    (define-key map [remap move-beginning-of-line]
      'psysh-move-beginning-of-line)
    ;; When there is no running process, 'g' starts a new one.
    ;; So to restart psysh, use 'C-d' (to exit), and then 'g'.
    (define-key map "g"
      `(menu-item "" run-psysh
                  :filter ,(lambda (cmd)
                             (unless (get-buffer-process (current-buffer))
                               cmd))))
    map)
  "Keymap for `psysh-mode'.")

(defvar psysh-syntax-table
  ;; Particularly needed to recognise comments in `psysh-comint-input-sender'.
  (let ((syntab (make-syntax-table)))
    (set-char-table-parent syntab c-mode-syntax-table)
    (modify-syntax-entry ?_  "_" syntab)
    (modify-syntax-entry ?`  "\"" syntab)
    (modify-syntax-entry ?\" "\"" syntab)
    (modify-syntax-entry ?#  "< b" syntab)
    (modify-syntax-entry ?\n "> b" syntab)
    (modify-syntax-entry ?$  "'" syntab)
    syntab)
  "Syntax table for PsySH.")

(defvar-local psysh-duplicate-prompt-regexp nil
  "Used by `psysh-comint-output-filter' to detect duplicate prompts.")

(defvar psysh-temp-file-hash-table
  (make-hash-table :test 'equal :size 16) ;; Not expecting many values.
  "Maps `psysh-config' values to config files with that config.

Each alist maps a user/host pair to a temporary file path on that host
which contains the same configuration.")

(defun psysh-temp-file (contents &optional prefix dir)
  "Returns the path of a temporary file containing CONTENTS.

PREFIX is the temp file name prefix.

If directory DIR (or `default-directory', if unspecified) is a
tramp path for a remote host, the temporary file will be created
on that host; otherwise the file will be created locally using
`make-temp-file'.  Any DIR value which is not `tramp-tramp-file-p'
can be used to enforce a local file."
  (unless prefix
    (setq prefix "psysh."))
  (unless dir
    (setq dir default-directory))
  (let ((filemap (gethash contents psysh-temp-file-hash-table))
        (isremote (tramp-tramp-file-p dir))
        vec method user domain host port temp hop)
    ;; Determine the user and host for the given DIR.
    (if isremote
        (setq vec (tramp-dissect-file-name dir)
              method (tramp-file-name-method vec)
              user (tramp-file-name-user vec)
              domain (unless (version< tramp-version "2.3")
                       (tramp-file-name-domain vec))
              host (tramp-file-name-host vec)
              port (unless (version< tramp-version "2.3")
                     (tramp-file-name-port vec))
              hop (tramp-file-name-hop vec))
      (setq user (user-login-name)
            host "localhost"))
    ;; Check for an existing cached config filename.
    (let* ((key (cons user host))
           (temp (cdr (assoc key filemap)))
           (fulltemp (if (and temp isremote)
                         (apply
                          #'tramp-make-tramp-file-name
                          (if (version< tramp-version "2.3")
                              (list method user host temp hop)
                            (list method user domain host port temp hop)))
                       temp)))
      ;; Check that the cached temp file still exists.
      (unless (and fulltemp (file-exists-p fulltemp))
        (setq temp nil))
      ;; If there is no valid temp file, generate and cache a new one.
      (unless temp
        (setq temp (if isremote
                       (let ((tramp-temp-name-prefix prefix))
                         ;; Is there a way to get the full VEC out of
                         ;; tramp when makeing a temp file?!
                         (tramp-make-tramp-temp-file vec))
                     (make-temp-file prefix)))
        (push (cons key temp) filemap)
        (puthash contents filemap psysh-temp-file-hash-table)
        ;; Write the PsySH config to the new file.
        (with-temp-file (if isremote
                            (apply
                             #'tramp-make-tramp-file-name
                             (if (version< tramp-version "2.3")
                                 (list method user host temp hop)
                               (list method user domain host port temp hop)))
                          temp)
          (insert (concat contents "\n"))))
      ;; Return the cached filename.
      temp)))

;;;###autoload
(defun run-psysh ()
  "Run an inferior instance of psysh inside Emacs."
  (interactive)
  (funcall psysh-run-psysh-function))

(defun psysh-run-psysh ()
  "Run an inferior instance of psysh inside Emacs."
  ;; Create the comint process if there is no buffer.
  (let ((buffer (get-buffer psysh-buffer-name)))
    (unless (and buffer (comint-check-proc buffer))
      (let* ((command (split-string-and-unquote psysh-command)))
        (let ((inhibit-read-only t))
          (setq buffer (apply 'make-comint-in-buffer
                              psysh-process-name psysh-buffer-name
                              "env"
                              (and psysh-initial-input
                                   (psysh-temp-file psysh-initial-input
                                                    "psysh-startfile." t))
                              (format "PSYSH_CONFIG=%s"
                                      (psysh-temp-file
                                       psysh-config "psysh-config."))
                              command)))
        ;; The default `internal-default-process-sentinel' sentinel
        ;; used by comint conflicts with `comint-prompt-read-only',
        ;; generating errors like the following:
        ;; * comint-exec: Text is read-only
        ;; * error in process sentinel: Text is read-only
        ;; In lieu of any custom sentinel requirements, set the
        ;; sentinel to 'ignore in otder to avoid these errors.
        (let ((proc (get-buffer-process buffer)))
          (when (processp proc)
            (set-process-sentinel proc 'psysh-sentinel)))))
    ;; Check that buffer is in `psysh-mode'.
    (with-current-buffer buffer
      (unless (derived-mode-p 'psysh-mode)
        (psysh-mode)))
    ;; Pop to the psysh buffer.
    (pop-to-buffer-same-window buffer)))

(define-derived-mode psysh-mode comint-mode "PsySH"
  "Major mode for `run-psysh'.

\\<psysh-mode-map>"
  nil "Psysh"
  ;; This sets up the prompt so it matches >>> and ...
  (setq-local comint-use-prompt-regexp t)
  (setq-local comint-prompt-regexp psysh-prompt-regexp)

  ;; `psysh-comint-output-filter' needs a version of the prompt
  ;; which is not anchored to the start of the line, in order to
  ;; remove any additional prompts following the initial one.
  (setq-local psysh-duplicate-prompt-regexp
              (string-remove-prefix "^" psysh-prompt-regexp))

  ;; Make the prompt read only.
  (setq-local comint-prompt-read-only t)

  ;; Assume that the subprocess echoes input appropriately.
  (setq-local comint-process-echoes t)

  ;; Filter process output before insertion into buffer.
  (add-hook 'comint-preoutput-filter-functions
            'psysh-comint-preoutput-filter nil :local)

  ;; Filter process output after insertion into buffer.
  (add-hook 'comint-output-filter-functions
            'psysh-comint-output-filter nil :local)

  ;; Enable ANSI colour.
  (ansi-color-for-comint-mode-on)
  ;; (ansi-color-for-comint-mode-filter)
  ;;
  ;; Note that these are also commands:
  ;; M-x ansi-color-for-comint-mode-on
  ;; M-x ansi-color-for-comint-mode-off
  ;; M-x ansi-color-for-comint-mode-filter

  ;; Don't highlight whitespace.
  (setq show-trailing-whitespace nil)

  ;; Restore the input history.
  (setq-local comint-input-ring-file-name psysh-history-file)
  (comint-read-input-ring :silent)

  ;; Use custom input sender function.
  (setq-local comint-input-sender 'psysh-comint-input-sender)

  ;; Paragraph delimiters??
  ;; I don't know what these should be for PHP...
  ;; Maybe the main prompt, for skipping back over previous output?
  ;; This makes it so commands like M-{ and M-} work.
  ;; (setq-local paragraph-separate "\\'")
  ;; (setq-local paragraph-start psysh-prompt-regexp)

  ;; Certain `php-mode'-alike settings.
  (setq-local comment-start "//")
  (setq-local comment-end "")
  (set-syntax-table psysh-syntax-table)
  (comment-normalize-vars)
  ;; end of `psysh-mode' body
  )


;; "This has to be done in a hook. grumble grumble."
;; (I'm not convinced that's actually true, but TEST the theory --
;; apparently comint is really tricky to get 100% right, and maybe
;; this is one of the pitfalls?)
;;
;; For now I've moved these into the mode body, as they seem to work.
;;
;; (add-hook 'psysh-mode-hook 'psysh--initialize)
;;
;; (defun psysh--initialize ()
;;   "Helper function to initialize Psysh"
;;   ;; (setq-local comint-process-echoes t)
;;   ;; (setq-local comint-use-prompt-regexp t)
;;   )


;;; Font lock:
;;
;; (setq-local font-lock-defaults '(psysh-font-lock-keywords t))
;;
;; (defconst psysh-keywords '(...))
;;
;; (defvar psysh-font-lock-keywords
;;   (list
;;    ;; highlight all the reserved commands.
;;    `(,(concat "\\_<" (regexp-opt psysh-keywords) "\\_>") . font-lock-keyword-face))
;;   "Additional expressions to highlight in `psysh-mode'.")


;;; Filter functions:
;;
;; `comint-dynamic-complete-functions'
;; List of functions called to perform completion.
;;
;; `comint-input-filter-functions'
;; Abnormal hook run before input is sent to the process.
;;
;; `comint-output-filter-functions'
;; Functions to call after output is inserted into the buffer.
;;
;; `comint-preoutput-filter-functions'
;; List of functions to call before inserting Comint output into the buffer.
;;
;; `comint-redirect-filter-functions'
;; List of functions to call before inserting redirected process output.
;;
;; `comint-redirect-original-filter-function'
;; The process filter that was in place when redirection is started
;;
;; Another useful variable is `comint-input-sender', which lets you
;; alter the input string mid-stream. Annoyingly its name is
;; inconsistent with the filter functions above.

(defvar psysh-process-mark-position nil
  "Remembers the process mark before `comint-send-input' is called.")

(defun psysh-comint-send-input-maybe ()
  "This is a hack, due to https://github.com/bobthecow/psysh/issues/490

We bind RET to this command in our keymap so a newline following a '}'
does not send the input, but instead just inserts a literal newline."
  (interactive)
  ;; Require a double-newline after a "}" to send the input, otherwise
  ;; we can very easily lose the 'else' clause from an if-then-else
  ;; statement.  (We can still lose it this way, but it's much less
  ;; likely to happen.)
  (if (looking-back "}" (line-beginning-position 0))
      ;; Just insert a newline, faking a continuation prompt.
      (insert (propertize "\n" 'display
                          (propertize (concat "\n" psysh-prompt-continuation)
                                      'face 'comint-highlight-prompt)))
    ;; If another newline is entered at the fake continuation prompt,
    ;; remove that display property before sending the input.
    (let* ((prevchar (1- (point)))
           (tidyup (looking-back "\n" prevchar)))
      (when tidyup
        (let ((display (plist-get (text-properties-at prevchar) 'display)))
          (and display
               (equal display (concat "\n" psysh-prompt-continuation))
               (remove-text-properties prevchar (point) '(display nil))))))
    ;; Remember the process mark position for `psysh-comint-input-sender'.
    (setq psysh-process-mark-position (marker-position
                                       (process-mark (get-buffer-process
                                                      (current-buffer)))))
    ;; Send the input.
    (comint-send-input)
    ;; FIXME: A fake continuation on the previous line now gets
    ;; highlighted with the `comint-highlight-input' face. It would be
    ;; nice to detect that and either undo or override it.
    ))

(defun psysh-comint-input-sender (proc string)
  "This is a hack, due to https://github.com/bobthecow/psysh/issues/490

It replaces all newlines in the input, so that no PsySH command
can ever be executed unless it appears at the very start of the
input.

Newlines in strings are replaced with the \n escape sequence.

Comments are deleted entirely, so newlines at the end of line
comments (i.e. //... and #...) will not cause the subsequent
lines to be commented out as well.

Note that this also prevents the use of certain PsySH commands
which are intended to be usable in positions other than the start
of the input.  If you wish to disable this functionality, you can
evaluate (setq-local comint-input-sender 'comint-simple-send) in
`psysh-mode-hook'."
  (cond
   ;; user-defined
   ((functionp psysh-comint-input-sender)
    (funcall psysh-comint-input-sender proc string))
   ;; default comint
   ((or (not psysh-comint-input-sender)
        ;; We also use this at a continuation prompt, because we are
        ;; only seeing a part of the input, and therefore we cannot do
        ;; any syntax parsing.
        (and psysh-process-mark-position
             (save-excursion
               (goto-char psysh-process-mark-position)
               (looking-back (concat "^" (regexp-quote
                                          psysh-prompt-continuation))
                             (line-beginning-position)))))
    (comint-simple-send proc string))
   ;; psysh
   (t
    (comint-simple-send
     proc (with-temp-buffer
            ;; (display-buffer (current-buffer)) ;; debug
            (set-syntax-table (or (bound-and-true-p php-mode-syntax-table)
                                  psysh-syntax-table))
            (setq-local comment-start "//")
            (setq-local comment-end "")
            (comment-normalize-vars)
            (insert string)
            (let ((pos (point-min)))
              (goto-char pos)
              (when (looking-at "<\\?php")
                (replace-match ""))
              (save-match-data
                (while (re-search-forward "\\(;[[:blank:]]*\\)?\\(\n+\\)" nil :noerror)
                  (save-excursion
                    (goto-char (match-beginning 0))
                    (let ((ppss (syntax-ppss)))
                      (cond ((nth 3 ppss) ;; string
                             (replace-match
                              ;; n.b. This isn't actually correct, as
                              ;; the newline escape sequence is for
                              ;; double-quoted strings only!
                              (mapconcat 'identity (make-list
                                                    (length (match-string 2)) "\\n")
                                         "")
                              t t nil 2))
                            ((nth 4 ppss) ;; comment
                             (let* ((start (comment-search-backward pos :noerror))
                                    (end (and start
                                              (progn (goto-char start)
                                                     (while (forward-comment 1))
                                                     (point)))))
                               (when (and start end)
                                 (delete-region start end)
                                 (goto-char start)
                                 (unless (or (bobp) (eobp))
                                   (insert " ")))))
                            ((eq (char-after) ?\;)
                             (replace-match "\n;"))
                            (t
                             (replace-match " ")))))
                  (setq pos (point)))))
            ;; Delete leading whitespace, which can cause errors.
            (goto-char (point-min))
            (while (forward-comment 1))
            (delete-region (point-min) (point))
            ;; (message "%s" (buffer-string))
            (buffer-string))))))

(defun psysh-comint-preoutput-filter (output)
  "Strip trailing whitespace from comint process output lines.

Called via `comint-preoutput-filter-functions'."
  (replace-regexp-in-string "  +$" "" output t t))

(defun psysh-comint-output-filter (output)
  "Delete any duplicate prompts.

Called via `comint-output-filter-functions'."
  (save-excursion
    (goto-char (point-max))
    (beginning-of-line)
    (when (looking-at comint-prompt-regexp)
      (comint-skip-prompt)
      (let ((pos (point))
            (comint-prompt-regexp psysh-duplicate-prompt-regexp))
        (while (comint-skip-prompt)
          (delete-region pos (point)))))))

(defun psysh-sentinel (process signal)
  "Process signals from the psysh process."
  (when (memq (process-status process) '(exit signal))
    (comint-write-input-ring)))

(defun psysh-move-beginning-of-line ()
  "Move to the beginning of the line, respecting the prompt."
  ;; Derived from `comint-line-beginning-position'.
  (interactive)
  (beginning-of-line)
  (comint-skip-prompt))

(defun psysh-beginning-of-line-or-indentation ()
  "Move to beginning of line, or indentation, respecting the prompt."
  (interactive)
  (if (not (bolp))
      ;; Find the end of the prompt (if any) on this line.
      (let ((eop (save-excursion
                   (beginning-of-line)
                   (comint-skip-prompt)
                   (point))))
        (if (<= (point) eop) ;; At (or within) the prompt, so go to bol.
            (beginning-of-line)
          (goto-char eop))) ;; Else beyond the prompt, so return to it.
    ;; Otherwise we were initially at bol, and may want to move forwards.
    (comint-skip-prompt) ;; If there is a prompt, move to that.
    (when (bolp) ;; There was no prompt to skip.  Skip indentation instead.
      (back-to-indentation))))

(defun psysh-send-region ()
  "Send the current line or active region to PsySH.

If no PsySH buffer is found, fall back to calling `php-send-region'.

If 'requireSemicolons' is set to true in `psysh-config', then you
will not be able to directly execute regions which are not
terminated with a semicolon -- you would need to switch to the
REPL and enter the semicolon manually."
  (interactive)
  (let* ((buf (get-buffer psysh-buffer-name))
         (proc (get-buffer-process buf))
         (bounds (if (use-region-p)
                     (list (region-beginning) (region-end))
                   (list (line-beginning-position)
                         (line-end-position)))))
    (if proc
        (progn (psysh-comint-input-sender
                proc (apply #'buffer-substring-no-properties bounds))
               (display-buffer buf))
      (if (fboundp 'php-send-region)
          (progn (apply #'php-send-region bounds)
                 (display-buffer "*PHP*"))
        (error "No %s buffer or process was found" psysh-buffer-name)))))

(psysh-remap-php-send-region-setter) ;; Arrange the initial remapping.

(provide 'psysh)
;;; psysh.el ends here
