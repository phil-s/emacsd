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
   t t))

;;; Local Variables:
;;; eval:(add-hook 'after-save-hook 'my-local-backup nil t)
;;; End:
