;;; visual-wrap-comments.el --- Auto-wrap comments without modifying the buffer  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Free Software Foundation, Inc.

;; Author: Phil Sainty
;; Inspired by visual-fill.el by Stefan Monnier
;; Version: 0.5.4
;; Keywords: convenience

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This `visual-wrap-comments-mode' minor mode visually re-formats long comment
;; lines via jit-lock (hence without modifying the buffer), wrapping word-wise
;; at the edge of the window in order to improve the comment readability.
;;
;; Comment lines matching `visual-wrap-comments-regexp' are processed.
;;
;; When `visual-wrap-comments-dynamic' is non-nil, window width changes will
;; cause comments to be re-wrapped accordingly.
;;
;; Related modes and/or GNU ELPA packages:
;; - `visual-line-mode'
;; - `adaptive-wrap-prefix-mode'
;; - `visual-fill-mode'

;;; Code:

(defvar visual-wrap-comments-column #'visual-wrap-comments-window-width-min
  "Determines the column at which comments will be wrapped.

Valid values are any positive integer; a symbol (which will be
called as a function with no arguments to obtain a value; or
nil (which means use the current `fill-column').

Some useful function symbols are `window-max-chars-per-line', and
the related functions `visual-wrap-comments-window-width-min' and
`visual-wrap-comments-window-width-max'.")

(defvar visual-wrap-comments-column-min 40
  "If non-nil, limits the value of `visual-wrap-comments-column'.")

(defvar visual-wrap-comments-column-max 100
  "If non-nil, limits the value of `visual-wrap-comments-column'.")

(defvar visual-wrap-comments-regexp
  ;; n.b. Parens in the examples represent match subgroups.
  (rx (or
       ;; (<prefix>) (//)<comment>
       ;;             // [continues]
       (seq (group-n 1
              (opt (minimal-match (zero-or-more not-newline))
                   (not (any ":")))) ;; Ignore "://" (probable URL).
            (group-n 2
              (regexp "//+") (zero-or-more (any " \t"))))
       ;; /**
       ;; (*) <comment>
       ;;  *  [continues]
       ;; (*) (@param type $foo) <comment>
       ;;  *                     [continues]
       ;; (*) (@return type) <comment>
       ;;  *                 [continues]
       ;;  */
       (seq (group-n 2
              (zero-or-more (any " \t")) "*" (zero-or-more (any " \t")))
            (opt (or (seq "@param" (one-or-more (any " \t"))
                          (opt (group (one-or-more (not (any " \t\n")))
                                      (one-or-more (any " \t"))))
                          "$" (one-or-more (not (any " \t\n")))
                          (one-or-more (any " \t")))
                     (seq "@return" (one-or-more (any " \t"))
                          (opt (group (one-or-more (not (any " \t\n")))
                                      (one-or-more (any " \t")))))
                     (seq "@var" (one-or-more (any " \t"))
                          (group (one-or-more (not (any " \t\n")))
                                 (one-or-more (any " \t"))))
                     (seq (any "a-z") "." (one-or-more (any " \t"))))))
       ;; /** @var foo <comment>
       ;;              [continues] */
       (seq (group-n 1
              (zero-or-more (any " \t"))
              "/**")
            (group-n 2)
            (seq (zero-or-more (any " \t"))
                 (opt "@var" (one-or-more (any " \t"))
                      (group (one-or-more (not (any " \t\n")))
                             (one-or-more (any " \t"))))))
       ;; (<prefix>) (/**)<comment>
       ;;                 [continues]
       (seq (group-n 1
              (opt (minimal-match (zero-or-more not-newline)))
              "/**")
            (group-n 2)
            (zero-or-more (any " \t")))))
  "Regexp matching a buffer line with a comment.

The start of the match must be the start of the line.  The end of
the match must be within the comment.  Subgroup 1 matches any
prefix to the comment (to be replaced by equivalent spaces on
subsequent continuation lines).  Subgroup 2 contains the comment
syntax (to be repeated on each continuation line, following the
prefix indentation).  The remainder of the pattern matches any
suffix to the comment syntax (to be replaced by equivalent spaces
on subsequent continuation lines, following the comment syntax).

When `adaptive-fill-mode' is non-nil, `adaptive-fill-regexp' will
also be matched at the end of this regexp, potentially extending
the extent of the suffix.

\(Remember that you can repeat explicit group numbers when matching
multiple sets of alternatives.)")

(defvar visual-wrap-comments-dynamic t
  "Whether to automatically reformat when the window width changes.")

(defvar-local visual-wrap-comments--column nil)

(defun visual-wrap-comments--jit (start end)
  "Apply visual comment display properties in specified region."
  (visual-wrap-comments--cleanup start end)
  (goto-char start)
  (forward-line 0)
  ;; Use \= to anchor the regexp to point for efficiency.  No matching
  ;; beyond point will be attempted.
  (let ((comregexp (concat "\\=\\(?:" visual-wrap-comments-regexp "\\)"
                           (and adaptive-fill-mode
                                (concat "\\(?:" adaptive-fill-regexp "\\)?"))))
        (fillcol (or visual-wrap-comments--column
                     (setq-local visual-wrap-comments--column
                                 (visual-wrap-comments-column))))
        matchcol comstart columns linestart longcomment maxpos minpos
        lastcol prefix suffix replacement)
    ;; Process the specified region.
    (save-restriction
      (widen)
      (while (< (point) end)
        ;; Note that we anchor the start of the regexp to \= (point).
        ;; We do not use `looking-at' because we also want to forcibly
        ;; bound the search at `line-end-position', to ensure that a
        ;; rogue regexp cannot inadvertently match newlines and spill
        ;; into the next line (which would cause havoc).
        (when (save-excursion
                (re-search-forward comregexp (line-end-position) t))
          (setq linestart (point)
                matchcol (apply #'vector (mapcar (lambda (sub)
                                                   (and (match-end sub)
                                                        (goto-char (match-end sub))
                                                        (current-column)))
                                                 '(0 1 2)))
                lastcol (aref matchcol 0)
                prefix (if (aref matchcol 1)
                           (make-string (aref matchcol 1) ?\s)
                         "")
                comstart (match-string 2)
                suffix (make-string (- (aref matchcol 0) (aref matchcol 2))
                                    ?\s)
                columns (- fillcol (aref matchcol 0))
                longcomment (format "%s.\\{%d\\}"
                                    (regexp-quote (match-string 0))
                                    columns)
                replacement nil)
          (goto-char linestart)
          (catch 'done
            (when (<= columns 0)
              (throw 'done t))
            (while (looking-at longcomment)
              (move-to-column (+ lastcol columns))
              (setq maxpos (point))
              ;; Confirm we're inside a comment.
              (unless (nth 4 (syntax-ppss))
                (throw 'done t))
              ;; Don't break within a word.
              (skip-chars-backward " \t")
              (or (looking-at "[ \t]+")
                  (re-search-backward "[ \t]+" linestart 'noerror)
                  (throw 'done t))
              (setq minpos (match-end 0))
              ;; Make sure we can break safely.
              (when (>= (- maxpos minpos) columns)
                ;; We can't break this line, so let it run long and break at the
                ;; next opportunity.
                (goto-char maxpos)
                ;; Ensure that there is space to break at.
                (unless (re-search-forward "[ \t]+" (line-end-position) 'noerror)
                  (throw 'done t))
                ;; Ensure that we break at the first space.
                (skip-chars-backward " \t"))
              ;; Calculate the common replacement for this line.
              (unless replacement
                (setq replacement (concat "\n" prefix comstart suffix)
                      longcomment (format ".\\{%d\\}" columns)))
              ;; Add the text properties.
              (add-text-properties (point) (match-end 0)
                                   (list 'visual-wrap-comment t
                                         'display replacement))
              ;; Continue in this line.
              (goto-char (match-end 0))
              (setq lastcol (current-column)))))
        ;; Process the next line.
        (forward-line 1)))))

(defun visual-wrap-comments--cleanup (start end)
  "Remove the visual comment display properties."
  (while (and (< start end)
              (setq start (text-property-any start end
                                             'visual-wrap-comment t)))
    (remove-text-properties
     start
     (setq start (or (text-property-not-all start end
                                            'visual-wrap-comment t)
                     end))
     '(visual-wrap-comment nil display nil))))

(defun visual-wrap-comments-window-width-min ()
  "Return the minimum window width for windows displaying the current buffer."
  (if-let ((bufs (get-buffer-window-list)))
      (apply #'min (mapcar #'window-max-chars-per-line bufs))
    (or visual-wrap-comments--column
        fill-column)))

(defun visual-wrap-comments-window-width-max ()
  "Return the maximum window width for windows displaying the current buffer."
  (if-let ((bufs (get-buffer-window-list)))
      (apply #'max (mapcar #'window-max-chars-per-line bufs))
    (or visual-wrap-comments--column
        fill-column)))

(defun visual-wrap-comments-column ()
  "Return the column at which to wrap long comment lines."
  (max visual-wrap-comments-column-min
       (min visual-wrap-comments-column-max
            (cond ((numberp visual-wrap-comments-column)
                   visual-wrap-comments-column)
                  ((functionp visual-wrap-comments-column)
                   (funcall visual-wrap-comments-column))
                  (t
                   fill-column)))))

(defun visual-wrap-comments--window-configuration-change-handler ()
  "Buffer-local `window-configuration-change-hook' handler."
  ;; Called with the buffer's window selected.
  (when visual-wrap-comments-dynamic
    (unless (eql visual-wrap-comments--column
                 (visual-wrap-comments-column))
      (visual-wrap-comments-mode 1))))

;;;###autoload
(define-minor-mode visual-wrap-comments-mode
  "Auto-refill comments without modifying the buffer."
  :lighter " VF*"
  :global nil
  (jit-lock-unregister #'visual-wrap-comments--jit)
  (with-silent-modifications
    (visual-wrap-comments--cleanup (point-min) (point-max)))
  (if visual-wrap-comments-mode
      ;; Enable.
      (progn
        (jit-lock-register #'visual-wrap-comments--jit)
        (setq-local visual-wrap-comments--column (visual-wrap-comments-column))
        (add-hook 'window-configuration-change-hook
                  'visual-wrap-comments--window-configuration-change-handler
                  nil :local))
    ;; Disable.
    (setq-local visual-wrap-comments--column nil)
    (remove-hook 'window-configuration-change-hook
                 'visual-wrap-comments--window-configuration-change-handler
                 :local)))

(provide 'visual-wrap-comments)
;;; visual-wrap-comments.el ends here
