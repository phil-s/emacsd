;; -*- lexical-binding: nil; -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Colour theme and faces
;;
;; (Loaded in early-init.el!)
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


;; Prot's notes on customizing theme faces:
;; https://old.reddit.com/r/emacs/comments/1auhjpb/how_to_set_faces_using_dynamic_colors/


;; Not this.  Needs to be repeated after enabling the theme.
;; (custom-theme-set-faces 'modus-operandi '(hl-line ((t :background "cyan")) t "Mine"))
;; (custom-theme-set-faces 'modus-vivendi '(hl-line ((t :background "darkgreen")) t "Mine"))
;; (custom-theme-recalc-face 'hl-line)


;; Silence compiler warnings
(eval-when-compile
  (defvar hl-line-face)
  (defvar mumamo-background-colors)
  )

;; Disable mumamo chunk background colours
(setq mumamo-background-colors nil)

(defun my-zenburn-theme-config ()
  "Custom changes to Zenburn defaults."
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
    (set-face-background 'hl-sexp-face "#383838") ;; "#090909"
    (with-eval-after-load "paren"
      (set-face-attribute 'show-paren-match-expression nil
                          :background "#384848"
                          :extend t)))

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

;; Color theme - Zenburn
;; https://github.com/bbatsov/zenburn-emacs
(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/el-get/zenburn-theme"))
(with-demoted-errors "Error: %S"
  ;; (when (require-theme 'zenburn-theme t) ;; we would be loading it twice
  ;; (mapc #'disable-theme custom-enabled-themes) ;; will be nil
  (load-theme 'zenburn t)
  (my-zenburn-theme-config))

;; This magic means we fall back to Symbola for all missing unicode glyphs.
;; For Debian: apt-get install ttf-ancient-fonts
(set-fontset-font "fontset-default" nil (font-spec :size 20 :name "Symbola:"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-alt-theme ()
  "A really obviously-different theme, for when I need it."
  (interactive)
  (mapc #'disable-theme custom-enabled-themes)
  ;;(load-theme 'light-blue t)
  (load-theme 'deeper-blue t)
  (with-eval-after-load "whitespace"
    (custom-theme-set-faces
     'deeper-blue
     '(whitespace-space ((t . (:foreground "grey16"))) t)
     '(whitespace-newline ((t . (:foreground "grey16"))) t)
     ))
  ;; (with-eval-after-load "magit"
  ;;   (set-face-background 'magit-item-highlight "blue4")
  ;;   (set-face-foreground 'magit-item-highlight nil)
  ;;   (set-face-underline 'magit-item-highlight nil)
  ;;   (set-face-attribute 'magit-item-highlight nil :inherit nil))
  )

(defun my-replace-theme (theme &optional faces)
  "Replace current theme with THEME.
FACES is a list of face specs for `custom-theme-set-faces'."
  (mapc #'disable-theme custom-enabled-themes)
  (enable-theme theme)
  ;; Modus theme tweaks.
  (when (memq theme '(modus-operandi modus-vivendi))
    (dolist (face '(hl-line))
      (let* ((theme-face (cadr (assq theme (get face 'theme-face))))
             (face-spec (face-spec-choose theme-face))
             (background (plist-get face-spec :background)))
        (set-face-attribute 'hl-line nil :background background))))
  ;; Override certain faces.
  (when faces
    (apply #'custom-theme-set-faces theme faces)))

(defun my-theme-modus-operandi ()
  "Replace current theme with `modus-operandi'."
  (interactive)
  (require 'modus-operandi-theme)
  (my-replace-theme 'modus-operandi
                    '((hl-sexp-face ((t . (:background "#f3f3f3"))) t)
                      (tks-comment-face ((t . (:foreground "#3548cf"))) t)
                      (tks-date-face ((t . (:foregreound "#dc0c93"))) t)
                      (tks-description-face ((t . (:foregreound ""))) t)
                      (tks-time-face ((t . (:foregreound "#9c6903"))) t)
                      (tks-wr-face ((t . (:foregreound "#603f9f"))) t))))

(defun my-theme-modus-vivendi ()
  "Replace current theme with `modus-vivendi'."
  (interactive)
  (require 'modus-vivendi-theme)
  (my-replace-theme
   'modus-vivendi '((hl-sexp-face ((t . (:background "#172031"))) t))))

(defun my-theme-zenburn ()
  "Replace current theme with `zenburn'."
  (interactive)
  (require 'zenburn-theme)
  (my-replace-theme 'zenburn) ;; "#383838"
  (my-zenburn-theme-config))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-theme)
