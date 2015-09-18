;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Indentation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Notes:
;; visual-line-mode
;; adaptive-wrap-prefix-mode
;; redshift-indent-mode

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

;; That's a little ridiculous in retrospect. Just make a custom
;; function and/or binding for setting tab-width and remember to
;; use it! (C-z C-i ?)

;; An enhancement might be to compare the tab width to the tab-stop
;; list after the local variables have been determined, and
;; re-configure if necessary at that stage.

;; Use tab-width 4 by default
(set-default 'tab-width 4)
(setq tab-width 4)
(setq tab-stop-list (generate-tab-stop-list))
;; See also the above advice `after-set-variable-regenerate-tab-stop-list'

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
;; No. Absolutely NOT a feasible approach. Give up on this idea.

;; Disallow tabs in elisp indentation (it mixes tabs and spaces)
(add-hook 'emacs-lisp-mode-hook '(lambda () (set-variable 'indent-tabs-mode nil)))
;; (triggers the advice, but ew. just call a custom function.)

;; Smart Tabs (usually) does the Right Thing when I press the TAB key
(eval-when-compile
  (declare-function global-smart-tab-mode "smart-tab"))
(when (require 'smart-tab nil 'noerror)
  ;; ;; Completion can be annoying. Go with indentation only.
  ;; (global-set-key (kbd "TAB") 'smart-tab-default)
  ;; (global-set-key (kbd "<tab>") 'smart-tab-default)
  ;; ;; This being the case, do I even want smart-tab??
  ;; ;; n.b. without smart-tab, TAB will currently be bound to yas/expand)
  (global-smart-tab-mode 1))

(defvar my-global-smart-tab-major-mode-exceptions
  '(org-mode term-mode shell-mode eshell-mode erc-mode Custom-mode eww-mode
             markdown-mode)
  "List of major modes for which `smart-tab-mode' should not be enabled.")

;; Smart Tabs occasionally does the Wrong Thing,
;; so disable smart-tab-mode for certain major modes
(defadvice smart-tab-mode-on
  (around disable-smart-tab-for-modes)
  "Disable `smart-tab-mode' in the specified major modes,
to counter-act `global-smart-tab-mode'."
  (unless (memq major-mode
                my-global-smart-tab-major-mode-exceptions)
    ad-do-it))
(ad-activate 'smart-tab-mode-on)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-indentation)
