;; I don't really know what I'm doing yet.

;;; Silence compiler warnings
(eval-when-compile
  (defvar org-adapt-indentation)
  (defvar org-agenda-files)
  (defvar org-capture-templates)
  (defvar org-default-notes-file)
  (defvar org-ellipsis)
  (defvar org-fontify-done-headline)
  (defvar org-mode-map)
  (defvar org-src-fontify-natively)
  (defvar org-src-preserve-indentation)
  )

;;; Tutorials etc

;; http://pragmaticemacs.com/category/org/
;; http://orgmode.org/worg/org-tutorials/org4beginners.html
;; http://orgmode.org/worg/org-tutorials/orgtutorial_dto.html
;; http://www.star.bris.ac.uk/bjm/emacs.html


;;; Deferred configuration
(with-eval-after-load "org"
  (my-org-babel-do-load-languages)
  (define-key org-mode-map (kbd "C-M-<") 'my-org-structure-template)
  (my-org-configuration))

;;; General configuration

(defun my-org-configuration ()
  "General configuration for `org-mode'."

  ;; Prevent the demoting of a heading also shifting text within its sections.
  (setq org-adapt-indentation nil)

  ;; ;; Set maximum indentation for description lists.
  ;; (setq org-list-description-max-indent 5)

  ;; Prevent the demoting of a heading also shifting text within its sections.
  (setq org-adapt-indentation nil)

  ;; Use a real ellipsis character.
  (setq org-ellipsis "…")

  ;; Use the `org-headline-done' face for completed todo items.
  (setq org-fontify-done-headline t)

  ;; Make the `org-headline-done' less noticeable.
  (set-face-attribute
   'org-headline-done nil :foreground nil :inherit 'shadow)

  ;; Use the `org-headline-done' face for checked checkboxes.
  ;; https://fuco1.github.io/2017-05-25-Fontify-done-checkbox-items-in-org-mode.html
  (let ((pattern "^[ \t]*\\(?:[-+*]\\|[0-9]+[).]\\)[ \t]+\\(\\(?:\\[@\\(?:start:\\)?[0-9]+\\][ \t]*\\)?\\[\\(?:X\\|\\([0-9]+\\)/\\2\\)\\][^\n]*\n\\)"))
    (font-lock-add-keywords
     'org-mode
     `((,pattern 1 'org-headline-done prepend))
     'append))

  ) ;; `my-org-configuration'


;;; Agenda / Capture

;; Default notes file.
(setq org-default-notes-file (expand-file-name "~/org/notes.org"))

;; Default agenda files.
(setq org-agenda-files `(,org-default-notes-file
                         ,(expand-file-name "~/org/todo.org")))

(with-eval-after-load "org-capture"
  ;; (setq org-capture-templates nil)
  (add-to-list 'org-capture-templates
               `("t" "Todo" entry
                 (file+headline ,org-default-notes-file "Tasks")
                 "** %^{title}
SCHEDULED: %T
%?
%i
  %a
  Added: %U"))
  )

;; https://cestlaz.github.io/posts/using-emacs-24-capture-2/
;; Bind Key to: emacsclient --eval "(my-org-capture)"
;; XMonad: , ((modMask, xK_o), spawn "emacsclient --eval \"(my-org-capture)\"")
(defun my-org-capture ()
  "Create a new frame and run `org-capture'."
  (interactive)
  (select-frame (make-frame '((my-org-capture . t))))
  (delete-other-windows)
  (cl-letf (((symbol-function 'switch-to-buffer-other-window) #'switch-to-buffer))
    (condition-case err
        (org-capture)
      ;; `org-capture' signals (error "Abort") when "q" is typed, so
      ;; delete the newly-created frame in this scenario.
      (error (when (equal err '(error "Abort"))
               (delete-frame))))))

(defadvice org-capture-finalize (after my-delete-capture-frame activate)
  "Delete the frame after `capture-finalize'."
  (when (frame-parameter nil 'my-org-capture)
    (delete-frame)))

(defadvice org-capture-destroy (after my-delete-capture-frame activate)
  "Delete the frame after `capture-destroy'."
  (when (frame-parameter nil 'my-org-capture)
    (delete-frame)))

;; (ad-remove-advice 'org-capture-finalize 'after 'my-delete-capture-frame)
;; (ad-activate 'org-capture-finalize)
;; (ad-remove-advice 'org-capture-destroy 'after 'my-delete-capture-frame)
;; (ad-activate 'org-capture-destroy)

(add-hook 'org-agenda-finalize-hook 'hide-trailing-whitespace)


;;; Babel

;; Syntax highlighting for source code blocks.
(setq org-src-fontify-natively t)

;; Preserve source code indentation upon export
(setq org-src-preserve-indentation t)

;; org-babel supported languages
(defun my-org-babel-do-load-languages ()
  (org-babel-do-load-languages
   'org-babel-load-languages
   (mapcar (lambda (lang) (cons lang t))
           `(
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
             ;; ;; ob-sh changed to ob-shell in emacs 26.1
             ,(if (locate-library "ob-shell") 'shell 'sh)
             ;; shen
             sql
             ;; sqlite
             ))))


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


;;; Compatibility

;; Org conflicts with the default windmove bindings, and I'm much too
;; used to those, so I'm changing the bindings for Org instead:
(customize-set-value 'org-replace-disputed-keys t)
(customize-set-value 'org-disputed-keys
                     '(([(shift up)] . [(super shift up)])
                       ([(shift down)] . [(super shift down)])
                       ([(shift left)] . [(super shift left)])
                       ([(shift right)] . [(super shift right)])))

;; n.b. Org also conflicts with shift-selection, but I don't use that:
;; ([(control shift right)] . [(meta shift +)])
;; ([(control shift left)] . [(meta shift -)])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-org)
