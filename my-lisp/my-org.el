;; -*- lexical-binding: nil; -*-

;; I don't really know what I'm doing yet.

;;; Silence compiler warnings
(eval-when-compile
  (declare-function hide-trailing-whitespace "my-whitespace")
  (declare-function my-bug-reference-mode-enable "my-version-control")
  (declare-function org-agenda-files "org")
  (declare-function org-defkey "org-keys")
  (declare-function org-eval-in-calendar "org")
  (declare-function org-open-at-mouse "org")
  (declare-function org-timer--get-timer-title "org-timer")
  (declare-function org-timer-set-timer "org-timer")
  (declare-function org-timer-value-string "org-timer")

  (defvar org-adapt-indentation)
  (defvar org-agenda-files)
  (defvar org-agenda-include-diary)
  (defvar org-agenda-mode-map)
  (defvar org-agenda-time-grid)
  (defvar org-capture-templates)
  (defvar org-default-notes-file)
  (defvar org-edit-src-content-indentation)
  (defvar org-ellipsis)
  (defvar org-fontify-done-headline)
  (defvar org-goto-interface)
  (defvar org-log-done)
  (defvar org-mode-map)
  (defvar org-read-date-minibuffer-local-map)
  (defvar org-show-notification-handler)
  (defvar org-src-fontify-natively)
  (defvar org-src-preserve-indentation)
  (defvar org-timer-mode-line-string)
  (defvar org-timer-pause-time)
  (defvar org-todo-keyword-faces)
  (defvar org-todo-keywords)
  (defvar org-use-speed-commands)
  )

;;; Tutorials etc

;; http://pragmaticemacs.com/category/org/
;; http://orgmode.org/worg/org-tutorials/org4beginners.html
;; http://orgmode.org/worg/org-tutorials/orgtutorial_dto.html
;; http://www.star.bris.ac.uk/bjm/emacs.html


;;; General configuration

