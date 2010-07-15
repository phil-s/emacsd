;;;; python-mode-1.0
;;(setq load-path (append load-path (list "c:/emacs/emacs-23.1/site-lisp/python-mode-1.0")))
;;(autoload 'python-mode "python-mode" "Python Mode." t)
;;(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;;(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; Zope / Plone
(add-to-list 'auto-mode-alist '("\\.zcml\\'" . nxml-mode))

;; ;; buildout
;; (define-derived-mode conf-buildout-mode conf-mode "Conf[Buildout]"
;;   "Conf Mode starter for Python Buildout files.
;; Comments start with `#', and may ONLY appear on the first character of a line.
;; For details see `conf-mode'."
;;   (conf-mode-initialize "#"))


;;;; python-mode.el
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(setq interpreter-mode-alist (cons '("python" . python-mode)
                                   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)
(add-hook 'python-mode-hook 'my-python-mode-hook)

(defun my-python-mode-hook ()
  (hide-trailing-whitespace)
  (setq indent-tabs-mode nil)

  ;; (require 'flymake)

  ;; (make-local-variable 'find-file-hook)
  ;; (add-hook 'find-file-hook 'flymake-find-file-hook)

  ;; (make-local-variable 'flymake-allowed-file-name-masks)
  ;; (if (boundp 'flymake-allowed-file-name-masks)
  ;;     (add-to-list 'flymake-allowed-file-name-masks
  ;;                  '("\\.py\\'" flymake-pyflakes-init))
  ;;   (setq flymake-allowed-file-name-masks
  ;;         '("\\.py\\'" flymake-pyflakes-init)))
  )

;; ;; Flymake with pyflakes
;; (eval-after-load "flymake"
;;   (progn
;;     (message "Hello, world... boo!")
;;     (defun flymake-pyflakes-init ()
;;       (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                          'flymake-create-temp-inplace))
;;              (local-file (file-relative-name
;;                           temp-file
;;                           (file-name-directory buffer-file-name))))
;;         (list "pyflakes" (list local-file))))
;;     ))

;;;; ipython

(setq ipython-command "/usr/bin/ipython")
(require 'ipython)
(global-set-key [(f6)] 'ipython-complete)

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


;; Support pdbtrack over TRAMP
(defadvice py-pdbtrack-get-source-buffer (around py-pdbtrack-tramp-device activate)
  "Prefix the tramp device to the file path in pdbtrack."
  (let ((block (ad-get-arg 0)))
    (if (string-match py-pdbtrack-stack-entry-regexp block)
        (let ((newblock
               (replace-regexp-in-string
                py-pdbtrack-stack-entry-regexp
                (concat
                 "> "
                 (tramp-make-tramp-file-name ; WARNING:
                  tramp-current-method       ; These variables are the most recently-generated
                  tramp-current-user         ; values. Accessing a new server via TRAMP will
                  tramp-current-host         ; cause them to change, and break pdbtracking.
                  (match-string 1 block))    ; (It should be possible to solve this, but I don't
                 "(\\2)\\3()")               ; want to spend time investigating that right now...)
                block)))
          (ad-set-arg 0 newblock)
          ad-do-it))))

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

(provide 'my-python)

