(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(confirm-kill-emacs (quote y-or-n-p))
 '(current-language-environment "Latin-1")
 '(default-input-method "latin-1-prefix")
 '(dnd-protocol-alist (quote (("^file:///" . dnd-open-local-file) ("^file://" . dnd-open-file) ("^file:[A-Za-z]%3a" . dnd-open-local-file-fix-url) ("^file:" . dnd-open-local-file) ("^\\(https?\\|ftp\\|file\\|nfs\\)://" . dnd-open-file))))
 '(fic-highlighted-words (quote ("FIXME" "TODO" "KLUDGE")))
 '(global-font-lock-mode t nil (font-lock))
 '(grep-find-ignored-files (quote (".#*" "*.o" "*~" "*.bin" "*.lbin" "*.so" "*.a" "*.ln" "*.blg" "*.bbl" "*.elc" "*.lof" "*.glo" "*.idx" "*.lot" "*.fmt" "*.tfm" "*.class" "*.fas" "*.lib" "*.mem" "*.x86f" "*.sparcf" "*.fasl" "*.ufsl" "*.fsl" "*.dxl" "*.pfsl" "*.dfsl" "*.p64fsl" "*.d64fsl" "*.dx64fsl" "*.lo" "*.la" "*.gmo" "*.mo" "*.toc" "*.aux" "*.cp" "*.fn" "*.ky" "*.pg" "*.tp" "*.vr" "*.cps" "*.fns" "*.kys" "*.pgs" "*.tps" "*.vrs" "*.pyc" "*.pyo" "*.png" "*.gif" "*.jpg" "*.jpeg" "*.tiff" "*.pdf" "*.doc" "")))
 '(history-length 100)
 '(ibuffer-saved-filter-groups (quote (("default" ("Scratch" (mode . lisp-interaction-mode)) ("Shells" (mode . shell-mode)) ("Emacs" (filename . "emacs"))))))
 '(ibuffer-saved-filters (quote (("gnus" ((or (mode . message-mode) (mode . mail-mode) (mode . gnus-group-mode) (mode . gnus-summary-mode) (mode . gnus-article-mode)))) ("programming" ((or (mode . emacs-lisp-mode) (mode . cperl-mode) (mode . c-mode) (mode . java-mode) (mode . idl-mode) (mode . lisp-mode)))))))
 '(inhibit-eol-conversion nil)
 '(read-buffer-completion-ignore-case t)
 '(read-file-name-completion-ignore-case t)
 '(safe-local-variable-values (quote ((eval progn (outline-minor-mode) (outline-toggle-children) (let ((n 9)) (while (> n 0) (setq n (1- n)) (call-interactively (quote outline-next-visible-heading)) (outline-toggle-children)))) (eval when (not (eq major-mode (quote drupal-mode))) (drupal-mode) (hack-local-variables)) (eval add-hook (quote after-save-hook) (quote my-local-backup) nil t) (ffip-patterns "*.php" "*.inc" "*.module" "*.install" "*.info" "*.js" "*.css" ".htaccess" "*.engine" "*.txt" "*.profile" "*.xml" "*.test" "*.theme" "*.ini" "*.make") (whitespace-mode . 0) (css-indent-offset . 2) (js-indent-level . 2) (eval progn (outline-minor-mode) (outline-toggle-children) (let ((n 8)) (while (> n 0) (setq n (1- n)) (call-interactively (quote outline-next-visible-heading)) (outline-toggle-children)))) (eval hide-body))))
 '(scroll-bar-mode (quote right))
 '(svn-log-edit-show-diff-for-commit t)
 '(tool-bar-mode nil)
 '(tramp-remote-path (quote (tramp-default-remote-path "/usr/sbin" "/usr/local/bin" "/local/bin" "/local/freeware/bin" "/local/gnu/bin" "/usr/freeware/bin" "/usr/pkg/bin" "/usr/contrib/bin" "/usr/bin")))
 '(vc-svn-global-switches (quote ("--username" "phils" "--password" "password"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#3f3f3f" :foreground "#dcdccc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "WenQuanYi Micro Hei Mono"))))
 '(tks-time-face ((t (:foreground "#cc9933"))))
 '(whitespace-newline ((t (:foreground "grey32" :weight normal))))
 '(whitespace-space ((((class color) (background dark)) (:foreground "grey30")))))
;; WARNING: my-theme.el over-rides (custom-set-faces) for the 'user
;; theme, to set the default font face. Custom faces set in the above
;; call will be over-ridden.
