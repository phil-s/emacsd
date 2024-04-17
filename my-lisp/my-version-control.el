;; General VCS

;; Silence compiler warnings
(eval-when-compile
  (defvar bug-reference-bug-regexp)
  (defvar vc-log-show-limit)
  (declare-function diff-hl-flydiff-mode "diff-hl-flydiff")
  (declare-function global-diff-hl-mode "diff-hl")
  (declare-function vc-deduce-backend "vc")
  (declare-function vc-deduce-fileset "vc")
  (declare-function vc-find-revision "vc")
  (declare-function vc-print-log-internal "vc")
  (declare-function vc-read-revision "vc")
  )

;; Don't waste CPU and mode-line space on VC data for Git.
;; I use Magit for basically everything to do with Git.
;; (advice-add 'vc-git-mode-line-string :override #'ignore)
(setq vc-display-status nil)

;; Use `read-only-mode' in `diff-mode' buffers by default, as this provides
;; more convenient key bindings, and actually editing a diff is uncommon.
(add-hook 'diff-mode-hook 'read-only-mode)

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
     (list file (if (vc-backend file)
                    (vc-read-revision
                     "Revision to visit (default is working revision): "
                     (list file))
                  (vc-read-revision "Revision to visit: " t
                                    (or (vc-deduce-backend)
                                        (vc-responsible-backend file)))))))
  (require 'vc)
  (let ((revision (if (string-equal rev "")
                      (if (vc-backend file)
                          (vc-working-revision file)
                        (error "No revision specified for unregistered file %s"
                               file))
                    rev))
        (backend (or (vc-backend file)
                     (vc-deduce-backend)
                     (vc-responsible-backend file)))
        (visit (if current-prefix-arg
                   'switch-to-buffer
                 'switch-to-buffer-other-window)))
    (condition-case err
        (funcall visit (vc-find-revision file revision backend))
      ;; The errors which can result when we request an invalid combination of
      ;; file and revision tend to be opaque side-effects of some unexpected
      ;; failure within the backend; so we simply trap everything and signal a
      ;; replacement error indicting the assumed cause.
      (error (error "File not found at revision %s: %s" revision file)))))

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

;; ;; diff-hl library
;; (global-diff-hl-mode 1)
;; (diff-hl-flydiff-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Link to bug trackers.

;; Recognise various bug/issue identifiers.
(defvar my-bug-reference-bug-regexp
  (rx (group-n
          1 (seq (group-n
                     3 (or (regexp "[Ww][Rr][- ]?#?")
                           (regexp "[Rr][Mm][- ]?#?")
                           (regexp "[Ii]ssue[- ]?#?")
                           (regexp "[Rr][Ff][Cc][- ]?#?")
                           (regexp "[Bb]ug[- ]?#?")))
                 (group-n
                     2 (seq (one-or-more digit)
                            (opt "#" (one-or-more digit)))))))
  "Value for `bug-reference-bug-regexp'.
Intended for use with `my-bug-reference-url-format'.

Note that if `bug-reference-url-format' is a function, group 1 should
encompass the other groups (see `bug-reference-bug-regexp'); but this
then conflicts with the need for group 2 to match the issue number
if `bug-reference-url-format' actually a format string (if the default
group numbers are used).  This is why I'm using explicit group numbers
here, so that group 2 has the desired value in both scenarios.")

;; Use my custom regexp as the default `bug-reference-bug-regexp'.
;; This has no effect unless `bug-reference-url-format' is also set
;; (which only happens conditionally, and buffer-locally).
;;
;; Starting from 28.1, if either of those variables are nil then
;; 'bug-reference-mode' and 'bug-reference-prog-mode' will attempt
;; an auto-setup process via `bug-reference-auto-setup-functions'.
(setq bug-reference-bug-regexp my-bug-reference-bug-regexp)

(defun my-bug-reference-url-format ()
  "URL generator for `bug-reference-url-format' (see which)."
  (when-let ((type (match-string 3))
             (formatstring
              (cond ((string-prefix-p "WR" type t)
                     "https://wrms.catalyst.net.nz/wr.php?request_id=%s")
                    ((string-prefix-p "RM" type t)
                     "https://redmine.catalyst.net.nz/issues/%s")
                    ((string-prefix-p "Issue" type t)
                     "https://www.drupal.org/i/%s")
                    ((string-prefix-p "RFC" type t)
                     "https://www.rfc-editor.org/rfc/rfc%s.html")
                    ((string-prefix-p "Bug" type t)
                     "https://debbugs.gnu.org/cgi/bugreport.cgi?bug=%s"))))
    (format formatstring (match-string-no-properties 2))))

;; Make that safe for use in the Local Variables section of a file.
(put 'my-bug-reference-url-format 'bug-reference-url-format t)

;; Provide a function for use in mode hooks.
(defun my-bug-reference-mode-enable ()
  "Enable `bug-reference-mode' using `my-bug-reference-url-format'."
  (interactive)
  (setq-local bug-reference-url-format #'my-bug-reference-url-format)
  (bug-reference-mode 1))

;; Link bug references in VC log buffers.
(add-hook 'log-view-mode-hook #'my-bug-reference-mode-enable)

;; How to browse.
(with-eval-after-load 'browse-url
  (add-to-list 'browse-url-handlers
               (cons (rx bos "https://www.rfc-editor.org/rfc/rfc"
                         (one-or-more digit) ".html" eos)
                     'eww-browse-url)))

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
(with-eval-after-load 'psvn
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
      (edited "tomato"      )
      (up-to-date "#c0e0c0" )
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
  ) ;; eval-after-load "psvn"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Git

;; Silence compiler warnings
(eval-when-compile
  (defvar bug-reference-url-format)
  (defvar git-commit-finish-query-functions)
  (defvar git-commit-major-mode)
  (defvar git-commit-summary-max-length)
  (defvar magit-branch-read-upstream-first)
  (defvar magit-diff-paint-whitespace-lines)
  (defvar magit-diff-refine-ignore-whitespace)
  (defvar magit-log-buffer-file-locked)
  (defvar magit--minimal-git)
  (defvar magit-mode-map)
  (defvar magit-process-log-max)
  (defvar magit-process-timestamp-format)
  (defvar magit-refs-sections-hook)
  (defvar magit-refs-show-remote-prefix)
  (defvar magit-revision-fill-summary-line)
  (defvar magit-save-repository-buffers)
  (defvar magit-section-initial-visibility-alist)
  (require 'eieio)
  (declare-function eieio-oref "eieio-core")
  (declare-function global-git-commit-mode "git-commit")
  (declare-function magit-branch-or-commit-at-point "magit-git")
  (declare-function magit-branch-p "magit-git")
  (declare-function magit-current-section "magit-section")
  (declare-function magit-diff-arguments "magit-diff")
  (declare-function magit-diff-range "magit-diff")
  (declare-function magit-get "magit-git")
  (declare-function magit-get-current-branch "magit-git")
  (declare-function magit-get-section "magit-section")
  (declare-function magit-get-upstream-branch "magit-git")
  (declare-function magit-push-current-to-upstream@query-yes-or-no "my-version-control")
  (declare-function magit-push-tag "magit-push")
  (declare-function magit-read-branch "magit-git")
  (declare-function magit-read-string-ns "magit-utils")
  (declare-function magit-refs-refresh-buffer "magit-refs")
  (declare-function magit-run-git "magit-process")
  (declare-function magit-show-refs-head "magit-refs")
  (declare-function magit-wip-mode "magit-wip")
  )

;; Refer to: (info "(magit) Wip Modes")
(magit-wip-mode 1)

;; No, I really don't want Emacs to complain that my summary line is
;; long enough to be useful (no matter what the git book recommends).
(with-eval-after-load "git-commit"
  (setq git-commit-finish-query-functions
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

;; DWIM prompting when creating new branches.
(setq magit-branch-read-upstream-first 'fallback)

;; Keep much more than 32 process log entries.  I sometimes wish to
;; refer back to the output of previous commands.
(setq magit-process-log-max 1024)

;; Include timestamps in the process buffer.
(setq magit-process-timestamp-format "%F %R")

;; Make the refs buffer show the remote name for remote branches.
(setq magit-refs-show-remote-prefix t)

;; Ensure that whitespace additions and removals are highlighted.
(setq magit-diff-paint-whitespace-lines 'all)
(setq magit-diff-refine-ignore-whitespace nil)

;; Show the unpushed commits by default.
(with-eval-after-load "magit-section"
  (add-to-list 'magit-section-initial-visibility-alist
               '(unpushed . show)))

;; FIXME. (el-get is messing this up? Why?)
(load "magit-autoloads")

;; Remove -- now default behaviour.
;; (with-eval-after-load "magit"
;;   (global-magit-file-mode 1)) ;; per-file popup on C-c M-g

;; ;; FIXME: Convert to transient.
;; (with-eval-after-load "magit-branch"
;;   (magit-define-popup-action 'magit-branch-popup
;;     ?a "Create alias"
;;     'my-magit-branch-alias-create)
;;   (magit-define-popup-action 'magit-branch-popup
;;     ?K "Delete alias"
;;     'my-magit-branch-alias-delete))

(defun my-magit-branch-alias-create (alias &optional branch)
  "Create a new ALIAS for BRANCH."
  (interactive (list (magit-read-string-ns "New alias")
                     (magit-read-branch "Source branch")))
  (when (magit-branch-p alias)
    (user-error "Cannot create alias %s.  It already exists" alias))
  (magit-run-git "branch-alias" alias branch))

(defun my-magit-branch-alias-delete (alias)
  "Delete an existing ALIAS."
  (interactive (list (magit-read-branch "Delete alias")))
  (magit-run-git "branch-alias" "--delete" alias))

(defun my-magit-diff-config ()
  "Called after loading `magit-diff'."
  (transient-append-suffix 'magit-diff "r"
    '("R" "Diff range" magit-diff-range))
  (transient-replace-suffix 'magit-diff "r"
    '("r" "Diff ..HEAD" my-magit-diff-range-from-ref-to-head)))

(with-eval-after-load "magit-diff"
  (my-magit-diff-config))

(defun my-magit-diff-range-from-ref-to-head (rev &optional args files)
  "Call `magit-diff-range' for REV..HEAD."
  (interactive (cons (or (magit-branch-or-commit-at-point)
                         (magit-read-branch-or-commit "Diff to HEAD from"))
                     (magit-diff-arguments)))
  (magit-diff-range (format "%s..HEAD" rev) args files))

;; ;; FIXME: Convert to transient.
;; (with-eval-after-load "magit-refs"
;;   ;; Do not insert Tags into the refs buffer by default. (Slow!)
;;   (setq magit-refs-sections-hook
;;         (delq 'magit-insert-tags magit-refs-sections-hook))
;;   ;; ...but add a new Tags option to the popup, which does so. (y t)
;;   (magit-define-popup-action 'magit-show-refs-popup ?t
;;     "Insert tags section" 'my-magit-insert-tags))

(defun my-magit-push-timestamp-tag-to-origin ()
  (interactive)
  (let ((ts (format-time-string "%s")))
    (magit-run-git "tag" ts)
    (magit-push-tag ts "origin")))

;; ;; FIXME: Convert to transient.
;; (with-eval-after-load "magit-remote"
;;   (magit-define-popup-action 'magit-push-popup
;;     ?s "timestamp tag to origin"
;;     'my-magit-push-timestamp-tag-to-origin))

(defun my-magit-insert-tags ()
  "Insert the Tags section at the end of the current buffer."
  (interactive)
  (eval-and-compile (require 'magit-section))
  (unless (derived-mode-p 'magit-refs-mode)
    (magit-show-refs-head))
  (widen)
  ;; Use the following to discover the identifier for a section:
  ;; M-: (magit-section-ident (magit-current-section))
  (let ((tags (magit-get-section '((tags) (branchbuf)))))
    (if tags
        (progn
          (goto-char (oref tags start))
          (recenter 0))
      (let ((inhibit-read-only t))
        ;; Calling `magit-insert-tags' directly causes problems with
        ;; the other sections (e.g. they are no longer collapsible)
        ;; and so I'm refreshing all the contents, which is going to
        ;; be slower; but not by too much -- Tags is by far the
        ;; slowest section to insert, so this seems ok in practice.
        (erase-buffer)
        (let ((magit-refs-sections-hook
               (if (memq 'magit-insert-tags magit-refs-sections-hook)
                   magit-refs-sections-hook
                 (append magit-refs-sections-hook '(magit-insert-tags)))))
          (magit-refs-refresh-buffer nil)
          (setq tags (magit-get-section '((tags) (branchbuf))))
          (if (not tags)
              (message "No tags found")
            (goto-char (oref tags start))
            (recenter 0)))))))

;; Jump to *my* branches in the refs buffer.  Jump to the end of the
;; list, on the basis that I'll be using issue numbers in the branch
;; names, and therefore the end of the list has the most-recent issue.
(add-hook 'magit-refresh-buffer-hook 'my-magit-refresh-buffer-hook)
(defun my-magit-refresh-buffer-hook ()
  "Custom `magit-refresh-buffer' behaviours."
  (eval-and-compile (require 'magit-section))
  (when (derived-mode-p 'magit-refs-mode)
    (let ((pos (save-excursion
                 (goto-char (oref (magit-current-section) end))
                 (re-search-backward "^\\*? *phil/" nil :noerror))))
      (when pos
        (goto-char pos)
        (recenter -1)))))

;; Protect against accidental pushes to upstream
(with-eval-after-load "magit"
  (if (version< "1.9.4" magit--minimal-git)
      ;; We undoubtedly have a more recent magit version.
      ;; (It's actually difficult to establish magit's version!)
      (define-advice magit-push-current-to-upstream (:before (args) query-yes-or-no)
        "Prompt for confirmation before permitting a push to upstream."
        (when-let ((branch (magit-get-current-branch)))
          (unless (yes-or-no-p (format "Push %s branch upstream to %s? "
                                       branch
                                       (or (magit-get-upstream-branch branch)
                                           (magit-get "branch" branch "remote"))))
            (user-error "Push to upstream aborted by user"))))
    ;; Otherwise we're probably still using 2.12:
    (advice-remove 'magit-push-current-to-upstream
                   #'magit-push-current-to-upstream@query-yes-or-no)

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
    (ad-activate 'magit-git-push)))

;; Custom major mode for commits
(define-derived-mode my-git-commit-mode text-mode "Git commit"
  ;; Insert a WR# prefix based on the branch name. e.g.:
  ;; # On branch phil/wr123456-feature-description
  (save-match-data
    (unless (looking-at "\\`[^#\n]")
      (let ((wr "^# On branch \\(?:[^/]+/\\)?[wW][rR]#?\\([0-9]+\\)"))
        (when (save-excursion (re-search-forward wr nil :noerror))
          (insert (format "WR#%s - " (match-string 1)))
          (open-line 1))))))

(add-hook 'my-git-commit-mode-hook #'my-bug-reference-mode-enable)

(setq git-commit-major-mode 'my-git-commit-mode)

(add-hook 'magit-mode-hook 'my-magit-mode-hook)
(defun my-magit-mode-hook ()
  "Custom `magit-mode' behaviours."
  ;; Magit uses big margins which reduce the effective window width, and
  ;; cause `window-splittable-p' to return nil for horizontal splits even
  ;; in a full-width widescreen window.  Reduce `split-width-threshold'
  ;; from its usual value of 160, as a workaround.
  (setq-local split-width-threshold 120)
  ;; Magit uses fringe bitmaps which don't fit nicely in the default fringe.
  ;; (setq left-fringe-width 8)
  (setq left-fringe-width 20)
  )

;; Always open magit windows in the current frame.
(add-to-list 'display-buffer-alist
             (cons "^magit[-:]"
                   (cons 'display-buffer-reuse-mode-window
                         '((inhibit-same-window . nil)
                           (reusable-frames . visible)
                           (inhibit-switch-frame . nil)))))

;; Link bug references in Magit log and revision buffers.
(add-hook 'magit-revision-mode-hook #'my-bug-reference-mode-enable)
(add-hook 'magit-log-mode-hook #'my-bug-reference-mode-enable)

;; In `magit-revision-mode' fill the summary line if it is long.
(setq magit-revision-fill-summary-line 80)

;; pcomplete support for git.
;;
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
