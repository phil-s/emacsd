(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("4e89c70455cea42887121c649f53c475442b30d4607d5035ff7b7b46c66c868b" "00db6503bcfb4b91e9a5eefcc1d06b30fd30b65174ca35bd66bb35ceef26ca2a" default)))
 '(dnd-protocol-alist (quote (("^file:///" . dnd-open-local-file) ("^file://" . dnd-open-file) ("^file:[A-Za-z]%3a" . dnd-open-local-file-fix-url) ("^file:" . dnd-open-local-file) ("^\\(https?\\|ftp\\|file\\|nfs\\)://" . dnd-open-file))))
 '(ibuffer-saved-filter-groups (quote (("default" ("Scratch" (mode . lisp-interaction-mode)) ("Shells" (mode . shell-mode)) ("Emacs" (filename . "emacs"))))))
 '(ibuffer-saved-filters (quote (("gnus" ((or (mode . message-mode) (mode . mail-mode) (mode . gnus-group-mode) (mode . gnus-summary-mode) (mode . gnus-article-mode)))) ("programming" ((or (mode . emacs-lisp-mode) (mode . cperl-mode) (mode . c-mode) (mode . java-mode) (mode . idl-mode) (mode . lisp-mode)))))))
 '(org-agenda-files (quote ("~/todo.org")))
 '(safe-local-variable-values (quote ((eval while (re-search-forward "^### " nil t) (outline-toggle-children)) (eval while (re-search-forward "^;;;; \\* " nil t) (outline-toggle-children)) (eval unless (eq major-mode (quote drupal-mode)) (drupal-mode) (hack-local-variables)) (eval when (and buffer-file-name (string-match "\\.make\\'" buffer-file-name)) (conf-mode)) (ff-other-file-alist ("\\.module$" (".install" ".info")) ("\\.install$" (".info")) ("\\.info$" (".module"))) (ff-search-directories ".") (eval when (not (eq major-mode (quote drupal-mode))) (drupal-mode) (hack-local-variables)) (eval add-hook (quote after-save-hook) (quote my-local-backup) nil t) (ffip-patterns "*.php" "*.inc" "*.module" "*.install" "*.info" "*.js" "*.css" ".htaccess" "*.engine" "*.txt" "*.profile" "*.xml" "*.test" "*.theme" "*.ini" "*.make") (whitespace-mode . 0) (css-indent-offset . 2) (js-indent-level . 2) (eval hide-body) (eval (when (and buffer-file-name (string-match "\\.make\\'" buffer-file-name)) (conf-mode))))))
 '(tramp-remote-path (quote (tramp-default-remote-path "/usr/sbin" "/usr/local/bin" "/local/bin" "/local/freeware/bin" "/local/gnu/bin" "/usr/freeware/bin" "/usr/pkg/bin" "/usr/contrib/bin" "/usr/bin"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:slant normal :weight normal :height 122 :width normal :foundry "unknown" :family "Droid Sans Mono Dotted"))))
 '(diff-hl-change ((t (:background "#4f4f6f" :foreground "blue3"))))
 '(diff-hl-delete ((t (:inherit diff-removed :background "#7f4f4f" :foreground "red3"))))
 '(diff-hl-insert ((t (:inherit diff-added :background "#4f664f" :foreground "#004600"))))
 '(diff-refine-added ((t (:inherit diff-refine-change :background "#228822"))))
 '(ediff-fine-diff-B ((t (:background "#007700"))))
 '(magit-diff-context-highlight ((t (:background "grey10" :foreground "grey70"))))
 '(term-color-blue ((t (:background "blue2" :foreground "deep sky blue"))))
 '(term-color-cyan ((t (:background "cyan" :foreground "cyan3"))))
 '(term-color-green ((t (:background "green3" :foreground "green2"))))
 '(term-color-magenta ((t (:background "#cf3360" :foreground "#ff3377"))))
 '(term-color-red ((t (:background "red3" :foreground "orange red"))))
 '(term-color-yellow ((t (:background "yellow3" :foreground "yellow2"))))
 '(tks-time-face ((t (:foreground "#cc9933"))))
 '(whitespace-newline ((t (:foreground "grey32" :weight normal))))
 '(whitespace-space ((((class color) (background dark)) (:foreground "grey30")))))

;; WARNING: my-theme.el over-rides (custom-set-faces) for the 'user
;; theme, to set the default font face. Custom faces set in the above
;; call will be over-ridden.
