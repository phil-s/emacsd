;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Indentation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Generate a tab-stop-list using multiples of tab-width
(defun generate-tab-stop-list ()
  "Generate a tab-stop-list based upon tab-width."
  (let ((tab-stops (/ 200 tab-width)))
    (number-sequence tab-width (* tab-width tab-stops) tab-width)))

;; Redefine tab-stop-list if tab-width is modified
(defadvice set-variable (after after-set-variable-regenerate-tab-stop-list)
  "Re-generate tab-stop-list when tab-width is modified."
  (if (equal (symbol-name (ad-get-arg 0)) "tab-width")
      (setq tab-stop-list (generate-tab-stop-list))))
(ad-activate 'set-variable)

;; ;; Redefine tab-stop-list if tab-width is modified
;; ;; (set-variable) calls (set). If we advise (set) and (setq),
;; ;; we'll have a comprehensive solution.
;; (defadvice set (after after-set-regenerate-tab-stop-list)
;;   "Re-generate tab-stop-list when tab-width is modified."
;;   (if (equal (symbol-name (ad-get-arg 0)) "tab-width")
;;       (setq tab-stop-list (generate-tab-stop-list))))
;; (ad-activate 'set)

;; ;; (defadvice setq (after after-setq-regenerate-tab-stop-list)
;; ;;   "Re-generate tab-stop-list when tab-width is modified."
;; ;;   (if (equal (symbol-name (ad-get-arg 0)) "tab-width")
;; ;;       (setq tab-stop-list (generate-tab-stop-list))))
;; ;; (ad-activate 'setq)

;; Use tab-width 4 by default
(set-default 'tab-width 4)
(set-variable 'tab-width 4) ; to invoke after-set-variable-regenerate-tab-stop-list

;; tab-width is already buffer-local
;; tab-stop-list needs to be likewise, otherwise
;; indentation could start mixing spaces and tabs
;; if a global tab-stop-list interacts with a local
;; tab-width.
;;
;; Do this AFTER setting tab-width, so that the default value
;; for this var will align with the default value of tab-width.
(make-variable-buffer-local 'tab-stop-list)

;; TODO do I need to advise (setq)? (set-default)?

;; Disallow tabs in elisp indentation (it mixes tabs and spaces)
(add-hook 'emacs-lisp-mode-hook '(lambda () (set-variable 'indent-tabs-mode nil)))

;; Smart Tabs does the Right Thing when I press the TAB key
(require 'smart-tab)
(global-smart-tab-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-indentation)
