;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Programming language support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-coding-config ()
  (make-local-variable 'column-number-mode)
  (column-number-mode t)
  (if window-system (hl-line-mode t))
  (idle-highlight)
  (when (require 'rainbow-delimiters nil t)
    (rainbow-delimiters-mode 1))
  (turn-on-eldoc-mode)
  (setq indent-tabs-mode nil)
  (local-set-key (kbd "RET") (key-binding (kbd "M-j")))
  (local-set-key (kbd "<S-return>") 'newline)
  (whitespace-mode 1)
  ;;(which-function-mode 1)
  ;;(turn-on-fic-mode)
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

;; Highlight the eldoc echo area text
(defun frob-eldoc-argument-list (string)
  "Upcase and fontify STRING for use with `eldoc-mode'."
  (propertize (upcase string)
              'face 'font-lock-variable-name-face))
(setq eldoc-argument-case 'frob-eldoc-argument-list)

(defun rgr/toggle-context-help ()
  "Turn on or off the context help.
Note that if ON and you hide the help buffer then you need to
manually reshow it. A double toggle will make it reappear"
  (interactive)
  (with-current-buffer (help-buffer)
    (unless (local-variable-p 'context-help)
      (set (make-local-variable 'context-help) t))
    (when (setq context-help (not context-help))
      (unless (get-buffer-window (help-buffer))
        (display-buffer (help-buffer))))
    (message "Context help %s" (if context-help "ON" "OFF"))))

(defun rgr/context-help ()
  "Display function or variable at point in *Help* buffer if visible.
Default behaviour can be turned off by setting the buffer local
context-help to false"
  (interactive)
  (let ((rgr-symbol (symbol-at-point))) ; symbol-at-point http://www.emacswiki.org/cgi-bin/wiki/thingatpt%2B.el
    (with-current-buffer (help-buffer)
      (unless (local-variable-p 'context-help)
        (set (make-local-variable 'context-help) t))
      (if (and context-help (get-buffer-window (help-buffer))
               rgr-symbol)
          (if (fboundp  rgr-symbol)
              (describe-function rgr-symbol)
            (if (boundp  rgr-symbol) (describe-variable rgr-symbol)))))))

(defadvice eldoc-print-current-symbol-info
  (around eldoc-show-c-tag activate)
  (if (memq major-mode
            '(emacs-lisp-mode
              lisp-interaction-mode
              apropos-mode))
      (rgr/context-help))
  ad-do-it)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Compilation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'compilation-mode-hook 'my-compilation-mode-hook)
(defun my-compilation-mode-hook ()
  (local-set-key (kbd "n") 'compilation-next-error)
  (local-set-key (kbd "p") 'compilation-previous-error))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Emacs Lisp

(add-hook 'emacs-lisp-mode-hook 'my-emacs-lisp-mode-hook)
(defun my-emacs-lisp-mode-hook ()
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
  (idle-highlight)
  (setq indent-tabs-mode nil))
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

(setq web-mode-autocompletes nil)

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

;; Javascript
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.min\\.js\\'" . fundamental-mode))

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
(add-hook 'sql-interactive-mode-hook 'my-sql-interactive-mode-hook)
(defun my-sql-interactive-mode-hook ()
  (abbrev-mode 1)
  (setq show-trailing-whitespace nil))

(define-abbrev-table 'sql-mode-abbrev-table
  (mapcar (lambda (v) (list v (upcase v) nil 1))
          '("absolute" "action" "add" "after" "all" "allocate" "alter" "and" "any" "are" "array" "as" "asc" "asensitive" "assertion" "asymmetric" "at" "atomic" "authorization" "avg" "before" "begin" "between" "bigint" "binary" "bit" "bitlength" "blob" "boolean" "both" "breadth" "by" "call" "called" "cascade" "cascaded" "case" "cast" "catalog" "char" "char_length" "character" "character_length" "check" "clob" "close" "coalesce" "collate" "collation" "column" "commit" "condition" "connect" "connection" "constraint" "constraints" "constructor" "contains" "continue" "convert" "corresponding" "count" "create" "cross" "cube" "current" "current_date" "current_default_transform_group" "current_path" "current_role" "current_time" "current_timestamp" "current_transform_group_for_type" "current_user" "cursor" "cycle" "data" "date" "day" "deallocate" "dec" "decimal" "declare" "default" "deferrable" "deferred" "delete" "depth" "deref" "desc" "describe" "descriptor" "deterministic" "diagnostics" "disconnect" "distinct" "do" "domain" "double" "drop" "dynamic" "each" "element" "else" "elseif" "end" "equals" "escape" "except" "exception" "exec" "execute" "exists" "exit" "external" "extract" "false" "fetch" "filter" "first" "float" "for" "foreign" "found" "free" "from" "full" "function" "general" "get" "global" "go" "goto" "grant" "group" "grouping" "handler" "having" "hold" "hour" "identity" "if" "immediate" "in" "indicator" "initially" "inner" "inout" "input" "insensitive" "insert" "int" "integer" "intersect" "interval" "into" "is" "isolation" "iterate" "join" "key" "language" "large" "last" "lateral" "leading" "leave" "left" "level" "like" "local" "localtime" "localtimestamp" "locator" "loop" "lower" "map" "match" "map" "member" "merge" "method" "min" "minute" "modifies" "module" "month" "multiset" "names" "national" "natural" "nchar" "nclob" "new" "next" "no" "none" "not" "null" "nullif" "numeric" "object" "octet_length" "of" "old" "on" "only" "open" "option" "or" "order" "ordinality" "out" "outer" "output" "over" "overlaps" "pad" "parameter" "partial" "partition" "path" "position" "precision" "prepare" "preserve" "primary" "prior" "privileges" "procedure" "public" "range" "read" "reads" "real" "recursive" "ref" "references" "referencing" "relative" "release" "repeat" "resignal" "restrict" "result" "return" "returns" "revoke" "right" "role" "rollback" "rollup" "routine" "row" "rows" "savepoint" "schema" "scope" "scroll" "search" "second" "section" "select" "sensitive" "session" "session_user" "set" "sets" "signal" "similar" "size" "smallint" "some" "space" "specific" "specifictype" "sql" "sqlcode" "sqlerror" "sqlexception" "sqlstate" "sqlwarning" "start" "state" "static" "submultiset" "substring" "sum" "symmetric" "system" "system_user" "table" "tablesample" "temporary" "then" "time" "timestamp" "timezone_hour" "timezone_minute" "to" "trailing" "transaction" "translate" "translation" "treat" "trigger" "trim" "true" "under" "undo" "union" "unique" "unknown" "unnest" "until" "update" "upper" "usage" "user" "using" "value" "values" "varchar" "varying" "view" "when" "whenever" "where" "while" "window" "with" "within" "without" "work" "write" "year" "zone")))

;; Python / Plone / Zope
(require 'my-python)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-programming)
