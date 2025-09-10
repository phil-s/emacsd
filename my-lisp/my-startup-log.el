;; -*- lexical-binding: nil; -*-

;; TODO: `before-init-hook' is a thing.
;;
;; I could probably load this in early-init.el (first), and use
;; hooks to do everything else which is currently hard-coded in
;; either early-init.el or init.el ?
;;
;; I might need to use depths of both -100 and 100 when adding
;; to `after-init-hook' ?
;;
;; And maybe I'd need to do more in the advice to
;; `package-activate-all'?
;;
;; Or perhaps I can just call functions defined in this file,
;; rather than inlining timing code.
;;
;; If it's much-of-a-muchness, then the benefit of having it all
;; automated probably outweighs any miniscule timing differences.




;; Display the time taken to start Emacs.
;;
;; This depends on code in both early-init.el and init.el.
;;
;; It's a separate file just because it got big/messy.
;;
;; Example:
;;
;; Init time was 2.87s comprising:
;; - 0.11s early-init.el
;; - 0.23s elpa (package-activate-all)
;; - 0.37s GUI / frame / site-start
;; - 1.45s init.el
;; - 0.09s after init.el / after-init-hook
;; - 0.52s continued startup / emacs-startup-hook
;; - 0.10s final startup / window-setup-hook

(defvar my-init-load-start (current-time))

(defvar my-early-init-load-start)
(defvar my-early-init-load-end)
(defvar my-elpa-time -0.0)
(defvar my-after-init-hook-time -0.0)
(defvar my-after-init-hook-duration -0.0)
(defvar my-after-startup-hook-time -0.0)
(defvar my-after-startup-hook-duration -0.0)

(defun my-startup-log ()
  "Display the time taken to start Emacs."
  (let (;; Time between `before-init-time' and early-init.el.  [Near zero]
        ;; (before-early (time-to-seconds (time-subtract my-early-init-load-start
        ;;                                               before-init-time)))
        ;; Time to process early-init.el.
        (early-el (time-to-seconds (time-subtract my-early-init-load-end
                                                  my-early-init-load-start)))
        ;; Time between early-init.el and init.el, excluding time for
        ;; `package-activate-all' (see early-init.el).
        (early-to-init (- (time-to-seconds (time-subtract my-init-load-start
                                                          my-early-init-load-end))
                          my-elpa-time))
        ;; Time to process init.el.
        (init-el (time-to-seconds (time-since my-init-load-start)))
        ;; End of init.el (now).
        (after-init-el (current-time)))
    ;; Note the end of `after-init-hook'.
    (add-hook 'after-init-hook
              `(lambda ()
                 (setq my-after-init-hook-time (current-time)
                       my-after-init-hook-duration (time-to-seconds
                                                    (time-since ',after-init-el))))
              100)
    ;; Note the end of `emacs-startup-hook'.
    (add-hook 'emacs-startup-hook
              (lambda ()
                (setq my-after-startup-hook-time (current-time)
                      my-after-startup-hook-duration (time-to-seconds
                                                      (time-since my-after-init-hook-time))))
              100)
    ;; Report all times after `emacs-startup-hook'.
    (add-hook 'window-setup-hook
              `(lambda ()
                 ;; (message "Init time was %.2fs (%.2fs before) (%.2fs in %s) \
                 ;; (%.2fs elpa etc) (%.2fs in %s) (%.2fs after)."
                 ;;                (message "Init time was %.2fs (%.2fs %s) (%.2fs elpa) \
                 ;; (%.2fs other) (%.2fs %s) (%.2fs after-init) (%.2fs startup)"
                 (let ((inhibit-message t))
                   (message "Init time was %.2fs comprising:
- %.2fs %s
- %.2fs elpa (package-activate-all)
- %.2fs GUI / frame / site-start
- %.2fs %s
- %.2fs after init.el / after-init-hook
- %.2fs continued startup / emacs-startup-hook
- %.2fs final startup / window-setup-hook"
                            ;; Total time.
                            (time-to-seconds (time-since before-init-time))
                            ;; ,before-early [~zero]
                            ,early-el (file-name-nondirectory early-init-file)
                            ,my-elpa-time
                            ,early-to-init ;; "other" time between early-init.el and
                            ;; init.el, not accounted for by `package-activate-all'.
                            ,init-el (file-name-nondirectory user-init-file)
                            my-after-init-hook-duration
                            my-after-startup-hook-duration
                            (time-to-seconds (time-since my-after-startup-hook-time))
                            )))
              100)))

(provide 'my-startup-log)
