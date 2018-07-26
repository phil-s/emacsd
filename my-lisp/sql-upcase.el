;;; sql-upcase.el --- Upcase SQL keywords -*- lexical-binding: t -*-


;; Bug (maybe?):
;; C-M-% runs the command query-replace-regexp
;; $ => ;
;; Debugger entered--Lisp error: (error "Match data clobbered by buffer modification hooks")
;;   replace-match(";" nil nil)
;;   replace-match-maybe-edit(";" nil nil nil (115 115 #<buffer *SQL ctl: *SQL: mts@mts_staging*<2>*>) nil)
;;   perform-replace("$" ";" t t nil nil nil nil nil nil nil)
;;   query-replace-regexp("$" ";" nil nil nil nil nil)
;;   funcall-interactively(query-replace-regexp "$" ";" nil nil nil nil nil)
;;   call-interactively(query-replace-regexp nil nil)
;;   command-execute(query-replace-regexp)


;; Copyright (C) 2016 Phil Sainty
;; Author: Phil Sainty <psainty@orcon.net.nz>
;; URL: https://www.emacswiki.org/emacs/SqlUpcase
;; Keywords: abbrev, convenience, languages
;; Created: 9 May 2016
;; Package-Requires: ((emacs "24.3"))
;; Version: 0.3.2

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; `sql-upcase-mode' is a minor mode that converts SQL keywords to upper-case
;; as you type or otherwise insert text in the buffer (for instance, killing
;; and yanking an entire SQL query would upcase all keywords in that query).
;;
;; It is intended for use in `sql-mode' and/or `sql-interactive-mode', and
;; can be enabled using the respective mode hooks:
;;
;; (add-hook 'sql-mode-hook 'sql-upcase-mode)
;; (add-hook 'sql-interactive-mode-hook 'sql-upcase-mode)
;;
;; The `sql-upcase-region' and `sql-upcase-buffer' commands will process all
;; SQL keywords in the region or buffer respectively. These commands may be
;; used in non-SQL buffers, so if you are writing a query string in another
;; language, you can simply mark the SQL content and call `sql-upcase-region'.
;; (Note that the original language will not be considered here; the region
;; will be interpreted as SQL, so any conflicting quoting and comment syntax
;; may interfere. For the best results, be sure to mark only the SQL itself.)
;;
;; By default, only lower-case keywords are processed.  To transform mixed-
;; case keywords as well, customize `sql-upcase-mixed-case'.
;;
;; This library uses the product-specific regexps defined by sql.el, and
;; thus will upcase only the keywords defined for the buffer's `sql-product'.
;; (Note that `sql-mode' buffers default to the `ansi' product.) You may
;; pass a prefix argument to `sql-upcase-region' and `sql-upcase-buffer' in
;; order to select a different product.

;;; TODO:
;; Notes on using the same product for connected sql-mode and SQLi buffers

;;; Known issues
;;
;; `sql-upcase-mode' is slightly aggressive in ‘sql-interactive-mode’, in that
;; text insertions in that mode are not always typed by the user. The biggest
;; concern is handled – output from the inferior comint process is not touched.
;; However there may be other cases (e.g. cycling through the comint command
;; history) in which automatic modifications to the inserted text are less
;; desirable. In practice this is probably ok, but YMMV.
;;
;; It is assumed that font-lock patterns using ‘font-lock-builtin-face’ are
;; functions, and should only be upcased when followed by an opening
;; parenthesis. In practice this is not always accurate (an example being that,
;; for PostgreSQL, set is treated as a ‘builtin’ rather than a ‘keyword’). It
;; may be better to treat both types the same, and not insist upon the opening
;; parenthesis for builtins, but more investigation is needed.
;;
;; Contextual behaviour is limited to ignoring comments and strings, so if you
;; have an identifier name in your query which is also a keyword, it will be
;; upcased. If an unwanted upcasing occurs, you can use undo to revert to the
;; original case.
;;
;; If experiencing issues with keyword detection in `sql-mode', try narrowing
;; the buffer to just the query you are working on.  Unbalanced quotes in a
;; sql-mode buffer prior to the current statement could confuse the code which
;; checks whether a potential keyword is actually part of a string. This might
;; be improved by using ‘sql-beginning-of-statement’, but it’s neither clear to
;; me that that command is robust enough for non-interactive uses, nor that the
;; general question of establishing the (outer) beginning of a SQL statement is
;; even possible when it can be preceded by arbitrary content. For instance,
;; the actual query might easily appear as the sub-query of some incomplete SQL
;; earlier in the buffer. Narrowing the buffer to the query you are actually
;; editing should be a workaround for any such issues. (Note that in SQLi
;; buffers we use the prompt to constrain these syntax checks, which should be
;; fairly reliable.)

;;; Change Log:
;;
;; 0.3.2 - Minor refactoring for improved readability.
;;       - Improved documentation.
;;       - Improved error handling.
;; 0.3   - Enable `sql-upcase-region' in non-SQL buffers.
;;       - Prefix argument to `sql-upcase-region' (or -buffer) selects product.
;; 0.2   - Added `sql-upcase-region' and `sql-upcase-buffer' commands.
;;       - Rename from sql-upcase-mode.el to sql-upcase.el.
;;       - Match both boundaries of a keyword, to avoid false-positives.
;;       - Constrain 'in string' and 'in comment' tests to current query.
;;       - Fixed error with whitespace at beginning of buffer.
;; 0.1   - Initial release to EmacsWiki.

;;; Code:

(require 'sql)

(defcustom sql-upcase-mixed-case nil
  "If nil, `sql-upcase-keywords' looks only for lower-case keywords,
and mixed-case keywords are ignored.

If non-nil, then mixed-case keywords will also be upcased."
  :type '(choice (const :tag "Lower-case only" nil)
                 (const :tag "Both lower- and mixed-case" t))
  :group 'SQL)

(defvar sql-upcase-boundary "[\t\n\r ();]"
  "Regexp matching a character which can precede or follow a keyword.

In addition we match \"^\" at the start of a keyword; and both
`sql-upcase-region' and `sql-upcase-buffer' match \"\\'\" at the
end of a keyword.")

(defvar sql-upcase-inhibited nil
  "Set non-nil to prevent `sql-upcase-keywords' from acting.")

(defvar-local sql-upcase-comint-output nil)

(defvar sql-upcase-regions)

;;;###autoload
(define-minor-mode sql-upcase-mode
  "Automatically upcase SQL keywords as text is inserted in the buffer.

Intended to be enabled via `sql-mode-hook' and/or `sql-interactive-mode-hook'.

Note that this can be a little aggressive in `sql-interactive-mode'. Although
output from the inferior process is ignored, all other text changes to the
buffer are processed (e.g. cycling through the command history)."
  :lighter " sql^"
  (if sql-upcase-mode
      (progn
        (add-hook 'after-change-functions 'sql-upcase-keywords nil :local)
        (when (derived-mode-p 'sql-interactive-mode)
          (add-hook 'comint-preoutput-filter-functions
                    'sql-upcase-comint-preoutput nil :local)))
    ;; Disable.
    (remove-hook 'after-change-functions 'sql-upcase-keywords :local)
    (when (derived-mode-p 'sql-interactive-mode)
      (remove-hook 'comint-preoutput-filter-functions
                   'sql-upcase-comint-preoutput :local))))

(defvar sql-upcase-product)

;;;###autoload
(defun sql-upcase-region (beginning end arg)
  "Upcase SQL keywords within the marked region.

For best results in non-SQL buffers, be sure to mark only the SQL itself.
The region will be interpreted as SQL, so any conflicting quoting and comment
syntax may interfere.

With a prefix argument, prompt for the `sql-product' to use."
  (interactive "*r\nP")
  (when arg
    (setq-local sql-product
                (sql-read-product
                 "SQL product: " (or (bound-and-true-p sql-upcase-product)
                                     sql-product))))
  ;; Make an exception if the last character of the region is the last
  ;; character of a keyword.  Normally we require a trailing boundary
  ;; character matching `sql-upcase-boundary', but for this command we
  ;; will also treat the end of the region as a boundary.
  (let ((sql-upcase-boundary
         (concat "\\(?:\\'\\|" sql-upcase-boundary "\\)"))
        ;; DONE: (defvar sql-upcase-product) so we can set this globally.
        ;; TODO: re-use the current value by default.
        buf)
    (setq sql-upcase-product sql-product)
    (unwind-protect
        (save-current-buffer
          (unless (derived-mode-p 'sql-mode 'sql-interactive-mode)
            ;; Process the region in a `sql-mode' indirect copy of the buffer.
            ;; `unwind-protect' ensures we kill this buffer when we're done.
            (setq buf (clone-indirect-buffer nil nil))
            (set-buffer buf)
            ;; Avoid the notice from `jit-lock-mode' on account of being
            ;; an indirect buffer.
            (cl-letf (((symbol-function 'jit-lock-mode) 'ignore))
              (sql-mode))
            (setq-local sql-product sql-upcase-product))
          ;; Call our `after-change-functions' handler to process the region.
          (save-restriction
            (narrow-to-region beginning end)
            (sql-upcase-keywords beginning end 0)))
      ;; Kill the indirect buffer, if we used one.
      (when buf
        (kill-buffer buf)
        ;; Refresh font-locking, as we changed major mode in the
        ;; indirect buffer.
        (when font-lock-mode
          (font-lock-mode 1))))))

;;;###autoload
(defun sql-upcase-buffer (arg)
  "Upcase all SQL keywords in the buffer.

With a prefix argument, prompt for the `sql-product' to use."
  (interactive "P")
  (sql-upcase-region (point-min) (point-max) arg))

(defun sql-upcase-comint-preoutput (output)
  "Inhibit `sql-upcase-keywords' for comint process output.

Called via `comint-preoutput-filter-functions'."
  (setq sql-upcase-comint-output t)
  output)

(defun sql-upcase-keywords (beginning end old-len)
  "Automatically upcase SQL keywords and builtin function names.

If `sql-upcase-mixed-case' is non-nil, then only lower-case keywords
will be processed, and mixed-case keywords will be ignored.

Triggered by `after-change-functions' (see which regarding the
function arguments), and utilising the product-specific font-lock
keywords specified in `sql-product-alist'."
  (when (eq old-len 0) ; The text change was an insertion.
    (if sql-upcase-comint-output
        ;; The current input is output from comint, so ignore it and
        ;; just reset this flag.
        (setq sql-upcase-comint-output nil)
      ;; User-generated input.
      (unless (or undo-in-progress
                  sql-upcase-inhibited)
        (let ((sql-upcase-regions nil)
              (case-fold-search sql-upcase-mixed-case))
          (save-excursion
            ;; Any errors must be handled, otherwise we will be removed
            ;; automatically from `after-change-functions'.
            ;; (let ((debug-on-error t))
            ;; (condition-case nil
            ;;     (progn
            (with-demoted-errors "sql-upcase-keywords error: %S"
              ;; Process all keywords affected by the inserted text.
              ;;
              ;; The "two steps forward one step back" approach of looking
              ;; for the ENDs of keywords in the text and then testing the
              ;; preceding words may seem odd, but one of the primary use-cases
              ;; is as-you-type processing, in which case the text inserts we
              ;; are looking at are typically single self-insert characters,
              ;; and we are actually searching just that single character to
              ;; see if it is a keyword-ending character, in order that we can
              ;; upcase the previously-entered keyword before it.
              (goto-char beginning)
              ;; We could search for [boundary]+ here, but it could only help
              ;; at all with `sql-upcase-region'.
              ;; TODO: Check the potential for using zero-width symbol
              ;; boundaries -- at least for the left boundary.  The right
              ;; boundary needs to be actual whitespace for the as-you-type
              ;; case, and I don't see a pressing reason to make things much
              ;; different in the region/buffer case.)
              (while (and (< (point) end)
                          (re-search-forward sql-upcase-boundary end :noerror))
                (save-excursion
                  (goto-char (match-beginning 0))
                  (and (not (bobp))
                       ;; ...if the preceding character is of word syntax...
                       (eq (char-syntax (char-before)) ?w)
                       ;; ...and we're not inside a string or a comment...
                       (let* ((sep (if sql-prompt-regexp
                                       (concat
                                        "\\`\\|\\(?:" sql-prompt-regexp "\\)")
                                     "\\`"))
                              ;; TODO: Use (sql-beginning-of-statement 1)?
                              ;; Might error out. Should call that only once
                              ;; (and only if needed), and cache the result.
                              (from (save-excursion
                                      (re-search-backward sep nil :noerror)
                                      (or (match-end 0) (point-min))))
                              (syn (parse-partial-sexp from (point))))
                         (not (or (nth 3 syn) ; string
                                  (nth 4 syn)))) ; comment
                       ;; Try to match the preceding word as a SQL keyword.
                       (sql-upcase-match-keyword))))))
          ;; ((debug error) nil))))
          ;; Upcase the matched regions (if any)
          (when sql-upcase-regions
            (undo-boundary) ;; now that save-excursion has returned
            (mapc (lambda (r) (upcase-region (car r) (cdr r)))
                  sql-upcase-regions)))))))

