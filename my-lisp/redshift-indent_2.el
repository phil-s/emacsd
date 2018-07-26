;;; redshift-indent.el --- minor mode to control the size of (indentation) space
;;
;; Author: Phil S.
;; Created: Sep 2015
;; Version: 0.28

;; This file is not part of GNU Emacs.
;;
;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; `redshift-indent-mode' controls the expansion and contraction of
;; space, based on the `redshift/cosmological-constant' multiplier.
;; Only the indentation space at the beginning of a line is affected.
;;
;; There is no differentiation between spaces indicating nesting
;; structure, and spaces used beyond that point for code alignment
;; purposes. (i.e. visual alignments are prone to break with this
;; mode enabled.)
;;
;; n.b. the `whitespace-mode' display-table functionality (which
;; facilitates rendering spaces as special glyphs) makes life slightly
;; difficult. Were it not for this, the `space-width' specification for
;; the display text-property would be a nicer approach, as it allows
;; each individual space to remain visibly independent and editable.
;; As it is, the most compatible solution to the problem is to use the
;; `space' specification to replace the indentation (regardless of the
;; glyph used) with a single specified space of the appropriate width.
;; This is not as nice for editing, but is more likely to work.

;; You may (or may not) find that (setq x-stretch-cursor t) is a useful
;; setting to use with this library.

;; TODO: We could implement support for callback functions which
;; (if provided) could intelligently make these differentiations.

;;; Change Log:
;; 1.0 - Initial release.

;;; Code:

(defcustom redshift/cosmological-constant 0.5
  "The cosmological constant fixes the size of space.

This value is a multiplier, applied to the width of indentation
spaces when `redshift-indent-mode' is enabled."
  :group 'indent)

(defun rsi/add-text-properties (beginning end)
  "Apply space-warping text property to the specified region.

Buffer positions BEGINNING and END should delineate a region of (only)
indentation spaces."
  ;;
  ;; Using `space-width' is nicer in lots of ways, but it only works
  ;; for actual spaces -- and specifically not for different characters
  ;; displayed in place of a space via `whitespace-display-mappings'.
  ;; As such we either need to dynamically override those display
  ;; mappings (in which case we would also lose the mapping for
  ;; non-indentation spaces) or else *replace* the characters via text
  ;; properties. Replacement is much simpler, but has the down-side
  ;; that point cannot then be moved into the middle of the
  ;; indentation.
  ;;
  ;; (add-text-properties (match-beginning 0) (match-end 0)
  ;;                      `(display (space-width
  ;;                                 ,redshift/cosmological-constant)))
  (when redshift-indent-mode
    (let ((width (- end beginning)))
      (with-silent-modifications
        (add-text-properties
         beginning end
         `(display
           (space :relative-width
                  ,(* width redshift/cosmological-constant))))))))

