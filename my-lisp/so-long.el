;;; so-long.el --- Say farewell to performance problems with minified code.
;;
;; Author: Phil S.
;; URL: http://www.emacswiki.org/emacs/SoLong
;; Keywords: convenience
;; Package-Requires: ((emacs "24.3"))
;; Created: 12 Jan 2016
;; Version: 0.5

;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation, either version 3 of the License, or (at your option) any later
;; version. See <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; When the lines in a buffer are so long that performance could suffer to an
;; unacceptable degree, we say "so long" to the buffer's major mode, and invoke
;; something much more basic in its place.
;;
;; Many Emacs modes struggle with buffers which contain excessively long lines.
;; This is commonly on account of 'minified' code (i.e. code that has been
;; compacted into the smallest file size possible, which often entails removing
;; newlines should they not be strictly necessary).  Most programming modes
;; simply aren't optimised (remotely) for this scenario, and so performance can
;; suffer significantly.  However these kinds of files are typically not
;; intended to be edited; so not providing the usual editing mode in such cases
;; will rarely be an issue (and if desired, the original mode may be reinstated
;; for any given buffer).
;;
;; When such files are detected, we invoke `so-long-mode' in place of the mode
;; that Emacs selected.  This is almost identical to `fundamental-mode', and
;; so provides optimal performance in the buffer.
;;
;; The variables `so-long-target-modes', `so-long-line-threshold',
;; `so-long-max-lines', and `so-long-mode-enabled' determine whether this mode
;; will be invoked for a given buffer.  The tests are made after `set-auto-mode'
;; has set the normal major mode.

;; This library advises `hack-local-variables' (in order that we may inhibit our
;; functionality when a file-local mode is set), and `set-auto-mode' (in order
;; to react after Emacs has chosen the major mode for a buffer).

;; Installation
;; ------------
;; (when (require 'so-long nil :noerror)
;;   (so-long-enable))

;; File-local MODE specifications
;; ------------------------------
;; Ideally we would defer seamlessly to any file-local MODE variable; but at
;; present (Emacs 24.5) -*- mode: MODE; -*- header comments are processed by
;; `set-auto-mode' directly, with the outcome that we never get a chance to
;; inhibit our own mode switch.  Ultimately that specified mode *is* still
;; called (as part of the main `hack-local-variables' evaluation), but our mode
;; switch is *also* called prior to that, which is undesirable (as we display
;; messages at that time).  Once Emacs drops the deprecated feature whereby
;; 'mode:' is also allowed to specify minor-modes (i.e. there can be more than
;; one "mode:"), this problem will be removed, as (hack-local-variables t) will
;; handle file-local modes in all cases.
;;
;; In the interim, it's cleanest to use a Local Variables comment block to
;; specify a mode override, if one is required.

;;; Change Log:
;;
;; 0.5 - Renamed library so-long.el.
;;     - Added explicit `so-long-enable' command to activate our advice.
;; 0.4 - Amended/documented behaviour with file-local 'mode' variables.
;; 0.3 - Defer to a file-local 'mode' variable.
;; 0.2 - Initial release to EmacsWiki.
;; 0.1 - Experimental.

;;; Code:

(defvar so-long-target-modes
  '(prog-mode css-mode)
  "`so-long-mode' affects only these modes and their derivatives.

Our primary use-case is minified programming code, so `prog-mode' covers
most cases, but there are some exceptions to this.")

(defvar so-long-threshold 250
  "Number of columns after which the normal mode for a file will not be
used, unless it is specified as a local variable.

`so-long-mode' will be used instead in these circumstances.

See `so-long-line-detected-p' for details.")

(defvar so-long-max-lines 20
  "Number of non-blank, non-comment lines to test for excessive length.

See `so-long-line-detected-p' for details.")

(defvar so-long-mode-enabled t
  "Set to nil to prevent `so-long-mode' from being triggered.")

(defvar-local so-long-original-mode nil
  "Stores the original `major-mode' value.")
(put 'so-long-original-mode 'permanent-local t)

(defvar so-long-mode--inhibited nil) ; internal use
(make-variable-buffer-local 'so-long-mode--inhibited)
(put 'so-long-mode--inhibited 'permanent-local t)

(defun so-long-line-detected-p ()
  "Following any initial comments and blank lines, the next N lines of the
buffer will be tested for excessive length (where \"excessive\" means above
`so-long-threshold', and N is `so-long-max-lines').

Returns non-nil if any such excessive-length line is detected."
  (let ((count 0))
    (save-excursion
      (goto-char (point-min))
      (while (comment-forward)) ;; clears whitespace at minimum
      (catch 'excessive
        (while (< count so-long-max-lines)
          (if (> (- (line-end-position 1) (point))
                 so-long-threshold)
              (throw 'excessive t)
            (forward-line)
            (setq count (1+ count))))))))

(define-derived-mode so-long-mode nil "So long"
  "This mode is used if line lengths exceed `so-long-threshold'.

Many Emacs modes struggle with buffers which contain excessively long lines,
and may consequently cause unacceptable performance issues.

This is commonly on account of 'minified' code (i.e. code has been compacted
into the smallest file size possible, which often entails removing newlines
should they not be strictly necessary). These kinds of files are typically
not intended to be edited, so not providing the usual editing mode in these
cases will rarely be an issue.

When such files are detected, we invoke this mode. This happens after
`set-auto-mode' has set the major mode, should the selected major mode be
a member (or derivative of a member) of `so-long-target-modes'.

By default this mode is essentially equivalent to `fundamental-mode', and
exists mainly to provide information to the user as to why the expected mode
was not used.

To revert to the original mode despite any potential performance issues,
type \\[so-long-mode-revert], or else re-invoke it manually."
  ;; Disable font-lock (circumventing `global-font-lock-mode').
  ;; (setq-local font-lock-global-modes '(not so-long-mode))
  (add-hook 'after-change-major-mode-hook
            (lambda () (font-lock-mode 0)) :append :local)
  ;; Inform the user about our major mode hijacking.
  (message "Changed to %s (from %s) on account of line length. %s to revert."
           major-mode
           so-long-original-mode
           (substitute-command-keys "\\[so-long-mode-revert]")))

(defun so-long-mode-revert ()
  "Call the `major-mode' which was originally selected by `set-auto-mode'
before `so-long-mode' was called to replace it."
  (interactive)
  (if so-long-original-mode
      (funcall so-long-original-mode)
    (error "Original mode unknown.")))

(define-key so-long-mode-map (kbd "C-c C-c") 'so-long-mode-revert)

(defadvice hack-local-variables (after so-long--file-local-mode disable)
  "Ensure that `so-long-mode' defers to file-local mode declarations.

This advice acts after any initial MODE-ONLY call to `hack-local-variables',
and ensures that we do not change to `so-long-mode' in that scenario.

File-local header comments are currently an exception (see the commentary
for details). The file-local mode will ultimately still be used, however
`so-long-mode' still runs first, thus displaying a misleading message.
This issue will eventually be resolved in Emacs."
  (when (ad-get-arg 0) ; MODE-ONLY argument to `hack-local-variables'
    ;; Inhibit `so-long-mode' if a MODE is specified.
    (setq so-long-mode--inhibited ad-return-value)))

(defadvice set-auto-mode (around so-long--set-auto-mode disable)
  "Maybe change to `so-long-mode' for files with very long lines.

This advice acts after `set-auto-mode' has set the buffer's major mode.

We can't act before this point, because some major modes must be exempt
from `so-long-mode' (binary file modes, for example).  Instead, we act
only when the selected major mode is a member (or derivative of a member)
of `so-long-target-modes'.

`so-long-line-detected-p' then determines whether the mode change is needed."
  (setq so-long-mode--inhibited nil) ; is permanent-local
  ad-do-it ; `set-auto-mode'
  (when so-long-mode-enabled
    (unless so-long-mode--inhibited
      (when (and (apply 'derived-mode-p so-long-target-modes)
                 (so-long-line-detected-p))
        (setq so-long-original-mode major-mode)
        (so-long-mode)))))

;;;###autoload
(defun so-long-enable ()
  "Enable the so-long library's functionality."
  (interactive)
  (ad-enable-advice 'hack-local-variables 'after 'so-long--file-local-mode)
  (ad-enable-advice 'set-auto-mode 'around 'so-long--set-auto-mode)
  (ad-activate 'hack-local-variables)
  (ad-activate 'set-auto-mode)
  (setq so-long-mode-enabled t))

(defun so-long-disable ()
  "Disable the so-long library's functionality."
  (interactive)
  (ad-disable-advice 'hack-local-variables 'after 'so-long--file-local-mode)
  (ad-disable-advice 'set-auto-mode 'around 'so-long--set-auto-mode)
  (ad-activate 'hack-local-variables)
  (ad-activate 'set-auto-mode)
  (setq so-long-mode-enabled nil))

(defun so-long-unload-function ()
  (so-long-disable)
  nil)

(provide 'so-long)

;; So long, farewell, auf wiedersehen, goodbye
;; You have to go, this code is minified
;; Goodbye!

;;; so-long.el ends here
