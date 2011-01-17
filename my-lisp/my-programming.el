;;;; ;; directory-local config
;;;;
;;;; (add-hook 'nxml-mode-hook 'my-nxml-mode-hook)
;;;; (defun my-nxml-mode-hook ()
;;;;   (if (buffer-file-name)
;;;;       (if (string-match "\\.tpl.php\\'" (buffer-file-name))
;;;;           (rng-validate-mode 0))))
;;;;
;;;; ;; (defun my-dir-locals-php-hook ()
;;;; ;;   (and (buffer-file-name)
;;;; ;;        (string-match "\\.php\\'" (buffer-file-name))
;;;; ;;        (cdr (assoc 'drupal-p dir-local-variables-alist))
;;;; ;;        (my--drupal-mode)))
;;;; ;; (add-hook 'php-mode-hook 'my-dir-locals-php-hook t)
;;;;
;;;; (dir-locals-set-class-variables
;;;;  'drupal
;;;;  '((nil . ((indent-tabs-mode . nil)
;;;;            (fill-column . 80)))
;;;;    (php-mode . ((drupal-p . t)))
;;;;    ))
;;;;
;;;; (dir-locals-set-directory-class "//lucas/sites/" 'drupal)
;;;; (dir-locals-set-directory-class "//sagan/sites/" 'drupal)
;;;; (dir-locals-set-directory-class "//welles/sites/" 'drupal)
;;;;
;;;;
;;;;
;;;; (dir-locals-set-class-variables
;;;;  'plone-core
;;;;  '((nil . ((buffer-read-only . t)))))
;;;;
;;;; (dir-locals-set-class-variables
;;;;  'plone-instance
;;;;  '((nil . ((indent-tabs-mode . nil)
;;;;            (fill-column . 80)))
;;;;    ;; (python-mode . (()))
;;;;    ;; (nxhtml-mode . (()))
;;;;    ))
;;;;
;;;; (dir-locals-set-directory-class
;;;;  "/scpc:phil@hnzc-dev-5:/home/phil/Plone/" 'plone-core)
;;;; (dir-locals-set-directory-class
;;;;  "/scpc:phil@hnzc-dev-5:/home/phil/hnzc-web/" 'plone-core)
;;;;
;;;; (dir-locals-set-directory-class
;;;;  "/scpc:phil@hnzc-dev-5:/home/phil/Plone/zinstance/" 'plone-instance)
;;;; (dir-locals-set-directory-class
;;;;  "/scpc:phil@hnzc-dev-5:/home/phil/Plone/hnzc/site/intranet/" 'plone-instance)
;;;; (dir-locals-set-directory-class
;;;;  "/scpc:phil@hnzc-dev-5:/home/phil/hnzc-web/website/" 'plone-instance)
;;;;
;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; (fset 'ipdb-set-trace
;;;;    (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([105 109 112 111 114 116 32 105 112 100 98 59 32 105 112 100 98 46 115 101 116 95 116 114 97 99 101 40 41] 0 "%d")) arg)))
;;;;
;;;; (defun my-local-python-hook ()
;;;;   (setq show-trailing-whitespace nil)
;;;;   (setq indent-tabs-mode nil)
;;;;   (local-set-key (kbd "C-x C-k i") 'ipdb-set-trace))
;;;;
;;;; (add-hook 'python-mode-hook 'my-local-python-hook)
;;;;
;;;; ;; Zope / Plone
;;;; (add-to-list 'auto-mode-alist '("\\.zcml\\'" . nxml-mode))
;;;; (add-to-list 'auto-mode-alist '("\\.pt\\'" . nxhtml-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;










;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Programming language support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-coding-config ()
  (make-local-variable 'column-number-mode)
  (column-number-mode t)
  (if window-system (hl-line-mode t))
  (idle-highlight)
  (turn-on-eldoc-mode)
  (setq indent-tabs-mode nil)
  ;;(whitespace-mode 1)
  ;;(turn-on-fic-mode)
  ;;(imenu-add-menubar-index)
  )

(mapcar
 #'(lambda (language-mode-hook)
     (add-hook language-mode-hook 'my-coding-config))
 '(cperl-mode-hook
   emacs-lisp-mode-hook
   ielm-mode-hook
   lisp-interaction-mode-hook
   perl-mode-hook
   php-mode-hook
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
(require 'hl-sexp)
(add-hook 'emacs-lisp-mode-hook
          #'(lambda () "Enable hl-sexp-mode" (hl-sexp-mode 1)))


;; Use cperl-mode instead of the default perl-mode
(defalias 'perl-mode 'cperl-mode)
(setq cperl-indent-level 4)


;; nXHTML
(load "nxhtml/autostart.el")

;; XML
(defun my-xml-hook ()
  (make-local-variable 'column-number-mode)
  (column-number-mode t)
  (if window-system (hl-line-mode t))
  (idle-highlight)
  (setq indent-tabs-mode nil))
(add-hook 'nxml-mode-hook 'my-xml-hook)

;; CSS
(add-hook 'css-mode-hook 'my-css-mode-hook)
(autoload 'rainbow-mode "rainbow" nil t)
(defun my-css-mode-hook ()
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
(add-to-list 'auto-mode-alist '("\\.html\\'" . html-helper-mode))
;;(add-to-list 'auto-mode-alist '("\\.html\\'" . html-helper-mode))
;;(add-hook 'html-helper-load-hook #'(lambda () (require 'visual-basic-mode)))
(add-hook 'html-helper-load-hook #'(lambda () (require 'html-font)))
(add-hook 'html-helper-mode-hook #'(lambda () (font-lock-mode 1)))


;; Wrap-region minor mode for mark-up
(autoload 'wrap-region-mode "wrap-region" "Wrap region with stuff." t)


;; JavaScript
(autoload 'javascript-mode "javascript" nil t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))


;; PHP (see my-php.el)
(autoload 'php-mode "my-php" "PHP Mode." t)
;;(add-to-list 'auto-mode-alist '("\\.php[34]?\\'\\|\\.phtml\\'" . php-mode))
;; (add-to-list 'auto-mode-alist '("\\.\\(php\\|inc\\)\\'" . drupal-mode))

;; Drupal mode (see my-php.el)
(autoload 'drupal-mode "my-php" "Drupal Mode." t)
(add-to-list 'auto-mode-alist '("\\.\\(module\\|test\\|install\\|theme\\)\\'" . drupal-mode))
(add-to-list 'auto-mode-alist '("\\.info" . conf-windows-mode))

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