(defun rsi/remove-text-properties (beginning end)
  "Remove our text property from all spaces in the specified region.

Unlike `rsi/add-text-properties', buffer positions BEGINNING and END
can span any region of the buffer. We only ever add properties to
indentation spaces, but those spaces may subsequently be moved or
copied to other parts of the buffer, so we may need to remove the
properties from any arbitrary spaces."
  ;;
  ;; n.b. We cannot assume that all contiguous spaces share the same
  ;; text properties (for example, it is easy to yank modified spaces
  ;; into the middle of a sequence of unmodified spaces); however, that
  ;; is unimportant when it comes to removing properties, as we do not
  ;; actually need all of the characters in the affected region to have
  ;; the properties in question.
  (save-excursion
    (goto-char beginning)
    (with-silent-modifications
      (while (re-search-forward " +" end :noerror)
        (remove-text-properties
         (match-beginning 0) (match-end 0) '(display))))))

(defun rsi/redshift-indentation (action &optional beginning end)
  "Manipulate the size of space for all indentation in the buffer.

If ACTION is :shift, we modify the size of space.
If ACTION is :rest, we return space to its usual size.

Optionally, process only the indentation between buffer positions
BEGINNING and END."
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (or beginning (point-min)))
      (with-silent-modifications
        (while (re-search-forward "^ +" end :noerror)
          (let ((indent-start (match-beginning 0))
                (indent-end (match-end 0)))
            (cond ((eq action :shift)
                   (rsi/add-text-properties indent-start indent-end))
                  ((eq action :rest)
                   (remove-text-properties indent-start indent-end '(display)))
                  )))))))

(defalias 'rsi/redshift-indentation-shift
  (apply-partially 'rsi/redshift-indentation :shift)
  "Equivalent to `rsi/redshift-indentation' with ACTION set to :shift")

(defalias 'rsi/redshift-indentation-rest
  (apply-partially 'rsi/redshift-indentation :rest)
  "Equivalent to `rsi/redshift-indentation' with ACTION set to :rest")

(defun rsi/after-change (beginning end old-len)
  "Reset the size of any redshifted space which is not indentation.

This function is called via `after-change-functions'.

START and END are the start and end of the changed text. OLD-LEN is the
pre-change length. (For an insertion, the pre-change length is zero;
for a deletion, that length is the number of chars deleted, and the
post-change beginning and end are at the same place.)

Changes may result in redshifted space no longer being indentation,
but also not included in the \"change\". We need to extend the range
to include any adjacent space, to take account of such occurances."
  ;;
  ;; This can occur anywhere -- joining lines can shift indentation to
  ;; the end of another line, and any redshifted space in the kill
  ;; ring can be yanked into any arbitrary part of the buffer. Any
  ;; such space is no longer matched by the indentation regexp.
  (save-excursion
    ;; Extend the beginning of the region (if necessary).
    (goto-char beginning)
    (when (looking-back " +" nil :greedy)
      (setq beginning (match-beginning 0)))
    ;; Extend the end of the region (if necessary).
    (goto-char end)
    (when (looking-at " +")
      (setq end (match-end 0))))
  ;; Now clean up the (modified) region.
  (rsi/remove-text-properties beginning end)
  ;; Finally, we may have clobbered the text properties of indented
  ;; text, so we need to restore them. (It should be more efficient
  ;; to detect these cases and avoid removing the properties in the
  ;; first place, but this is simpler for now.)
  (rsi/redshift-indentation :shift beginning end))

(define-minor-mode redshift-indent-mode
  "Adjust the size of space to your liking.

Multiplies the width of indentation spaces by `redshift/cosmological-constant'.

Only actual spaces are affected. (If you wish to manipulate the width of
tabbed indentation, you can use the `tab-width' variable.)

n.b. Indentation which mixes spaces and tabs is not compatible with this
mode, and will produce inconsistent results."
  :init-value nil
  :lighter " <<"
  (if redshift-indent-mode
      (progn
        (add-hook 'after-change-functions 'rsi/after-change nil :local)
        (add-hook 'change-major-mode-hook 'rsi/redshift-indentation-rest nil :local)
        (rsi/redshift-indentation :shift))
    (remove-hook 'after-change-functions 'rsi/after-change :local)
    (remove-hook 'change-major-mode-hook 'rsi/redshift-indentation-rest :local)
    (rsi/redshift-indentation :rest)))

(defun redshift-indent (arg)
  "Invoke `redshift-indent-mode' with a buffer-local cosmological constant.

With no prefix ARG, `redshift-indent-mode' is toggled.
If ARG is C-u, `redshift-indent-mode' is disabled.
If ARG is positive, `redshift/cosmological-constant' is set to ARG.
If ARG is negative, `redshift/cosmological-constant' is set to 1.0 / (abs ARG).

e.g.:
With prefix arg 2, indentation will appear 2 times its normal width.
With prefix arg -2, indentation will appear 0.5 times its normal width."
  (interactive "P")
  (cond ((eq arg nil) ; No prefix
         (redshift-indent-mode 'toggle))
        ((consp arg) ; C-u
         (redshift-indent-mode -1))
        (t ; Positive or negative numbers
         (setq arg (prefix-numeric-value arg))
         (setq-local redshift/cosmological-constant (if (>= arg 0)
                                                        arg
                                                      (/ 1.0 (abs arg))))
         (redshift-indent-mode 1))))

;;; redshift-indent.el ends here
