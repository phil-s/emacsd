;; General VCS
(defadvice log-view-diff (around my-advice-log-view-diff)
  "Don't switch from the log window to the diff window."
  (let ((log-view-buffer (current-buffer)))
    ad-do-it
    (pop-to-buffer log-view-buffer)))
(ad-activate 'log-view-diff)

(defadvice log-view-diff-changeset (around my-advice-log-view-diff-changeset)
  "Don't switch from the log window to the changeset window."
  (let ((log-view-buffer (current-buffer)))
    ad-do-it
    (pop-to-buffer log-view-buffer)))
(ad-activate 'log-view-diff-changeset)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; SVN (Subversion)

;; (setq vc-svn-global-switches
;;       '("--username" "phils" "--password" "password"))

(setq svn-log-edit-show-diff-for-commit t)

;; Start the psvn interface with M-x svn-status
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Git

;; pcompete support from: http://www.masteringemacs.org/articles/2012/01/16/pcomplete-context-sensitive-completion-emacs/
(defconst pcmpl-git-commands
  '("add" "bisect" "branch" "checkout" "clone"
    "commit" "diff" "fetch" "grep"
    "init" "log" "merge" "mv" "pull" "push" "rebase"
    "reset" "rm" "show" "status" "tag" )
  "List of `git' commands")

(defvar pcmpl-git-ref-list-cmd "git for-each-ref refs/ --format='%(refname)'"
  "The `git' command to run to get a list of refs")

(defun pcmpl-git-get-refs (type)
  "Return a list of `git' refs filtered by TYPE"
  (with-temp-buffer
    (insert (shell-command-to-string pcmpl-git-ref-list-cmd))
    (goto-char (point-min))
    (let ((ref-list))
      (while (re-search-forward (concat "^refs/" type "/\\(.+\\)$") nil t)
        (add-to-list 'ref-list (match-string 1)))
      ref-list)))

(defun pcomplete/git ()
  "Completion for `git'"
  ;; Completion for the command argument.
  (pcomplete-here* pcmpl-git-commands)
  ;; complete files/dirs forever if the command is `add' or `rm'
  (cond
   ((pcomplete-match (regexp-opt '("add" "rm")) 1)
    (while (pcomplete-here (pcomplete-entries))))
   ;; provide branch completion for the command `checkout'.
   ((pcomplete-match "checkout" 1)
    (pcomplete-here* (pcmpl-git-get-refs "heads")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Check that my git hooks are active for this .emacs.d repository.
(let* ((git-hooks (concat user-emacs-directory "/.git/hooks"))
       (my-hooks (concat user-emacs-directory "/git-hooks"))
       (hook-files (directory-files my-hooks nil "[^.]")))
  (when (file-directory-p git-hooks) ;; we're in a git repo
    (mapc (lambda (hook)
            (unless (file-exists-p (expand-file-name
                                    (concat git-hooks "/" hook)))
              (message "%s git hook not installed." hook)))
          hook-files)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-version-control)
