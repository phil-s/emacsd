;; I don't really know what I'm doing yet.

;;; Tutorials etc

;; http://pragmaticemacs.com/category/org/
;; http://orgmode.org/worg/org-tutorials/org4beginners.html
;; http://orgmode.org/worg/org-tutorials/orgtutorial_dto.html
;; http://www.star.bris.ac.uk/bjm/emacs.html


;;; General configuration

;; ;; Set maximum indentation for description lists.
;; (setq org-list-description-max-indent 5)

;; Default notes file.
(setq org-default-notes-file "~/notes.org")

;; Default agenda files.
(setq org-agenda-files '("~/todo.org"))

;; Prevent the demoting of a heading also shifting text within its sections.
(setq org-adapt-indentation nil)


;;; Babel

;; Syntax highlighting for source code blocks.
(setq org-src-fontify-natively t)

;; org-babel supported languages
(org-babel-do-load-languages
 'org-babel-load-languages
 (mapcar (lambda (lang) (cons lang t))
         '(
           ;; asymptote
           awk
           ;; C
           ;; calc
           ;; clojure
           css
           ;; ditaa
           ;; dot
           emacs-lisp
           ;; fortran
           ;; gnuplot
           ;; haskell
           ;; io
           ;; java
           js
           latex
           ;; ledger
           ;; lilypond
           lisp
           makefile
           ;; matlab
           ;; maxima
           ;; mscgen
           ;; ocaml
           ;; octave
           org
           ;; perl
           ;; picolisp
           ;; plantuml
           python
           ;; R
           ;; ruby
           sass
           ;; scala
           ;; scheme
           sh
           ;; shen
           sql
           ;; sqlite
           )))

;; Wrap region in an org template (e.g. latex, src etc)
;; http://pragmaticemacs.com/emacs/wrap-text-in-an-org-mode-block/
;; FIXME: This should clearly use `org-structure-template-alist'.
(defun my-org-structure-template ()
  "Make an org structure template at point, or around the marked region."
  (interactive)
  (let* ((choices '(("s" . "SRC")
                    ("e" . "EXAMPLE")
                    ("q" . "QUOTE")
                    ("v" . "VERSE")
                    ("c" . "CENTER")
                    ("l" . "LaTeX")
                    ("h" . "HTML")
                    ("a" . "ASCII")))
         (key
          (key-description
           (vector
            (read-key
             (concat (propertize "Template type: " 'face 'minibuffer-prompt)
                     (mapconcat (lambda (choice)
                                  (concat (propertize (car choice) 'face
                                                      'font-lock-type-face)
                                          ": "
                                          (cdr choice)))
                                choices
                                ", ")))))))
    (let ((result (assoc key choices)))
      (when result
        (let ((choice (cdr result)))
          (cond
           ((region-active-p)
            (let ((start (region-beginning))
                  (end (region-end)))
              (goto-char end)
              (insert "#+END_" choice "\n")
              (goto-char start)
              (insert "#+BEGIN_" choice "\n")))
           (t
            (insert "#+BEGIN_" choice "\n")
            (save-excursion (insert "#+END_" choice)))))))))

(define-key org-mode-map (kbd "C-M-<") 'my-org-structure-template)

;;; Compatibility

;; Make windmove work in org-mode.
(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftright-final-hook 'windmove-right)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-org)
