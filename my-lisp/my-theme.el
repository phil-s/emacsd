;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Colour theme and faces
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Disable mumamo chunk background colours
(setq mumamo-background-colors nil)

;; Color theme - Zenburn
;; http://www.emacswiki.org/emacs/ColorThemeZenburn
(when (require 'zenburn-theme nil t)

  ;; hl-sexp-mode
  ;; See my-programming.el
  (when (require 'hl-sexp nil 'noerror)
    (set-face-background 'hl-sexp-face "#090909"))

  ;; Initialise zenburn
  (load-theme 'zenburn t)

  ;; Changes to Zenburn defaults
  ;; hl-line-mode
  (set-face-background hl-line-face "#333333")

  ;; Magit customisation.
  (eval-after-load "magit"
    '(progn
       (set-face-foreground 'magit-section-heading "LemonChiffon")))

  ;; StackExchange (sx library)
  ;; (plist-get (symbol-plist 'sx-question-mode-kbd-tag) 'face-defface-spec)
  (eval-after-load "sx-question-print"
    '(when (symbol-plist 'sx-question-mode-kbd-tag)
       (set-face-attribute
        'sx-question-mode-kbd-tag nil
        :box nil
        :height 1.0
        :weight 'normal
        :foreground "LightGoldenrod1"))) ;; or yellow2 ?

  ;; end of zenburn-theme config
  )

;; Don't set the default font in (custom-set-faces), because it makes
;; things super-funky during initialisation if that font doesn't exist
;; on the system.

;; WARNING: Is this safe? See (custom-set-faces) call in init.el:
;; "Your init file should contain only one such instance.
;; If there is more than one, they won't work right."
(when (equal emacs-major-version 23) ; no longer default
  (cond
   ((eq system-type 'gnu/linux)
    (apply 'custom-theme-set-faces 'user '(default ((t (:slant normal :weight normal :height 121 :width normal :foundry "unknown" :family "Droid Sans Mono Dotted"))))))

   ;; Win32 NTEmacs
   ((eq system-type 'windows-nt)
    (apply 'custom-theme-set-faces 'user '(default ((t (:slant normal :weight normal :height 120 :width normal :foundry "outline" :family "Courier New"))))))
   ))

;; This magic means we fall back to Symbola for all missing unicode glyphs.
;; For Debian: apt-get install ttf-ancient-fonts
(set-fontset-font "fontset-default" nil (font-spec :size 20 :name "Symbola:"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-alt-theme ()
  "A really obviously different theme, for when I need it."
  (interactive)
  (disable-theme 'zenburn)
  ;;(load-theme 'light-blue t)
  (load-theme 'deeper-blue t)
  (eval-after-load "whitespace"
    '(custom-theme-set-faces
      'deeper-blue
      '(whitespace-space ((t . (:foreground "grey16"))) t)
      '(whitespace-newline ((t . (:foreground "grey16"))) t)))
  ;; (eval-after-load "magit"
  ;;   '(progn
  ;;      (set-face-background 'magit-item-highlight "blue4")
  ;;      (set-face-foreground 'magit-item-highlight nil)
  ;;      (set-face-underline 'magit-item-highlight nil)
  ;;      (set-face-attribute 'magit-item-highlight nil :inherit nil)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-theme)
