;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Colour theme and faces
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Disable mumamo chunk background colours
(setq mumamo-background-colors nil)

;; Color theme - Zenburn
;; http://www.emacswiki.org/emacs/ColorThemeZenburn
(when (and (require 'color-theme nil t)
           (require 'zenburn nil t))

  ;; hl-sexp-mode
  ;; See my-programming.el
  (when (require 'hl-sexp nil 'noerror)
    (set-face-background 'hl-sexp-face "#090909"))

  ;; Initialise zenburn
  (color-theme-zenburn)

  ;; Changes to Zenburn defaults
  ;; hl-line-mode
  (set-face-background hl-line-face "#333333"))

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

(defun my-alt-theme ()
  "A really obviously different theme, for when I need it."
  (interactive)
  (color-theme-blue-mood)
  (eval-after-load "magit"
    '(progn
       (set-face-background 'magit-item-highlight "blue4")
       (set-face-foreground 'magit-item-highlight nil)
       (set-face-underline 'magit-item-highlight nil)
       (set-face-attribute 'magit-item-highlight nil :inherit nil))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-theme)
