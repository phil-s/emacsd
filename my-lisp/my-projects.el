;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Directory local variables
;;
;; Assign in my-local.el with:
;; (dir-locals-set-directory-class "/dir/path/" 'class-symbol)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Drupal
(dir-locals-set-class-variables
 'drupal
 '((nil . ((indent-tabs-mode . nil)
           (fill-column . 80)))
   (php-mode . ((drupal-p . t)))
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
 '((nil . ((buffer-read-only . t)))))

(dir-locals-set-class-variables
 'plone-instance
 '((nil . ((indent-tabs-mode . nil)
           (fill-column . 80)))
   ;; (python-mode . (()))
   ;; (nxhtml-mode . (()))
   ))


;; Emacs
(dir-locals-set-class-variables
 'emacs
 '((emacs-lisp-mode . ((tab-width . 8)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-projects)
