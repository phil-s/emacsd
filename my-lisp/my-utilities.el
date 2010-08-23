;; Functions/keys for moving within and switching between
;; buffers and windows

(defun expand-other-window ()
  "Move to and expand the next window"
  (interactive)
  (other-window 1)
  (delete-other-windows))

(defun kill-other-buffer ()
  "Kill the next buffer, and expand the current one"
  (interactive)
  (other-window 1)
  (kill-buffer nil)
  (other-window -1)
  (delete-other-windows))

(defun split-window-vertically-change-buffer ()
  "Split the window vertically, and switch to the next buffer"
  (interactive)
  (split-window-vertically)
  (other-window 1)
  (switch-to-buffer (other-buffer)))

(defun scroll-one-line-ahead ()
  "Scroll ahead one line"
  (interactive)
  (scroll-up 1)
  (forward-line 1))

(defun scroll-one-line-back ()
  "Scroll back one line"
  (interactive)
  (scroll-down 1)
  (forward-line -1))

(defun my-multi-occur-in-matching-buffers (regexp &optional allbufs)
  "Show all lines matching REGEXP in all buffers."
  (interactive (occur-read-primary-args))
  (multi-occur-in-matching-buffers ".*" regexp))

;; Provide a simpler backwards zap-to-char (than prefixing with C-u -1)
(defun zap-to-char-backwards (arg char)
  (interactive "p\ncZap backwards to char: ")
  (zap-to-char (- arg) char))
