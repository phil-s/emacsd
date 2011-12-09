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

;; Emacs
(dir-locals-set-class-variables
 'emacs
 '((nil . ((buffer-read-only . t)
           (show-trailing-whitespace . nil)
           (tab-width . 8)))))

;; Generic read-only class
(dir-locals-set-class-variables
 'read-only
 '((nil (buffer-read-only . t))))

;; Drupal
(dir-locals-set-class-variables
 'drupal
 '((nil . ((indent-tabs-mode . nil)
           (tab-width . 8)
           (fill-column . 76)
           (ffip-patterns . ("*.php" "*.inc" "*.module" "*.install" "*.info" "*.js"
                             "*.css" ".htaccess" "*.engine" "*.txt" "*.profile"
                             "*.xml" "*.test" "*.theme" "*.ini" "*.make"))
           ;; (drupal-p . t)
           ))
   (php-mode . ((mode . drupal)
                (c-basic-offset . 2)))
   ;; (drupal-mode . ((drupal-p . t)))
   (css-mode . ((css-indent-offset . 2)))
   (js-mode . ((js-indent-level . 2)))
   (javascript-mode . ((js-indent-level . 2)))
   ))

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
