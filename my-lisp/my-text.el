;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Text modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Silence compiler warnings
(eval-when-compile
  (defvar adaptive-wrap-prefix-mode)
  (defvar deft-auto-save-interval)
  (defvar deft-directory)
  (defvar deft-extension)
  (defvar deft-text-mode)
  )

;; Intuitive word wrapping.
(defun my-adaptive-visual-line-mode (&optional arg)
  ;; Not a real minor mode.
  "Toggles both `visual-line-mode' and `adaptive-wrap-prefix-mode'.

Enable both modes if either/both are currently disabled or if ARG
is positive; otherwise if both are currently enabled or if ARG is
zero or negative, then disable both modes."
  (interactive "P")
  (require 'adaptive-wrap-prefix-mode nil :noerror)
  (let ((state (if arg
                   (prefix-numeric-value arg)
                 (if (and visual-line-mode
                          (or (not (boundp 'adaptive-wrap-prefix-mode))
                              adaptive-wrap-prefix-mode))
                     0 1))))
    (visual-line-mode state)
    (when (fboundp 'adaptive-wrap-prefix-mode)
      (adaptive-wrap-prefix-mode state))))

(require 'delight)
(delight '((adaptive-wrap-prefix-mode "" adaptive-wrap)
           (visual-line-mode
            (adaptive-wrap-prefix-mode " AWrap" " Wrap")
            simple)))

;; PDFs
(defun my-pdf-tools-install ()
  "Initialise `pdf-tools' if the package is installed."
  (and (fboundp 'pdf-tools-install)
       (pdf-tools-install)))

(add-hook 'doc-view-mode-hook #'my-pdf-tools-install)

;; CSV mode
(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(autoload 'csv-mode "csv-mode"
  "Major mode for editing comma-separated value files." t)

;; ;; Enable spelling correction
;; (add-hook 'text-mode-hook 'my-text-mode-hook)
;; (defun my-text-mode-hook ()
;;   (flyspell-mode t))

;; Deft
(setq deft-directory (expand-file-name "~/notes/")
      deft-extension "org"
      deft-text-mode 'org-mode
      deft-auto-save-interval 5.0)
(defun my-deft-mode-hook ()
  (local-set-key (kbd "M-RET") 'deft-new-file-named)
  (local-set-key (kbd "C-c f") 'deft-find-file))
(add-hook 'deft-mode-hook 'my-deft-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-text)
