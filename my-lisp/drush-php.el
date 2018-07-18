;;; drush-php.el --- Drush PHP integration for psysh.el
;;
;; Author: Phil Sainty
;; Created: April 2018
;; Version: 0.2

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
;; To start the repl:  M-x run-drush-php
;;
;; To configure:  M-x customize-group RET drush-php
;; along with its parent group:  psysh
;;
;; This library is a wrapper around psysh.el.
;; For more information, refer to its commentary:
;; M-x find-library RET psysh

(require 'psysh)

(defgroup drush-php nil
  "PsySH REPL for Drush PHP command"
  :tag "Drush PHP"
  :prefix "drush-php"
  :group 'psysh)

(defcustom drush-php-command "drush php"
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
  :group 'drush-php)

;;;###autoload
(defun run-drush-php ()
  "Run the drush php REPL inside Emacs."
  (interactive)
  (let ((psysh-command drush-php-command)
        (psysh-buffer-name "*Drush-PHP*")
        (psysh-process-name "drush-php"))
    (psysh-run-psysh)
    (when (derived-mode-p 'psysh-mode)
      (setq-local psysh-run-psysh-function 'run-drush-php))))

(provide 'drush-php)
