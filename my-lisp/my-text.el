;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Text modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Silence compiler warnings
(eval-when-compile
  (defvar deft-auto-save-interval)
  (defvar deft-directory)
  (defvar deft-extension)
  (defvar deft-text-mode)
  )

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