(defun my-org-configuration ()
  "General configuration for `org-mode'."

  ;; Enable `org-speed-commands' when at the beginning of a headline.
  ;; E.g. 'n', 'p' to move between headlines.  For details, see
  ;; `org-speed-command-hook' (called by `org-self-insert-command').
  ;; This variable may also have a function value, to test for
  ;; appropriate locations where speed commands should be active.
  (setq org-use-speed-commands t)

  ;; Use a completing read UI for the `org-goto' (C-c C-j) command.
  (setq org-goto-interface 'outline-path-completion)

  ;; Prevent the demoting of a heading also shifting text within its sections.
  (setq org-adapt-indentation nil)

  ;; ;; Set maximum indentation for description lists.
  ;; (setq org-list-description-max-indent 5)

  ;; Number of empty lines needed to keep an empty line between collapsed trees.
  ;; (setq org-cycle-separator-lines 2)

  ;; Use a real ellipsis character.
  (setq org-ellipsis "…")

  ;; TODO keywords.
  (setq org-todo-keywords '((sequence "TODO" "WORK" "DONE"))
        org-todo-keyword-faces '(("WORK" . org-priority)))

  ;; Use the `org-headline-done' face for completed todo items.
  (setq org-fontify-done-headline t)

  ;; Log the date/time when a TODO item is marked as DONE.
  (setq org-log-done 'time)

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

  ;; Default notes file.
  (setq org-default-notes-file (expand-file-name "~/org/notes.org"))

  ;; Default agenda files.
  (setq org-agenda-files `(,org-default-notes-file
                           ,(expand-file-name "~/org/todo.org")))

  ;; Calendar keys conflict with windmove.
  (let ((map org-read-date-minibuffer-local-map)) ;; see which.
    (org-defkey map (kbd "M-<up>")
                (lambda () (interactive)
                  (org-eval-in-calendar '(calendar-backward-week 1))))
    (org-defkey map (kbd "M-<down>")
                (lambda () (interactive)
                  (org-eval-in-calendar '(calendar-forward-week 1))))
    (org-defkey map (kbd "M-<left>")
                (lambda () (interactive)
                  (org-eval-in-calendar '(calendar-backward-day 1))))
    (org-defkey map (kbd "M-<right>")
                (lambda () (interactive)
                  (org-eval-in-calendar '(calendar-forward-day 1)))))

  ;; Notifications.
  (when (fboundp 'reminder--frame)
    (setq org-show-notification-handler #'reminder--frame))

  ) ;; `my-org-configuration'


;;; Clock / timer / notification

(defvar my-pomodoro-history nil
  "History of purpose strings for `my-pomodoro'.")

(defun my-pomodoro (minutes &optional purpose)
  "Start a count-down timer lasting MINUTES for working on PURPOSE."
  ;; (interactive "nMinutes: \nsPurpose: ")
  (interactive (let (title)
                 (require 'org-timer)
                 (setq title (or (org-timer--get-timer-title)
                                 "Pomodoro"))
                 (list (read-number "Minutes: ")
                       (read-string (format "Purpose [%s]: " title)
                                    nil 'my-pomodoro-history title))))
  ;; This is a hack to make `org-timer--get-timer-title' default to
  ;; the title of our choosing, rather than the selected buffer name
  ;; (by making the buffer name the message of our choosing).
  (let ((buf (get-buffer-create
              (if purpose (format "Pomodoro: %s" purpose) "Pomodoro")
              t)))
    (unwind-protect
        (with-current-buffer buf
          (org-timer-set-timer minutes))
      (when (buffer-live-p buf)
        (kill-buffer buf)))))

;; This is the standard definition with the space at the end instead
;; of at the start.
(define-advice org-timer-update-mode-line (:override () my-spacing)
  "Update the timer time in the mode line."
  (if org-timer-pause-time
      nil
    (setq org-timer-mode-line-string
          (concat "<" (substring (org-timer-value-string) 0 -1) "> "))
    (force-mode-line-update)))


;;; Agenda / Capture

(defun my-org-open-at-mouse (ev)
  "Used in org-agenda buffers."
  ;; We do this because of: Warning (org-element):
  ;; `org-element-at-point' cannot be used in non-Org buffer #<buffer
  ;; *Org Agenda*> (org-agenda-mode) (found in org-mouse-map) which
  ;; happen when `org-open-at-point' calls `org-element-context' if it
  ;; doesn't have any success trying `org-open-at-point-functions'.
  (interactive "e")
  (let ((warning-suppress-log-types '((org-element org-element-parser))))
    (org-open-at-mouse ev)))

(defun my-org-agenda-configuration ()
  "Configuration for `org-agenda'."

  ;; Include diary entries in the agenda.
  (setq org-agenda-include-diary t)

  ;; Fix display alignment (make this two chars shorter).
  ;; (setf (nth 2 org-agenda-time-grid) " ┄┄┄ ")
  ;; (setf (nth 2 org-agenda-time-grid) "       ┄ ")
  (setf (nth 2 org-agenda-time-grid) "        ")
  ;; Plus this hack to `org-agenda-format-item':
  ;; (setq time (cond (s2 (concat (org-agenda-time-of-day-to-ampm-maybe s1)
  ;;                              "-" (org-agenda-time-of-day-to-ampm-maybe s2)
  ;;                              (when org-agenda-timegrid-use-ampm " ")
  ;;                              "  ")) ;; <--- append these spaces.

  ;; Prevent warning when following links in Agenda buffers.
  (define-key org-agenda-mode-map [remap org-open-at-mouse] #'my-org-open-at-mouse)
  ) ;; `my-org-agenda-configuration'

(with-eval-after-load "org-agenda"
  (my-org-agenda-configuration))

(add-hook 'org-agenda-mode-hook 'my-org-agenda-mode-hook)

(defun my-org-agenda-mode-hook ()
  "Used in `org-agenda-mode-hook'."
  (my-bug-reference-mode-enable))

(add-hook 'org-agenda-finalize-hook 'my-org-agenda-finalize-hook)

(defvar my-org-agenda--daily-reset nil
  "Used to ensure that org-agenda arranges appt notifications daily.")

(defun my-org-agenda-finalize-hook ()
  "Called in `org-agenda-finalize-hook'."
  (hide-trailing-whitespace)
  ;; Include org-agenda entries in appt.el notifications.
  ;;
  ;; Only process the changes if an agenda file has been modified.
  ;; This still risks re-adding appts that I previously deleted
  ;; manually, but I'm not sure if I can easily do anything more
  ;; about that.
  (when (catch 'update-required
          (let ((today (time-to-days (current-time))))
            (unless (eql my-org-agenda--daily-reset today)
              (setq my-org-agenda--daily-reset today)
              (throw 'update-required t)))
          (dolist (file (org-agenda-files))
            (when (file-has-changed-p file)
              (throw 'update-required t))))
    (org-agenda-to-appt)))

(defun my-org-capture-configuration ()
  "Configuration for `org-capture'."
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
  ) ;; `my-org-capture-configuration'

(with-eval-after-load "org-capture"
  (my-org-capture-configuration))

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

(define-advice org-capture-finalize (:after (&rest _args) my-delete-capture-frame)
  "Delete the frame after `capture-finalize'."
  (when (frame-parameter nil 'my-org-capture)
    (delete-frame)))

(define-advice org-capture-destroy (:after (&rest _args) my-delete-capture-frame)
  "Delete the frame after `capture-destroy'."
  (when (frame-parameter nil 'my-org-capture)
    (delete-frame)))


;;; Babel

;; Syntax highlighting for source code blocks.
(setq org-src-fontify-natively t)

;; Don't introduce extra indentation within the block.
(setq org-edit-src-content-indentation 0)

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
             ;; python
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


;;; Deferred configuration

(defun my-org-deferred-config ()
  (require 'org-tempo)
  (define-key org-mode-map (kbd "C-M-<") 'my-org-structure-template)
  (my-org-babel-do-load-languages)
  (my-org-configuration))

(with-eval-after-load "org"
  (my-org-deferred-config))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-org)
