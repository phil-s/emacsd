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

;; Enable smart-tabs support.
(smart-tabs-insinuate
 'c 'c++ 'java 'javascript 'cperl 'python 'ruby 'nxml)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-indentation)
