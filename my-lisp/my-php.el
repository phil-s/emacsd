;; n.b. php-mode is the modified version provided by nxhtml
;; at: lisp/nxhtml/related/php-mode.el. lisp/nxhtml/related
;; was added to the load path by nxhtml/autostart.el (which
;; is loaded in my-programming.el prior to defining the PHP
;; autoloads).
(load "php-mode") ;load the real php-mode
;; (Removed nXhtml)
;; See my-externals for php-mode source.

;; Custom php-mode configuration
(add-hook 'php-mode-hook 'my-php-mode-hook t)

;; (Removed nXhtml)
;; ;; .php files use nxhtml-mumamo-mode
;; (add-hook 'nxhtml-mumamo-mode-hook 'my-nxhtml-mumamo-mode-hook t)
;; (defun my-nxhtml-mumamo-mode-hook ()
;;   (and (buffer-file-name)
;;        (string-match "\\.php\\'" (buffer-file-name))
;;        (not (string-match "\\.tpl\\.php\\'" (buffer-file-name)))
;;        (php-mode)))


;; Check the `c-offsets-alist' variable and `c-set-offset' function.


(defconst my-php-style
  '((c-offsets-alist . ((arglist-close . c-lineup-close-paren))))
  "My PHP programming style")
(c-add-style "my-php-style" my-php-style)

;; ;; Configure imenu usage with php-imenu (also provided by nxhtml)
;; (autoload 'php-imenu-create-index "php-imenu" nil t)

(defun my-php-mode-hook ()
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
