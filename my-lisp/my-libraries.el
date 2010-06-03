;; Local occur minor mode
;(require 'loccur)

(autoload 'loccur "loccur"
  "Perform a simple grep in current buffer for the regular
expression REGEX

This command hides all lines from the current buffer except those
containing the regular expression REGEX. A second call of the function
unhides lines again" t)
(autoload 'loccur-current "loccur" "Call `loccur' for the current word." t)
(autoload 'loccur-previous-match "loccur" "Call `loccur' for the previously found word." t)

(global-set-key (kbd "M-s l") 'loccur) ; interactive loccur command
(global-set-key (kbd "M-s C-l") 'loccur-current) ; loccur of the current word
(global-set-key (kbd "M-s C-S-l") 'loccur-previous-match) ; loccur of the previously-found word


;; Follow mode for compilation/output buffers
;; http://www.anc.ed.ac.uk/~stephen/emacs/fm.el
;(require 'fm)
;(add-hook 'occur-mode-hook 'fm-start)
;(add-hook 'compilation-mode-hook 'fm-start)


;; SVN (Subversion)
;;(require 'psvn)
;; Start the svn interface with M-x svn-status


;;; ;; Colour Theme
;;; (add-to-list 'load-path "~/lisp/color-theme/color-theme.el")
;;; ;;(require 'color-theme)
;;; ;;(eval-after-load "color-theme"
;;; ;;  '(progn
;;; ;;     (color-theme-initialize)
;;; ;;     (color-theme-hober)))
;;; (require 'zenburn)
;;; (unless (zenburn-format-spec-works-p)
;;;   (zenburn-define-format-spec))
;;; (eval-after-load "color-theme"
;;;   '(progn
;;;      (color-theme-initialize)
;;;      (color-theme-zenburn)))

(provide 'my-libraries)
