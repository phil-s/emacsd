;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Directory local variables
;;
;; Assign in my-local.el with:
;; (dir-locals-set-directory-class "/dir/path" 'class-symbol)
;; or for individual files:
;; (my-file-locals-set-directory-class "/file/path" 'class-symbol)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Null class
(dir-locals-set-class-variables 'null '(nil))

;; Fundamental mode (file class)
;; This is primarily intended for use with `my-file-locals-set-directory-class',
;; for very large files which are too slow to load/edit when their normal mode
;; is active. (Largely deprecated by so-long.el).
(dir-locals-set-class-variables
 'fundamental-mode-class
 '((nil . ((mode . fundamental)
           (indent-tabs-mode . nil)))))

;; Emacs
;; Copied and modified from git-repository/.dir-locals.el
(dir-locals-set-class-variables
 'emacs
 '((nil . ((tab-width . 8)
           (sentence-end-double-space . t)
           (fill-column . 70)
           (buffer-read-only . t)
           (my-inhibit-whitespace-mode . t)
           (show-trailing-whitespace . nil)))
   (c-mode . ((c-file-style . "GNU")))
   (objc-mode . ((c-file-style . "GNU")))
   (log-edit-mode . ((log-edit-font-lock-gnu-style . t)
                     (log-edit-setup-add-author . t)))
   (change-log-mode . ((add-log-time-zone-rule . t)
                       (fill-column . 74)
                       (bug-reference-url-format . "http://debbugs.gnu.org/%s")
                       (mode . bug-reference)))
   (diff-mode . ((mode . whitespace)))
   (emacs-lisp-mode . ((indent-tabs-mode . nil)))))

(dir-locals-set-directory-class "/usr/local/src/emacs" 'emacs)
(dir-locals-set-directory-class "/usr/local/share/emacs" 'emacs)
(dir-locals-set-directory-class "/usr/share/emacs" 'emacs)
(dir-locals-set-directory-class "~/emacs/trunk/git-repository" 'emacs)
(when (file-directory-p "~/emacs")
  (mapc (lambda (dir) ; Apply to every ~/emacs/XX.X/emacs-XX.X directory
          (dir-locals-set-directory-class
           (concat dir "/emacs-" (file-name-nondirectory dir)) 'emacs))
        (directory-files "~/emacs" :full "[0-9][0-9]\.[0-9]")))

;; Generic read-only class
(dir-locals-set-class-variables
 'read-only
 '((nil (buffer-read-only . t))))

;; Drupal
(dir-locals-set-class-variables
 'drupal
 '((nil . ((indent-tabs-mode . nil)
           (tab-width . 8)
           (my-inhibit-whitespace-mode . t)
           (fill-column . 76)
           (ffip-patterns . ("*.php" "*.inc" "*.module" "*.install" "*.info"
                             "*.js" "*.css" ".htaccess" "*.engine" "*.txt"
                             "*.profile" "*.xml" "*.test" "*.theme" "*.ini"
                             "*.make"))
           ;; (drupal-p . t)
           (ff-search-directories . ("."))
           ;; Cycle between these files with <f5>
           (ff-other-file-alist . (("\\.module$" (".install" ".info"))
                                   ("\\.install$" (".info"))
                                   ("\\.info$" (".module"))))
           (my-sql-db-name-getter . my-drupal-db-name)
           (my-sql-db-user-getter . my-drupal-db-user)
           (eval . (when (and buffer-file-name
                              (string-match "\\.make\\'" buffer-file-name))
                     (conf-mode)))
           (eval . (grep-apply-setting ; Make M-x grep use git-grep:
                    'grep-command
                    "git --no-pager grep -H -n --no-color -I -e "))
           ))
   (php-mode . ((eval . (unless (eq major-mode 'drupal-mode)
                          (drupal-mode)
                          (hack-local-variables))) ;; Oooh.
                (flymake-phpcs-standard . "Drupal")
                (c-basic-offset . 2)))
   ;; (drupal-mode . ((drupal-p . t)))
   (css-mode . ((css-indent-offset . 2)))
   (scss-mode . ((css-indent-offset . 2)))
   (js-mode . ((js-indent-level . 2)))
   (javascript-mode . ((js-indent-level . 2)))
   (javascript-generic-mode . ((eval . (progn
                                         (js-mode)
                                         (hack-local-variables))))) ;; Oooh.
   (web-mode . ((web-mode-code-indent-offset . 2)
                (web-mode-code-indent-offset . 2)
                (web-mode-css-indent-offset . 2)
                (web-mode-markup-indent-offset . 2)
                (web-mode-sql-indent-offset . 2)))
   (makefile-gmake-mode . ((eval . (progn (conf-mode)
                                          (hack-local-variables)))))
   (dired-mode . ((dired-omit-mode . t)))
   ;; whitespace-mode is SO SLOW :(
   ;; ("sites" . ((nil . ((my-inhibit-whitespace-mode . nil)))))
   ("sites/all/modules/contrib" . ((nil . ((my-inhibit-whitespace-mode . t)))))
   ))

;; We call `grep-apply-setting' for Drupal projects.
(autoload 'grep-apply-setting "grep")

;; (defun my-dir-locals-php-hook ()
;;   (and (buffer-file-name)
;;        (string-match "\\.php\\'" (buffer-file-name))
;;        (cdr (assoc 'drupal-p dir-local-variables-alist))
;;        (my--drupal-mode)))
;; (add-hook 'php-mode-hook 'my-dir-locals-php-hook t)

;; Plone
(dir-locals-set-class-variables
 'plone-core
 '((nil . ((buffer-read-only . t)
           (show-trailing-whitespace . nil)))))

(dir-locals-set-class-variables
 'plone-instance
 '((nil . ((indent-tabs-mode . nil)
           (fill-column . 80)))
   ;; (python-mode . (()))
   ;; (nxhtml-mode . (()))
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defadvice ffip-completing-read (around my-ido-ffip-completing-read)
  "Always use ido-completing-read with ffip."
  (let ((ido-mode t))
    ad-do-it))
(ad-activate 'ffip-completing-read)

(eval-when-compile
  (declare-function ffip-project-root "find-file-in-project"))

(defun my-find-file-in-project ()
  (interactive)
  (if (executable-find "gpicker")
      (let ((*gpicker-project-dir*
             (expand-file-name (ffip-project-root))))
        (call-interactively 'gpicker-find-file))
    (call-interactively 'find-file-in-project)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-file-locals-set-directory-class (file class &optional mtime)
  "Enable 'directory local' classes for individual files,
by allowing non-directories in `dir-locals-directory-cache'.
Adapted from `dir-locals-set-directory-class'."
  (setq file (expand-file-name file))
  (unless (assq class dir-locals-class-alist)
    (error "No such class `%s'" (symbol-name class)))
  (push (list file class mtime) dir-locals-directory-cache))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-projects)
