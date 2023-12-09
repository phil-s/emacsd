;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Colour theme and faces
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Notes on "light" and "dark" terminal themes
;; --------------------------------------------
;; Have a look at the code for `frame-set-background-mode' and
;; `frame-terminal-default-bg-mode'.
;;
;; The latter "checks the ‘frame-background-mode’ variable, the X
;; resource named "backgroundMode" (if FRAME is an X frame), and
;; finally the ‘background-mode’ terminal parameter."
;;
;; Customize the `frame-background-mode' user option to enforce a
;; value.
;;
;; Individual terminals/emulators are handled via the various files
;; in the "lisp/term/" directory; e.g.:
;; "/usr/local/share/emacs/27.2/lisp/term/" (but depending on how
;; Emacs is installed); or else refer to
;; https://git.savannah.gnu.org/cgit/emacs.git/tree/lisp/term
;;
;; See the README file in that directory for details of how Emacs
;; selects which of those files to load.  Once you've established
;; which file is in use, you would need to read the code to see how
;; backgrounds are established, as functionality can vary between
;; terminals.


;; Silence compiler warnings
(eval-when-compile
  (defvar hl-line-face)
  (defvar mumamo-background-colors)
  )

;; Disable mumamo chunk background colours
(setq mumamo-background-colors nil)

;; Color theme - Zenburn
;; https://www.emacswiki.org/emacs/ColorThemeZenburn
(when (require 'zenburn-theme nil t)

  ;; Initialise zenburn
  (load-theme 'zenburn t)
  ;; Custom changes to Zenburn defaults...
  (setq frame-background-mode 'dark)

  ;; Make errors slightly less red for a nicer zenburn contrast.
  (set-face-foreground 'error "orangered")

  ;; `display-fill-column-indicator-mode' (27+).
  (when (facep 'fill-column-indicator)
    (set-face-attribute 'fill-column-indicator nil :foreground "grey27"))

  ;; Set zenburn-friendly colours for ansi-color-* faces.
  (with-eval-after-load "ansi-color"
    (dolist (map '((blue . "SteelBlue1")
                   (green . "OliveDrab2")
                   (red . "OrangeRed")))
      (let ((face (intern (concat "ansi-color-" (symbol-name (car map)))))
            (colour (cdr map)))
        (set-face-foreground face colour)
        (set-face-background face colour))))

  (with-eval-after-load "hl-sexp"
    (set-face-background 'hl-sexp-face "#383838")) ;; "#090909"

  (with-eval-after-load "hl-line"
    (set-face-background hl-line-face "#333333"))

  (with-eval-after-load "magit"
    (set-face-foreground 'magit-section-heading "LemonChiffon")
    (set-face-foreground 'magit-mode-line-process "yellow"))

  (with-eval-after-load "visible-mark"
    (set-face-foreground 'visible-mark-active "white")
    (set-face-background 'visible-mark-active "firebrick3")
    (set-face-background 'visible-mark-face1 "DarkRed")
    (set-face-background 'visible-mark-face2 "DarkOrange4"))

  (with-eval-after-load "whitespace"
    (set-face-attribute 'whitespace-space nil
                        :foreground "grey30"
                        :background 'unspecified))

  ;; StackExchange (sx library)
  ;; (plist-get (symbol-plist 'sx-question-mode-kbd-tag) 'face-defface-spec)
  (with-eval-after-load "sx-question-print"
    (when (symbol-plist 'sx-question-mode-kbd-tag)
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
(custom-set-faces
 '(default ((t (:height 120 :family "Droid Sans Mono Dotted")))))

;; This magic means we fall back to Symbola for all missing unicode glyphs.
;; For Debian: apt-get install ttf-ancient-fonts
(set-fontset-font "fontset-default" nil (font-spec :size 20 :name "Symbola:"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-alt-theme ()
  "A really obviously-different theme, for when I need it."
  (interactive)
  (disable-theme 'zenburn)
  ;;(load-theme 'light-blue t)
  (load-theme 'deeper-blue t)
  (with-eval-after-load "whitespace"
    (custom-theme-set-faces
     'deeper-blue
     '(whitespace-space ((t . (:foreground "grey16"))) t)
     '(whitespace-newline ((t . (:foreground "grey16"))) t)))
  ;; (with-eval-after-load "magit"
  ;;   (set-face-background 'magit-item-highlight "blue4")
  ;;   (set-face-foreground 'magit-item-highlight nil)
  ;;   (set-face-underline 'magit-item-highlight nil)
  ;;   (set-face-attribute 'magit-item-highlight nil :inherit nil))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-theme)
