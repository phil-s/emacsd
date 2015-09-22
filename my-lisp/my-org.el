;; I don't really know what I'm doing yet.

:;; Tutorials etc
;; http://pragmaticemacs.com/category/org/
;; http://orgmode.org/worg/org-tutorials/org4beginners.html
;; http://orgmode.org/worg/org-tutorials/orgtutorial_dto.html
;; http://www.star.bris.ac.uk/bjm/emacs.html

;; ;; Set maximum indentation for description lists.
;; (setq org-list-description-max-indent 5)

;; Default notes file.
(setq org-default-notes-file "~/notes.org")

;; Default agenda files.
(setq org-agenda-files '("~/todo.org"))

;; Prevent the demoting of a heading also shifting text within its sections.
(setq org-adapt-indentation nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-org)
