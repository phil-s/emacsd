;; Local occur minor mode
;(require 'loccur)

(autoload 'loccur "loccur"
  "Perform a simple grep in current buffer for the regular
expression REGEX

This command hides all lines from the current buffer except those
containing the regular expression REGEX. A second call of the function
unhides lines again"
  t)
(autoload 'loccur-current "loccur" "Call `loccur' for the current word." t)
(autoload 'loccur-previous-match "loccur" "Call `loccur' for the previously found word." t)

;; Use framemove, integrated with windmove.
(windmove-default-keybindings) ;default modifier is <SHIFT>
(when (require 'framemove nil :noerror)
  (setq framemove-hook-into-windmove t))

;; Sudo support for Unix-like systems
;; (should this include (eq system-type 'cygwin) ??)
(when (not (or (eq system-type 'windows-nt)
               (eq system-type 'ms-dos)))
  (require 'sudo)
  (defun sudo-before-save-hook ()
    (set (make-local-variable 'sudo:file) (buffer-file-name))
    (when sudo:file
      (unless(file-writable-p sudo:file)
        (set (make-local-variable 'sudo:old-owner-uid) (nth 2 (file-attributes sudo:file)))
        (when (numberp sudo:old-owner-uid)
          (unless (= (user-uid) sudo:old-owner-uid)
            (when (y-or-n-p
                   (format "File %s is owned by %s, save it with sudo? "
                           (file-name-nondirectory sudo:file)
                           (user-login-name sudo:old-owner-uid)))
              (sudo-chown-file (int-to-string (user-uid)) (sudo-quoting sudo:file))
              (add-hook 'after-save-hook
                        (lambda ()
                          (sudo-chown-file (int-to-string sudo:old-owner-uid)
                                           (sudo-quoting sudo:file))
                          (if sudo-clear-password-always
                              (sudo-kill-password-timeout)))
                        nil   ;; not append
                        t	    ;; buffer local hook
                        )))))))
  (add-hook 'before-save-hook 'sudo-before-save-hook))

;; Follow mode for compilation/output buffers
;; http://www.anc.ed.ac.uk/~stephen/emacs/fm.el
;; (when (require 'fm nil 'noerror)
;;   (add-hook 'occur-mode-hook 'fm-start)
;;   (add-hook 'compilation-mode-hook 'fm-start))


;; ;; Icicles
;; (add-to-list 'load-path
;;              (file-name-as-directory
;;               (expand-file-name "~/.emacs.d/lisp/icicles")))
;; (autoload 'icicle-mode "icicle-mode"
;;   "Icicle mode: Toggle minibuffer input completion and cycling.
;; Non-nil prefix ARG turns mode on if ARG > 0, else turns it off.
;; Icicle mode is a global minor mode.  It binds keys in the minibuffer."
;;   t)


(eval-after-load 'geben
  '(progn
     ;; Evaluate word at point.
     (define-key geben-mode-map (kbd "E") 'geben-eval-current-word)

     (defadvice geben-dbgp-command-eval (before my-geben-eval-printr)
       "Use print_r($var, TRUE); by default when evaluating $var."
       (when (or (equal major-mode 'php-mode)
                 (equal major-mode 'drupal-mode))
         (let ((expr (ad-get-arg 1)))
           (when (posix-string-match "^\\$" expr)
             (ad-set-arg 1 (concat "print_r(" expr ", TRUE);"))))))
     (ad-activate 'geben-dbgp-command-eval)

     ;; Re-define `geben-dbgp-response-eval' to output to a temporary buffer,
     ;; rather than using (message).
     (defun geben-dbgp-response-eval (session cmd msg)
       "A response message handler for \`eval\' command."
       (with-output-to-temp-buffer "*GEBEN: eval*"
         (when (string< "0.24" geben-version)
           (print "GEBEN has been upgraded since geben-dbgp-response-eval was redefined."))
         (print
          (geben-dbgp-decode-value (car-safe (xml-get-children msg 'property)))))
       ;; (select-window (display-buffer "*GEBEN: eval*"))
       )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-libraries)
