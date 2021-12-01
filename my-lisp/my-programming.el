;; Silence compiler warnings
(eval-when-compile
  (defvar comint-prompt-regexp)
  (defvar context-help)
  (defvar cperl-indent-level)
  (defvar eldoc-argument-case)
  (defvar fic-highlighted-words)
  (defvar imenu--index-alist)
  (defvar imenu--rescan-item)
  (defvar js-mode-map)
  (defvar name-and-pos)
  (defvar selected-symbol)
  (defvar sql-interactive-mode-map)
  (defvar sql-mode-map)
  (defvar sql-product)
  (defvar sql-prompt-cont-regexp)
  (defvar sql-prompt-regexp)
  (defvar symbol-names)
  (defvar web-mode-autocompletes)
  (defvar web-mode-tag-auto-close-style)
  (defvar whitespace-style)
  (declare-function comint-send-string "comint")
  (declare-function eldoc-current-symbol "eldoc")
  (declare-function elisp--current-symbol "elisp-mode")
  (declare-function fic-mode "fic-mode")
  (declare-function hl-sexp-mode "hl-sexp")
  (declare-function idle-highlight "idle-highlight-mode")
  (declare-function imenu--cleanup "imenu")
  (declare-function imenu--make-index-alist "imenu")
  (declare-function imenu--subalist-p "imenu")
  (declare-function lexbind-mode "lexbind-mode")
  (declare-function rainbow-mode "rainbow-mode")
  (declare-function global-so-long-mode "so-long")
  (declare-function sql-send-string "sql")
  (declare-function sql-upcase-mode "sql-upcase")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Programming language support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-coding-config ()
  (make-local-variable 'column-number-mode)
  (column-number-mode t)
  (if window-system (hl-line-mode t))
  (idle-highlight-mode 1)
  ;; `global-eldoc-mode' is enabled in 25.1 by default
  (when (< emacs-major-version 25)
    (eldoc-mode 1))
  (setq indent-tabs-mode nil)
  ;; Make RET smarter.  If `comment-auto-fill-only-comments' is non-nil then
  ;; `default-indent-new-line' may do nothing (if `comment-line-break-function'
  ;; is set to `comment-indent-new-line'), so we inhibit that here.  (I can't
  ;; immediately see what this variable is protecting against, so let's assume
  ;; for now that it's not a significant issue in practice.  It rather sounds
  ;; like it only affects `auto-fill-mode', which I never use.  Here's hoping
  ;; that I remember this if it turns out to be a problem :)
  (setq-local comment-auto-fill-only-comments nil)
  (local-set-key (kbd "RET") (key-binding (kbd "M-j")))
  (local-set-key (kbd "<S-return>") 'newline)
  ;; Make "C-o" smarter as well.
  (local-set-key (kbd "C-o") 'my-open-line-and-indent)
  (fic-mode 1)
  ;;(which-function-mode 1) ; Global minor mode, and `which-func-non-auto-modes'
                            ; is checked only upon find-file (hook).
  ;;(imenu-add-menubar-index)
  )

(mapc
 (lambda (language-mode-hook)
   (add-hook language-mode-hook 'my-coding-config))
 '(prog-mode-hook
   ;; plus anything not derived from prog-mode:
   css-mode-hook
   inferior-emacs-lisp-mode-hook
   python-mode-hook))

;; Highlighted keywords in strings and comments.
(setq fic-highlighted-words '("TODO" "DEBUG" "FIXME" "BUG" "KLUDGE"))

;; Don't leave empty lines uncommented when commenting a region
(setq comment-empty-lines 'eol)

;; Don't let minified files bring Emacs to its knees.
(when (require 'so-long nil :noerror)
  (global-so-long-mode 1))

;; Provide nice keyboard access to imenu, using Ido.
(defun imenu-ido-goto-symbol (&optional symbol-list)
  "Refresh imenu and jump to a place in the buffer using Ido."
  (interactive)
  (unless (featurep 'imenu)
    (require 'imenu nil t))
  (cond
   ((not symbol-list)
    (let ((ido-mode ido-mode)
          (ido-enable-flex-matching
           (if (boundp 'ido-enable-flex-matching)
               ido-enable-flex-matching t))
          name-and-pos symbol-names position)
      (unless ido-mode
        (ido-mode 1)
        (setq ido-enable-flex-matching t))
      (while (progn
               (imenu--cleanup)
               (setq imenu--index-alist nil)
               (imenu-ido-goto-symbol (imenu--make-index-alist))
               (setq selected-symbol
                     (ido-completing-read "Symbol? " symbol-names))
               (string= (car imenu--rescan-item) selected-symbol)))
      (unless (and (boundp 'mark-active) mark-active)
        (push-mark nil t nil))
      (setq position (cdr (assoc selected-symbol name-and-pos)))
      (cond
       ((overlayp position)
        (goto-char (overlay-start position)))
       (t
        (goto-char position)))))
   ((listp symbol-list)
    (dolist (symbol symbol-list)
      (let (name position)
        (cond
         ((and (listp symbol) (imenu--subalist-p symbol))
          (imenu-ido-goto-symbol symbol))
         ((listp symbol)
          (setq name (car symbol))
          (setq position (cdr symbol)))
         ((stringp symbol)
          (setq name symbol)
          (setq position
                (get-text-property 1 'org-imenu-marker symbol))))
        (unless (or (null position) (null name)
                    (string= (car imenu--rescan-item) name))
          (add-to-list 'symbol-names name)
          (add-to-list 'name-and-pos (cons name position))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eldoc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Support eldoc for eval-expression (Emacs 24.4).
(add-hook 'eval-expression-minibuffer-setup-hook #'eldoc-mode)

;; Highlight the eldoc echo area text
(defun frob-eldoc-argument-list (string)
  "Upcase and fontify STRING for use with `eldoc-mode'."
  (propertize (upcase string)
              'face 'font-lock-variable-name-face))
(setq eldoc-argument-case 'frob-eldoc-argument-list)

(define-minor-mode my-contextual-help-mode
  "Show help for the elisp symbol at point in the current *Help* buffer.

Advises `eldoc-print-current-symbol-info'."
  :lighter " C-h"
  :global t
  (require 'help-mode) ;; for `help-xref-interned'
  (when (eq this-command 'my-contextual-help-mode)
    (message "Contextual help is %s" (if my-contextual-help-mode "on" "off")))
  (and my-contextual-help-mode
       (eldoc-mode 1)
       (if (fboundp 'eldoc-current-symbol)
           (eldoc-current-symbol)
         (elisp--current-symbol))
       (my-contextual-help :force)))

(defadvice eldoc-print-current-symbol-info (before my-contextual-help activate)
  "Triggers contextual elisp *Help*. Enabled by `my-contextual-help-mode'."
  (and my-contextual-help-mode
       (derived-mode-p 'emacs-lisp-mode)
       (my-contextual-help)))

(defvar-local my-contextual-help-last-symbol nil
  ;; Using a buffer-local variable for this means that we can't
  ;; trigger changes to the help buffer simply by switching windows,
  ;; which seems generally preferable to the alternative.
  "The last symbol processed by `my-contextual-help' in this buffer.")

(defun my-contextual-help (&optional force)
  "Describe function, variable, or face at point, if *Help* buffer is visible."
  (let ((help-visible-p (get-buffer-window (help-buffer))))
    (when (or help-visible-p force)
      (let ((sym (if (fboundp 'eldoc-current-symbol)
                     (eldoc-current-symbol)
                   (elisp--current-symbol))))
        ;; We ignore keyword symbols, as their help is redundant.
        ;; If something else changes the help buffer contents, ensure we
        ;; don't immediately revert back to the current symbol's help.
        (and (not (keywordp sym))
             (or (not (eq sym my-contextual-help-last-symbol))
                 (and force (not help-visible-p)))
             (setq my-contextual-help-last-symbol sym)
             sym
             (save-selected-window
               (help-xref-interned sym)))))))

(defun my-contextual-help-toggle ()
  "Intelligently enable or disable `my-contextual-help-mode'."
  (interactive)
  (if (get-buffer-window (help-buffer))
      (my-contextual-help-mode 'toggle)
    (my-contextual-help-mode 1)))

(my-contextual-help-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Compilation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'compilation-mode-hook 'my-compilation-mode-hook)
(defun my-compilation-mode-hook ()
  (local-set-key (kbd "n") 'compilation-next-error)
  (local-set-key (kbd "p") 'compilation-previous-error)
  ;; `winnow' provides bindings "m" and "x" to Match and eXclude results
  ;; from the list (it's essentially `keep-lines' and `flush-lines').
  (when (fboundp 'winnow-mode)
    (winnow-mode 1)))

;; Handle ansi colour codes in compile command output.
(eval-after-load "compile"
  '(require 'ansi-color))

(defun colorize-compilation-output ()
  "Process any ansi colour codes in `compile' command output.

We deal only with `compilation-mode' itself, ignoring derivatives such as
`grep-mode' (which tend to support colour already)."
  (when (eq major-mode 'compilation-mode)
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region compilation-filter-start (point)))))

(add-hook 'compilation-filter-hook 'colorize-compilation-output)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Emacs Lisp (elisp)

(setq debugger-stack-frame-as-list t)

(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook 'turn-on-elisp-slime-nav-mode))

(add-hook 'emacs-lisp-mode-hook 'my-emacs-lisp-mode-hook)
(defun my-emacs-lisp-mode-hook ()
  (setq tab-width 8)
  ;; ;; Automated byte re-compilation.
  ;; ;; Now replaced by the auto-compile library.
  ;; (require 'bytecomp)
  ;; (add-hook 'after-save-hook 'my-auto-byte-recompile nil t)
  ;; lexbind-mode indicates `lexical-binding' value.
  (when (require 'lexbind-mode nil 'noerror)
    (lexbind-mode 1))
  ;; Highlight current sexp
  (when (require 'hl-sexp nil 'noerror)
    (hl-sexp-mode 1)))

;; (defun my-auto-byte-recompile ()
;;   "Byte compile if a corresponding .elc file already exists.
;; Use as a buffer-local after-save-hook, for emacs-lisp-mode buffers."
;;   (when (file-exists-p (byte-compile-dest-file buffer-file-name))
;;     (byte-compile-file buffer-file-name)))

;; Use cperl-mode instead of the default perl-mode
(defalias 'perl-mode 'cperl-mode)
(setq cperl-indent-level 4)

;; (Removed nXhtml)
;; nXHTML (also includes php-mode)
;; (load "nxhtml/autostart.el")

;; Mumamo is making emacs 23.3 freak out:
(when (and (equal emacs-major-version 23)
           (equal emacs-minor-version 3))
  (eval-after-load "bytecomp"
    '(add-to-list 'byte-compile-not-obsolete-vars
                  'font-lock-beginning-of-syntax-function))
  ;; tramp-compat.el clobbers this variable!
  (eval-after-load "tramp-compat"
    '(add-to-list 'byte-compile-not-obsolete-vars
                  'font-lock-beginning-of-syntax-function)))

;; Mark-up (SGML, XML, HTML)

;; XML
(defun my-xml-hook ()
  (make-local-variable 'column-number-mode)
  (column-number-mode t)
  (if window-system (hl-line-mode t))
  (idle-highlight-mode 1)
  (setq indent-tabs-mode nil)
  (local-set-key (kbd "<C-M-right>") 'nxml-forward-element)
  (local-set-key (kbd "<C-M-left>") 'nxml-backward-element))
(add-hook 'nxml-mode-hook 'my-xml-hook)

(defun my-templates-nxml-mode-hook ()
  (if (buffer-file-name)
      (if (or (string-match "\\.tpl\\.php\\'" (buffer-file-name))
              (string-match "\\.pt\\'" (buffer-file-name)))
          (rng-validate-mode 0))))
(add-hook 'nxml-mode-hook 'my-templates-nxml-mode-hook)

;; SGML
(autoload 'sgml-skip-tag-forward "sgml-mode")
(autoload 'sgml-skip-tag-backward "sgml-mode")
(defun my-sgml-mode-hook ()
  (local-set-key (kbd "<C-M-right>") 'sgml-skip-tag-forward)
  (local-set-key (kbd "<C-M-left>") 'sgml-skip-tag-backward))

(add-hook 'sgml-mode-hook 'my-sgml-mode-hook)
(add-hook 'web-mode-hook 'my-sgml-mode-hook)

(setq web-mode-autocompletes nil
      web-mode-tag-auto-close-style 0)

;; HTML
;;(add-to-list 'auto-mode-alist '("\\.html\\'" . html-helper-mode))
(add-hook 'html-helper-load-hook (lambda () (require 'html-font nil 'noerror)))
(add-hook 'html-helper-mode-hook (lambda () (font-lock-mode 1)))

;; CSS
(add-hook 'css-mode-hook 'my-css-mode-hook)
(defun my-css-mode-hook ()
  ;; Treat clauses as paragraphs, regardless of newlines.
  (set (make-local-variable 'paragraph-separate) "[} \t\f]*$")
  (local-set-key (kbd "<C-down>")
                 (lambda (&optional arg)
                   (interactive "^p")
                   (forward-paragraph arg)
                   (forward-line)))
  ;; Don't highlight long lines
  (when (boundp 'whitespace-style)
    (set (make-local-variable 'whitespace-style)
         (remq 'lines-tail (remq 'lines whitespace-style))))
  ;; Show colours
  (rainbow-mode 1))

;; small tool, used with regex search and replace
;; replace the start of CSS properties with \,(insert-selector)
(defun insert-selector ()
  "Insert the selector for this rule."
  (interactive)
  (push-mark)
  (re-search-backward "^\\(.+\\){")
  (exchange-point-and-mark)
  (pop-mark)
  (match-string 0))

;; C (and derived) modes.
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(defun my-c-mode-common-hook ()
  "Common behaviours for C-based programming modes."
  ;; Ensure that case clauses in switch statements are indented.
  (c-set-offset 'case-label '+))

;; Javascript
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-mode))

(add-hook 'js-mode-hook 'my-js-mode-hook)
(defun my-js-mode-hook ()
  ;; https://alexschroeder.ch/wiki/2016-03-06_Javascript_Comments
  ;; (setq-local comment-auto-fill-only-comments t)
  ;; (auto-fill-mode 1)
  ;; (setq-local comment-multi-line t)
  ;;
  ;; Fix M-j behaviour in block comments in js-mode
  (setq-local comment-multi-line t)
  (local-set-key [remap indent-new-comment-line] 'c-indent-new-comment-line))

;; PHP (see my-php.el)
(autoload 'php-mode "my-php" "PHP Mode." t)
(add-to-list 'auto-mode-alist '("\\.\\(php\\|inc\\)\\'" . php-mode))
;;(add-to-list 'auto-mode-alist '("\\.php[34]?\\'\\|\\.phtml\\'" . php-mode))

;; Drupal mode (see my-drupal.el)
(autoload 'drupal-mode "my-drupal" "Drupal Mode." t)
(add-to-list 'auto-mode-alist '("\\.\\(module\\|test\\|install\\|theme\\|engine\\)\\'" . drupal-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode)) ;; except see `my-php-mode-hook'
(add-to-list 'auto-mode-alist '("\\.info\\'" . conf-mode))

;; (Removed nXhtml)
;; ;; nxhtml seems slightly borked at the moment, with continual
;; ;; font-lock issues cropping up after a while. Trying here to avoid
;; ;; problems, by not switching to it unnecessarily...
;; (delete '("\\.php\\'" . nxhtml-mumamo-mode) auto-mode-alist)
;; (delete '("\\.php\\'" . html-mumamo-mode) auto-mode-alist)
;; (delete '("\\.tpl\\.php\\'" . nxhtml-mumamo-mode) auto-mode-alist)
;; (add-to-list 'auto-mode-alist '("\\.\\(php\\|inc\\)\\'" . php-mode))
;; (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . nxml-mode))

;; ;; Default to Drupal mode for PHP files
;; (delete '("\\.php\\'" . nxhtml-mumamo-mode) auto-mode-alist)
;; (delete '("\\.php\\'" . html-mumamo-mode) auto-mode-alist)
;; (delete '("\\.inc\\'" . php-mode) auto-mode-alist)
;; (delete '("\\.php[s34]?\\'" . php-mode) auto-mode-alist)
;; (add-to-list 'auto-mode-alist '("\\.\\(php\\|inc\\)\\'" . drupal-mode))

;; Varnish
(add-to-list 'auto-mode-alist '("\\.vcl\\'" . vcl-mode))

;; SQL
(with-eval-after-load "sql"
  (require 'sql-upcase)
  (define-key sql-mode-map (kbd "C-c C-r") 'my-sql-send-region)
  ;; Within SQLi buffer, open a sql-mode buffer (from which you can
  ;; edit queries and send them to SQLi; see C-h f sql-mode RET).
  (define-key sql-interactive-mode-map (kbd "C-c q") 'my-sql-query-buffer)
  ;; Make "g" restart the SQLi connection, if no process is running.
  ;; With a prefix argument, prompt for new connection details.
  (define-key sql-interactive-mode-map "g"
    `(menu-item "" my-sqli-restart
                :filter ,(lambda (cmd)
                           (unless (get-buffer-process (current-buffer))
                             cmd)))))

(add-hook 'sql-mode-hook 'my-sql-mode-hook)
(defun my-sql-mode-hook ()
  "Custom SQL mode behaviours. See `sql-mode-hook'."
  (setq show-trailing-whitespace nil)
  ;; Automatically upcase SQL keywords.
  (sql-upcase-mode 1))

(add-hook 'sql-interactive-mode-hook 'my-sql-interactive-mode-hook)
(defun my-sql-interactive-mode-hook ()
  "Custom interactive SQL mode behaviours. See `sql-interactive-mode-hook'."
  (setq show-trailing-whitespace nil)
  ;; Automatically upcase SQL keywords.
  (sql-upcase-mode 1)
  ;; Product-specific behaviours.
  (when (eq sql-product 'postgres)
    ;; Allow symbol chars and hyphens in database names in prompt.
    ;; TODO: Try to make this *strictly* accurate, in accordance with:
    ;; http://www.postgresql.org/docs/current/interactive/sql-syntax-lexical.html#SQL-SYNTAX-IDENTIFIERS
    ;; (and then submit the fix upstream).
    ;; (hmm... hyphens are not actually mentioned in that documentation :/ )
    ;;
    ;; SQL identifiers and key words must begin with a letter (a-z, but also
    ;; letters with diacritical marks and non-Latin letters) or an underscore
    ;; (_). Subsequent characters in an identifier or key word can be letters,
    ;; underscores, digits (0-9), or dollar signs ($). Note that dollar signs
    ;; are not allowed in identifiers according to the letter of the SQL
    ;; standard, so their use might render applications less portable. The SQL
    ;; standard will not define a key word that contains digits or starts or
    ;; ends with an underscore, so identifiers of this form are safe against
    ;; possible conflict with future extensions of the standard.
    ;;
    ;; The system uses no more than NAMEDATALEN-1 bytes of an identifier; longer
    ;; names can be written in commands, but they will be truncated. By default,
    ;; NAMEDATALEN is 64 so the maximum identifier length is 63 bytes. If this
    ;; limit is problematic, it can be raised by changing the NAMEDATALEN
    ;; constant in src/include/pg_config_manual.h.

    ;; Default postgres pattern was: "^\\w*=[#>] " (see `sql-product-alist').
    (setq sql-prompt-regexp "^\\(?:\\sw\\|\\s_\\|-\\)*=[#>] ")
    ;; Ditto for continuation prompt: "^\\w*[-(][#>] "
    (setq sql-prompt-cont-regexp "^\\(?:\\sw\\|\\s_\\|-\\)*[-(][#>] "))

  ;; Deal with inline prompts in query output.
  ;; Runs after `sql-interactive-remove-continuation-prompt'.
  (add-hook 'comint-preoutput-filter-functions
            'my-sql-comint-preoutput-filter :append :local))

;;(message (concat "'" output "'"))

;; FIXME: We can now have duplicate prompts *following* the results as
;; well as prefixing it.  Not sure whether this is Emacs 27's doing,
;; or psql itself, but I'll want to address it here in any case.
(defun my-sql-comint-preoutput-filter (output)
  "Filter prompts out of SQL query output.

Runs after `sql-interactive-remove-continuation-prompt' in
`comint-preoutput-filter-functions'."
  ;; If the entire output is simply the main prompt, return that.
  ;; (i.e. When simply typing RET at the sqli prompt.)
  (if (string-match (concat "\\`\\(" sql-prompt-regexp "\\)\\'") output)
      output
    ;; Otherwise filter all leading prompts from the output.
    ;; Store the buffer-local prompt patterns before changing buffers.
    (let ((main-prompt sql-prompt-regexp)
          (any-prompt comint-prompt-regexp) ;; see `sql-interactive-mode'
          (prefix-newline nil))
      (with-temp-buffer
        (insert output)
        (goto-char (point-min))
        (when (looking-at main-prompt)
          (setq prefix-newline t))
        (while (looking-at any-prompt)
          (replace-match ""))
        ;; Prepend a newline to the output, if necessary.
        (when prefix-newline
          (goto-char (point-min))
          (unless (looking-at "\n")
            (insert "\n")))
        ;; Limit the length of record separator lines in the 'expanded'
        ;; output format, so that they do not exceed the window width.
        (while (re-search-forward "^-\\[ RECORD [0-9]+ \\][-+]+$" nil t)
          (when (> (- (match-end 0) (match-beginning 0)) (window-body-width))
            (replace-match
             (substring (match-string 0) 0 (window-body-width)))))
        ;; Return the filtered output.
        (buffer-substring-no-properties (point-min) (point-max))))))

(defadvice sql-send-string (before my-prefix-newline-to-sql-string)
  "Force all `sql-send-*' commands to include an initial newline.

This is a trivial solution to single-line queries tripping up my
custom output filter.  (See `my-sql-comint-preoutput-filter'.)"
  (ad-set-arg 0 (concat "\n" (ad-get-arg 0))))
(ad-activate 'sql-send-string)

(add-hook 'sql-login-hook 'my-sql-login-hook)
(defun my-sql-login-hook ()
  "Custom SQL log-in behaviours. See `sql-login-hook'."
  ;; n.b. If you are looking for a response and need to parse the
  ;; response, use `sql-redirect-value' instead of `comint-send-string'.
  (when (eq sql-product 'postgres)
    (let ((proc (get-buffer-process (current-buffer))))
      ;; Display readable bytea data
      (comint-send-string proc "SET bytea_output = 'escape';\n")
      ;; Terminate query with :G instead of ; to use expanded display
      (comint-send-string ; \set G '\\set QUIET 1\\x\\g\\x\\set QUIET 0'
       proc "\\set G '\\\\set QUIET 1\\\\x\\\\g\\\\x\\\\set QUIET 0'\n")
      ;; But actually :L is much easier to type, and a mnemonic for "long"
      (comint-send-string ; \set L '\\set QUIET 1\\x\\g\\x\\set QUIET 0'
       proc "\\set L '\\\\set QUIET 1\\\\x\\\\g\\\\x\\\\set QUIET 0'\n"))))

(defun my-sqli-restart (&optional arg)
  "Restart `sql-product-interactive' using existing settings.

With a prefix argument, prompt for the connection settings."
  (interactive "P")
  (if arg
      (call-interactively 'sql-product-interactive)
    (cl-letf (((symbol-function 'sql-get-login) #'ignore))
      (call-interactively 'sql-product-interactive))))

(defun my-sql-send-region (start end &optional arg)
  "Send a region to the SQL process."
  (interactive "r\nP")
  (let ((string (buffer-substring-no-properties start end)))
    (sql-send-string
     (if (consp arg)
         string
       (if (string-match-p ";[[:space:]\n]*\\'" string)
           string
         (concat string ";"))))))

;; Python / Plone / Zope
(require 'my-python nil :noerror)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-programming)
