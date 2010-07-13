;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Colour theme and faces
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Disable mumamo chunk background colours
(setq mumamo-background-colors nil)


;; hl-sexp-mode
;; See my-programming.el
(set-face-background 'hl-sexp-face "#090909")

;;
;; Color theme - Zenburn
;;

(add-to-list 'load-path
             (file-name-as-directory (expand-file-name
                                      "~/.emacs.d/lisp/color-theme")))

;; http://www.emacswiki.org/emacs/ColorThemeZenburn
(require 'zenburn)
(color-theme-zenburn)

;;
;; Changes to Zenburn defaults
;;

;; hl-line-mode
(set-face-background 'hl-line "#333333")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-theme)
