;; Comint-based integration for 'drush core-cli' (aka 'drush php').

;; Comint code based upon:
;; https://www.masteringemacs.org/article/comint-writing-command-interpreter

;; To prevent PsySH from attempting to invoke a pager in the dumb terminal you
;; will need to create a config file which sets the 'pager' option to 'cat'.
;; Read the config.php documentation to review all available options.
;; The default config filename is "~/.config/psysh/config.php", but we can set
;; a custom config file with the PSYSH_CONFIG environment variable (see below).
;; e.g.:
;; <?php
;; return array(
;;     'pager' => 'cat', // Assume I'm running this inside Emacs.
;;     // Some other settings which may be useful are:
;;     // 'requireSemicolons' => true, // Helps with multi-line statements.
;;     // 'errorLoggingLevel' => E_ALL,
;; );
;; See also https://github.com/bobthecow/psysh/issues/361

;; Set a custom config file:
;; The only way we have of doing this is by making psysh use a different
;; config file, with a 'pager' => 'cat' entry. The \Psy\Configuration
;; object used by drush_cli_core_cli() has a setPager() method, but we
;; have no access to it from the drush command. We cannot pass arguments
;; through to the psysh command, so using an environment variable is
;; the best option available to us.  Here we use a config file named
;; "~/.config/psysh/comint.config.php".
;;
;; ;; Note the double-quoting around all of \"PSYSH_CONFIG=%s\" so that
;; ;; `split-string-and-unquote' sees it as a single argument.
;; (let ((psysh-config "~/.config/psysh/comint.config.php")
;;       (drush-args "-u 1 -r /PATH/TO/SITE/ROOT -l http://SITE.DOMAIN/"))
;;   (setq drush-php-command
;;         (format "env \"PSYSH_CONFIG=%s\" drush %s php"
;;                 (expand-file-name psysh-config)
;;                 drush-args)))

;; Show drush status automatically on start-up:
;; printf %s\\n "status" >"~/.config/psysh/comint.init.commands"
;; (setq drush-php-startfile
;;       (expand-file-name "~/.config/psysh/comint.init.commands"))

(require 'comint)
(require 'subr-x)

(defvar drush-php-command "drush php"
  "Command and arguments used by `run-drush-php'.

This string is processed by `split-string-and-unquote' to establish
the command and its arguments.  No shell quoting of special characters
is needed, but you may need to double-quote arguments which would
otherwise be split.")

(defvar drush-php-startfile nil
  "The name of a file, whose contents are sent to the process as initial input.

For example you could use a file containing the word 'status' to run the drush
status command automatically when invoking the REPL.")

(defvar drush-php-mode-map
  (let ((map (nconc (make-sparse-keymap) comint-mode-map)))
    ;; Example definition
    (define-key map "\t" 'completion-at-point)
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

(defvar drush-php-prompt-regexp "^\\(?:>>>\\|\\.\\.\\.\\) "
  "Prompt for `drush-php-command'.

Defaults to matching PsySH's main prompt '>>> ' as well as its
continuation prompt '... '")

(defvar-local drush-php-duplicate-prompt-regexp nil
  "Used by `drush-php-comint-output-filter' to detect duplicate prompts.")

(defun run-drush-php ()
  "Run an inferior instance of `drush-php-command' inside Emacs."
  (interactive)
  ;; Create the comint process if there is no buffer.
  (let ((buffer (get-buffer "*Drush-PHP*")))
    (unless (and buffer (comint-check-proc buffer))
      (let* ((command (split-string-and-unquote drush-php-command))
             (program (car command))
             (switches (cdr command)))
        (let ((inhibit-read-only t))
          (setq buffer (apply 'make-comint-in-buffer "Drush-PHP" nil
                              program drush-php-startfile switches)))
        ;; The default `internal-default-process-sentinel' sentinel
        ;; used by comint conflicts with `comint-prompt-read-only',
        ;; generating errors like the following:
        ;; * comint-exec: Text is read-only
        ;; * error in process sentinel: Text is read-only
        (let ((proc (get-buffer-process buffer)))
          (when (processp proc)
            (set-process-sentinel proc 'ignore)))))
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
  ;; ANSI colour is all we need, I think?
  ;; In any case, drush-php-font-lock-keywords has not been configured.
  ;; (setq-local font-lock-defaults '(drush-php-font-lock-keywords t))

  ;; Don't highlight whitespace.
  (setq show-trailing-whitespace nil)

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
