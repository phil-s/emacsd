;; Do things before other initialisation.
;; ...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Do things after other initialisation.
(add-hook 'after-init-hook 'my-local-after-init-hook)
(defun my-local-after-init-hook ()
  ;; ...
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-local)

;; Adding tracked files to .gitignore won't work because GIT will
;; still track the changes and commit the file if you use the -a
;; parameter.

;; To ignore changes to a tracked file:
;; git update-index --assume-unchanged <file>

;; To start tracking changes again:
;; git update-index --no-assume-unchanged <file>

;; See:
;; http://www.kernel.org/pub/software/scm/git/docs/git-update-index.html

(defun my-local-backup ()
  "Copy this file to a backup file after saving, to protect against git issues."
  (copy-file
   buffer-file-name
   (concat (file-name-sans-extension buffer-file-name) ".backup")
   t t)
  ;; Also copy a backup to my home directory, because git will
  ;; occasionally clobber the backup within the repository as well.
  ;; (I'm not sure how or why that happens, but I figure a backup
  ;; outside of the repository will be safe).
  (copy-file
   buffer-file-name
   (expand-file-name
    (concat "~/.emacs.d.my-lisp."
            (file-name-nondirectory buffer-file-name)
            ".backup"))
   t t))

;;; Local Variables:
;;; eval:(add-hook 'after-save-hook 'my-local-backup nil t)
;;; End:
