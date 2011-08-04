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
