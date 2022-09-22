;;
;; Whitespace
;;

;; Notes:
;; visual-line-mode
;; adaptive-wrap-prefix-mode
;; redshift-indent-mode

;; Silence compiler warnings
(eval-when-compile
  (defvar whitespace-display-mappings)
  (defvar whitespace-style)
  (defvar ws-trim-global-modes)
  (declare-function global-ws-trim-mode "ws-trim")
  )

(defalias 'dw 'delete-trailing-whitespace)

;; Highlight trailing whitespace by default
(setq-default show-trailing-whitespace t)

;(global-set-key (kbd "C-x M-w") 'toggle-whitespace-mode)

;; (global-whitespace-mode t)
;; (setq whitespace-global-modes '(not org-mode))
;; (setq whitespace-space-regexp "\\(  +\\)")
;; (setq whitespace-style (quote (tabs spaces trailing lines space-before-tab newline indentation empty space-after-tab tab-mark newline-mark)))

;; make whitespace-mode use “¶” for newline,
;; together with the rest of its defaults
(setq whitespace-display-mappings
      '((space-mark 32 [183] [46])
        (space-mark 160 [164] [95])
        (space-mark 2208 [2212] [95])
        (space-mark 2336 [2340] [95])
        (space-mark 3616 [3620] [95])
        (space-mark 3872 [3876] [95])
        (newline-mark 10 [182 10]) ;non-default newline char
        (tab-mark 9 [187 9] [92 9])
        ))

;; One of my webmail clients inserts the glyphless WORD JOINER unicode
;; character after hyphens, which makes copying and pasting from email
;; liable to cause invisible problems :( e.g. glyphless-⁠char
;;
;; This makes any such characters apparent!
(set-face-background 'glyphless-char "red")

;; Use ws-trim mode to strip trailing whitespace automatically
;; from edited lines (the default ws-trim-level).
(when (require 'ws-trim nil 'noerror)
  (setq ws-trim-global-modes '(guess (not term-mode so-long-mode drush-php-mode)))
  (global-ws-trim-mode 1))

;; ;; Strip trailing whitespace.
;; ;; No need for this now; delete-trailing-whitespace is built in.
;; (defun strip-trailing-whitespace ()
;;   "Remove trailing spaces and tabs from lines."
;;   (interactive "*")
;;   (save-excursion
;;     (goto-char (point-min))
;;     (while (re-search-forward "[ \t]+$" nil t)
;;       (replace-match "" nil nil))))

(defun toggle-show-trailing-whitespace ()
  "Toggle the show-trailing-whitespace variable."
  (interactive)
  (setq show-trailing-whitespace (not show-trailing-whitespace)))

(defun hide-trailing-whitespace ()
  "Do not highlight trailing whitespace."
  (setq show-trailing-whitespace nil))

;; Hide trailing whitespace in all of the following modes.
(mapc (lambda (mode)
        (add-hook (intern (concat (symbol-name mode) "-mode-hook"))
                  'hide-trailing-whitespace))
      '(calendar
        cfw:calendar
        diary
        diary-fancy-display
        ediff-meta
        elfeed-search
        elpher
        erc
        eww
        geben-context
        help
        image-dired-display
        image-dired-thumbnail
        Info
        log-view
        magit
        magit-popup
        messages-buffer
        mu4e-headers
        mu4e-view
        org-agenda
        python
        sauron
        shell
        sql-interactive
        sx-compose
        sx-inbox
        sx-question
        sx-question-list
        term
        ztree))

;(defun toggle-whitespace-mode ()
;  "Toggle whitespace-mode."
;  (interactive)
;  (whitespace-mode (not (or whitespace-mode global-whitespace-mode))))

(defun my-ignore-whitespace-long-lines ()
  "Stop highlighting long lines in whitespace mode."
  (interactive)
  (when (boundp 'whitespace-style)
    (set (make-local-variable 'whitespace-style)
         (remq 'lines-tail (remq 'lines whitespace-style)))
    (when (fboundp 'whitespace-mode)
      (whitespace-mode 0)
      (whitespace-mode 1))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-whitespace)
