;; -*- lexical-binding: nil; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Directory local variables
;;
;; Assign in my-local.el with:
;; (dir-locals-set-directory-class "/dir/path" 'class-symbol)
;; or for individual files:
;; (my-file-locals-set-directory-class "/file/path" 'class-symbol)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Emacs caches .dir-locals.el entries to avoid reparsing them. It
;; also checks the modification time on the file at each open to
;; ensure the cache is fresh, and reparses if needed.
;;
;; However, if you invoke dir-locals-set-directory-class with a nil
;; mtime, the cache is always considered fresh. If you do this when
;; you assign your classes to your remote directory roots, you can
;; avoid the repeated costs and pay only for the first parse. Of
;; course, this assumes you won't be changing your class content.
;;
;; If you want to use .dir-locals.el (which I prefer since it's
;; transparent and would likely be in source control for each
;; project), the one hack you might want to consider is to alter the
;; remote-project root entries in dir-locals-directory-cache to nil
;; their mtime. I guess you'd do this in a find-file-hook. Even though
;; it would nil each time a file is opened, it's way cheaper than
;; checking mtime across the net.
;;
;; See the code for dir-locals-find-file to see how the cache works.
;;
;; -- https://old.reddit.com/r/emacs/comments/1luxt57/remote_dirlocals_enable_directory_classes_but_not/n21yiki/


;; Null class
(dir-locals-set-class-variables 'null '(nil))

;; Read-only
(dir-locals-set-class-variables
 'read-only
 '((nil . ((buffer-read-only . t)))))

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
   (emacs-lisp-mode . ((indent-tabs-mode . nil)))
   (".git" . ((nil . ((buffer-read-only . nil)))))))

(dir-locals-set-directory-class "/usr/local/src/emacs" 'emacs)
(dir-locals-set-directory-class "/usr/local/share/emacs" 'emacs)
(dir-locals-set-directory-class "/usr/share/emacs" 'emacs)
(dir-locals-set-directory-class (substitute-in-file-name "/home/$USER/emacs") 'emacs)
(dir-locals-set-directory-class (substitute-in-file-name "/home/$USER/emacs/trunk/git-repository") 'emacs)
(when (file-directory-p (substitute-in-file-name "/home/$USER/emacs"))
  (mapc (lambda (dir) ; Apply to every ~/emacs/XX.X/emacs-XX.X directory
          (dir-locals-set-directory-class
           (concat dir "/emacs-" (file-name-nondirectory dir)) 'emacs))
        (directory-files (substitute-in-file-name "/home/$USER/emacs") :full "[0-9][0-9]\.[0-9]")))

;; 29.1 adds `find-sibling-file' and `find-sibling-rules'.
;; These are documented at (emacs-index-search "find-sibling-file")
;; How does that differ to `ff-find-other-file' and `ff-other-file-alist'
;; in practice?  (Check S.O. -- I've dug into the latter in the past.)

;; Mahara
(dir-locals-set-class-variables
 'mahara
 '((auto-mode-alist . (("\\.php\\'" . mahara-mode)
                       ("\\.inc\\'" . mahara-mode)
                       ("/interdiff[^/]*\\.txt\\'" . diff-mode)
                       ("/composer.patches.json\\'" . my-mahara-composer-patches-mode)))
   (nil . ((indent-tabs-mode . nil)
           (tab-width . 8)
           (fill-column . 76)
           (ffip-patterns . ("*.php" "*.inc" "*.module" "*.install" "*.info"
                             "*.js" "*.css" ".htaccess" "*.engine" "*.txt"
                             "*.profile" "*.xml" "*.test" "*.theme" "*.ini"
                             "*.make"))
           ;; (mahara-p . t)
           (ff-search-directories . ("."))
           ;; Cycle between these files with <f5>
           (ff-other-file-alist . (("\\.module$" (".install" ".info"))
                                   ("\\.install$" (".info"))
                                   ("\\.info$" (".module"))))
           (my-sql-db-name-getter . my-mahara-db-name)
           (my-sql-db-user-getter . my-mahara-db-user)
           (eval . (when (and buffer-file-name
                              (string-match "\\.make\\'" buffer-file-name))
                     (unless (derived-mode-p 'conf-mode)
                       (conf-mode))))
           ;; (eval . (grep-apply-setting ; Make M-x grep use git-grep:
           ;;          'grep-command
           ;;          "git --no-pager grep -H -n --no-color -I -e "))
           ;; See `my-bug-reference-url-format'.
           (my-bug-reference-url-for-bugs . "https://bugs.launchpad.net/mahara/+bug/%s")
           (my-bug-reference-url-for-issues . "https://git.mahara.org/catalyst/mahara/-/issues/%s")
           ))
   (mahara-mode . ((c-basic-offset . 4)
                   (psysh-buffer-name . "*Mahara-PHP*")
                   ;; (flymake-phpcs-standard . "Mahara")
                   ))
   (css-mode . ((css-indent-offset . 4)))
   (scss-mode . ((css-indent-offset . 4)
                 ;; Paths in SASS 'partials/*' are relative to the parent dir.
                 (eval . (when (equal (file-name-base (directory-file-name
                                                       default-directory))
                                      "partials")
                           (setq default-directory
                                 (expand-file-name "../" (file-name-directory
                                                          buffer-file-name)))))))
   (js-mode . ((js-indent-level . 4)))
   (web-mode . ((web-mode-code-indent-offset . 4)
                (web-mode-css-indent-offset . 4)
                (web-mode-markup-indent-offset . 4)
                (web-mode-sql-indent-offset . 4)))
   (makefile-gmake-mode . ((eval . (when (string= "make" (file-name-extension
                                                          buffer-file-name))
                                     (progn (conf-mode)
                                            (hack-local-variables))))))
   (dired-mode . ((dired-omit-mode . t)))
   ))

;; Mahara-performant PHP.
;; See also ~/code/.dir-locals.el
(dir-locals-set-class-variables
 'mahara-performant
 '((auto-mode-alist . (("\\.php\\'" . php-mode) ;; No `mahara-mode' as yet.
                       ("\\.inc\\'" . php-mode)))
   (php-mode . ((c-basic-offset . 4)
                (indent-tabs-mode . nil)
                (fill-column . 80)
                (eval . (progn (require 'visual-wrap-comments)
                               (visual-wrap-comments-mode 1)))
                (psysh-buffer-name . "*Mahara-PHP*")
                ;; Performance.
                (eval . (setq-local syntax-propertize-function #'ignore))
                (eval . (remove-hook 'syntax-propertize-extend-region-functions
                                     #'php-syntax-propertize-extend-region t))
                ))))

;; Drupal
(dir-locals-set-class-variables
 'drupal
 '((auto-mode-alist . (("\\.php\\'" . drupal-mode)
                       ("\\.inc\\'" . drupal-mode)
                       ("/interdiff[^/]*\\.txt\\'" . diff-mode)
                       ("/composer.patches.json\\'" . my-drupal-composer-patches-mode)))
   (nil . ((indent-tabs-mode . nil)
           (tab-width . 8)
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
                     (unless (derived-mode-p 'conf-mode)
                       (conf-mode))))
           ;; (eval . (grep-apply-setting ; Make M-x grep use git-grep:
           ;;          'grep-command
           ;;          "git --no-pager grep -H -n --no-color -I -e "))
           ;; See `my-bug-reference-url-format'.
           (my-bug-reference-url-for-issues . "https://www.drupal.org/i/%s")
           ))
   (drupal-mode . ((flymake-phpcs-standard . "Drupal")
                   (c-basic-offset . 2)
                   (psysh-buffer-name . "*Drush-PHP*")))
   ;; (drupal-mode . ((drupal-p . t)))
   (css-mode . ((css-indent-offset . 2)))
   (scss-mode . ((css-indent-offset . 2)
                 ;; Paths in SASS 'partials/*' are relative to the parent dir.
                 (eval . (when (equal (file-name-base (directory-file-name
                                                       default-directory))
                                      "partials")
                           (setq default-directory
                                 (expand-file-name "../" (file-name-directory
                                                          buffer-file-name)))))))
   (js-mode . ((js-indent-level . 2)))
   (web-mode . ((web-mode-code-indent-offset . 2)
                (web-mode-css-indent-offset . 2)
                (web-mode-markup-indent-offset . 2)
                (web-mode-sql-indent-offset . 2)))
   (makefile-gmake-mode . ((eval . (when (string= "make" (file-name-extension
                                                          buffer-file-name))
                                     (progn (conf-mode)
                                            (hack-local-variables))))))
   (dired-mode . ((dired-omit-mode . t)))
   ))

;; PHP Composer.
(dir-locals-set-class-variables
 'composer
 '((json-mode . ((js-indent-level . 4)))))

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
  "Enable \\='directory local\\=' classes for individual files,
by allowing non-directories in `dir-locals-directory-cache'.
Adapted from `dir-locals-set-directory-class'."
  (setq file (expand-file-name file))
  (unless (assq class dir-locals-class-alist)
    (error "No such class `%s'" (symbol-name class)))
  (push (list file class mtime) dir-locals-directory-cache))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-projects)
