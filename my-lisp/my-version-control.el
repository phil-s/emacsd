;; General VCS

;; Silence compiler warnings
(eval-when-compile
  (defvar vc-log-show-limit)
  (declare-function diff-hl-flydiff-mode "diff-hl-flydiff")
  (declare-function global-diff-hl-mode "diff-hl")
  (declare-function vc-deduce-fileset "vc")
  (declare-function vc-find-revision "vc")
  (declare-function vc-print-log-internal "vc")
  (declare-function vc-read-revision "vc")
  )

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

(defun my-vc-visit-file-revision (file rev)
  "Visit revision REV of FILE in another window.
With prefix argument, uses the current window instead.
If the current file is named `F', the revision is named `F.~REV~'.
If `F.~REV~' already exists, use it instead of checking it out again."
  ;; based on `vc-revision-other-window'.
  (interactive
   (let ((file (expand-file-name
                (read-file-name
                 (if (buffer-file-name)
                     (format "File (%s): " (file-name-nondirectory
                                            (buffer-file-name)))
                   "File: ")))))
     (require 'vc)
     (unless (vc-backend file)
       (error "File %s is not under version control" file))
     (list file (vc-read-revision
                 "Revision to visit (default is working revision): "
                 (list file)))))
  (require 'vc)
  (unless (vc-backend file)
    (error "File %s is not under version control" file))
  (let ((revision (if (string-equal rev "")
                      (vc-working-revision file)
                    rev))
        (visit (if current-prefix-arg
                   'switch-to-buffer
                 'switch-to-buffer-other-window)))
    (funcall visit (vc-find-revision file revision))))

(defun my-vc-print-revision-log (working-revision &optional limit)
  ;; Derived from `vc-print-log'.
  "List the change log at WORKING-REVISION of the current fileset in a window.

If LIMIT is non-nil, it should be a number specifying the maximum
number of revisions to show; the default is `vc-log-show-limit'.

When called interactively with a prefix argument, prompts for LIMIT also."
  (interactive
   (let ((rev (read-from-minibuffer
               "Working revision (default: last revision): " nil nil nil nil))
         (lim (when current-prefix-arg
                (string-to-number (read-from-minibuffer
                                   "Limit display (unlimited: 0): "
                                   (format "%s" vc-log-show-limit)
                                   nil nil nil)))))
     (when (string= rev "") (setq rev nil))
     (when (and lim (<= lim 0)) (setq lim nil))
     (list rev lim)))
  (let* ((vc-fileset (vc-deduce-fileset t)) ;FIXME: Why t? --Stef
         (backend (car vc-fileset))
         (files (cadr vc-fileset))
         ;; (working-revision (or working-revision
         ;;                       (vc-working-revision (car files))))
         )
    (vc-print-log-internal backend files working-revision t limit)))

;; diff-hl library
(global-diff-hl-mode 1)
(diff-hl-flydiff-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; SVN (Subversion)

;; Silence compiler warnings
(eval-when-compile
  (defvar svn-log-edit-show-diff-for-commit)
  (defvar svn-status-custom-hide-function)
  (declare-function svn-status-line-info->filename-nondirectory "psvn"))

;; (setq vc-svn-global-switches
;;       '("--username" "phils" "--password" "password"))

(setq svn-log-edit-show-diff-for-commit t)

;; Start the psvn interface with M-x svn-status
;; PSVN customisations
(eval-after-load 'psvn
  '(progn
     (require 'cl-lib)
     (setq svn-status-custom-hide-function 'svn-status-hide-pyc-files)
     (defun svn-status-hide-pyc-files (info)
       "Hide all pyc files in the `svn-status-buffer-name' buffer."
       (let* ((fname (svn-status-line-info->filename-nondirectory info))
              (fname-len (length fname)))
         (and (> fname-len 4) (string= (substring fname (- fname-len 4)) ".pyc"))))

     (defsubst svn-status-interprete-state-mode-color (stat)
       "Interpret vc-svn-state symbol to mode line color"
       (cl-case stat
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

;; Silence compiler warnings
(eval-when-compile
  (defvar git-commit-finish-query-functions)
  (defvar git-commit-finish-query-functions)
  (defvar git-commit-summary-max-length)
  (defvar magit-log-buffer-file-locked)
  (defvar magit-mode-map))

;; No, I really don't want Emacs to complain that my summary line is
;; long enough to be useful (no matter what the git book recommends).
(eval-after-load "git-commit"
  '(setq git-commit-finish-query-functions
         (delq 'git-commit-check-style-conventions
               git-commit-finish-query-functions)))

;; Highlighting of too-long summary lines.
;; The default 50 chars is tiny, but let's still highlight summary lines
;; that exceed the standard maximum 72 chars for other log message lines
;; (as the standard formatting will add 8 chars of padding).
(setq git-commit-summary-max-length 72)

;; Whenever Git uses emacsclient as the editor for a commit message,
;; (regardless of Magit), we want to edit in `git-commit-mode'.
(global-git-commit-mode 1)

;; Make log and diff commands from `magit-file-popup' use separate
;; buffers to show the specific-file log/diff. This avoids un/setting
;; the file filter for regular log/diff commands.
(setq magit-log-buffer-file-locked t)

;; Stop asking to save modified buffers before every magit operation!
;; Had I wanted to save the buffers first, I would likely have done so.
(setq magit-save-repository-buffers nil)

(eval-after-load "magit"
  '(global-magit-file-mode 1)) ;; per-file popup on C-c M-g

;; Protect against accidental pushes to upstream
(defadvice magit-push-current-to-upstream
    (around my-protect-accidental-magit-push-current-to-upstream)
  "Protect against accidental push to upstream.

Causes `magit-git-push' to ask the user for confirmation first."
  (let ((my-magit-ask-before-push t))
    ad-do-it))

(defadvice magit-git-push (around my-protect-accidental-magit-git-push)
  "Maybe ask the user for confirmation before pushing.

Advice to `magit-push-current-to-upstream' triggers this query."
  (if (bound-and-true-p my-magit-ask-before-push)
      ;; Arglist is (BRANCH TARGET ARGS)
      (if (yes-or-no-p (format "Push %s branch upstream to %s? "
                               (ad-get-arg 0) (ad-get-arg 1)))
          ad-do-it
        (error "Push to upstream aborted by user"))
    ad-do-it))

(ad-activate 'magit-push-current-to-upstream)
(ad-activate 'magit-git-push)

;; pcomplete

;; Silence compiler warnings
(eval-when-compile
  (declare-function pcomplete-here* "pcomplete")
  (declare-function pcomplete-match "pcomplete")
  (declare-function pcomplete-here, "pcomplete")
  (declare-function pcomplete-entries "pcomplete"))

;; pcomplete support from: http://www.masteringemacs.org/articles/2012/01/16/pcomplete-context-sensitive-completion-emacs/
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
