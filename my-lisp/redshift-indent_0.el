;;; Commentary

;; redshift-indent-mode controls the expansion and contraction of
;; space, based on the rsi/cosmological-constant multiplier. Only the
;; indentation space at the beginning of a line is affected.

;; There is no differentiation between spaces indicating block structure,
;; and spaces used beyond that point for code alignment purposes. (i.e.
;; All visual alignments are prone to break with this mode enabled.)
;;
;; TODO: We could extend this library to make use of callback functions
;; (where provided) to intelligently make these differentiations.

;; n.b. the `whitespace-mode' display-table functionality (which
;; facilitates rendering spaces as special glyphs) makes life slightly
;; difficult. Were it not for this, the space-width specification for
;; the display text-property would be a nicer approach, as it allows
;; each individual space to remain independently visible and editable.
;; As it is, the most compatible solution to the problem is to use the
;; space specification to replace the indentation (whatever its glyph)
;; with a specified space of the appropriate width. This is not as
;; nice for editing, but is more compatible in general.

;; FIXME: Now that we're using `after-change-functions' in a pretty
;; heavy-handed manner (by necessity), we may actually not need
;; font-locking any longer??! I think we just need to process the
;; indentation spaces when we enable and disable the mode.

(defgroup redshift-indent
  '((rsi/redshift-indent custom-face))
  "Controls the expansion or contraction of (indentation) space."
  :group 'indent)

(defcustom rsi/cosmological-constant 0.5
  "The cosmological constant fixes the size of space.

This value is a multiplier, applied to the width of indentation
spaces when `redshift-indent-mode' is enabled."
  :group 'redshift-indent)

;; We don't *want* a face for this, but it seems that we *need*
;; one when specifying the font-lock keywords.
(defface rsi/redshift-indent
  nil ;; '((t (:width narrow))) ;; no visible effect
  "Face for `redshift-indent-mode'.

You probably don't want to modify this. It only exists so that we
can get font lock mode to do the heavy lifting for us. It's not
otherwise needed by this mode, and therefore it's not guaranteed
to be in effect."
  :group 'redshift-indent)

(defvar rsi/font-lock-keywords
  '(("^ +" 0
     (prog1 'rsi/redshift-indent
       (rsi/redshift-region (match-beginning 0) (match-end 0)))
     prepend))
  "Font lock keywords for `redshift-indent-mode'.")

(defun rsi/redshift-region (beginning end)
  "Apply space-warping text properties to the specified region."
  (when redshift-indent-mode
    (let ((width (- end beginning)))
      (with-silent-modifications
        (add-text-properties
         beginning end
         `(display
           (space :relative-width
                  ,(* width rsi/cosmological-constant))))))))

;;; Using space-width is nicer in lots of ways, but it only works
;;; for spaces -- and specifically not for other characters being
;;; displayed in place of a space via whitespace-display-mappings.
;;; As such we either need to dynamically override those display
;;; mappings, or else *replace* the characters in our text
;;; properties. This is much simpler, but has the down-side that
;;; point cannot be moved into the middle of the indentation.
;;
;;  (add-text-properties (match-beginning 0) (match-end 0)
;;                       `(display (space-width
;;                                  ,rsi/cosmological-constant)))

(defun rsi/reset-indent ()
  "Remove our text property from all indentation spaces.

We don't want to make the 'display text-property managed by
`font-lock-mode' (that seems much too generic), so instead we
do our own processing when `font-lock-mode' is disabled.

This means that `font-lock-unfontify-region' doesn't handle
our case, but that seems better to me than the alternative.

We could always deal to that with advice? (Should we bother,
though?)"
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (with-silent-modifications
        (while (re-search-forward "^ +" nil t)
          (let ((beginning (match-beginning 0))
                (end (match-end 0)))
            (remove-text-properties beginning end '(display))))))))

(defun rsi/reset-buffer-indent ()
  "Remove our text property from all indentation spaces in the buffer."
  (save-excursion
    (save-restriction
      (widen)
      (rsi/reset-region (point-min) (point-max)))))

;; TODO: Hook this into `font-lock-unfontify-region' as well? (Maybe not?)
;;
;; n.b. We cannot assume that all contiguous spaces share the same
;; text properties -- for example, it is easy to yank modified spaces
;; into the middle of a sequence of unmodified spaces -- however that
;; is unimportant when it comes to removing properties, as we do not
;; actually care whether or not all characters in the region have the
;; properties in question.
(defun rsi/reset-region (beginning end)
  "Remove our text property from all spaces in the specified region."
  (save-excursion
    (goto-char beginning)
    (with-silent-modifications
      (while (re-search-forward " +" end t)
        (let ((beginning (match-beginning 0))
              (end (match-end 0)))
          (remove-text-properties beginning end '(display)))))))

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
  (message "Range: %d to %d" beginning end)
  ;; This can occur anywhere -- joining lines can shift indentation to
  ;; the end of another line, and any redshifted space in the kill
  ;; ring can be yanked into any arbitrary part of the buffer. Any
  ;; such space is no longer matched by the indentation regexp.
  (save-excursion
    ;; Extend the beginning of the region (if necessary).
    (goto-char beginning)
    (when (looking-back " +")
      (setq beginning (match-beginning 0)))
    ;; Extend the end of the region (if necessary).
    (goto-char end)
    (when (looking-at " +")
      (setq end (match-end 0))))
  ;; Now clean up the (modified) region.
  (message "Modified Range: %d to %d" beginning end)
  (rsi/reset-region beginning end)
  ;; Finally, we may have clobbered the text properties of indented
  ;; text, so we need to restore them. (It should be more efficient
  ;; to detect these cases and avoid removing the properties in the
  ;; first place, but this is simpler for now.)
  (save-excursion
    (goto-char beginning)
    (while (re-search-forward "^ +" nil t)
      (rsi/redshift-region (match-beginning 0) (match-end 0)))))

(define-minor-mode redshift-indent-mode
  "Adjust the size of space to your liking.

Multiplies the width of all indentation space by `rsi/cosmological-constant'."
  :init-value nil
  (if redshift-indent-mode
      (progn
        (font-lock-add-keywords nil rsi/font-lock-keywords)
        ;;(add-to-list 'font-lock-extra-managed-props 'display)
        (add-hook 'after-change-functions 'rsi/after-change nil :local)
        (add-hook 'font-lock-mode-off-hook 'rsi/redshift-reset nil :local))
    ;; It's unsafe to remove 'display when the mode is disabled, as we
    ;; don't know whether anything else also wanted it. n.b. Having
    ;; font-lock-mode managing 'display doesn't seem like a wonderful
    ;; idea. Is there a simple alternative to using font-locking?
    ;; Or should we just manually process our properties for the
    ;; whole buffer via `font-lock-mode-off-hook' ? (n.b. we can
    ;; do that provided that we test `redshift-indent-mode'
    ;; and we need to use the LOCAL argument to `add-hook' to ensure
    ;; we only process the intended buffer.) We could use our face
    ;; as a marker to indicate whether or not we should remove the
    ;; space-width property from any given indentation, but that's
    ;; probably overkill -- if the mode is on, we expect that
    ;; property to be present on all indentation.
    (remove-hook 'after-change-functions 'rsi/after-change-reset :local)
    (font-lock-remove-keywords nil rsi/font-lock-keywords)
    (rsi/redshift-reset))
  (font-lock-fontify-buffer))
