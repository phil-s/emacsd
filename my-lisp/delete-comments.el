(defun my-delete-all-comments ()
  "Delete all comments from region or buffer, respecting current narrowing."
  (interactive)
  (save-excursion
    (let (pos commentstart beginning end)
      ;; Establish region
      (if (use-region-p)
          (progn
            (setq end (make-marker))
            (set-marker end (region-end))
            (goto-char (region-beginning)))
        (setq end (point-max-marker))
        (goto-char (point-min)))
      ;; Delete all comments
      (while (setq commentstart (comment-search-forward end :noerror))
        (setq pos (point))
        (goto-char commentstart)
        (when (looking-back "^[[:space:]]+")
          (delete-region (line-beginning-position) (point)))
        (let ((bounds (bounds-of-thing-at-point 'comment)))
          (if bounds
              (delete-region (car bounds) (cdr bounds))
            (goto-char pos))))
      ;; Deallocate marker
      (set-marker end nil))))
