;; See my-project.el for directory local variables for Drupal projects.

;; Silence compiler warnings
(eval-when-compile
  (defvar c-basic-offset)
  (defvar drupal-tags-autoupdate-timer)
  (defvar grep-find-ignored-directories)
  (defvar tags-completion-table)
  (defvar tags-revert-without-query)
  (declare-function c-mark-function "cc-cmds")
  (declare-function find-tag-interactive "etags")
  (declare-function php-mode "php-mode")
  (declare-function term-char-mode "term")
  (declare-function term-mode "term")
  )

;;;###autoload
(define-derived-mode drupal-mode php-mode "Drupal"
  "Major mode for Drupal coding.\n\n\\{drupal-mode-map}"
  ;; PHP configuration for Drupal
  ;; n.b. php-mode is derived from c-mode
  (setq tab-width                8 ; these should stand out!
        c-basic-offset           2
        indent-tabs-mode         nil
        fill-column              78
        show-trailing-whitespace t
        ;; Don't clobber (too badly) doxygen comments when using fill-paragraph
        paragraph-start          (concat paragraph-start "\\| \\* @[a-z]+")
        paragraph-separate       "$"
        )

  ;; See `c-offsets-alist' for details of offset definitions.
  (c-set-offset 'case-label '+)
  (c-set-offset 'arglist-intro '+) ; for FAPI arrays and DBTNG
  (c-set-offset 'arglist-cont-nonempty 'c-lineup-math) ; for DBTNG fields/values
  (c-set-offset 'arglist-close 'c-lineup-close-paren)

  ;; Key bindings
  (local-set-key (kbd "C-c C-c") 'my-drupal-php-code-sniffer)
  (local-set-key (kbd "C-x C-k h") 'my-insert-drupal-hook)
  (local-set-key (kbd "C-c q") 'drupal-quick-and-dirty-debugging))

(defun my-drupal-php-code-sniffer ()
  "Run phpcs (with Drupal standards) for the current buffer."
  (interactive)
  (compile (format "phpcs --report=emacs --standard=Drupal %s"
                   (buffer-file-name))))

;; Ew.
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
  "Test whether to ignore directories matching \"files\".

Used in `grep-find-ignored-directories'."
  (when dir
    (locate-dominating-file dir "index.php")))
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
  (let* ((drush-args (concat drush-args " php"))
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
    (forward-line) ; else (c-mark-function) now marks the wrong function.
                   ; M-x report-emacs-bug
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

;;; TAGS

;; Uses Exuberant Ctags syntax:
;; sudo apt-get install -y exuberant-ctags
;; (ensure "ctags --version" does not report the GNU version)
;;
;; Even better: https://ctags.io => https://github.com/universal-ctags/ctags
;; Ctags (5.8) is now old and unmaintained. The above appears to be the way
;; forwards, and includes a complete rewrite of the PHP functionality, so I
;; should be checking this out...

;; Ensure Emacs doesn't prompt us when the TAGS file has changed.
(setq tags-revert-without-query t)

;; Update TAGS file automatically.
(require 'grep) ;; Use non-cons members of `grep-find-ignored-directories'.
(defcustom drupal-tags-autoupdate-prune
  (concat
   "^.*/\\("
   "sites/[^/]+/files\\|"
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

(defvar drupal-tags-autoupdate-command
  ;; # We can almost do this directly with an Exuberant Ctags command,
  ;; # but the exclusion options are not as comprehensive. A basic
  ;; # approach looks like this:
  ;; exclude="--exclude=.git --exclude=.debian --exclude=.branches"
  ;; exclude="${exclude} --exclude='sites/*/files'" #n.b. '*' can include '/' :/
  ;; drupalmap="php:+.module.install.inc.engine"
  ;; drupalspec="--langmap=${drupalmap} --php-kinds=-v --languages=php"
  ;; ctags -e -R -f TAGS.new ${drupalspec} ${exclude} ${args} \
  ;;   && ! cmp --silent TAGS TAGS.new \
  ;;   && mv -f TAGS.new TAGS
  ;; rm -f TAGS.new
  `(,(concat
      "cd %s;"                                       ;dir
      ;; Gah. Ctags (5.8) is buggy:
      ;; If we use 'find .' or 'find ./' we get broken paths:
      ;; $ find . -name "*.php" | ctags -e -f TAGS -L -
      ;; $ grep sites/.*/settings.php TAGS
      ;; sites/defauls/settings.php,418
      ;;             ^
      ;; But it's happy with 'find *"
      ;; $ find * -name "*.php" | ctags -e -f TAGS -L -
      ;; $ grep settings.php TAGS
      ;; sites/default/settings.php,418
      ;;             ^
      ;; We don't expect to index any dot files in a Drupal site's
      ;; root directory so in practice it's ok to use 'find *'. This
      ;; is an annoying bug, though.  n.b. Using an absolute path is
      ;; also safe, but makes the TAGS non-portable.
      " find * \\( -type d -regex \"%s\" -prune \\)" ;prune
      " -o -type f \\( -regex \"%s\" "               ;ignore
      "                -o -iregex \"%s\" -print \\)" ;pattern
      " | ctags -e --php-kinds=-v --language-force=php -f TAGS.new -L -"
      " && ! cmp --silent TAGS TAGS.new"
      " && mv -f TAGS.new TAGS"
      " ; rm -f TAGS.new"
      " ; touch TAGS")
    (shell-quote-argument dir)
    drupal-tags-autoupdate-prune
    drupal-tags-autoupdate-ignore
    drupal-tags-autoupdate-pattern)
  "A shell command to update TAGS.
Do not replace the original file unless there are differences.

Composed of a list of arguments to be passed to `format'.
See function `drupal-tags-autoupdate-command' for details.")

(defun drupal-tags-autoupdate-command (dir)
  "Regenerate TAGS."
  (if (consp drupal-tags-autoupdate-command)
      (apply 'format (mapcar 'eval drupal-tags-autoupdate-command))
    drupal-tags-autoupdate-command))

(defvar drupal-tags-autoupdate-tree-modified-command
  ;; TODO: This uses `tags-file-name'. What about `tags-table-list'??
  ;; (Should I use `locate-dominating-file' instead?)
  `(,(concat
      " find %s \\( -type d -regex \"%s\" -prune \\)" ;dir,prune
      " -o -type f \\( -regex \"%s\"" ;ignore
      "                -o -newer %s -iregex \"%s\" -print \\)" ;mtime,pattern
      " | head -1")
    (shell-quote-argument dir)
    drupal-tags-autoupdate-prune
    drupal-tags-autoupdate-ignore
    (shell-quote-argument tags-file-name)
    drupal-tags-autoupdate-pattern)
  "A shell command to determine whether any files have been modified
since the TAGS file was generated.

All the exclusions applied to `drupal-tags-autoupdate-command' are
also applied to this search, such that modifications to those (excluded)
files are not relevant.")

(defun drupal-tags-autoupdate-tree-modified (dir)
  "Non-nil if DIR has been modified since the TAGS file was modified."
  (not (string=
        "" (shell-command-to-string
            (if (consp drupal-tags-autoupdate-tree-modified-command)
                (apply 'format
                       (mapcar
                        'eval drupal-tags-autoupdate-tree-modified-command))
              drupal-tags-autoupdate-tree-modified-command)))))

(defvar drupal-tags-autoupdate-timer nil)
(defvar drupal-tags-autoupdate-interval 300 "Interval, in seconds.")

(defun drupal-tags-sentinel (process signal)
  "Process signals from the TAGS update shell process."
  (when (memq (process-status process) '(exit signal))
    ;; Unlike `shell-command', the output buffer is not automatically
    ;; killed if it is empty upon `async-shell-command' completion.
    (let ((buf (get-buffer drupal-tags-autoupdate-buffer)))
      (when (eq 0 (buffer-size buf))
        (kill-buffer buf)))))

(defun drupal-tags-autoupdate-callback ()
  "Check whether the TAGS file is out of date, and rebuild it if necessary."
  (when (and drupal-tags-autoupdate-enabled
             (eq major-mode 'drupal-mode)
             (bound-and-true-p tags-file-name))
    (let ((dir (file-name-directory tags-file-name)))
      (when (drupal-tags-autoupdate-tree-modified dir)
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

(defun drupal-tags-autoupdate-start ()
  "Start (or re-start) the TAGS file autoupdate mechanism.
The update interval is set according to `drupal-tags-autoupdate-interval'."
  (interactive)
  (when (timerp drupal-tags-autoupdate-timer)
    (cancel-timer drupal-tags-autoupdate-timer))
  (setq drupal-tags-autoupdate-timer
        (run-with-timer
         1 drupal-tags-autoupdate-interval #'drupal-tags-autoupdate-callback)))

(defun drupal-tags-autoupdate-stop ()
  "Stop the TAGS file autoupdate mechanism."
  (interactive)
  (when (timerp drupal-tags-autoupdate-timer)
    (cancel-timer drupal-tags-autoupdate-timer))
  (setq drupal-tags-autoupdate-timer nil))

(defun drupal-tags-autoupdate-init ()
  "Initiate TAGS file management."
  (let ((tag-dir (locate-dominating-file default-directory "TAGS")))
    (when tag-dir
      (let ((tag-dir (file-name-as-directory
                      (or (file-symlink-p (directory-file-name tag-dir))
                          tag-dir))))
        (visit-tags-table tag-dir t)
        (unless (timerp drupal-tags-autoupdate-timer)
          (drupal-tags-autoupdate-start))))))

(add-hook 'drupal-mode-hook 'drupal-tags-autoupdate-init)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-drupal)
