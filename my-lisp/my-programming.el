;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Programming language support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-coding-hook ()
  (make-local-variable 'column-number-mode)
  (column-number-mode t)
  (if window-system (hl-line-mode t))
  (idle-highlight))

(add-hook 'cperl-mode-hook 'my-coding-hook)
(add-hook 'emacs-lisp-mode-hook 'my-coding-hook)
(add-hook 'ielm-mode-hook 'my-coding-hook)
(add-hook 'lisp-interaction-mode-hook 'my-coding-hook)
(add-hook 'perl-mode-hook 'my-coding-hook)
(add-hook 'php-mode-hook 'my-coding-hook)
(add-hook 'python-mode-hook 'my-coding-hook)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eldoc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(add-hook 'cperl-mode-hook 'turn-on-eldoc-mode)
(add-hook 'python-mode-hook 'turn-on-eldoc-mode)

;; Highlight the eldoc echo area text
(defun frob-eldoc-argument-list (string)
  "Upcase and fontify STRING for use with `eldoc-mode'."
  (propertize (upcase string)
              'face 'font-lock-variable-name-face))
(setq eldoc-argument-case 'frob-eldoc-argument-list)

;; Context-sensitive *Help* buffer
(global-set-key (kbd "C-c h") 'rgr/toggle-context-help)

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
  (cond
   ((eq major-mode 'emacs-lisp-mode) (rgr/context-help) ad-do-it)
   ((eq major-mode 'lisp-interaction-mode) (rgr/context-help) ad-do-it)
   ((eq major-mode 'apropos-mode) (rgr/context-help) ad-do-it)
   (t ad-do-it)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Emacs Lisp
;; ELisp debugger
(global-set-key (kbd "C-c d") 'debug-on-entry)
(global-set-key (kbd "C-c D") 'cancel-debug-on-entry)

;; Parenthesis / sexp matching
(require 'hl-sexp)
(add-hook 'emacs-lisp-mode-hook
          (function (lambda () "Enable hl-sexp-mode" (hl-sexp-mode 1))))


;; Use cperl-mode instead of the default perl-mode
(defalias 'perl-mode 'cperl-mode)
(setq cperl-indent-level 4)


;; nXHTML
(load "nxhtml/autostart.el")
;; OLD nXML CONFIG:
;; XML - nXMLmode
;(load "nxml-mode-20041004/rng-auto")
;(setq auto-mode-alist
;     (append '(("\\.\\(xml\\|xsl\\|rng\\|xhtml\\)\\'" . nxml-mode))
;           auto-mode-alist))


; ;; CSS
; ;; emacs-22.2 has its own CSS mode
; ;;
; (autoload 'css-mode "css-mode_shinn" "Mode for editing CSS files" t)
; ;;(autoload 'css-mode "css-mode_garshol" "Mode for editing CSS files" t)
; (setq auto-mode-alist
;        (append '(("\\.css$" . css-mode))
;                auto-mode-alist))
; (setq cssm-indent-function #'cssm-c-style-indenter)


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


;; HTML / ASP / VBSCRIPT
(setq auto-mode-alist (cons '("\\.html$" . html-helper-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.asp$" . html-helper-mode) auto-mode-alist))
(add-hook 'html-helper-load-hook '(lambda () (require 'visual-basic-mode)))
(add-hook 'html-helper-load-hook '(lambda () (require 'html-font)))
(add-hook 'html-helper-mode-hook '(lambda () (font-lock-mode 1)))

;; Wrap-region minor mode for mark-up
(autoload 'wrap-region-mode "wrap-region" "Wrap region with stuff." t)


;; JavaScript
(autoload 'javascript-mode "javascript" nil t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))


;; PHP (see my-php.el)
(require 'my-php)



;;;; Python

;;;; python-mode-1.0
;;(setq load-path (append load-path (list "c:/emacs/emacs-23.1/site-lisp/python-mode-1.0")))
;;(autoload 'python-mode "python-mode" "Python Mode." t)
;;(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;;(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; Zope / Plone
(add-to-list 'auto-mode-alist '("\\.zcml\\'" . nxml-mode))

;;;; python-mode.el
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
                                   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)
(add-hook 'python-mode-hook
          (function (lambda ()
                      (hide-trailing-whitespace)
                      (setq indent-tabs-mode nil))))

;		(setq ipython-command "/usr/bin/ipython")
;		(require 'ipython)
;		(global-set-key [(f6)] 'ipython-complete)

;; (defconst py-pdbtrack-input-prompt "\n[(<]*[Pp]db[>)]+ "
;;   "Regular expression pdbtrack uses to recognize a pdb prompt.")
;; (make-variable-buffer-local 'py-pdbtrack-input-prompt)
;; (add-hook 'shell-mode-hook
;;           (function (lambda()
;;                       (setq py-pdbtrack-input-prompt
;;                             "\n[(<]*[Ii]?[Pp]db[>)]+ "))))


;; Make the Python shell line-buffered
;; http://stackoverflow.com/questions/2881346/emacs-python-running-python-shell-in-line-buffered-vs-block-buffered-mode
(setenv "PYTHONUNBUFFERED" "x")

;		;; Support pdbtrack over TRAMP
;		(defadvice py-pdbtrack-get-source-buffer (around py-pdbtrack-tramp-device activate)
;		  "Prefix the tramp device to the file path in pdbtrack."
;		  (let ((block (ad-get-arg 0)))
;		    (if (string-match py-pdbtrack-stack-entry-regexp block)
;		        (let ((newblock
;		               (replace-regexp-in-string
;		                py-pdbtrack-stack-entry-regexp
;		                (concat
;		                 "> "
;		                 (tramp-make-tramp-file-name ; WARNING:
;		                  tramp-current-method       ; These variables are the most recently-generated
;		                  tramp-current-user         ; values. Accessing a new server via TRAMP will
;		                  tramp-current-host         ; cause them to change, and break pdbtracking.
;		                  (match-string 1 block))    ; (It should be possible to solve this, but I don't
;		                 "(\\2)\\3()")               ; want to spend time investigating that right now...)
;		                block)))
;		          (ad-set-arg 0 newblock)
;		          ad-do-it))))

;; (defun my-housing-shell-output-filter (string)
;;   "Add in TRAMP prefix for file paths."
;;   (when (string-match "^([> ]) (/home)" string)
;;     (setq string (replace-match "\1 /scpc:phil@hnzc-dev-5:\2" t t string))))





;;;; python.el
;;(autoload 'python-mode "python" "Python Mode." t)
;;(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;;(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;;;; Pylint
;;(autoload 'python-pylint "python-pylint")
;;(autoload 'pylint "python-pylint")
;;;; Pep8
;;(autoload 'python-pep8 "python-pep8")
;;(autoload 'pep8 "python-pep8")

;;;; PSGML mode (required by DTML mode)
(add-to-list 'load-path (file-name-as-directory (expand-file-name "~/.emacs.d/lisp/psgml-1.3.2")))

;;;; DTML (Zope)
(add-to-list 'load-path (file-name-as-directory (expand-file-name "~/.emacs.d/lisp/dtml-mode")))
(autoload 'dtml-mode "dtml-mode" "" t)
(add-to-list 'auto-mode-alist '("\\.dtml\\'" . dtml-mode))
(setq sgml-local-catalogs `(,(expand-file-name "~/.emacs.d/lisp/dtml-mode/dtml.catalog")))
(setq dtml-auto-insert-mode-declaration nil)
;;(autoload 'dtml-edit-via-ftp "dtml-mode" "" t)
;;(autoload 'dtml-browse-via-http "dtml-mode" "" t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-programming)

