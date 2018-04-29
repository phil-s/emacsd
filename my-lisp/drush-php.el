;; Comint-based integration for 'drush core-cli' (aka 'drush php').

;; 'tabCompletion' 	You can disable tab completion if you want to. Not sure why you’d want to.
;; Default: true
;; Is the TAB key binding an issue here?  We probably want that ^ ??
;; I expect I just inherited this from Mickey's article:
;; (define-key map "\t" 'completion-at-point)
;; And I should actually send a tab to the inferior process instead?


;; Comint code based upon:
;; https://www.masteringemacs.org/article/comint-writing-command-interpreter

;; To prevent PsySH from attempting to invoke a pager in the dumb terminal
;; we need to create a config file which sets the 'pager' option to 'cat',
;; and set the PSYSH_CONFIG environment variable to that file name.
;; See also https://github.com/bobthecow/psysh/issues/361

;; (setq drush-php-startfile "/ssh:USER@HOST:/home/USER/.config/psysh/comint.init.commands")
;;
;; ;; (with-parsed-tramp-file-name default-directory file
;; ;;   (tramp-make-tramp-file-name
;; ;;    file-method file-user file-host
;; ;;    "~/.config/psysh/comint.init.commands" file-hop))
;;
;; => "/ssh:USER@HOST:~/.config/psysh/comint.init.commands"
;; which is... not going to work?
;; ~ needs to be expanded to /home/USER (or as appropriate)
;; on the remote host?
;; Which is why I hard-coded it locally in the end.

;; Show drush status automatically on start-up:
;; printf %s\\n "status" >"~/.config/psysh/comint.init.commands"
;; (setq drush-php-startfile
;;       (expand-file-name "~/.config/psysh/comint.init.commands"))

;; Customize `ansi-color-names-vector' if you find any colours hard to
;; see.  Alternatively, call `ansi-color-for-comint-mode-filter' in
;; `drush-php-mode-hook' to filter the colour codes from the output;
;; or you may be able to prevent PsySH from generating the colour
;; codes at all by setting 'colorMode' in `drush-php-psysh-config'.

;; TODO:
;;
;; Turn the startfile into configurable text just like the psysh
;; config, so that you simply customize the *text* of that file,
;; rather than specifying a filename.  As per (1), use a hash table
;; for those contents to look up a temporary filename (noting that
;; this temporary file will always be local to Emacs).

(require 'comint)
(require 'subr-x)

(defgroup drush-php nil
  "Drush PHP shell integration."
  :tag "Drush PHP"
  :prefix "drush-php"
  :group 'drupal
  :group 'php)

(defcustom drush-php-command "drush php"
  "Command and arguments used by `run-drush-php'.

This string is processed by `split-string-and-unquote' to establish
the command and its arguments.  No shell quoting of special characters
is needed, but you may need to double-quote arguments which would
otherwise be split."
  :type 'string
  :group 'drush-php)

(defcustom drush-php-prompt-regexp (rx bol (or ">>>" "...") " ")
  "Regexp matching the REPL prompt.

Defaults to matching PsySH's main prompt '>>> ' as well as its
continuation prompt '... '"
  :type 'string
  :group 'drush-php)

;; TODO: Turn the startfile into configurable text just like the psysh
;; config, so that you simply customize the *text* of that file,
;; rather than specifying a filename.  As per (1), use a hash table
;; for those contents to look up a temporary filename (noting that
;; this temporary file will always be local to Emacs).
(defcustom drush-php-startfile nil
  "The name of a file, whose contents are sent to the process as initial input.

For example you could use a file containing the word 'status' to run the drush
status command automatically when invoking the REPL."
  :type `(choice (const :tag "No initial input to drush php" nil)
                 (file :tag "File"
                         :value ,(locate-user-emacs-file
                                  ".drush-php-initial-input")))
  :group 'drush-php)

(defcustom drush-php-history-file nil
  "If non-nil, name of the file to read/write input history.

`comint-input-ring-file-name' will be set to this value, and the file will
be read from and written to automatically."
  :type `(choice (const :tag "Do not save input history" nil)
                 (file :tag "File"
                         :value ,(locate-user-emacs-file
                                  ".drush-php-history")))
  :group 'drush-php)

(define-widget 'drush-php-text-widget 'text
  "Defined due to Emacs bug #31309."
  ;; We could use :type (widget-convert 'text :format "%{%t%}: %v") in
  ;; the `drush-php-psysh-config' definition without defining a named
  ;; widget -- but that necessitates the loading of wid-edit.el, which
  ;; is not reasonable when it might not be otherwise needed.
  :format "%{%t%}: %v")

(defcustom drush-php-psysh-config
  ;; `describe-variable' only displays this nicely since Emacs 26.1,
  ;; but `customize-option' will display it nicely in older versions.
  "<?php
return array(
    'pager' => 'cat', # comint provides a dumb terminal.
    'requireSemicolons' => true, # Reduce issues with multi-line input.
    'useReadline' => false, # No need for this in Emacs.
    'startupMessage' => '<fg=blue>Emacs:</> M-x customize-group RET drush-php RET\n',
    'errorLoggingLevel' => E_ALL,
    'warnOnMultipleConfigs' => true,
    // 'colorMode' => '\\Psy\\Configuration::COLOR_MODE_DISABLED',
);"
  "PHP code for the PsySH config file.

At minimum you must set the 'pager' value to 'cat', as the comint
buffer provides only a dumb terminal.

This config will be written to a temporary file, to which the
PSYSH_CONFIG environment variable will be pointed when invoking
drush php.

Refer to URL `http://github.com/bobthecow/psysh/wiki/Config-options'
for details of all the available config options."
  ;; See also https://github.com/bobthecow/psysh/issues/361
  :type 'drush-php-text-widget
  :group 'drush-php)

;; TODO: Turn the startfile into configurable text just like the psysh
;; config, so that you simply customize the *text* of that file,
;; rather than specifying a filename.  As for that, use a hash table
;; for those contents to look up a temporary filename (noting that
;; *this* temporary file will always be local to Emacs).
(defcustom drush-php-initial-input nil
  ;; `describe-variable' only displays this nicely since Emacs 26.1,
  ;; but `customize-option' will display it nicely in older versions.
  "Initial input to send to PsySH.

For example you could send 'status' to run the drush status command
automatically when invoking the REPL."
  :type '(choice (const :tag "No initial input" nil)
                 (drush-php-text-widget :tag "Commands"))
  :group 'drush-php)

(defvar drush-php-mode-map
  (let ((map (nconc (make-sparse-keymap) comint-mode-map)))
    (define-key map "\t" 'completion-at-point)
    (define-key map "\C-m" 'drush-php-comint-send-input-maybe)
    (define-key map [remap move-beginning-of-line]
      'drush-php-move-beginning-of-line)
    ;; When there is no running process, 'g' starts a new one.
    ;; So to restart drush-php, use 'C-d' (to exit), and then 'g'.
    (define-key map "g"
      `(menu-item "" run-drush-php
                  :filter ,(lambda (cmd)
                             (unless (get-buffer-process (current-buffer))
                               cmd))))
    map)
  "Basic mode map for `drush-php-mode'")

(defvar-local drush-php-duplicate-prompt-regexp nil
  "Used by `drush-php-comint-output-filter' to detect duplicate prompts.")

(defvar drush-php-psysh-config-hash-table
  (make-hash-table :test 'equal :size 16) ;; Not expecting many values.
  "Maps `drush-php-psysh-config' values to config files with that config.

Each alist maps a user/host pair to a temporary file path on that host
which contains the same configuration.")

;; Silence byte-compiler warnings.
(eval-when-compile
  (declare-function tramp-dissect-file-name "tramp")
  (declare-function tramp-file-name-hop "tramp")
  (declare-function tramp-file-name-host "tramp")
  (declare-function tramp-file-name-method "tramp")
  (declare-function tramp-file-name-user "tramp")
  (declare-function tramp-make-tramp-file-name "tramp")
  (declare-function tramp-make-tramp-temp-file "tramp")
  (declare-function tramp-tramp-file-p "tramp"))

(defun drush-php-psysh-config-file (&optional dir)
  "Return the PsySH config file path for this directory

This file will contain the current value of `drush-php-psysh-config'."
  (unless dir
    (setq dir default-directory))
  (let ((filemap (gethash drush-php-psysh-config
                          drush-php-psysh-config-hash-table))
        (isremote (tramp-tramp-file-p dir))
        user host temp vec method hop)
    ;; Determine the user and host for the given DIR.
    (if isremote
        (setq vec (tramp-dissect-file-name dir)
              method (tramp-file-name-method vec)
              user (tramp-file-name-user vec)
              host (tramp-file-name-host vec)
              hop (tramp-file-name-hop vec))
      (setq user (user-login-name)
            host "localhost"))
    ;; Check for an existing cached config filename.
    (let* ((key (cons user host))
           (temp (cdr (assoc key filemap)))
           (fulltemp (if (and temp isremote)
                         (tramp-make-tramp-file-name
                          method user host temp hop)
                       temp)))
      ;; Check that the cached temp file still exists.
      (unless (and fulltemp (file-exists-p fulltemp))
        (setq temp nil))
      ;; If there is no valid temp file, generate and cache a new one.
      (unless temp
        (setq temp (if isremote
                       (let ((tramp-temp-name-prefix "drush-php."))
                         ;; Is there a way to get the full VEC out of
                         ;; tramp when makeing a temp file?!
                         (tramp-make-tramp-temp-file vec))
                     (make-temp-file "drush-php.")))
        (push (cons key temp) filemap)
        (puthash drush-php-psysh-config filemap
                 drush-php-psysh-config-hash-table)
        ;; Write the PsySH config to the new file.
        (with-temp-file (if isremote
                            (tramp-make-tramp-file-name
                             method user host temp hop)
                          temp)
          (insert drush-php-psysh-config)))
      ;; Return the cached filename.
      temp)))

;;;###autoload
(defun run-drush-php ()
  "Run an inferior instance of `drush-php-command' inside Emacs."
  (interactive)
  ;; Create the comint process if there is no buffer.
  (let ((buffer (get-buffer "*Drush-PHP*")))
    (unless (and buffer (comint-check-proc buffer))
      (let* ((command (split-string-and-unquote drush-php-command)))
        (let ((inhibit-read-only t))
          (setq buffer (apply 'make-comint-in-buffer "Drush-PHP" nil
                              "env"
                              drush-php-startfile
                              (format "PSYSH_CONFIG=%s"
                                      (drush-php-psysh-config-file))
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
            (set-process-sentinel proc 'drush-php-sentinel)))))
    ;; Check that buffer is in `drush-php-mode'.
    (with-current-buffer buffer
      (unless (derived-mode-p 'drush-php-mode)
        (drush-php-mode)))
    ;; Pop to the drush-php buffer.
    (pop-to-buffer-same-window buffer)))

(define-derived-mode drush-php-mode comint-mode "Drush-PHP"
  "Major mode for `run-drush-php'.

\\<drush-php-mode-map>"
  nil "Drush-PHP"
  ;; This sets up the prompt so it matches >>> and ...
  (setq-local comint-use-prompt-regexp t)
  (setq-local comint-prompt-regexp drush-php-prompt-regexp)

  ;; `drush-php-comint-output-filter' needs a version of the prompt
  ;; which is not anchored to the start of the line, in order to
  ;; remove any additional prompts following the initial one.
  (setq-local drush-php-duplicate-prompt-regexp
              (string-remove-prefix "^" drush-php-prompt-regexp))

  ;; Make the prompt read only.
  (setq-local comint-prompt-read-only t)

  ;; Assume that the subprocess echoes input appropriately.
  (setq-local comint-process-echoes t)

  ;; Filter process output before insertion into buffer.
  (add-hook 'comint-preoutput-filter-functions
            'drush-php-comint-preoutput-filter nil :local)

  ;; Filter process output after insertion into buffer.
  (add-hook 'comint-output-filter-functions
            'drush-php-comint-output-filter nil :local)

  ;; Enable ANSI colour.
  (ansi-color-for-comint-mode-on)
  ;; ;; In fact, until I figure out how to map colours for this, it's
  ;; ;; better to filter the colours out.
  ;; (ansi-color-for-comint-mode-filter)
  ;;
  ;; Note that these are also commands:
  ;; M-x ansi-color-for-comint-mode-on
  ;; M-x ansi-color-for-comint-mode-off
  ;; M-x ansi-color-for-comint-mode-filter
  ;;
  ;; ANSI colour is all we need, I think?
  ;; In any case, drush-php-font-lock-keywords has not been configured.
  ;; (setq-local font-lock-defaults '(drush-php-font-lock-keywords t))

  ;; Don't highlight whitespace.
  (setq show-trailing-whitespace nil)

  ;; Restore the input history.
  (setq-local comint-input-ring-file-name drush-php-history-file)
  (comint-read-input-ring :silent)

  ;; Use custom input sender function.
  (setq-local comint-input-sender 'drush-php-comint-input-sender)

  ;; ;; Don't try to use a PAGER in our (dumb) terminal.
  ;; (make-local-variable 'process-environment)
  ;; (setenv "PAGER" "cat")
  ;; That didn't work, because the PHP shell (PsySH) uses its own
  ;; 'pager' setting (which can be set in ~/.config/psysh/config.php).
  ;; Setting PHP's cli.pager ini setting at run-time doesn't help.

  ;; Paragraph delimiters??
  ;; I don't know what these should be for PHP...
  ;; This makes it so commands like M-{ and M-} work.
  ;; (setq-local paragraph-separate "\\'")
  ;; (setq-local paragraph-start drush-php-prompt-regexp)

  ;; end of `drush-php-mode' body
  )


;; "This has to be done in a hook. grumble grumble."
;; (I'm not convinced that's actually true, but TEST the theory --
;; apparently comint is really tricky to get 100% right, and maybe
;; this is one of the pitfalls?)
;;
;; For now I've moved these into the mode body, as they seem to work.
;;
;; (add-hook 'drush-php-mode-hook 'drush-php--initialize)
;;
;; (defun drush-php--initialize ()
;;   "Helper function to initialize Drush-PHP"
;;   ;; (setq-local comint-process-echoes t)
;;   ;; (setq-local comint-use-prompt-regexp t)
;;   )


;;; Font lock:
;;
;; (setq-local font-lock-defaults '(drush-php-font-lock-keywords t))
;;
;; (defconst drush-php-keywords '(...))
;;
;; (defvar drush-php-font-lock-keywords
;;   (list
;;    ;; highlight all the reserved commands.
;;    `(,(concat "\\_<" (regexp-opt drush-php-keywords) "\\_>") . font-lock-keyword-face))
;;   "Additional expressions to highlight in `drush-php-mode'.")


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

(defun drush-php-comint-send-input-maybe ()
  "This is a hack, due to https://github.com/bobthecow/psysh/issues/490

We bind RET to this command in our keymap so that it only sends the
input following a semicolon, and otherwise simply inserts a newline."
  (interactive)
  ;; FIXME: This needs to be more adaptable.
  ;; If the input begins with a single un-quoted word, assume it's
  ;; a psysh command?? No... that's no good. e.g. Any control word
  ;; such as "foreach".  Um... if the input is *only* a single
  ;; un-quoted word (or "?"... any other non-word chars?) then
  ;; send input.  Otherwise is it ok to require semicolons with
  ;; psysh commands???  Looks like we may need to turn ";" into
  ;; "; " before sending!
  (if (looking-back (rx-to-string
                     `(or (regexp ,drush-php-duplicate-prompt-regexp)
                          (seq ";" (zero-or-more " "))
                          "\n\n"))
                    (or (save-excursion
                          (search-backward ";" nil t)
                          (point))
                        (line-beginning-position 0)))
      (comint-send-input)
    (insert "\n")))

(defun drush-php-comint-input-sender (proc string)
  "This is a hack, due to https://github.com/bobthecow/psysh/issues/490

It replaces all newlines with spaces.

I would prefix a semicolon as well, but that breaks for continuation lines."
  (comint-simple-send
   proc (replace-regexp-in-string "\n+" " " string)))

(defun drush-php-comint-preoutput-filter (output)
  "Strip trailing whitespace from comint process output lines.

Called via `comint-preoutput-filter-functions'."
  (replace-regexp-in-string "  +$" "" output t t))

(defun drush-php-comint-output-filter (output)
  "Delete any duplicate prompts.

Called via `comint-output-filter-functions'."
  (save-excursion
    (goto-char (point-max))
    (beginning-of-line)
    (when (looking-at comint-prompt-regexp)
      (comint-skip-prompt)
      (let ((pos (point))
            (comint-prompt-regexp drush-php-duplicate-prompt-regexp))
        (while (comint-skip-prompt)
          (delete-region pos (point)))))))

(defun drush-php-sentinel (process signal)
  "Process signals from the drush process."
  (when (memq (process-status process) '(exit signal))
    (comint-write-input-ring)))

(defun drush-php-move-beginning-of-line ()
  "Move to the beginning of the line, respecting the prompt."
  ;; Derived from `comint-line-beginning-position'.
  (interactive)
  (beginning-of-line)
  (comint-skip-prompt))

(defun drush-php-beginning-of-line-or-indentation ()
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

(provide 'drush-php)
