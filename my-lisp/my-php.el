;; See my-externals for php-mode source.
(load "php-mode") ;load the real php-mode

;; Silence compiler warnings
(eval-when-compile
  (defvar php-mode-map)
  (defvar php-search-documentation-browser-function)
  (defvar php-manual-path)
  (defvar php-template-compatibility)
  (defvar c-electric-flag))

;; Find documentation (locally or online).
(define-key php-mode-map (kbd "<f1>") 'php-search-documentation)
(when (fboundp 'eww-browse-url)
  (setq php-search-documentation-browser-function 'eww-browse-url))

;; Locate local documentation.
(let ((expected "/usr/local/share/php/php-chunked-xhtml"))
  (if (file-directory-p expected)
      (setq php-manual-path expected)
    (setq expected (expand-file-name "~/php/php-chunked-xhtml"))
    (if (file-directory-p expected)
        (setq php-manual-path expected)
      (message "PHP manual not found. Attempting download.")
      ;; Download and untar
      (let ((download-directory (file-name-directory expected))
            (url "http://nz2.php.net/get/php_manual_en.tar.gz/from/this/mirror")
            (file "php_manual_en.tar.gz"))
        (make-directory download-directory t)
        (shell-command
         (format
          "cd %s && wget -q %s -O %s && tar -xf %s && rm %s"
          (shell-quote-argument download-directory)
          (shell-quote-argument url)
          (shell-quote-argument file)
          (shell-quote-argument file)
          (shell-quote-argument file))))
      ;; Check the result
      (if (file-directory-p expected)
          (setq php-manual-path expected)
        (message "Failed to download PHP manual.")))))

;; Custom php-mode configuration
(add-hook 'php-mode-hook 'my-php-mode-hook t)

(defconst my-php-style
  ;; Check the `c-offsets-alist' variable and `c-set-offset' function.
  '((c-offsets-alist . ((arglist-close . c-lineup-close-paren))))
  "My PHP programming style")
(c-add-style "my-php-style" my-php-style)

;; Assume that we *only* use `php-mode' for pure PHP files.
;; (as we actually use `web-mode' for mixed-mode templates.)
(setq php-template-compatibility nil)

;; ;; Configure imenu usage with php-imenu (this was in nxhtml).
;; (autoload 'php-imenu-create-index "php-imenu" nil t)

(defun my-php-mode-hook ()
  "My php-mode customisations."
  ;; Edit PHP templates in `web-mode'.
  (if (and (buffer-file-name)
           (string-match "\\.tpl\\.php\\'" (buffer-file-name)))
      (web-mode)
    ;; Otherwise use PHP mode.
    ;; Note that my directory-local settings (in my-project.el) for
    ;; Drupal projects forces files loaded in `php-mode' (i.e. PHP
    ;; files without a Drupal- specific extension such as .module) to
    ;; run `drupal-mode', which results in `php-mode-hook' running
    ;; again. TODO: Figure out how to avoid that.
    ;; n.b. The sequence is:
    ;; Major Mode: php-mode ;; Mode: unknown
    ;; Major Mode: drupal-mode ;; Mode: unknown
    ;; for:
    ;; (message (concat "Major Mode: " (symbol-name major-mode)))
    ;; (message (concat "Mode: " (if (boundp 'mode) (symbol-name mode) "unknown")))
    (my-php-mode-hook-1)))

(defun my-php-mode-hook-1 ()
  "My php-mode customisations."
  (c-set-style "my-php-style")

  ;; The electric flag (toggled by `c-toggle-electric-state').
  ;; If t, electric actions (like automatic reindentation, and (if
  ;; c-auto-newline is also set) auto newlining) will happen when an
  ;; electric key like `{' is pressed (or an electric keyword like
  ;; `else').
  (setq c-electric-flag nil)
  ;; electric behaviours appear to be bad/unwanted in php-mode

  ;; Per-line comments preferred over block comments.
  (setq-local comment-style 'indent)
  (setq-local comment-start "//")
  (setq-local comment-padding " ")
  (setq-local comment-end "")

  ;; This is bugging out recently. Not sure why. Thought it
  ;; was a conflict with (my-coding-config), but not certain
  ;; any longer. Commenting out for now.
  ;; Configure imenu
  ;; (php-imenu-setup)
  )

(eval-when-compile
  (declare-function php-imenu-create-index "php-imenu"))

(defun php-imenu-setup ()
  (setq imenu-create-index-function (function php-imenu-create-index))
  ;; uncomment if you prefer speedbar:
  ;;(setq php-imenu-alist-postprocessor (function reverse))
  (imenu-add-menubar-index))
