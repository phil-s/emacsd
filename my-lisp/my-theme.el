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


;; In Win32 NTEmacs, customize the default font
(when (eq system-type 'windows-nt)
  (apply 'custom-theme-set-faces 'user '(default ((t (:inherit nil :stipple nil :background "#3f3f3f" :foreground "#dcdccc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "outline" :family "Courier New")))))
  ;; WARNING:
  ;; This is a hack. See (custom-set-faces) call in init.el:
  ;; "Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right."
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-theme)
