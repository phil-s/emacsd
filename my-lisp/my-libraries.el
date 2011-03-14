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


;; SVN (Subversion)
(require 'psvn) ;; Start the svn interface with M-x svn-status
;; PSVN customisations
(eval-after-load 'psvn
  '(progn
     (setq svn-status-custom-hide-function 'svn-status-hide-pyc-files)
     (defun svn-status-hide-pyc-files (info)
       "Hide all pyc files in the `svn-status-buffer-name' buffer."
       (let* ((fname (svn-status-line-info->filename-nondirectory info))
              (fname-len (length fname)))
         (and (> fname-len 4) (string= (substring fname (- fname-len 4)) ".pyc"))))

     (defsubst svn-status-interprete-state-mode-color (stat)
       "Interpret vc-svn-state symbol to mode line color"
       (case stat
         ('edited "tomato"      )
         ('up-to-date "#c0e0c0" )
         ;; what is missing here??
         ;; ('unknown  "gray"        )
         ;; ('added    "blue"        )
         ;; ('deleted  "red"         )
         ;; ('unmerged "purple"      )
         (t "red")))

     (defun svn-status-state-mark-modeline-dot (color)
       (propertize "    "
                   'help-echo 'svn-status-state-mark-tooltip
                   'display
                   `(image :type xpm
                           :data ,(format "/* XPM */
static char * data[] = {
\"15 10 3 1\",
\"  c None\",
\"+ c #000000\",
\". c %s\",
\"               \",
\"       ++      \",
\"      +..+     \",
\"     +....+    \",
\"    +......+   \",
\"    +......+   \",
\"     +....+    \",
\"      +..+     \",
\"       ++      \",
\"               \"};"
                                          color)
                           :ascent center)))

     (global-set-key (kbd "C-c v") 'svn-status)
     )) ;; eval-after-load "psvn"


;; ;; Icicles
;; (add-to-list 'load-path
;;              (file-name-as-directory
;;               (expand-file-name "~/.emacs.d/lisp/icicles")))
;; (autoload 'icicle-mode "icicle-mode"
;;   "Icicle mode: Toggle minibuffer input completion and cycling.
;; Non-nil prefix ARG turns mode on if ARG > 0, else turns it off.
;; Icicle mode is a global minor mode.  It binds keys in the minibuffer."
;;   t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-libraries)

