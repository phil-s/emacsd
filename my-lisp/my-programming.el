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
  ;;(whitespace-mode 1)
  ;;(turn-on-fic-mode)
  ;;(imenu-add-menubar-index)
  )

(mapc
 (lambda (language-mode-hook)
   (add-hook language-mode-hook 'my-coding-config))
 '(cperl-mode-hook
   css-mode-hook
   emacs-lisp-mode-hook
   ielm-mode-hook
   js-mode-hook
   lisp-interaction-mode-hook
   perl-mode-hook
   php-mode-hook
   python-mode-hook
   sh-mode-hook))

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
    (if (setq context-help (not context-help))
        (progn
          (if (not (get-buffer-window (help-buffer)))
              (display-buffer (help-buffer)))))
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
;; Modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Emacs Lisp

;; Parenthesis / sexp matching
(add-hook 'emacs-lisp-mode-hook 'my-emacs-lisp-mode-hook)
(defun my-emacs-lisp-mode-hook ()
  (require 'bytecomp)
  (add-hook 'after-save-hook 'my-auto-byte-recompile nil t)
  (when (require 'hl-sexp nil 'noerror)
    (hl-sexp-mode 1)))

(defun my-auto-byte-recompile ()
  "Byte compile if a corresponding .elc file already exists.
Use as a buffer-local after-save-hook, for emacs-lisp-mode buffers."
  (when (file-exists-p (byte-compile-dest-file buffer-file-name))
    (byte-compile-file buffer-file-name)))

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
      (if (or (string-match "\\.tpl.php\\'" (buffer-file-name))
              (string-match "\\.pt\\'" (buffer-file-name)))
          (rng-validate-mode 0))))
(add-hook 'nxml-mode-hook 'my-templates-nxml-mode-hook)

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


;; HTML ;;/ ASP / VBSCRIPT
;;(add-to-list 'auto-mode-alist '("\\.html\\'" . html-helper-mode))
;;(add-hook 'html-helper-load-hook (lambda () (require 'visual-basic-mode)))
(add-hook 'html-helper-load-hook (lambda () (require 'html-font nil 'noerror)))
(add-hook 'html-helper-mode-hook (lambda () (font-lock-mode 1)))


;; Wrap-region minor mode for mark-up
(autoload 'wrap-region-mode "wrap-region" "Wrap region with stuff." t)


;; JavaScript
(autoload 'javascript-mode "javascript" nil t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))

;; PHP (see my-php.el)
(autoload 'php-mode "my-php" "PHP Mode." t)
(add-to-list 'auto-mode-alist '("\\.\\(php\\|inc\\)\\'" . php-mode))
;;(add-to-list 'auto-mode-alist '("\\.php[34]?\\'\\|\\.phtml\\'" . php-mode))

;; Drupal mode (see my-php.el)
(autoload 'drupal-mode "my-php" "Drupal Mode." t)
(add-to-list 'auto-mode-alist '("\\.\\(module\\|test\\|install\\|theme\\|engine\\)\\'" . drupal-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . nxml-mode))
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

;; Python / Plone / Zope
(require 'my-python)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-programming)
