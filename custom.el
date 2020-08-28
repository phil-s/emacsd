(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("4e89c70455cea42887121c649f53c475442b30d4607d5035ff7b7b46c66c868b" "00db6503bcfb4b91e9a5eefcc1d06b30fd30b65174ca35bd66bb35ceef26ca2a" default))
 '(dnd-protocol-alist
   '(("^file:///" . dnd-open-local-file)
     ("^file://" . dnd-open-file)
     ("^file:[A-Za-z]%3a" . dnd-open-local-file-fix-url)
     ("^file:" . dnd-open-local-file)
     ("^\\(https?\\|ftp\\|file\\|nfs\\)://" . dnd-open-file)))
 '(ibuffer-saved-filter-groups
   '(("default"
      ("Scratch"
       (mode . lisp-interaction-mode))
      ("Shells"
       (mode . shell-mode))
      ("Emacs"
       (filename . "emacs")))))
 '(ibuffer-saved-filters
   '(("gnus"
      ((or
        (mode . message-mode)
        (mode . mail-mode)
        (mode . gnus-group-mode)
        (mode . gnus-summary-mode)
        (mode . gnus-article-mode))))
     ("programming"
      ((or
        (mode . emacs-lisp-mode)
        (mode . cperl-mode)
        (mode . c-mode)
        (mode . java-mode)
        (mode . idl-mode)
        (mode . lisp-mode))))))
 '(package-selected-packages
   '(edit-server etags-select minibuffer-line pdf-tools project-local-variables))
 '(safe-local-variable-values
   '((eval when
           (fboundp 'rainbow-mode)
           (rainbow-mode 1))
     (eval and
           (fboundp 'my-ignore-whitespace-long-lines)
           (my-ignore-whitespace-long-lines))
     (dired-omit-mode . t)
     (eval buffer-enable-undo)
     (eval jit-lock-fontify-now)
     (eval when
           (fboundp 'adaptive-wrap-prefix-mode)
           (adaptive-wrap-prefix-mode 1))
     (eval my-buffer-local-set-key
           (kbd "<C-M-left>")
           'sgml-skip-tag-backward)
     (eval my-buffer-local-set-key
           (kbd "<C-M-right>")
           'sgml-skip-tag-forward)
     (comment-padding . " ")
     (comment-style quote indent)
     (rng-nxml-auto-validate-flag)
     (eval while
           (re-search-forward "^### " nil t)
           (outline-toggle-children))
     (eval while
           (re-search-forward "^;;;; \\* " nil t)
           (outline-toggle-children))
     (eval unless
           (eq major-mode 'drupal-mode)
           (drupal-mode)
           (hack-local-variables))
     (eval when
           (and buffer-file-name
                (string-match "\\.make\\'" buffer-file-name))
           (conf-mode))
     (ff-other-file-alist
      ("\\.module$"
       (".install" ".info"))
      ("\\.install$"
       (".info"))
      ("\\.info$"
       (".module")))
     (ff-search-directories ".")
     (eval when
           (not
            (eq major-mode 'drupal-mode))
           (drupal-mode)
           (hack-local-variables))
     (eval add-hook 'after-save-hook 'my-local-backup nil t)
     (ffip-patterns "*.php" "*.inc" "*.module" "*.install" "*.info" "*.js" "*.css" ".htaccess" "*.engine" "*.txt" "*.profile" "*.xml" "*.test" "*.theme" "*.ini" "*.make")
     (whitespace-mode . 0)
     (css-indent-offset . 2)
     (js-indent-level . 2)
     (eval hide-body)
     (eval
      (when
          (and buffer-file-name
               (string-match "\\.make\\'" buffer-file-name))
        (conf-mode)))))
 '(tramp-remote-path
   '(tramp-default-remote-path "/usr/sbin" "/usr/local/bin" "/local/bin" "/local/freeware/bin" "/local/gnu/bin" "/usr/freeware/bin" "/usr/pkg/bin" "/usr/contrib/bin" "/usr/bin")))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:slant normal :weight normal :height 122 :width normal :foundry "unknown" :family "Droid Sans Mono Dotted"))))
 '(diff-hl-change ((t (:background "#4f4f7f" :foreground "#5f5fff"))))
 '(diff-hl-delete ((t (:background "#7f4f4f" :foreground "#964f6f"))))
 '(diff-hl-insert ((t (:background "#4f664f" :foreground "#4f7f4f"))))
 '(diff-refine-added ((t (:inherit diff-refine-change :background "#228822"))))
 '(ediff-current-diff-C ((t (:background "#888833" :foreground "#333333"))))
 '(ediff-fine-diff-B ((t (:background "#22aa22" :foreground "#333333"))))
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
 '(magit-item-highlight ((t (:background "#4f4f4f"))))
 '(magit-tag ((t (:background "LemonChiffon1" :foreground "black"))))
 '(term-color-blue ((t (:background "blue2" :foreground "deep sky blue"))))
 '(term-color-cyan ((t (:background "DodgerBlue4" :foreground "CadetBlue1"))))
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
