;;;###autoload
(define-derived-mode drupal-mode php-mode "Drupal"
  "Major mode for Drupal coding.\n\n\\{drupal-mode-map}"

  ;; Configure local TAGS
  (let ((tag-dir (locate-dominating-file default-directory "TAGS")))
    (when tag-dir
      (visit-tags-table tag-dir t)
      (when (not (timerp drupal-tags-autoupdate-timer))
        (drupal-tags-autoupdate-start))))

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
   (php-mode . ((eval . (when (not (eq major-mode 'drupal-mode))
                          (drupal-mode) (hack-local-variables))) ;; Oooh.
                (c-basic-offset . 2)))
   (css-mode . ((css-indent-offset . 2)))
   (js-mode . ((js-indent-level . 2)))
   (javascript-mode . ((js-indent-level . 2)))
   ))


;; Update TAGS file automatically.
(require 'grep) ;; use grep-find-ignored-directories
(defcustom drupal-tags-autoupdate-prune
  (concat
   "^.*/\\("
   (mapconcat 'shell-quote-argument grep-find-ignored-directories "\\|")
  "\\)$")
  "Regexp of directories to omit from TAGS. Case sensitive")

(defcustom drupal-tags-autoupdate-ignore
  ".*/\\(TAGS\\(\\.new\\)?\\)$"
  "Regexp of files to omit from TAGS. Case sensitive.")

(defcustom drupal-tags-autoupdate-pattern
  ".*\\.\\(php\\|module\\|install\\|inc\\|engine\\)\\'"
  "Regexp of files to index in TAGS. Case insensitive.")

;; (defun drupal-tags-autoupdate-command ()
;;   (concat
;;    "cd " (file-name-directory tags-file-name) ";"
;;    " find . \\( -type d -regex \"" drupal-tags-autoupdate-prune "\" -prune \\)"
;;    " -o -type f \\( -regex \"" drupal-tags-autoupdate-ignore "\""
;;    " -o -iregex \"" drupal-tags-autoupdate-pattern "\" -print \\)"
;;    " | etags --language=php --output=TAGS.new -"
;;    " && ! cmp --silent TAGS TAGS.new"
;;    " && mv -f TAGS.new TAGS;"
;;    " rm -f TAGS.new;"))

(defun drupal-tags-autoupdate-command (dir)
  "Regenerate TAGS.
Do not replace the original file unless there are differences."
  (format
   (concat
    "cd \"%s\";"
    " find . \\( -type d -regex \"%s\" -prune \\)"
    " -o -type f \\( -regex \"%s\" -o -iregex \"%s\" -print \\)"
    " | etags --language=php --output=TAGS.new -"
    " && ! cmp --silent TAGS TAGS.new"
    " && mv -f TAGS.new TAGS;"
    " rm -f TAGS.new;")
   dir
   drupal-tags-autoupdate-prune
   drupal-tags-autoupdate-ignore
   drupal-tags-autoupdate-pattern))

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

;; variable for the timer object
(defvar drupal-tags-autoupdate-timer nil)
(defvar drupal-tags-autoupdate-interval 300)

;; callback function
(defun drupal-tags-autoupdate-callback ()
  (let ((dir (file-name-directory tags-file-name))
        (tags-modified (my-buffer-file-last-modified tags-file-name)))
    (when (and tags-modified
               (> (my-directory-tree-last-modified dir)
                  tags-modified))
      (save-window-excursion
        (async-shell-command (drupal-tags-autoupdate-command dir) nil))
      (when (not (verify-visited-file-modtime
                  (get-file-buffer tags-file-name)))
        (setq tags-completion-table nil)))))

;; start functions
(defun drupal-tags-autoupdate-start ()
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
  (interactive)
  (when (timerp drupal-tags-autoupdate-timer)
    (cancel-timer drupal-tags-autoupdate-timer))
  (setq drupal-tags-autoupdate-timer nil))

(setq tags-revert-without-query t)
;;(drupal-tags-autoupdate-start)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-drupal)
