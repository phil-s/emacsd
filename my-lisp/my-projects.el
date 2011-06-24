;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Directory local variables
;;
;; Assign in my-local.el with:
;; (dir-locals-set-directory-class "/dir/path/" 'class-symbol)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Emacs
(dir-locals-set-class-variables
 'emacs
 '((nil . ((buffer-read-only . t)
           (show-trailing-whitespace . nil)
           (tab-width . 8)))))

;; Drupal
(dir-locals-set-class-variables
 'drupal
 '((nil . ((indent-tabs-mode . nil)
           (tab-width . 2)
           (fill-column . 76)))
   (php-mode . ((drupal-p . t)))
   (css-mode . ((css-indent-offset . 2)))
   (js-mode . ((js-indent-level . 2)))
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

(provide 'my-projects)
