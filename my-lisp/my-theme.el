;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Colour theme and faces
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Disable mumamo chunk background colours
(setq mumamo-background-colors nil)

;; hl-sexp-mode
;; See my-programming.el
(set-face-background 'hl-sexp-face "#090909")

;; Color theme - Zenburn
;; http://www.emacswiki.org/emacs/ColorThemeZenburn
(color-theme-zenburn)

;; Changes to Zenburn defaults
;; hl-line-mode
(set-face-background hl-line-face "#333333")

;; Don't set the default font in (custom-set-faces), because it makes
;; things super-funky during initialisation if that font doesn't exist
;; on the system.

;; WARNING: Is this safe? See (custom-set-faces) call in init.el:
;; "Your init file should contain only one such instance.
;; If there is more than one, they won't work right."
(when (equal emacs-major-version 23)
  (cond
   ;; GNU/Linux
   ;; apt-cache search "WenQuanYi Micro"
   ;; sudo apt-get install ttf-wqy-microhei
   ((eq system-type 'gnu/linux)
    (apply 'custom-theme-set-faces 'user '(default ((t (:inherit nil :stipple nil :background "#3f3f3f" :foreground "#dcdccc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 121 :width normal :foundry "unknown" :family "WenQuanYi Micro Hei Mono"))))))
   ;; Win32 NTEmacs
   ((eq system-type 'windows-nt)
    (apply 'custom-theme-set-faces 'user '(default ((t (:inherit nil :stipple nil :background "#3f3f3f" :foreground "#dcdccc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "outline" :family "Courier New"))))))
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-theme)
