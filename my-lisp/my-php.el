;; n.b. php-mode is the modified version provided by nxhtml
;; at: lisp/nxhtml/related/php-mode.el. lisp/nxhtml/related
;; was added to the load path by nxhtml/autostart.el (which
;; is loaded in my-programming.el prior to defining the PHP
;; autoloads).
(load "php-mode") ;load the real php-mode

;; Custom php-mode configuration
(add-hook 'php-mode-hook 'my-php-mode t)

;; .php files use nxhtml-mumamo-mode
(add-hook 'nxhtml-mumamo-mode-hook 'my-nxhtml-mumamo-mode-hook t)
(defun my-nxhtml-mumamo-mode-hook ()
  ;; (and (buffer-file-name)
  ;;      (string-match "\\.php\\'" (buffer-file-name))
  ;;      ;; If this is a Drupal site, .php files need to be in Drupal
  ;;      ;; mode as well.
  ;;      (cdr (assoc 'drupal-p dir-local-variables-alist))
  ;;      (drupal-mode)))
  (and (buffer-file-name)
       (string-match "\\.php\\'" (buffer-file-name))
       (not (string-match "\\.tpl\\.php\\'" (buffer-file-name)))
       (drupal-mode)))

(defconst my-php-style
  '((c-offsets-alist . ((arglist-close . c-lineup-close-paren))))
  "My PHP programming style")
(c-add-style "my-php-style" my-php-style)

;; Configure imenu usage with php-imenu (also provided by nxhtml)
(autoload 'php-imenu-create-index "php-imenu" nil t)

(defun my-php-mode ()
  "My php-mode customisations."
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

  ;; ;; If this is a Drupal site, .php files need to be in Drupal
  ;; ;; mode as well.
  ;; (if (cdr (assoc 'drupal-p dir-local-variables-alist))
  ;;     (my--drupal-mode))
  (my--drupal-mode);; the other code is not working

  ;; Find documentation online
  (local-set-key (kbd "<f1>") 'my-php-symbol-lookup))

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

(defun my--drupal-mode ()
  "PHP mode customisations for Drupal development."

  ;; Configure local TAGS
  (let ((tag-dir (my-parent-of-dir-in-buffer-file-name "htdocs")))
    (if tag-dir
        (visit-tags-table (file-name-as-directory tag-dir) t)))

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

  (local-set-key (kbd "C-x C-k h") 'drupal-hook)
  (local-set-key (kbd "C-c q") 'drupal-quick-and-dirty-debugging))


;;; drupal-mode.el --- major mode for Drupal coding

;;;###autoload
(define-derived-mode drupal-mode php-mode "Drupal"
  "Major mode for Drupal coding.\n\n\\{drupal-mode-map}"
  (my--drupal-mode)
  ;;(add-hook 'before-save-hook 'delete-trailing-whitespace)
  (run-hooks 'drupal-mode-hook))

(fset 'drupal-quick-and-dirty-debugging
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([C-home 19 102 117 110 99 116 105 111 110 32 100 114 117 112 97 108 95 115 101 116 95 109 101 115 115 97 103 101 5 return tab 105 102 32 40 36 116 121 112 101 32 61 61 32 39 101 114 114 111 114 39 41 32 123 return tab 100 115 109 40 100 101 98 117 103 95 98 97 99 107 116 114 97 99 101 40 41 44 32 84 82 85 69 41 59 return tab 125 tab] 0 "%d")) arg)))

;; Use etags and the API files to replace hook_(name) with
;; the example code for that hook. For Drupal 6, you will need
;; to grab the developer documentation before generating TAGS
;; cvs -z6 -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib export -r DRUPAL-6--1 -d developer-docs contributions/docs/developer
;; Old etags:
;; $ find . -type f \( -name "*.php" -o -name "*.module" -o -name "*.install" -o -name "*.inc" \) | etags --language=php -
;; Exuberant ctags:
;; $ ctags -eR --langmap=php:+.module.install.inc --languages=php
(fset 'drupal-hook ;; To edit: C-x C-k e M-x drupal-hook RET
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([134217848 102 105 110 100 45 116 97 103 13 13 1 67108896 5 left C-M-right 134217847 24 107 13 1 11 134217848 101 118 97 108 45 101 120 112 114 101 115 115 105 111 110 13 40 115 119 105 116 99 104 45 116 111 45 98 117 102 102 101 114 40 103 101 110 101 114 97 116 101 45 110 101 119 45 98 117 102 102 101 114 34 42 116 101 109 112 42 34 41 41 13 25 134217849 C-M-left 1 13 up 47 42 42 13 32 42 32 73 109 112 108 101 109 101 110 116 97 116 105 111 110 32 111 102 32 C-right right 67108896 19 40 left 134217847 1 left 25 40 41 46 13 32 42 47 134217788 67108896 134217790 134217847 24 107 13 25 C-M-left down 134217837] 0 "%d")) arg)))

;; (defun my-expand-drupal-hook ()
;;   "Wrapper for the drupal-hook keyboard macro."
;;   (interactive)
;;   (with-temp-buffer
;;     (insert "howdy")
;;     (kill-region (point-min) (point-max))))
