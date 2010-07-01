;;
;; Whitespace
;;

;; Highlight trailing whitespace by default
(setq-default show-trailing-whitespace t)
(global-set-key (kbd "C-x M-w") 'toggle-show-trailing-whitespace)

(global-set-key (kbd "C-x M-C-S-w") 'strip-trailing-whitespace)
;(global-set-key (kbd "C-x M-w") 'toggle-whitespace-mode)

;(global-whitespace-mode t)
;(setq whitespace-space-regexp "\\(  +\\)")
;(setq whitespace-style (quote (tabs spaces trailing lines space-before-tab newline indentation empty space-after-tab tab-mark newline-mark)))

;; Strip trailing whitespace
(defun strip-trailing-whitespace ()
  "Remove trailing spaces and tabs from lines."
  (interactive "*")
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "[ \t]+$" nil t)
      (replace-match "" nil nil))))

(defun toggle-show-trailing-whitespace ()
  "Toggle the show-trailing-whitespace variable."
  (interactive)
  (set-variable 'show-trailing-whitespace (not show-trailing-whitespace)))

(defun hide-trailing-whitespace ()
  "Do not highlight trailing whitespace."
  (setq show-trailing-whitespace nil))

;(defun toggle-whitespace-mode ()
;  "Toggle whitespace-mode."
;  (interactive)
;  (whitespace-mode (not (or whitespace-mode global-whitespace-mode))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-whitespace)

