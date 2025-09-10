;; -*- lexical-binding: nil; -*-
;; Refactoring still needed?  This is now fixed:
;; At present I depend on dynamic binding of these `dir' function args:
;; (defun mahara-tags-autoupdate-command (dir)
;; (defun mahara-tags-autoupdate-tree-modified (dir)

;; See my-project.el for directory local variables for Mahara projects.

;; Silence compiler warnings
(eval-when-compile
  (defvar c-basic-offset)
  (defvar compilation-filter-start)
  (defvar mahara-tags-autoupdate-timer)
  (defvar grep-find-ignored-directories)
  (defvar tags-completion-table)
  (defvar tags-revert-without-query)
  (declare-function c-mark-function "cc-cmds")
  (declare-function find-tag-interactive "etags")
  (declare-function json-mode "json-mode")
  (declare-function php-mode "php-mode")
  (declare-function term-char-mode "term")
  (declare-function term-mode "term")
  (declare-function tramp-file-local-name "tramp")
  (declare-function visual-wrap-comments-mode "visual-wrap-comments")
  )

(add-to-list 'auto-mode-alist '("\\.twig\\'" . web-mode))

;;;###autoload
(define-derived-mode mahara-mode php-mode "Mahara"
  "Major mode for Mahara coding.\n\n\\{mahara-mode-map}"
  ;; PHP configuration for Mahara
  ;; n.b. php-mode is derived from c-mode
  (setq tab-width                8 ; these should stand out!
        c-basic-offset           4
        indent-tabs-mode         nil
        fill-column              80
        show-trailing-whitespace t
        ;; Don't clobber (too badly) doxygen comments when using fill-paragraph
        paragraph-start          (concat paragraph-start "\\| \\* @[a-z]+")
        paragraph-separate       "$"
        )

  (setq-local my-bug-reference-url-for-issues
              "https://git.mahara.org/catalyst/mahara/-/issues/%s"
              my-bug-reference-url-for-bugs
              "https://bugs.launchpad.net/mahara/+bug/%s")

  ;; See `c-offsets-alist' for details of offset definitions.
  (c-set-offset 'case-label '+)
  (c-set-offset 'arglist-intro '+) ; for FAPI arrays and DBTNG
  (c-set-offset 'arglist-cont-nonempty 'c-lineup-math) ; for DBTNG fields/values
  (c-set-offset 'arglist-close 'c-lineup-close-paren)

  ;; Cope with the crazy comment line lengths.
  ;; (I wrote this library specifically for the Mahara codebase!)
  (require 'visual-wrap-comments)
  (visual-wrap-comments-mode 1)

  ;; Key bindings
  (local-set-key (kbd "C-c C-c") 'my-mahara-php-code-sniffer))

;; This is (harmlessly) copied in my-drupal.el.
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

;; ;; Drupal 7:
;; (defun my-mahara-php-code-sniffer ()
;;   "Run phpcs (with Mahara standards) for the current buffer."
;;   (interactive)
;;   (compile (format "phpcs --report=emacs --standard=Mahara %s"
;;                    (shell-quote-argument
;;                     (file-relative-name (buffer-file-name))))))
;; ;; Drupal 9:
;; ;; Redefine `my-mahara-php-code-sniffer' to *not* specify a
;; ;; standard, as my D9 project uses a .phpcs.xml file which does
;; ;; all the right things by default, yet also has no idea about
;; ;; --standard=Mahara and issues a fatal error if you use it.
;; (defun my-mahara-php-code-sniffer-d9 ()
;;   "Run phpcs (with Mahara standards) for the current buffer."
;;   (interactive)
;;   (compile (format "phpcs --report=emacs %s"
;;                    (shell-quote-argument
;;                     (file-relative-name (buffer-file-name))))))


;;; find-grep

;; ;; Don't rgrep into .composer (from outside)
;; (with-eval-after-load "grep"
;;   (add-to-list 'grep-find-ignored-directories ".composer"))

;; Ignore nodejs modules -- when present, they tend to be both
;; enormous and also entirely irrelevant to our own code.
(with-eval-after-load "grep"
  (add-to-list 'grep-find-ignored-directories "node_modules"))


;; ;; SQL support
;; (defun my-mahara-db-name ()
;;   "Directory-local value for `my-sql-db-name-getter'."
;;   ;; Assumes the presence of shell script db-branch, which uses drush
;;   ;; to establish the database name as follows:
;;   ;;
;;   ;; sqlc=$(drush -r "/path/to/mahara" sql-connect)
;;   ;; if [ $? -ne 0 ]; then
;;   ;;     exit 1
;;   ;; fi
;;   ;; sqlc1=${sqlc##*--dbname=} #remove prefix
;;   ;; sqlc2=${sqlc1%% *} #remove suffix
;;   ;; printf %s\\n "${sqlc2}"
;;   (shell-command-to-string "printf %s $(db-branch 2>/dev/null)"))
;; (defun my-mahara-db-user ()
;;   "Directory-local value for `my-sql-db-user-getter'."
;;   ;; Assumes the presence of shell script db-user, which uses drush
;;   ;; to establish the database user, similarly to `my-mahara-db-name'
;;   ;; (see the comments for which), but parsing the --username value
;;   ;; instead of the --dbname value.
;;   (shell-command-to-string "printf %s $(db-user 2>/dev/null)"))


;;; TAGS

;; Uses Universal Ctags syntax:
;; https://ctags.io => https://github.com/universal-ctags/ctags
;; (ensure "ctags --version" does not report the GNU version)

;; Ensure Emacs doesn't prompt us when the TAGS file has changed.
(setq tags-revert-without-query t)

;; Update TAGS file automatically.
(require 'grep) ;; Use non-cons members of `grep-find-ignored-directories'.
(defcustom mahara-tags-autoupdate-prune
  (concat
   "^.*/\\("
   ;; "path/to/ignore\\|"
   ;; "also/to/ignore\\|"
   (mapconcat 'regexp-quote
              (delq nil (mapcar
                         #'(lambda (dir) (and (stringp dir) dir))
                         grep-find-ignored-directories))
              "\\|")
   "\\)$")
  "Regexp of directories to omit from TAGS. Case sensitive"
  :type 'regexp
  :group 'mahara)

(defcustom mahara-tags-autoupdate-ignore
  ".*/\\(TAGS\\(\\.new\\)?\\)$"
  "Regexp of files to omit from TAGS. Case sensitive."
  :type 'regexp
  :group 'mahara)

(defcustom mahara-tags-autoupdate-pattern
  ".*\\.\\(php\\|inc\\)\\'"
  "Regexp of files to index in TAGS. Case insensitive."
  :type 'regexp
  :group 'mahara)

(defvar mahara-tags-autoupdate-buffer "*mahara-tags-autoupdate*")

(defvar mahara-tags-autoupdate-enabled t
  "Set to nil to disable TAGS autoupdate functionality.")

(defun mahara-tags-autoupdate-toggle ()
  (interactive)
  (setq mahara-tags-autoupdate-enabled (not mahara-tags-autoupdate-enabled))
  (message "mahara-tags-autoupdate is now %s."
           (if mahara-tags-autoupdate-enabled "enabled" "disabled")))

(defvar mahara-tags-autoupdate-dir)

(defvar mahara-tags-autoupdate-command
  ;; # We can almost do this directly with an Universal Ctags command,
  ;; # but the exclusion options are not as comprehensive. A basic
  ;; # approach looks like this:
  ;; exclude="--exclude=.git --exclude=.debian --exclude=.branches"
  ;; exclude="${exclude} --exclude='sites/*/files'" #n.b. '*' can include '/' :/
  ;; maharamap="php:+.inc"
  ;; maharaspec="--langmap=${maharamap} --kinds-php=-van --language-force=php"
  ;; ctags -e -R -f TAGS.new ${maharaspec} ${exclude} ${args} \
  ;;   && ! cmp --silent TAGS TAGS.new \
  ;;   && mv -f TAGS.new TAGS
  ;; rm -f TAGS.new
  `(,(concat
      "cd %s;"                                   ;dir
      " find ."
      " \\( -type d -regex %s -prune \\)"        ;prune
      " -o -type f \\( -regex %s "               ;ignore
      "                -o -iregex %s -print \\)" ;pattern
      " | ctags -e --php-kinds=-van --language-force=php -f TAGS.new -L -"
      " && ! cmp --silent TAGS TAGS.new"
      " && mv -f TAGS.new TAGS"
      " ; rm -f TAGS.new"
      " ; touch TAGS")
    (shell-quote-argument mahara-tags-autoupdate-dir)
    (shell-quote-argument mahara-tags-autoupdate-prune)
    (shell-quote-argument mahara-tags-autoupdate-ignore)
    (shell-quote-argument mahara-tags-autoupdate-pattern))
  "A shell command to update TAGS.
Do not replace the original file unless there are differences.

Composed of a list of arguments to be passed to `format'.
See function `mahara-tags-autoupdate-command' for details.")

(defun mahara-tags-autoupdate-command (dir)
  "Regenerate TAGS."
  (if (consp mahara-tags-autoupdate-command)
      (let ((mahara-tags-autoupdate-dir dir))
        (apply 'format (mapcar 'eval mahara-tags-autoupdate-command)))
    mahara-tags-autoupdate-command))

(defvar mahara-tags-autoupdate-tree-modified-command
  ;; TODO: This uses `tags-file-name'. What about `tags-table-list'??
  ;; (Should I use `locate-dominating-file' instead?)
  `(,(concat
      " find %s.git/HEAD %s \\( -type d -regex %s -prune \\)" ;dir,prune
      " -o -type f \\( -regex %s" ;ignore
      "                -o -newer %s \\( -iregex %s -o -name HEAD \\)"
      "                -print \\)" ;mtime,pattern
      " | head -1")
    (shell-quote-argument mahara-tags-autoupdate-dir) ;; %s.git/HEAD -- TODO: should be another var.
    (shell-quote-argument mahara-tags-autoupdate-dir) ;; %s
    (shell-quote-argument mahara-tags-autoupdate-prune)
    (shell-quote-argument mahara-tags-autoupdate-ignore)
    (shell-quote-argument tags-file-name)
    (shell-quote-argument mahara-tags-autoupdate-pattern))
  "A shell command to determine whether any files have been modified
since the TAGS file was generated.

All the exclusions applied to `mahara-tags-autoupdate-command' are
also applied to this search, such that modifications to those (excluded)
files are not relevant.")

(defun mahara-tags-autoupdate-tree-modified (dir)
  "Non-nil if DIR has been modified since the TAGS file was modified."
  (not (string=
        "" (shell-command-to-string
            (if (consp mahara-tags-autoupdate-tree-modified-command)
                (let ((mahara-tags-autoupdate-dir dir))
                  (apply 'format
                         (mapcar
                          'eval mahara-tags-autoupdate-tree-modified-command)))
              mahara-tags-autoupdate-tree-modified-command)))))

(defvar mahara-tags-autoupdate-timer nil)
(defvar mahara-tags-autoupdate-interval 300 "Interval, in seconds.")

(defun mahara-tags-sentinel (process _signal)
  "Process signals from the TAGS update shell process."
  (when (memq (process-status process) '(exit signal))
    ;; If the TAGS file has changed, invalidate it.
    (unless (verify-visited-file-modtime (get-file-buffer tags-file-name))
      (setq tags-completion-table nil))
    ;; Unlike `shell-command', the output buffer is not automatically
    ;; killed if it is empty upon `async-shell-command' completion.
    (let ((buf (get-buffer mahara-tags-autoupdate-buffer)))
      (when (eq 0 (buffer-size buf))
        (kill-buffer buf)))))

(defun mahara-tags-autoupdate-callback ()
  "Check whether the TAGS file is out of date, and rebuild it if necessary."
  ;; I'm still getting negative timer ETAs for this.  If the problem
  ;; is errors while the work is happening, let's try doing basically
  ;; no work here, and instead use this to trigger a separate one-off
  ;; timer to do what needs doing.
  (when (and mahara-tags-autoupdate-enabled tags-file-name)
    (run-at-time 0 nil #'mahara-tags-autoupdate-callback-1)))

(defun mahara-tags-autoupdate-callback-1 ()
  "Check whether the TAGS file is out of date, and rebuild it if necessary."
  (when (and mahara-tags-autoupdate-enabled tags-file-name)
    ;; Error handling is important for timer callbacks, else we can end up with
    ;; non-functional timers with a negative 'Next' time which can't trigger:
    ;; https://debbugs.gnu.org/cgi/bugreport.cgi?bug=39824#53
    (with-demoted-errors "Error: %S"
      (let ((debug-on-error nil)
            (tags-file-local-name (if (not (file-remote-p tags-file-name))
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
            (when (mahara-tags-autoupdate-tree-modified dir)
              (save-window-excursion
                (let ((message-truncate-lines t))
                  (async-shell-command (mahara-tags-autoupdate-command dir)
                                       mahara-tags-autoupdate-buffer)))
              (let ((proc (get-buffer-process mahara-tags-autoupdate-buffer)))
                (when proc
                  (set-process-sentinel proc 'mahara-tags-sentinel)))
              (bury-buffer mahara-tags-autoupdate-buffer)
              (unless (verify-visited-file-modtime (get-file-buffer tags-file-name))
                (setq tags-completion-table nil)))))))))

(defun mahara-tags-autoupdate-start ()
  "Start (or re-start) the TAGS file autoupdate mechanism.
The update interval is set according to `mahara-tags-autoupdate-interval'."
  (interactive)
  (when (timerp mahara-tags-autoupdate-timer)
    (cancel-timer mahara-tags-autoupdate-timer))
  (setq mahara-tags-autoupdate-timer
        (run-with-timer
         1 mahara-tags-autoupdate-interval #'mahara-tags-autoupdate-callback)))

(defun mahara-tags-autoupdate-stop ()
  "Stop the TAGS file autoupdate mechanism."
  (interactive)
  (when (timerp mahara-tags-autoupdate-timer)
    (cancel-timer mahara-tags-autoupdate-timer))
  (setq mahara-tags-autoupdate-timer nil))

(defun mahara-tags-autoupdate-init ()
  "Initiate TAGS file management."
  (let ((tag-dir (locate-dominating-file default-directory "TAGS")))
    (when tag-dir
      (let ((tag-dir (file-name-as-directory
                      (or (file-symlink-p (directory-file-name tag-dir))
                          tag-dir))))
        (visit-tags-table tag-dir t)
        (unless (timerp mahara-tags-autoupdate-timer)
          (mahara-tags-autoupdate-start))))))

(add-hook 'mahara-mode-hook 'mahara-tags-autoupdate-init)

;;; Composer.

;; See my-projects.el for usage:
(define-derived-mode my-mahara-composer-patches-mode json-mode "Patches"
  "Major mode for a composer.patches.json file in a Mahara project."
  ;; `bug-reference-bug-regexp' has particular requirements wrt grouping.
  ;; See also `my-bug-reference-bug-regexp'.
  (setq-local bug-reference-bug-regexp "#\\(\\([0-9]+\\)\\):"
              bug-reference-url-format "https://git.mahara.org/catalyst/mahara/-/issues/%s"
              truncate-lines t)
  ;; (face-remap-add-relative 'link :foreground 'unspecified)
  ;; (face-remap-add-relative 'link :foreground (face-attribute 'default :foreground))
  ;; (face-remap-add-relative 'link :foreground (face-attribute 'default :foreground))
  (face-remap-add-relative 'link :underline nil :weight 'normal)
  (face-remap-add-relative 'font-lock-keyword-face
                           :inherit 'font-lock-string-face
                           :weight 'normal)
  (bug-reference-mode 1))

;;; Docker containers.

;; Templates only.  Edit and add to my-local.el.

;; ;; Docker + drush-php.el
;;
;; (advice-add 'run-drush-php :around #'my-mahara-docker-directory)
;;
;; (defun my-mahara-docker-directory (orig-func &rest args)
;;   "Sets `default-directory' to \"/docker:USER@WEB.HOST:/PATH/TO/MAHARA\"
;;
;; Used as :around advice for `run-drush-php'."
;;   (if (string-prefix-p "/PATH/TO/LOCAL/MAHARA/"
;;                        (expand-file-name
;;                         (or default-directory dired-directory)))
;;       (let ((default-directory "/docker:USER@WEB.HOST:/PATH/TO/MAHARA"))
;;         (setq-local drush-php-command "/REMOTE/PATH/TO/vendor/bin/drush php")
;;         (setq-local psysh-completion-at-point-functions
;;                     '(tags-completion-at-point-function))
;;         (apply orig-func args))
;;     (apply orig-func args)))

;; ;; Docker + phpcs
;;
;; ;; Redefine `my-mahara-php-code-sniffer' to *not* specify a
;; ;; standard, as my D9 project uses a .phpcs.xml file which does
;; ;; all the right things by default, yet also has no idea about
;; ;; --standard=Mahara and issues a fatal error if you use it.
;; (defun my-mahara-php-code-sniffer ()
;;   "Run phpcs (with .phpcs.xml standards) for the current buffer."
;;   (interactive)
;;   (let ((default-directory default-directory)
;;         (file (buffer-file-name)))
;;     (when (string-prefix-p "/PATH/TO/LOCAL/MAHARA/"
;;                            (expand-file-name default-directory))
;;       (setq default-directory
;;             (replace-regexp-in-string
;;              "/PATH/TO/LOCAL/MAHARA/"
;;              "/docker:USER@WEB.HOST:/PATH/TO/MAHARA/"
;;              default-directory t t))
;;       (setq file
;;             (replace-regexp-in-string
;;              "/PATH/TO/LOCAL/MAHARA/"
;;              "/docker:USER@WEB.HOST:/PATH/TO/MAHARA/"
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
;;         (setq default-directory "/PATH/TO/LOCAL/MAHARA/")))))

;; ;; Docker + psql
;;
;; ;; PostgreSQL support.
;; (with-eval-after-load 'tramp-sh
;;   (add-to-list 'tramp-remote-path "/app/bin")
;;   (add-to-list 'tramp-remote-path "/app/vendor/bin"))
;; (define-advice my-mahara-db-user (:around (orig-fun &rest args) docker)
;;   (let ((default-directory "/docker:USER@WEB.HOST:/PATH/TO/MAHARA"))
;;     (apply orig-fun args)))
;; (define-advice my-mahara-db-name (:around (orig-fun &rest args) docker)
;;   (let ((default-directory "/docker:USER@WEB.HOST:/PATH/TO/MAHARA"))
;;     (apply orig-fun args)))
;; (define-advice my-sql-console (:around (orig-fun &rest args) docker)
;;   (let ((default-directory "/docker:USER@DATABASE.HOST:/"))
;;     (apply orig-fun args)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-mahara)
