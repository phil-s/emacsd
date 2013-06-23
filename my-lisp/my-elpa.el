;;; ELPA -- Emacs Lisp Package Archive
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.

;;; Install:
;;  (let ((buffer (url-retrieve-synchronously
;;           "http://tromey.com/elpa/package-install.el")))
;;  (save-excursion
;;    (set-buffer buffer)
;;    (goto-char (point-min))
;;    (re-search-forward "^$" nil 'move)
;;    (eval-region (point) (point-max))
;;    (kill-buffer (current-buffer))))
;;
;;; And then remove the content added at the end of this file!

;; Marmalade repository
(require 'package)
(add-to-list 'package-archives 
             '("marmalade" . "http://marmalade-repo.org/packages/"))

;;; Initialise:
(unless (functionp 'package-initialize)
  (let ((elpa-package (expand-file-name
                       (concat user-emacs-directory "elpa/package.el"))))
    (when (and (file-exists-p elpa-package)
               (load elpa-package))
      (package-initialize))))

(provide 'my-elpa)