(global-set-key (kbd "C-M-z") 'zap-to-char-backwards)

;; Enable apply-macro-to-region-lines with named macros
(defun apply-named-macro-to-region-lines (top bottom)
  "Apply named keyboard macro to all lines in the region."
  (interactive "r")
  (let ((macro (intern
                (completing-read "kbd macro (name): "
                                 obarray
                                 (lambda (elt)
                                   (and (fboundp elt)
                                        (or (stringp (symbol-function elt))
                                            (vectorp (symbol-function elt))
                                            (get elt 'kmacro))))
                                 t))))
    (apply-macro-to-region-lines top bottom macro)))

;; Uniqify region (alternative to "C-u M-| uniq RET")
(defun uniquify-region ()
  "remove duplicate adjacent lines in the given region"
  (interactive)
  (narrow-to-region (region-beginning) (region-end))
  (goto-char (point-min))
  (while (re-search-forward "\\(.*\n\\)\\1+" nil t)
    (replace-match "\\1" nil nil))
  (widen)
  nil)

;; Uniqify region (alternative to "C-u M-| sort | uniq RET")
(defun uniquify-region-sorted ()
  "sort and remove duplicate lines in the given region"
  (interactive)
  (sort-lines nil (region-beginning) (region-end))
  (uniquify-region))

;; Rename file and buffer together
(defun rename-file-and-buffer ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (cond ((get-buffer new-name)
               (message "A buffer named '%s' already exists!" new-name))
              (t
               (rename-file name new-name 1)
               (rename-buffer new-name)
               (set-visited-file-name new-name)
               (set-buffer-modified-p nil)))))))

;; Duplicate / clone the current line.
(defun clone-line ()
  "Duplicate line at cursor, leaving the latter intact."
  (interactive "*")
  (save-excursion
    ;; The last line of the buffer cannot be killed
    ;; if it is empty. Instead, simply add a new line.
    (if (and (eobp) (bolp))
        (newline)
      ;; Otherwise kill the whole line, and yank it back.
      (let ((kill-read-only-ok t)
            deactivate-mark)
        (toggle-read-only 1)
        (kill-whole-line)
        (toggle-read-only 0)
        (yank)))))


;; Display non-critical messages (probably) with minimal interference.
(defun my-unimportant-notification (format-string &rest args)
  (my--unimportant-notification format-string args
   0 ; seed the attempt counter
   5 ; default seconds to postpone when minibuffer is active
   ))

(defun my--unimportant-notification (format-string args attempts delay)
  "Display a message temporarily, unless minibuffer is active."
  (if (< attempts 32) ;; bail out eventually
      (if (minibufferp (current-buffer))
          ;; postpone by an ever-increasing delay
          (run-with-timer
           delay nil #'(lambda ()
                         (my--unimportant-notification format-string args
                          (1+ attempts) (+ 5 delay))))
        ;; otherwise
        (let ((backup-message (current-message))
              (tmp-message (apply 'format format-string args)))
          ;; TODO: add notice of how delayed the message was.
          (message tmp-message) ; show message briefly,
          (run-with-timer       ; then revert.
           3 nil
           #'(lambda (tmp-message backup-message)
               ;; revert to the backup message, unless something
               ;; else has already over-written our temporary one
               (if (string= tmp-message (current-message))
                   (message backup-message)))
           tmp-message
           backup-message)))))

;; Convert file's EOL style to Unix
(defun to-unix-eol (fpath)
  "Change file's line ending to unix convention."
  (let (mybuffer)
    (setq mybuffer (find-file fpath))
    (set-buffer-file-coding-system 'unix) ; or 'mac or 'dos
    (save-buffer)
    (kill-buffer mybuffer)))

;; Bulk-convert EOL style to Unix (for marked files in Dired).
(defun dired-2unix-marked-files ()
  "Change to unix line ending for marked (or next arg) files."
  (interactive)
  (mapc 'to-unix-eol (dired-get-marked-files)))

;; Diff file with autosave backup
(defun ediff-auto-save ()
  "Ediff the current file with its auto-save."
  (interactive)
  (let ((auto-file-name (make-auto-save-file-name))
        (file-major-mode major-mode))
    (ediff-files buffer-file-name auto-file-name)
    (switch-to-buffer-other-window (file-name-nondirectory auto-file-name))
    (apply file-major-mode '())
    (other-window 1))) ;; back to ediff panel

;; Kill ring / Yank assistance
(global-set-key (kbd "C-c y") #'(lambda ()
                                  (interactive)
                                  (popup-menu 'yank-menu)))

(when (require 'browse-kill-ring nil 'noerror)
  ;; Either...
  ;; make it the default behaviour:
  ;;(browse-kill-ring-default-keybindings)
  ;;
  ;; or use a custom key binding:
  (global-set-key (kbd "C-c k") 'browse-kill-ring)
  )

;; Add a 'F'ind marked files keybinding to dired
(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map "F" 'my-dired-find-file)
     (defun my-dired-find-file (&optional arg)
       "Open each of the marked files, or the file under the point, or when prefix arg, the next N files "
       (interactive "P")
       (let* ((fn-list (dired-get-marked-files nil arg)))
         (mapc 'find-file fn-list)))))

;;
;; Ediff with autosave file
;;
(defun ediff-auto-save ()
  "Ediff current file and its auto-save pendant."
  (interactive)
  (let ((auto-file-name (make-auto-save-file-name))
        (file-major-mode major-mode))
    (ediff-files buffer-file-name auto-file-name)
    (switch-to-buffer-other-window (file-name-nondirectory auto-file-name))
    (apply file-major-mode '())
    (other-window 1))) ;; back to ediff panel

;;
;; Diff the current buffer with the file contents
;;

(defun diff-current-buffer-with-disk ()
  "Compare the current buffer with it's disk file."
  (interactive)
  (diff-buffer-with-file (current-buffer)))


;;(defun ediff-file-with-buffer (file-A buf-B &optional startup-hooks job-name merge-buffer-file)
;;  (let (buf-A buf-C)
;;    (message "Reading file %s ... " file-A)
;;    ;;(sit-for 0)
;;    (ediff-find-file 'file-A 'buf-A 'ediff-last-dir-A 'startup-hooks)
;;    (ediff-setup buf-B file-B
;;       startup-hooks
;;       (list (cons 'ediff-job-name job-name))
;;       merge-buffer-file)))
;;
;; see defun ediff-setup (ediff-utils.el)
;; see defun ediff-files-internal (ediff.el)


;; (defadvice kill-buffer (around my-kill-buffer-check activate)
;;   "Prompt when a buffer is about to be killed."
;;   (let* ((buffer-file-name (buffer-file-name))
;;          backup-file)
;;     ;; see 'backup-buffer
;;     (if (and (buffer-modified-p)
;;              buffer-file-name
;;              (file-exists-p buffer-file-name)
;;              (setq backup-file (car (find-backup-file-name buffer-file-name))))
;;         (let ((answer (completing-read (format "Buffer modified %s, (d)iff, (s)ave, (k)ill? " (buffer-name))
;;                                        '("d" "s" "k") nil t)))
;;           (cond ((equal answer "d")
;;                  (set-buffer-modified-p nil)
;;                  (let ((orig-buffer (current-buffer))
;;                        (file-to-diff (if (file-newer-than-file-p buffer-file-name backup-file)
;;                                          buffer-file-name
;;                                        backup-file)))
;;                    (set-buffer (get-buffer-create (format "%s last-revision" (file-name-nondirectory file-to-diff))))
;;                    (buffer-disable-undo)
;;                    (insert-file-contents file-to-diff nil nil nil t)
;;                    (set-buffer-modified-p nil)
;;                    (setq buffer-read-only t)
;;                    (ediff-buffers (current-buffer) orig-buffer)))
;;                 ((equal answer "k")
;;                  (set-buffer-modified-p nil)
;;                  ad-do-it)
;;                 (t
;;                  (save-buffer)
;;                  ad-do-it)))
;;       ad-do-it)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-utilities)

