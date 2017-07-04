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

;; Set a custom config file:
;; The only way we have of doing this is by making psysh use a different
;; config file, with a 'pager' => 'cat' entry. The \Psy\Configuration
;; object used by drush_cli_core_cli() has a setPager() method, but we
;; have no access to it from the drush command. We cannot pass arguments
;; through to the psysh command, so using an environment variable is
;; the best option available to us.  Here we use a config file named
;; "~/.config/psysh/comint.config.php".
;;
;; (setq drush-args
;;       "-u 1 -r \"/PATH/TO/SITE/ROOT\" -l \"http://SITE.DOMAIN/\""))
;; (setq drush-php-command
;;       (format "env \"PSYSH_CONFIG=%s\" drush %s php"
;;               (expand-file-name "~/.config/psysh/comint.config.php")
;;               drush-args))

(require 'comint)

(defvar drush-php-command "drush php"
  "Command and arguments used by `run-drush-php'")

(defvar drush-php-startfile nil
  "The name of a file, whose contents are sent to the process as initial input.

For example you could use a file containing the word 'status' to run the drush
status command automatically when invoking the REPL.")

(defvar drush-php-mode-map
  (let ((map (nconc (make-sparse-keymap) comint-mode-map)))
    ;; Example definition
    (define-key map "\t" 'completion-at-point)
    (define-key map (kbd "C-a") 'drush-php-move-beginning-of-line)
    map)
  "Basic mode map for `drush-php-mode'")

(defvar drush-php-prompt-regexp "^\\(?:>>>\\|\\.\\.\\.\\) "
  "Prompt for `drush-php-command'.

Defaults to matching PsySH's main prompt '>>> ' as well as its
continuation prompt '... '")

(defun run-drush-php ()
  "Run an inferior instance of `drush-php-command' inside Emacs."
  (interactive)
  ;; Create the comint process if there is no buffer.
  (let ((buffer (get-buffer "*Drush-PHP*")))
    (unless (and buffer (comint-check-proc buffer))
      (let* ((command (split-string-and-unquote drush-php-command))
             (program (car command))
             (switches (cdr command)))
        (setq buffer (apply 'make-comint-in-buffer "Drush-PHP" nil
                            program drush-php-startfile switches))
        ;; The default `internal-default-process-sentinel' sentinel
        ;; used by comint conflicts with `comint-prompt-read-only',
        ;; generating errors like the following:
        ;; * comint-exec: Text is read-only
        ;; * error in process sentinel: Text is read-only
        (set-process-sentinel (get-buffer-process buffer) 'ignore)))
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

  ;; This makes it read only; a contentious subject as some prefer the
  ;; buffer to be overwritable. (This causes problems when the process
  ;; exits, however, so commenting for now...)
  (setq-local comint-prompt-read-only t)

  ;; Assume that the subprocess echoes input appropriately.
  (setq-local comint-process-echoes t)

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

(defun drush-php-move-beginning-of-line ()
  "Move to the beginning of the line, respecting the prompt."
  ;; Derived from `comint-line-beginning-position'.
  (interactive)
  (beginning-of-line)
  (comint-skip-prompt))

(provide 'drush-php)
