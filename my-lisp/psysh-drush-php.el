;; Drush PHP integration for psysh.el

(require 'psysh)

(defgroup psysh-drush-php nil
  "PsySH REPL for Drush PHP command"
  :tag "Drush PHP"
  :prefix "psysh-drush-php"
  :group 'psysh)

(defcustom psysh-drush-php-command "drush php"
  "Command and arguments to run the drush php command.

If drush is not found in `exec-path' then make sure you use an
absolute path.  In particular, if drush was installed via
composer (or otherwise) to your HOME directory, do not use '~/'
in the path, but rather the expanded path to that directory.

This string is processed by `split-string-and-unquote' to establish
the command and its arguments.  No shell quoting of special characters
is needed, but you may need to double-quote arguments which would
otherwise be split."
  :type 'string
  :group 'psysh-drush-php)

;;;###autoload
(defun run-psysh-drush-php ()
  "Run the drush php REPL inside Emacs."
  (interactive)
  (let ((psysh-command psysh-drush-php-command)
        (psysh-buffer-name "*Drush-PHP*")
        (psysh-process-name "drush-php"))
    (psysh-run-psysh)
    (when (derived-mode-p 'psysh-mode)
      (setq-local psysh-run-psysh-function 'run-psysh-drush-php))))

(provide 'psysh-drush-php)
