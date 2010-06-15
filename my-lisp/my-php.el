;; n.b. php-mode is the modified version provided by nxhtml
;; at: lisp/nxhtml/related/php-mode.el. lisp/nxhtml/related
;; was added to the load path by nxhtml/autostart.el (which
;; is loaded in my-programming.el prior to calling setup-my-php).
(autoload 'php-mode "php-mode" "PHP Mode." t)
(add-to-list 'auto-mode-alist '("\\.php[34]?\\'\\|\\.phtml\\'" . php-mode))

;; Drupal mode
(add-to-list 'auto-mode-alist '("\\.\\(module\\|test\\|install\\|theme\\)$" . drupal-mode))
(add-to-list 'auto-mode-alist '("/drupal.*\\.\\(php\\|inc\\)$" . drupal-mode))
(add-to-list 'auto-mode-alist '("\\.info" . conf-windows-mode))

;; Custom php-mode configuration
(add-hook 'php-mode-hook 'my-php-mode)

(defconst my-php-style
  '((c-offsets-alist . ((arglist-close . c-lineup-close-paren))))
  "My PHP Programming style")
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
  ;; electric behaviours appear are bad/unwanted in php-mode

  ;; Configure imenu
  (php-imenu-setup)

  ;; Find documentation online
  (local-set-key (kbd "<f1>") 'my-php-symbol-lookup))

(defun php-imenu-setup ()
  (setq imenu-create-index-function (function php-imenu-create-index))
  ;; uncomment if you prefer speedbar:
  ;;(setq php-imenu-alist-postprocessor (function reverse))
  (imenu-add-menubar-index))

(defun my-php-symbol-lookup ()
  (interactive)
  (let ((symbol (symbol-at-point)))
    (if (not symbol)
        (message "No symbol at point.")

      (browse-url (concat "http://php.net/manual-lookup.php?pattern="
                          (symbol-name symbol))))))

(defun drupal-mode ()
  "Drupal php-mode."
  (interactive)
  (php-mode)
  (message "Drupal mode activated.")
  (set 'tab-width 2)
  (set 'c-basic-offset 2)
  (set 'indent-tabs-mode nil)
  (c-set-offset 'case-label '+)
  (c-set-offset 'arglist-intro '+) ; for FAPI arrays and DBTNG
  (c-set-offset 'arglist-cont-nonempty 'c-lineup-math) ; for DBTNG fields and values
  ;; More Drupal-specific customizations here...
  )

(provide 'my-php)