(defun sql-upcase-match-keyword ()
  "Tests whether the preceding word:

1) is itself preceded by (only) whitespace or (
2a) matches the regexp for a keyword
2b) matches the regexp for a builtin, followed by (

Returns non-nil if a match is found, and the matching region is
stored in `sql-upcase-regions' for subsequent processing by
`sql-upcase-keywords'."
  (and (sql-upcase-match-keyword-1) ;; Non-nil for a match.
       ;; If `sql-upcase-mixed-case' is non-nil then check for at least one
       ;; lower-case character in the matched region, as otherwise the upcase
       ;; will be a no-op (but stored as a change in the buffer undo list).
       (or (not sql-upcase-mixed-case)
           (save-match-data
             (let ((case-fold-search nil))
               (re-search-forward "[[:lower:]]" (match-end 0) :noerror))))
       ;; Store the matched keyword region for subsequent upcasing.
       (push (cons (match-beginning 0) (match-end 0))
             sql-upcase-regions)))

(defun sql-upcase-match-keyword-1 ()
  "Performs the matching for `sql-upcase-match-keyword'."
  (catch 'matched
    (let ((inhibit-field-text-motion t)) ;; for comint
      (forward-word -1)
      (unless (bolp)
        (forward-char -1)))
    ;; Try to match a keyword using the regexps for this SQL product.
    (let* ((before (concat "\\(?:^\\|" sql-upcase-boundary "\\)"))
           (after sql-upcase-boundary)
           ;; Build regexp for statement starters.
           ;; FIXME: Generate once only, as a buffer-local var?
           (statements ;; n.b. each of these is already a regexp
            (delq nil
                  (list (sql-get-product-feature sql-product :statement)
                        (unless (eq sql-product 'ansi)
                          (sql-get-product-feature 'ansi :statement)))))
           (statements-regexp
            (concat "\\(?:" (mapconcat 'identity statements "\\|") "\\)")))
      ;; Check statement starters first
      (if (looking-at (concat before statements-regexp after))
          (throw 'matched t)
        ;; Otherwise process the product's font-lock keywords.
        ;; TODO: I'm not sure that `font-lock-builtin-face' can be assumed
        ;; to just be functions. (e.g. SET is not seen as a keyword.)
        (dolist (keywords (sql-get-product-feature sql-product :font-lock))
          (when (or (and (eq (cdr keywords) 'font-lock-keyword-face)
                         (looking-at (concat before (car keywords) after)))
                    (and (eq (cdr keywords) 'font-lock-builtin-face)
                         (looking-at (concat before (car keywords) "("))))
            (throw 'matched t)))))))

(provide 'sql-upcase)
;;; sql-upcase.el ends here
