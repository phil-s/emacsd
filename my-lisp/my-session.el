;; -*- lexical-binding: nil; -*-
;; Silence compiler warnings
(eval-when-compile
  (defvar desktop-base-file-name)
  (defvar desktop-base-lock-name)
  (defvar desktop-dirname)
  (defvar desktop-files-not-to-save)
  (defvar desktop-globals-to-save)
  (defvar desktop-load-locked-desktop)
  (defvar desktop-path)
  (defvar desktop-save)
  (defvar savehist-additional-variables)
  (declare-function my-unimportant-notification "my-utilities")
  )

;; Automatically save and restore sessions
(setq desktop-dirname             "~/.emacs.d/desktop/"
      desktop-base-file-name      "emacs.desktop"
      desktop-base-lock-name      "lock"
      desktop-path                (list desktop-dirname)
      desktop-save                t
      desktop-files-not-to-save   "^$" ;reload tramp paths
      desktop-load-locked-desktop nil)
(desktop-save-mode 0)

(defun my-desktop ()
  "Load the desktop and enable autosaving"
  (interactive)
  (let ((desktop-load-locked-desktop "ask"))
    (desktop-read)
    (desktop-save-mode 1)))

;; Remember vars between sessions
(add-to-list 'desktop-globals-to-save 'whitespace-line-column)
(add-to-list 'desktop-globals-to-save 'whitespace-style)
(add-to-list 'desktop-globals-to-save 'ibuffer-filter-groups)

;; ;; Use the desktop-recover library to load and auto-save the desktop.
;; ;; Does not work for emacs --daemon
;; (when (require 'desktop-recover nil 'noerror)
;;   (setq desktop-recover-location
;;         (desktop-recover-fixdir desktop-dirname))
;;   ;; Brings up the interactive buffer restore menu
;;   (desktop-recover-interactive))
;;   ;; Note that after using this menu, your desktop will be saved
;;   ;; automatically (triggered by the auto-save mechanism).

;; Save desktop when idle
(add-hook 'auto-save-hook 'my-auto-desktop-save-in-desktop-dir)
(defun my-auto-desktop-save-in-desktop-dir ()
  "Save the desktop in directory `desktop-dirname'."
  (and desktop-save-mode
       desktop-dirname
       (desktop-save desktop-dirname)
       (my-unimportant-notification
        "Desktop saved in %s" (abbreviate-file-name desktop-dirname))))

;; Also save minibuffer/variable histories.
;; n.b. savehist-mode defaults to saving the vars listed in
;; savehist-minibuffer-history-variables, which gets added to
;; as individual features are utilised.
(setq savehist-additional-variables
      '(kill-ring
        Info-history-list
        ;; You don't need to add minibuffer history variables to this
        ;; list, all minibuffer histories will be saved automatically
        ;; as long as `savehist-save-minibuffer-history' is non-nil.
        ))

(define-advice savehist-autosave (:around (orig-fun &rest args) my-no-debug-repeating-timer)
  "Advice for `savehist-autosave'.

Error handling is important for timer callbacks, else we can end up with
non-functional timers with a negative \\='Next\\=' time which can't trigger:
https://debbugs.gnu.org/cgi/bugreport.cgi?bug=39824#53

We let-bind `debug-on-error' to nil around `savehist-autosave' calls.

Remove with:
\(advice-remove \\='savehist-autosave \\='savehist-autosave@my-no-debug-repeating-timer)"
  (with-demoted-errors "Error: %S"
    (let ((debug-on-error nil))
      (apply orig-fun args))))

(savehist-mode 1)
;; n.b. Code elsewhere should use:
;; (with-eval-after-load "savehist"
;;   (add-to-list 'savehist-additional-variables 'some-var))

;; Remove text properties from kill-ring before it is saved to the
;; history file, as these bloat the file dramatically.
;; See http://emacs.stackexchange.com/a/4191 for why this doesn't
;; use `savehist-save-hook'.
(add-hook 'kill-emacs-hook 'my-unpropertize-kill-ring)
(defun my-unpropertize-kill-ring ()
  (setq kill-ring (mapcar 'substring-no-properties kill-ring)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Use a separate static desktop file as the initial set of buffers at
;; start-up:
;;
;; ;; To prepare the start-up desktop file...
;; ;; 1. Run a separate temporary instance of Emacs, and within that:
;; ;; 2. M-x make-directory RET ~/.emacs.d/start RET
;; ;; 3. M-x desktop-change-dir RET ~/.emacs.d/start RET
;; ;; 4. Visit files, etc -- create the configuration you wish to store
;; ;; 5. M-x desktop-save-in-desktop-dir
;; ;; 6. Quit the temporary instance of Emacs
;; ;; 7. Add the following to your regular init file
;; (let (desktop-dirname)
;;   (desktop-read "~/.emacs.d/start")
;;   (desktop-release-lock))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-session)
