;;;###autoload
(define-derived-mode drupal-mode php-mode "Drupal"
  "Major mode for Drupal coding.\n\n\\{drupal-mode-map}"

  ;; Configure local TAGS
  (let ((tag-dir (locate-dominating-file default-directory "TAGS")))
    (when tag-dir
      (let ((tag-dir (file-name-as-directory
                      (or (file-symlink-p (directory-file-name tag-dir))
                          tag-dir))))
        (visit-tags-table tag-dir t)
        (unless (timerp drupal-tags-autoupdate-timer)
          (drupal-tags-autoupdate-start)))))

  ;; PHP configuration for Drupal
  ;; n.b. php-mode is derived from c-mode

  (setq tab-width                2
        c-basic-offset           2
        indent-tabs-mode         nil
        fill-column              78
        show-trailing-whitespace t
        ;; Don't clobber (too badly) doxygen comments when using fill-paragraph
        paragraph-start          (concat paragraph-start "\\| \\* @[a-z]+")
        paragraph-separate       "$"
        )

  (c-set-offset 'case-label '+)
  (c-set-offset 'arglist-close 0)
  (c-set-offset 'arglist-intro '+) ; for FAPI arrays and DBTNG
  (c-set-offset 'arglist-cont-nonempty 'c-lineup-math) ; for DBTNG fields and values

  ;; Key bindings
  (local-set-key (kbd "C-x C-k h") 'my-insert-drupal-hook)
  (local-set-key (kbd "C-c q") 'drupal-quick-and-dirty-debugging))

(fset 'drupal-quick-and-dirty-debugging
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([C-home 19 102 117 110 99 116 105 111 110 32 100 114 117 112 97 108 95 115 101 116 95 109 101 115 115 97 103 101 5 return tab 105 102 32 40 36 116 121 112 101 32 61 61 32 39 101 114 114 111 114 39 41 32 123 return tab 100 115 109 40 100 101 98 117 103 95 98 97 99 107 116 114 97 99 101 40 41 44 32 84 82 85 69 41 59 return tab 125 tab] 0 "%d")) arg)))


;;; find-grep

;; Don't rgrep in sites/*/files

;; Gah. The (cons predicate . path) behaviour of grep-find-ignored-directories
;; causes a no-value --path argument to appear in the find, which seems to allow
;; the would-be-ignored path to be searched :( Reported as bug #21548.

;; Workaround: Ignore all "files" if we think it's Drupal.
;; n.b. This STILL triggers the problem if we're NOT in Drupal, but that's
;; less likely to be a problem, and when we ARE in Drupal we gain the benefit.
(eval-after-load "grep"
  '(add-to-list 'grep-find-ignored-directories
                (cons 'my-drupal-grep-find-ignore-files-dir-p "files")))
(defun my-drupal-grep-find-ignore-files-dir-p (dir)
  "Test whether to ignore directories matching \"files\"."
  (locate-dominating-file dir "index.php"))
;; Problematic code below...
;; FIXME:

;; ;; (a) Searching from the site root (outside of 'sites').
;; (add-to-list 'grep-find-ignored-directories
;;              (cons 'my-drupal-grep-find-ignore-sites-files-dir-p
;;                    "sites/*/files"))
;; (defun my-drupal-grep-find-ignore-sites-files-dir-p (dir)
;;   "Test whether to ignore directories matching \"sites/*/files\"."
;;   ;; Try to identify something which is reasonably unique to Drupal.
;;   ;; xmlrpc.php was the best I could come up with for D7, but it won't
;;   ;; match Drupal 8. Go with index.php, even though it's really
;;   ;; generic, because Drupal is still the most likely use-case.
;;   ;;
;;   ;; TODO: We can implement a predicate function which does a more
;;   ;; robust test than this. See C-h f `locate-dominating-file' for
;;   ;; details of that functionality.
;;   (let ((root (locate-dominating-file dir "index.php")))
;;     (and root
;;          (file-equal-p root dir))))
;; ;; (b) Searching within 'sites'. Ok to just match any "files" in this case.
;; (add-to-list 'grep-find-ignored-directories
;;              (cons 'my-drupal-grep-find-ignore-files-dir-p
;;                    "files"))
;; (defun my-drupal-grep-find-ignore-files-dir-p (dir)
;;   "Test whether to ignore directories matching \"files\"."
;;   (let ((root (locate-dominating-file dir "index.php")))
;;     (and root
;;          (string-prefix-p (concat root "sites/")
;;                           dir))))


;;; Drush

(defvar drush-cmd "drush" "Name of (or path to) Drush executable.")
(defvar drush-args "-u 1"
  "Default arguments to pass to Drush for all commands.

You may wish to specify a drush @alias, or hard-code something similar to
the following:

-l http://site.example.com -r /var/www/drupal/site -u 1")

(defun drush-console ()
  "Runs the drush console in a `term' buffer.
See http://drupal.org/project/phpsh"
  (interactive)
  (require 'term)
  (let* ((drush-args (concat drush-args " console"))
         (switches (split-string-and-unquote drush-args))
         (buf (apply 'make-term "drush console" drush-cmd nil switches)))
    ;; Enable term mode for the process buffer.
    (set-buffer buf)
    (term-mode)
    (term-char-mode)
    ;; Don't highlight trailing whitespace.
    (setq show-trailing-whitespace nil)
    ;; Select the buffer.
    (switch-to-buffer buf)))

;;; TAGS

(defun my-insert-drupal-hook (tagname)
  "Clone the specified function as a new module hook implementation.

For Drupal <= 6, you will need to grab the developer documentation
before generating the TAGS file:

cvs -z6 -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib export -r DRUPAL-6--1 -d developer-docs contributions/docs/developer

Exuberant ctags:
$ ctags -eR --langmap=php:+.module.install.inc.engine --languages=php

Old etags:
$ find . -type f \\( -name '*.php' -o -name '*.module' -o -name '*.install' -o -name '*.inc' -o -name '*.engine' \\) | etags --language=php -
"
  (interactive (find-tag-interactive "Hook: "))
  (let ((module (file-name-sans-extension
                 (file-name-nondirectory (buffer-file-name)))))
    (find-tag (format "^function %s(" tagname) nil t)
    (let ((tmp-buffer (generate-new-buffer "*temp*")))
      (c-mark-function)
      (copy-to-buffer tmp-buffer (point) (mark))
      (kill-buffer) ;; the relevant API file
      (switch-to-buffer tmp-buffer))
    (newline)
    (forward-line -1)
    (insert "/**\n * Implements ")
    (forward-word)
    (forward-char) ;; to start of function name
    (let ((start (point)))
      (search-forward "(")
      (backward-char)
      (let ((funcname (filter-buffer-substring start (point))))
        (move-beginning-of-line nil)
        (backward-char)
        (insert funcname)))
    (insert "().\n */")
    (search-forward "_")
    (backward-char)
    (delete-region (point) (progn (forward-word -1) (point)))
    (insert module)
    (let ((function (filter-buffer-substring (point-min) (point-max))))
      (kill-buffer)
      (insert function))
    (backward-sexp)
    (forward-line)
    (back-to-indentation)))


;; Directory local variables
;; Assign with:
;; (dir-locals-set-directory-class "/dir/path" 'drupal)

(dir-locals-set-class-variables
 'drupal
 '((nil . ((indent-tabs-mode . nil)
           (tab-width . 8)
           (fill-column . 76)
           (ffip-patterns . ("*.php" "*.inc" "*.module" "*.install" "*.info" "*.js"
                             "*.css" ".htaccess" "*.engine" "*.txt" "*.profile"
                             "*.xml" "*.test" "*.theme" "*.ini" "*.make"))
           ))
   (php-mode . ((eval . (unless (eq major-mode 'drupal-mode)
                          (drupal-mode) (hack-local-variables))) ;; Oooh.
                (c-basic-offset . 2)))
   (css-mode . ((css-indent-offset . 2)))
   (js-mode . ((js-indent-level . 2)))
   (javascript-mode . ((js-indent-level . 2)))
   ))


;; Update TAGS file automatically.
(require 'grep) ;; Use non-cons members of `grep-find-ignored-directories'.
(defcustom drupal-tags-autoupdate-prune
  (concat
   "^.*/\\("
   (mapconcat 'shell-quote-argument
              (delq nil (mapcar
                         #'(lambda (dir) (and (stringp dir) dir))
                         grep-find-ignored-directories))
              "\\|")
   "\\)$")
  "Regexp of directories to omit from TAGS. Case sensitive"
  :group 'drupal)

(defcustom drupal-tags-autoupdate-ignore
  ".*/\\(TAGS\\(\\.new\\)?\\)$"
  "Regexp of files to omit from TAGS. Case sensitive."
  :group 'drupal)

(defcustom drupal-tags-autoupdate-pattern
  ".*\\.\\(php\\|module\\|install\\|inc\\|engine\\)\\'"
  "Regexp of files to index in TAGS. Case insensitive."
  :group 'drupal)

(defvar drupal-tags-autoupdate-buffer "*drupal-tags-autoupdate*")

(defvar drupal-tags-autoupdate-enabled t
  "Set to nil to disable TAGS autoupdate functionality.")

(defun drupal-tags-autoupdate-toggle ()
  (interactive)
  (setq drupal-tags-autoupdate-enabled (not drupal-tags-autoupdate-enabled))
  (message "drupal-tags-autoupdate is now %s."
           (if drupal-tags-autoupdate-enabled "enabled" "disabled")))

;; (defun drupal-tags-autoupdate-command ()
;;   (concat
;;    "cd " (file-name-directory tags-file-name) ";"
;;    " find . \\( -type d -regex \"" drupal-tags-autoupdate-prune "\" -prune \\)"
;;    " -o -type f \\( -regex \"" drupal-tags-autoupdate-ignore "\""
;;    " -o -iregex \"" drupal-tags-autoupdate-pattern "\" -print \\)"
;;    " | ctags -e --language-force=php -f TAGS.new -L -"
;;    " && ! cmp --silent TAGS TAGS.new"
;;    " && mv -f TAGS.new TAGS;"
;;    " rm -f TAGS.new;"))

(defun drupal-tags-autoupdate-command (dir)
  "Regenerate TAGS.
Do not replace the original file unless there are differences."
  (format
   (concat
    "cd \"%s\";";dir
    " find . \\( -type d -regex \"%s\" -prune \\)";prune
    " -o -type f \\( -regex \"%s\" -o -iregex \"%s\" -print \\)";ignore,pattern
    " | ctags -e --language-force=php -f TAGS.new -L -"
    " && ! cmp --silent TAGS TAGS.new"
    " && mv -f TAGS.new TAGS;"
    " rm -f TAGS.new;")
   dir
   drupal-tags-autoupdate-prune
   drupal-tags-autoupdate-ignore
   drupal-tags-autoupdate-pattern))
;; Should shell-quote-argument be used here?
;; (`drupal-tags-autoupdate-prune' may complicate that.)

(defun my-directory-tree-last-modified (dir)
  "Return a timestamp for the most recent modification under the specified dir."
  (string-to-number
   (shell-command-to-string
    (format
     (concat
      "max=0; find \"%s\" -print0 | xargs -0 stat --format=%%Y"
      " | while read -r ts; do test $ts -gt $max && max=$ts && echo $max; done"
      " | tail -1")
     (shell-quote-argument dir)))))

(defun my-buffer-file-last-modified (file-name)
  "Return a timestamp for the most recent modification to the specified file.
We assume that a buffer is visiting the most recent version of this time."
  (let ((buffer (get-file-buffer file-name)))
    (when buffer
      (string-to-number
       (format-time-string
        "%s" (with-current-buffer (get-file-buffer file-name)
               (visited-file-modtime)))))))

;; variables for the timer object
(defvar drupal-tags-autoupdate-timer nil)
(defvar drupal-tags-autoupdate-interval 300 "Interval, in seconds.")

;; shell process sentinel
(defun drupal-tags-sentinel (process signal)
  "Process signals from the TAGS update shell process."
  (when (memq (process-status process) '(exit signal))
    ;; Unlike `shell-command', the output buffer is not automatically
    ;; killed if it is empty upon `async-shell-command' completion.
    (let ((buf (get-buffer drupal-tags-autoupdate-buffer)))
      (when (eq 0 (buffer-size buf))
        (kill-buffer buf)))))

;; callback function
(defun drupal-tags-autoupdate-callback ()
  "Check whether the TAGS file is out of date, and rebuild it if necessary."
  (when drupal-tags-autoupdate-enabled
    (let ((dir (file-name-directory tags-file-name))
          (tags-modified (my-buffer-file-last-modified tags-file-name)))
      (when (and tags-modified
                 (> (my-directory-tree-last-modified dir)
                    tags-modified))
        (save-window-excursion
          (let ((message-truncate-lines t))
            (async-shell-command (drupal-tags-autoupdate-command dir)
                                 drupal-tags-autoupdate-buffer)))
        (let ((proc (get-buffer-process drupal-tags-autoupdate-buffer)))
          (when proc
            (set-process-sentinel proc 'drupal-tags-sentinel)))
        (bury-buffer drupal-tags-autoupdate-buffer)
        (unless (verify-visited-file-modtime (get-file-buffer tags-file-name))
          (setq tags-completion-table nil))))))

;; start functions
(defun drupal-tags-autoupdate-start ()
  "Start (or re-start) the TAGS file autoupdate mechanism.
The update interval is set according to `drupal-tags-autoupdate-interval'."
  (interactive)
  (when (timerp drupal-tags-autoupdate-timer)
    (cancel-timer drupal-tags-autoupdate-timer))
  (setq drupal-tags-autoupdate-timer
        (run-with-timer
         1 drupal-tags-autoupdate-interval #'drupal-tags-autoupdate-callback)))

;; (defun drupal-tags-autoupdate-run-once ()
;;   (interactive)
;;   (when (timerp drupal-tags-autoupdate-timer)
;;     (cancel-timer drupal-tags-autoupdate-timer))
;;   (setq drupal-tags-autoupdate-timer
;;         (run-with-idle-timer 1 nil #'drupal-tags-autoupdate-callback)))

;; stop function
(defun drupal-tags-autoupdate-stop ()
  "Stop the TAGS file autoupdate mechanism."
  (interactive)
  (when (timerp drupal-tags-autoupdate-timer)
    (cancel-timer drupal-tags-autoupdate-timer))
  (setq drupal-tags-autoupdate-timer nil))

(setq tags-revert-without-query t)
;;(drupal-tags-autoupdate-start)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-drupal)
