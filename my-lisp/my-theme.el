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

;; Silence compiler warnings
(eval-when-compile
  (defvar hl-line-face)
  (defvar mumamo-background-colors)
  )

;; Disable mumamo chunk background colours
(setq mumamo-background-colors nil)

(defface my-highlight-1 '((t :inherit dired-broken-symlink))
  "Readable highlighting for `highlight-regexp'.")

(defun my-theme-custom-faces-apply (theme faces)
  ;; Must be defined before it's called.
  "Make FACES for THEME take effect."
  (apply #'custom-theme-set-faces theme faces)
  (dolist (spec faces)
    (custom-theme-recalc-face (car spec))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Color theme - Zenburn
;; https://github.com/bbatsov/zenburn-emacs

(defun my-zenburn-theme-config ()
  "Custom changes to Zenburn defaults."
  (setq frame-background-mode 'dark)

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

(defun my-theme-custom-faces-for-zenburn ()
  "Equivalent to (custom-set-faces ...) but only for zenburn."
  (my-theme-custom-faces-apply
   'zenburn
   (list
    ;; Can copy these verbatim from `custom-set-faces' arguments.
    '(ansi-color-blue ((t (:background "SteelBlue1" :foreground "SteelBlue1"))))
    '(ansi-color-green ((t (:background "OliveDrab2" :foreground "OliveDrab2"))))
    '(ansi-color-red ((t (:background "OrangeRed" :foreground "OrangeRed"))))
    '(cfw:face-title ((t (:inherit variable-pitch :foreground "darkgoldenrod3" :weight bold))))
    '(cfw:face-toolbar ((t nil)))
    '(cfw:face-toolbar-button-off ((t (:foreground "Gray8" :weight bold))))
    '(cfw:face-toolbar-button-on ((t (:foreground "Gray65" :weight bold))))
    '(diff-hl-change ((t (:background "#4f4f7f" :foreground "#5f5fff"))))
    '(diff-hl-delete ((t (:background "#7f4f4f" :foreground "#964f6f"))))
    '(diff-hl-insert ((t (:background "#4f664f" :foreground "#4f7f4f"))))
    '(diff-refine-added ((t (:inherit diff-refine-change :background "#228822"))))
    '(ediff-current-diff-C ((t (:background "#888833" :foreground "#333333"))))
    '(ediff-fine-diff-B ((t (:background "#22aa22" :foreground "#333333"))))
    '(error ((t (:foreground "orangered"))))
    '(fill-column-indicator ((t (:foreground "grey27"))))
    '(ement-room-mention ((t (:extend t :background "grey12"))))
    '(ement-room-message-text ((t (:inherit variable-pitch))))
    '(ement-room-timestamp ((t (:inherit font-lock-comment-face :foreground "grey50" :height 0.8))))
    '(ement-room-timestamp-header ((t (:inherit header-line :foreground "darkorange" :weight bold :height 1.1))))
    '(ement-room-user ((t (:inherit (font-lock-function-name-face variable-pitch) :overline nil :weight bold))))
    '(highlight ((t (:background "#386868"))))
    '(hl-line ((t (:extend t :background "#303030"))))
    '(hl-sexp-face ((t (:background "#383838"))))
    '(magit-diff-added ((t (:extend t :background "#335533" :foreground "#ddffdd"))))
    '(magit-diff-added-highlight ((t (:extend t :background "#336633" :foreground "#cceecc"))))
    '(magit-diff-base ((t (:extend t :background "#555522" :foreground "#ffffcc"))))
    '(magit-diff-base-highlight ((t (:extend t :background "#666622" :foreground "#eeeebb"))))
    '(magit-diff-context-highlight ((t (:background "#4e5b7b" :foreground "grey70"))))
    '(magit-diff-hunk-heading ((t (:background "DodgerBlue4" :foreground "grey70"))))
    '(magit-diff-hunk-heading-highlight ((t (:background "DodgerBlue3" :foreground "grey70"))))
    '(magit-diff-hunk-region ((t (:inherit bold :extend t))))
    '(magit-diff-lines-heading ((t (:extend t :background "#DFAF8F" :foreground "#5F5F5F"))))
    '(magit-diff-removed ((t (:extend t :background "#553333" :foreground "#ffdddd"))))
    '(magit-diff-removed-highlight ((t (:extend t :background "#663333" :foreground "#eecccc"))))
    '(magit-diff-revision-summary ((t (:inherit bold))))
    '(magit-item-highlight ((t (:background "#4f4f4f"))))
    '(magit-mode-line-process ((t (:foreground "yellow"))))
    '(magit-section-heading ((t (:foreground "LemonChiffon"))))
    '(magit-tag ((t (:background "LemonChiffon1" :foreground "black"))))
    '(mu4e-header-face ((t (:foundry "GOOG" :family "Noto Sans Mono" :width semi-condensed))))
    '(mu4e-header-highlight-face ((t (:inherit (hl-line mu4e-header-face) :extend t :underline t :weight bold))))
    '(mu4e-header-marks-face ((t (:inherit (font-lock-preprocessor-face mu4e-header-face)))))
    '(mu4e-header-title-face ((t (:inherit (font-lock-type-face mu4e-header-face)))))
    '(mu4e-draft-face ((t (:inherit (font-lock-string-face mu4e-header-face)))))
    '(mu4e-flagged-face ((t (:inherit (font-lock-constant-face mu4e-header-face) :weight bold))))
    '(mu4e-forwarded-face ((t (:inherit (font-lock-builtin-face mu4e-header-face) :weight normal))))
    '(mu4e-replied-face ((t (:inherit (font-lock-builtin-face mu4e-header-face) :weight normal :foreground "#6F6F6F"))))
    '(mu4e-trashed-face ((t (:inherit (font-lock-comment-face mu4e-header-face) :foreground "#6F6F6F" :strike-through t))))
    '(mu4e-unread-face ((t (:inherit (font-lock-keyword-face mu4e-header-face) :weight bold))))
    '(mu4e-modeline-face ((t (:inherit mode-line-emphasis :weight bold))))
    '(show-paren-match-expression ((t (:extend t :background "#384848"))))
    '(simple-wiki-code-face ((t (:background "grey30"))))
    '(so-long-mode-line-active ((t (:inherit mode-line-emphasis :foreground "yellow"))))
    '(tab-bar ((t (:inherit variable-pitch :background "gray32" :foreground "black"))))
    '(tab-bar-tab ((t (:inherit tab-bar :background "dark gray" :box (:line-width (1 . 1) :style released-button)))))
    '(tab-bar-tab-inactive ((t (:inherit tab-bar-tab :background "grey45"))))
    '(tab-line ((t (:inherit variable-pitch :background "grey35" :foreground "black" :height 0.9))))
    '(term-color-blue ((t (:background "blue2" :foreground "deep sky blue"))))
    '(term-color-cyan ((t (:background "DodgerBlue4" :foreground "CadetBlue1"))))
    '(term-color-green ((t (:background "green3" :foreground "green2"))))
    '(term-color-magenta ((t (:background "#cf3360" :foreground "#ff3377"))))
    '(term-color-red ((t (:background "red3" :foreground "orange red"))))
    '(term-color-yellow ((t (:background "yellow3" :foreground "yellow2"))))
    '(tks-time-face ((t (:foreground "#cc9933"))))
    '(visible-mark-active ((t (:background "firebrick3" :foreground "white"))))
    '(visible-mark-face1 ((t (:background "DarkRed"))))
    '(visible-mark-face2 ((t (:background "DarkOrange4"))))
    '(whitespace-newline ((t (:foreground "grey32" :weight normal))))
    '(whitespace-space ((((class color) (background dark)) (:foreground "grey30"))))
    '(window-tool-bar-button ((t (:inherit tab-line :background "grey65" :box (:line-width (1 . -1) :style released-button)))))
    )))

(with-eval-after-load "zenburn-theme"
  (my-theme-custom-faces-for-zenburn))

(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/el-get/zenburn-theme"))
(with-demoted-errors "Error: %S"
  ;; (when (require-theme 'zenburn-theme t) ;; we would be loading it twice
  ;; (mapc #'disable-theme custom-enabled-themes) ;; will be nil
  (load-theme 'zenburn t)
  (my-zenburn-theme-config))

;; Emacs supports Symbola by default, nowadays, if when it is installed.
;; (But retain these comments as an example of this functionality.)
;;
;; ;; This magic means we fall back to Symbola for all missing unicode glyphs.
;; ;; For Debian: apt-get install ttf-ancient-fonts
;; (set-fontset-font "fontset-default" nil (font-spec :size 20 :name "Symbola:"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; My 'standard' alternative theme.

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Modus themes

(defun my-theme-custom-faces-for-modus-operandi ()
  "Equivalent to (custom-set-faces ...) but only for modus-operandi."
  (my-theme-custom-faces-apply
   'modus-operandi
   (list
    ;; Can copy these verbatim from `custom-set-faces' arguments.
    '(hl-sexp-face ((t (:background "#eaf5fc"))))
    '(mu4e-header-face ((t (:foundry "GOOG" :family "Noto Sans Mono" :width semi-condensed))))
    '(mu4e-header-highlight-face ((t (:inherit (hl-line mu4e-header-face) :extend t :underline t :weight bold))))
    '(mu4e-header-marks-face ((t (:inherit (font-lock-preprocessor-face mu4e-header-face)))))
    '(mu4e-header-title-face ((t (:inherit (font-lock-type-face mu4e-header-face)))))
    '(mu4e-draft-face ((t (:inherit (font-lock-string-face mu4e-header-face)))))
    '(mu4e-flagged-face ((t (:inherit (font-lock-constant-face mu4e-header-face) :weight bold))))
    '(mu4e-forwarded-face ((t (:inherit (font-lock-builtin-face mu4e-header-face) :weight normal))))
    '(mu4e-replied-face ((t (:inherit (font-lock-builtin-face mu4e-header-face) :weight normal))))
    '(mu4e-trashed-face ((t (:inherit (font-lock-comment-face mu4e-header-face) :strike-through t))))
    '(mu4e-unread-face ((t (:inherit (font-lock-keyword-face mu4e-header-face) :weight bold))))
    '(mu4e-modeline-face ((t (:inherit mode-line-emphasis :weight bold))))
    '(tks-comment-face ((t (:foreground "#3548cf"))))
    '(tks-date-face ((t (:foreground "#dc0c93"))))
    ;; '(tks-description-face ((t (:foreground ""))))
    '(tks-time-face ((t (:foreground "#9c6903"))))
    '(tks-wr-face ((t (:foreground "#603f9f"))))
    )))

(with-eval-after-load "modus-operandi-theme"
  (my-theme-custom-faces-for-modus-operandi))

(defun my-theme-custom-faces-for-modus-vivendi ()
  "Equivalent to (custom-set-faces ...) but only for modus-vivendi."
  (my-theme-custom-faces-apply
   'modus-vivendi
   (list
    ;; Can copy these verbatim from `custom-set-faces' arguments.
    '(hl-sexp-face ((t (:background "#172031"))))
    '(mu4e-header-face ((t (:foundry "GOOG" :family "Noto Sans Mono" :width semi-condensed))))
    '(mu4e-header-highlight-face ((t (:inherit (hl-line mu4e-header-face) :extend t :underline t :weight bold))))
    '(mu4e-header-marks-face ((t (:inherit (font-lock-preprocessor-face mu4e-header-face)))))
    '(mu4e-header-title-face ((t (:inherit (font-lock-type-face mu4e-header-face)))))
    '(mu4e-draft-face ((t (:inherit (font-lock-string-face mu4e-header-face)))))
    '(mu4e-flagged-face ((t (:inherit (font-lock-constant-face mu4e-header-face) :weight bold))))
    '(mu4e-forwarded-face ((t (:inherit (font-lock-builtin-face mu4e-header-face) :weight normal))))
    '(mu4e-replied-face ((t (:inherit (font-lock-builtin-face mu4e-header-face) :weight normal))))
    '(mu4e-trashed-face ((t (:inherit (font-lock-comment-face mu4e-header-face) :strike-through t))))
    '(mu4e-unread-face ((t (:inherit (font-lock-keyword-face mu4e-header-face) :weight bold))))
    '(mu4e-modeline-face ((t (:inherit mode-line-emphasis :weight bold))))
    )))

(with-eval-after-load "modus-vivendi-theme"
  (my-theme-custom-faces-for-modus-vivendi))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-replace-theme (theme)
  "Replace current theme with THEME."
  (mapc #'disable-theme custom-enabled-themes)
  (let ((setfaces (intern (concat "my-theme-custom-faces-for-"
                                  (symbol-name theme)))))
    (when (fboundp setfaces)
      (funcall setfaces)))
  (enable-theme theme))

(defun my-theme-modus-operandi ()
  "Replace current theme with `modus-operandi'."
  (interactive)
  (require 'modus-operandi-theme)
  (my-replace-theme 'modus-operandi))

(defun my-theme-modus-vivendi ()
  "Replace current theme with `modus-vivendi'."
  (interactive)
  (require 'modus-vivendi-theme)
  (my-replace-theme 'modus-vivendi))

(defun my-theme-zenburn ()
  "Replace current theme with `zenburn'."
  (interactive)
  (require 'zenburn-theme)
  (my-replace-theme 'zenburn)
  (my-zenburn-theme-config))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-theme)
