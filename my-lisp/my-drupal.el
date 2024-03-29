;; See my-project.el for directory local variables for Drupal projects.

;; Silence compiler warnings
(eval-when-compile
  (defvar c-basic-offset)
  (defvar compilation-filter-start)
  (defvar drupal-tags-autoupdate-timer)
  (defvar grep-find-ignored-directories)
  (defvar tags-completion-table)
  (defvar tags-revert-without-query)
  (declare-function c-mark-function "cc-cmds")
  (declare-function find-tag-interactive "etags")
  (declare-function php-mode "php-mode")
  (declare-function term-char-mode "term")
  (declare-function term-mode "term")
  (declare-function tramp-file-local-name "tramp")
  )

(add-to-list 'auto-mode-alist '("\\.twig\\'" . web-mode))

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
  (local-set-key (kbd "C-c R") 'my-drupal-change-records)
  (local-set-key (kbd "C-x C-k h") 'my-insert-drupal-hook)
  (local-set-key (kbd "C-c q") 'drupal-quick-and-dirty-debugging))

(defun my-drupal-change-records (phrase)
  "Search Drupal core change records for PHRASE"
  (interactive
   (list (read-string (format "Search Drupal change records%s: "
                              (if-let ((sap (symbol-at-point)))
                                  (format " (%s)" sap)
                                ""))
                      nil nil (thing-at-point 'symbol))))
  (let* ((url "https://www.drupal.org/list-changes/drupal/published")
         (eww-search-prefix (concat url "?keywords_description="))
         (eww-after-render-hook '(eww-readable)))
    (eww phrase)))

(defun my-compilation-relative-paths-filter ()
  "Make paths relative to `default-directory'."
  (save-excursion
    (let ((inhibit-read-only t)
          (pattern (concat "^" (regexp-quote default-directory))))
      (goto-char compilation-filter-start)
      (while (and (not (eobp))
                  (looking-at pattern))
        (delete-region (point) (match-end 0))
        (forward-line 1)))))

;; I think this is generic enough to use everywhere?
(add-hook 'compilation-filter-hook 'my-compilation-relative-paths-filter)

;; Drupal 7:
(defun my-drupal-php-code-sniffer ()
  "Run phpcs (with Drupal standards) for the current buffer."
  (interactive)
  (compile (format "phpcs --report=emacs --standard=Drupal %s"
                   (shell-quote-argument
                    (file-relative-name (buffer-file-name))))))
;; Drupal 9:
;; Redefine `my-drupal-php-code-sniffer' to *not* specify a
;; standard, as my D9 project uses a .phpcs.xml file which does
;; all the right things by default, yet also has no idea about
;; --standard=Drupal and issues a fatal error if you use it.
(defun my-drupal-php-code-sniffer-d9 ()
  "Run phpcs (with Drupal standards) for the current buffer."
  (interactive)
  (compile (format "phpcs --report=emacs %s"
                   (shell-quote-argument
                    (file-relative-name (buffer-file-name))))))

;; Ew.
(fset 'drupal-quick-and-dirty-debugging
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([C-home 19 102 117 110 99 116 105 111 110 32 100 114 117 112 97 108 95 115 101 116 95 109 101 115 115 97 103 101 5 return tab 105 102 32 40 36 116 121 112 101 32 61 61 32 39 101 114 114 111 114 39 41 32 123 return tab 100 115 109 40 100 101 98 117 103 95 98 97 99 107 116 114 97 99 101 40 41 44 32 84 82 85 69 41 59 return tab 125 tab] 0 "%d")) arg)))


;;; find-grep

;; ;; Don't rgrep into .composer (from outside)
;; (with-eval-after-load "grep"
;;   (add-to-list 'grep-find-ignored-directories ".composer"))

;; Ignore nodejs modules -- when present, they tend to be both
;; enormous and also entirely irrelevant to our own code.
(with-eval-after-load "grep"
  (add-to-list 'grep-find-ignored-directories "node_modules"))

;; Don't rgrep in sites/*/files

;; Gah. The (cons predicate . path) behaviour of grep-find-ignored-directories
;; is broken.  Between bugs #21548 and #51711 this functionality hasn't worked
;; for a long time :/

(with-eval-after-load "grep"
  ;; (a) Searching from the site root (outside of 'sites').
  ;;
  ;; Test whether to ignore --path 'sites/*/files'
  ;;
  ;; Try to identify something which is reasonably unique to Drupal.
  ;; xmlrpc.php was the best I could come up with for D7, but it won't
  ;; match Drupal 8. Go with index.php, even though it's really generic,
  ;; because Drupal is still the most likely use-case.
  ;;
  ;; TODO: We can implement a predicate function which does a more
  ;; robust test than this. See C-h f `locate-dominating-file' for
  ;; details of that functionality.
  ;;
  ;; n.b. If customize saves `grep-find-ignored-directories', we need it to
  ;; save the function definitions too, and therefore we must use anonymous
  ;; functions (intentionally quoted to prevent byte-compilation).
  (let ((drupal-root-dir-p
         '(lambda (dir)
            (and dir
                 (featurep 'my-drupal)
                 (let ((root (locate-dominating-file dir "index.php")))
                   (and root
                        (file-equal-p root dir)))))))
    (add-to-list 'grep-find-ignored-directories
                 (cons drupal-root-dir-p "sites/*/files")))
  ;; (b) Searching within 'sites'. Ok to just match any "files" in this case.
  (let ((drupal-sites-dir-p
         '(lambda (dir)
            (and dir
                 (featurep 'my-drupal)
                 (let ((root (locate-dominating-file dir "index.php")))
                   (and root
                        (string-prefix-p (expand-file-name "sites/" root)
                                         dir)))))))
    (add-to-list 'grep-find-ignored-directories
                 (cons drupal-sites-dir-p "files")))

  ;; Ignore .composer/cache/*
  (add-to-list 'grep-find-ignored-directories ".composer/cache"))


;; SQL support
(defun my-drupal-db-name ()
  "Directory-local value for `my-sql-db-name-getter'."
  ;; Assumes the presence of shell script db-branch, which uses drush
  ;; to establish the database name as follows:
  ;;
  ;; sqlc=$(drush -r "/path/to/drupal" sql-connect)
  ;; if [ $? -ne 0 ]; then
  ;;     exit 1
  ;; fi
  ;; sqlc1=${sqlc##*--dbname=} #remove prefix
  ;; sqlc2=${sqlc1%% *} #remove suffix
  ;; printf %s\\n "${sqlc2}"
  (shell-command-to-string "printf %s $(db-branch 2>/dev/null)"))
(defun my-drupal-db-user ()
  "Directory-local value for `my-sql-db-user-getter'."
  ;; Assumes the presence of shell script db-user, which uses drush
  ;; to establish the database user, similarly to `my-drupal-db-name'
  ;; (see the comments for which), but parsing the --username value
  ;; instead of the --dbname value.
  (shell-command-to-string "printf %s $(db-user 2>/dev/null)"))



(defun my-insert-drupal-hook (tagname)
  "Clone the specified function as a new module hook implementation.

For Drupal <= 6, you will need to grab the developer documentation
before generating the TAGS file:

cvs -z6 -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib export -r DRUPAL-6--1 -d developer-docs contributions/docs/developer

Universal Ctags:
$ ctags -eR --langmap=php:+.inc.module.install.theme.engine --kinds-php=-van --language-force=php

Old etags:
$ find . -type f \\( -name '*.php' -o -name '*.inc' -o -name '*.module' -o -name '*.install' -o -name '*.theme' -o -name '*.engine' \\) | etags --language=php -
"
  (interactive (find-tag-interactive "Hook: "))
  (let ((module (file-name-sans-extension
                 (file-name-nondirectory (buffer-file-name)))))
    (with-suppressed-warnings ((obsolete find-tag))
      ;; `find-tag' is an obsolete function (as of 25.1)
      ;; use `xref-find-definitions' instead.
      (find-tag (format "^function %s(" tagname) nil t))
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

;; Uses Universal Ctags syntax:
;; https://ctags.io => https://github.com/universal-ctags/ctags
;; (ensure "ctags --version" does not report the GNU version)

;; Ensure Emacs doesn't prompt us when the TAGS file has changed.
(setq tags-revert-without-query t)

;; Index drush.api.php
(defcustom drupal-drush-api-php
  "/usr/local/src/drush/docs/drush.api.php"
  "Location of drush.api.php"
  :type 'file
  :group 'drupal)

;; Update TAGS file automatically.
(require 'grep) ;; Use non-cons members of `grep-find-ignored-directories'.
(defcustom drupal-tags-autoupdate-prune
  (concat
   "^.*/\\("
   "sites/[^/]+/files\\|"
   (mapconcat 'regexp-quote
              (delq nil (mapcar
                         #'(lambda (dir) (and (stringp dir) dir))
                         grep-find-ignored-directories))
              "\\|")
   "\\)$")
  "Regexp of directories to omit from TAGS. Case sensitive"
  :type 'regexp
  :group 'drupal)

(defcustom drupal-tags-autoupdate-ignore
  ".*/\\(TAGS\\(\\.new\\)?\\)$"
  "Regexp of files to omit from TAGS. Case sensitive."
  :type 'regexp
  :group 'drupal)

(defcustom drupal-tags-autoupdate-pattern
  ".*\\.\\(php\\|inc\\|module\\|install\\|theme\\|engine\\)\\'"
  "Regexp of files to index in TAGS. Case insensitive."
  :type 'regexp
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
  ;; # We can almost do this directly with an Universal Ctags command,
  ;; # but the exclusion options are not as comprehensive. A basic
  ;; # approach looks like this:
  ;; exclude="--exclude=.git --exclude=.debian --exclude=.branches"
  ;; exclude="${exclude} --exclude='sites/*/files'" #n.b. '*' can include '/' :/
  ;; drupalmap="php:+.inc.module.install.theme.engine"
  ;; drupalspec="--langmap=${drupalmap} --kinds-php=-van --language-force=php"
  ;; ctags -e -R -f TAGS.new ${drupalspec} ${exclude} ${args} \
  ;;   && ! cmp --silent TAGS TAGS.new \
  ;;   && mv -f TAGS.new TAGS
  ;; rm -f TAGS.new
  `(,(concat
      "cd %s;"                                   ;dir
      " find . %s"                               ;include drush.api.php
      " \\( -type d -regex %s -prune \\)"        ;prune
      " -o -type f \\( -regex %s "               ;ignore
      "                -o -iregex %s -print \\)" ;pattern
      " | ctags -e --php-kinds=-van --language-force=php -f TAGS.new -L -"
      " && ! cmp --silent TAGS TAGS.new"
      " && mv -f TAGS.new TAGS"
      " ; rm -f TAGS.new"
      " ; touch TAGS")
    (shell-quote-argument dir) ;; `dir' is the function argument.
    (shell-quote-argument drupal-drush-api-php)
    (shell-quote-argument drupal-tags-autoupdate-prune)
    (shell-quote-argument drupal-tags-autoupdate-ignore)
    (shell-quote-argument drupal-tags-autoupdate-pattern))
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
      " find %s.git/HEAD %s \\( -type d -regex %s -prune \\)" ;dir,prune
      " -o -type f \\( -regex %s" ;ignore
      "                -o -newer %s \\( -iregex %s -o -name HEAD \\)"
      "                -print \\)" ;mtime,pattern
      " | head -1")
    (shell-quote-argument dir) ;; %s.git/HEAD -- TODO: should be another var.
    (shell-quote-argument dir) ;; %s
    (shell-quote-argument drupal-tags-autoupdate-prune)
    (shell-quote-argument drupal-tags-autoupdate-ignore)
    (shell-quote-argument tags-file-name)
    (shell-quote-argument drupal-tags-autoupdate-pattern))
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
  (when (and drupal-tags-autoupdate-enabled tags-file-name)
    (let ((tags-file-local-name (if (not (file-remote-p tags-file-name))
                                    tags-file-name
                                  (require 'tramp)
                                  (tramp-file-local-name tags-file-name))))
      ;; Verify that the TAGS file actually exists on the server the
      ;; shell commands will be running on.  We can be called in a
      ;; buffer with a tramp default-directory, in which case all of
      ;; our shell commands will be running on the remote server, and
      ;; that may not be the intended server.
      (when (let ((max-mini-window-height 1))
              (eq 0 (shell-command
                     (format "stat --printf='' %s >/dev/null 2>&1"
                             (shell-quote-argument tags-file-local-name)))))
        (let ((dir (file-name-directory tags-file-local-name)))
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
              (setq tags-completion-table nil))))))))

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

;;; Docker containers.

;; Templates only.  Edit and add to my-local.el.

;; ;; Docker + drush-php.el
;;
;; (advice-add 'run-drush-php :around #'my-drupal-docker-directory)
;;
;; (defun my-drupal-docker-directory (orig-func &rest args)
;;   "Sets `default-directory' to \"/docker:USER@WEB.HOST:/PATH/TO/DRUPAL\"
;;
;; Used as :around advice for `run-drush-php'."
;;   (if (string-prefix-p "/PATH/TO/LOCAL/DRUPAL/"
;;                        (expand-file-name
;;                         (or default-directory dired-directory)))
;;       (let ((default-directory "/docker:USER@WEB.HOST:/PATH/TO/DRUPAL"))
;;         (setq-local drush-php-command "/REMOTE/PATH/TO/vendor/bin/drush php")
;;         (setq-local psysh-completion-at-point-functions
;;                     '(tags-completion-at-point-function))
;;         (apply orig-func args))
;;     (apply orig-func args)))

;; ;; Docker + phpcs
;;
;; ;; Redefine `my-drupal-php-code-sniffer' to *not* specify a
;; ;; standard, as my D9 project uses a .phpcs.xml file which does
;; ;; all the right things by default, yet also has no idea about
;; ;; --standard=Drupal and issues a fatal error if you use it.
;; (defun my-drupal-php-code-sniffer ()
;;   "Run phpcs (with .phpcs.xml standards) for the current buffer."
;;   (interactive)
;;   (let ((default-directory default-directory)
;;         (file (buffer-file-name)))
;;     (when (string-prefix-p "/PATH/TO/LOCAL/DRUPAL/"
;;                            (expand-file-name default-directory))
;;       (setq default-directory
;;             (replace-regexp-in-string
;;              "/PATH/TO/LOCAL/DRUPAL/"
;;              "/docker:USER@WEB.HOST:/PATH/TO/DRUPAL/"
;;              default-directory t t))
;;       (setq file
;;             (replace-regexp-in-string
;;              "/PATH/TO/LOCAL/DRUPAL/"
;;              "/docker:USER@WEB.HOST:/PATH/TO/DRUPAL/"
;;              file t t)))
;;     ;; Run phpcs.
;;     (compile (format "/app/vendor/bin/phpcs --report=emacs %s"
;;                      (shell-quote-argument
;;                       (file-relative-name file))))))

;; ;; Docker + compilation output.
;;
;; ;; Redefine compilation output filter.
;; (defun my-compilation-relative-paths-filter ()
;;   "Make paths relative to `default-directory'."
;;   (save-excursion
;;     (let ((inhibit-read-only t)
;;           (pattern "^\\(/docker:USER@HOST:\\)?/PATH/"))
;;       (goto-char compilation-filter-start)
;;       (while (and (not (eobp))
;;                   (looking-at pattern))
;;         (delete-region (point) (match-end 0))
;;         (forward-line 1)
;;         (setq default-directory "/PATH/TO/LOCAL/DRUPAL/")))))

;; ;; Docker + psql
;;
;; ;; PostgreSQL support.
;; (with-eval-after-load 'tramp-sh
;;   (add-to-list 'tramp-remote-path "/app/bin")
;;   (add-to-list 'tramp-remote-path "/app/vendor/bin"))
;; (define-advice my-drupal-db-user (:around (orig-fun &rest args) docker)
;;   (let ((default-directory "/docker:USER@WEB.HOST:/PATH/TO/DRUPAL"))
;;     (apply orig-fun args)))
;; (define-advice my-drupal-db-name (:around (orig-fun &rest args) docker)
;;   (let ((default-directory "/docker:USER@WEB.HOST:/PATH/TO/DRUPAL"))
;;     (apply orig-fun args)))
;; (define-advice my-sql-console (:around (orig-fun &rest args) docker)
;;   (let ((default-directory "/docker:USER@DATABASE.HOST:/"))
;;     (apply orig-fun args)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-drupal)
