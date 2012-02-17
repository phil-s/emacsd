;; n.b. php-mode is the modified version provided by nxhtml
;; at: lisp/nxhtml/related/php-mode.el. lisp/nxhtml/related
;; was added to the load path by nxhtml/autostart.el (which
;; is loaded in my-programming.el prior to defining the PHP
;; autoloads).
(load "php-mode") ;load the real php-mode
;; (Removed nXhtml)
;; See my-externals for php-mode source.

;; Custom php-mode configuration
(add-hook 'php-mode-hook 'my-php-mode t)

;; (Removed nXhtml)
;; ;; .php files use nxhtml-mumamo-mode
;; (add-hook 'nxhtml-mumamo-mode-hook 'my-nxhtml-mumamo-mode-hook t)
;; (defun my-nxhtml-mumamo-mode-hook ()
;;   (and (buffer-file-name)
;;        (string-match "\\.php\\'" (buffer-file-name))
;;        (not (string-match "\\.tpl\\.php\\'" (buffer-file-name)))
;;        (php-mode)))

(defconst my-php-style
  '((c-offsets-alist . ((arglist-close . c-lineup-close-paren))))
  "My PHP programming style")
(c-add-style "my-php-style" my-php-style)

;; ;; Configure imenu usage with php-imenu (also provided by nxhtml)
;; (autoload 'php-imenu-create-index "php-imenu" nil t)

(defun my-php-mode ()
  "My php-mode customisations."
  ;; (message (concat "Major Mode: " (symbol-name major-mode)))
  ;; (message (concat "Mode: " (if (boundp 'mode) (symbol-name mode) "unknown")))

  (if (and (buffer-file-name)
           (string-match "\\.tpl\\.php\\'" (buffer-file-name)))
      (nxml-mode)

    (when (eq major-mode 'php-mode)
      (c-set-style "my-php-style")

      ;; The electric flag (toggled by `c-toggle-electric-state').
      ;; If t, electric actions (like automatic reindentation, and (if
      ;; c-auto-newline is also set) auto newlining) will happen when an
      ;; electric key like `{' is pressed (or an electric keyword like
      ;; `else').
      (setq c-electric-flag nil)
      ;; electric behaviours appear to be bad/unwanted in php-mode

      ;; This is bugging out recently. Not sure why. Thought it
      ;; was a conflict with (my-coding-config), but not certain
      ;; any longer. Commenting out for now.
      ;; Configure imenu
      ;; (php-imenu-setup)

      ;; Find documentation online
      (local-set-key (kbd "<f1>") 'my-php-symbol-lookup))))

(defun php-imenu-setup ()
  (setq imenu-create-index-function (function php-imenu-create-index))
  ;; uncomment if you prefer speedbar:
  ;;(setq php-imenu-alist-postprocessor (function reverse))
  (imenu-add-menubar-index))

(defun my-php-symbol-lookup ()
  "Find the symbol at point in the online PHP documentation."
  (interactive)
  (let ((symbol (symbol-at-point)))
    (if (not symbol)
        (message "No symbol at point.")
      (browse-url (concat "http://php.net/manual-lookup.php?pattern="
                          (symbol-name symbol))))))

;;; drupal-mode.el --- major mode for Drupal coding

;;;###autoload
(define-derived-mode drupal-mode php-mode "Drupal"
  "Major mode for Drupal coding.\n\n\\{drupal-mode-map}"

  ;; Configure local TAGS
  (let ((tag-dir (locate-dominating-file default-directory "TAGS")))
    (when tag-dir
      (visit-tags-table tag-dir t)))

  ;; Essential Drupal configurations.
  (drupal-mode-php-config)

  ;;(add-hook 'before-save-hook 'delete-trailing-whitespace)
  ;; (run-hooks 'drupal-mode-hook)
  )

(defun drupal-mode-php-config ()
  "PHP configuration for Drupal."
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
