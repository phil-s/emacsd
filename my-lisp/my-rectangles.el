(require 'rect)

(define-derived-mode my-edit-rectangle-mode nil "Rectangle-Edit"
  ;; The rectangle buffer contents will likely be invalid for the
  ;; major mode of the source buffer, so we derive from fundamental-mode
  ;; to avoid problems.
  "Major mode for *edit rectangle* buffers.

\\{my-edit-rectangle-mode-map}")

(define-key my-edit-rectangle-mode-map (kbd "C-c C-c") 'my-edit-rectangle-submit)

(defvar my-edit-rectangle-data)

(defun my-edit-rectangle (start end)
  "Edit the rectangle in a temporary buffer. C-c C-c applies the changes."
  (interactive "*r")
  (let* ((content (extract-rectangle start end))
         (width (length (car content)))
         (height (length content))
         (source-buffer (current-buffer))
         (source-syntax (syntax-table))
         (coords-point (list (line-number-at-pos) (current-column)))
         (coords-mark (save-excursion
                        (goto-char (mark))
                        (list (line-number-at-pos) (current-column)))))
    (switch-to-buffer (generate-new-buffer " *edit rectangle*"))
    (insert-rectangle content)
    (my-edit-rectangle-mode) ;; mode change kills local variables.
    (set-syntax-table source-syntax)
    ;; Store the rectangle details in a buffer-local structure.
    (set (make-local-variable 'my-edit-rectangle-data)
         (list start end width height source-buffer coords-point coords-mark))
    (message (substitute-command-keys
              "Editing rectangle. Type \\[my-edit-rectangle-submit] to confirm \
the changes, or \\[kill-buffer] RET to cancel."))))

(defun my-edit-rectangle-submit ()
  "Confirm changes to the rectangle, writing them back to the original buffer."
  (interactive)
  (cl-destructuring-bind
      (start end width height source-buffer coords-point coords-mark)
      my-edit-rectangle-data
    (let ((edit-rectangle-buffer (current-buffer)))
      ;; Account for possible changes in the dimensions of the
      ;; edit-buffer's contents by explicitly using the original
      ;; rectangle's height and width to establish the replacement
      ;; rectangle.
      (goto-char (point-min))
      (let ((remaining (forward-line (1- height))))
        (insert-char ?\n (if (looking-back "^") remaining (1+ remaining))))
      (move-to-column width t)
      ;; Replace the original rectangle with the edited version.
      (let ((content (extract-rectangle (point-min) (point))))
        (switch-to-buffer source-buffer)
        (goto-char start)
        (delete-rectangle start end)
        (insert-rectangle content)
        (kill-buffer edit-rectangle-buffer)
        ;; Set point and mark in accordance with their values before
        ;; editing began. `insert-rectangle' sets point and mark to
        ;; the lower-right and upper-left corners of the rectangle
        ;; respectively, but these may not be the same corners we
        ;; started with. We cannot use the original character
        ;; positions, as inserting the rectangle may have introduced
        ;; additional characters in the form of trailing whitespace.
        (forward-line (- (car coords-mark) (line-number-at-pos)))
        (move-to-column (cadr coords-mark) t)
        (pop-mark) ;; the value pushed by insert-rectangle
        (pop-mark) ;; the original value
        (push-mark) ;; replacement for the original value
        (forward-line (- (car coords-point) (line-number-at-pos)))
        (move-to-column (cadr coords-point) t)))))


(defun my-copy-rectangle (start end &optional fill)
  "Trigger the read-only behaviour of `kill-rectangle'."
  (interactive "r\nP")
  (let ((buffer-read-only t)
        (kill-read-only-ok t))
    (kill-rectangle start end fill)))


(defun my-fill-rectangle (start end)
  "`fill-region' within the confines of a rectangle."
  (interactive "*r")
  (let* ((indent-tabs-mode nil)
         (content (delete-extract-rectangle start end)))
    (goto-char start)
    (insert-rectangle
     (with-temp-buffer
       (setq indent-tabs-mode nil
             fill-column (length (car content)))
       (insert-rectangle content)
       (fill-region (point-min) (point-max))
       (goto-char (point-max))
       (move-to-column fill-column t)
       (extract-rectangle (point-min) (point))))))


(defun my-search-replace-in-rectangle
  (start end search-pattern replacement search-function literal)
  "Replace all instances of SEARCH-PATTERN (as found by SEARCH-FUNCTION)
with REPLACEMENT, in each line of the rectangle established by the START
and END buffer positions.

SEARCH-FUNCTION should take the same BOUND and NOERROR arguments as
`search-forward' and `re-search-forward'.

The LITERAL argument is passed to `replace-match' during replacement.

If `case-replace' is nil, do not alter case of replacement text."
  (apply-on-rectangle
   (lambda (start-col end-col search-function search-pattern replacement)
     (move-to-column start-col)
     (let ((bound (min (+ (point) (- end-col start-col))
                       (line-end-position)))
           (fixedcase (not case-replace)))
       (while (funcall search-function search-pattern bound t)
         (replace-match replacement fixedcase literal))))
   start end search-function search-pattern replacement))

(defun my-replace-regexp-rectangle-read-args (regexp-flag)
  "Interactively read arguments for `my-replace-regexp-rectangle'
or `my-replace-string-rectangle' (depending upon REGEXP-FLAG)."
  (let ((args (query-replace-read-args
               (concat "Replace"
                       (if current-prefix-arg " word" "")
                       (if regexp-flag " regexp" " string"))
               regexp-flag)))
    (list (region-beginning) (region-end)
          (nth 0 args) (nth 1 args) (nth 2 args))))

(defun my-replace-regexp-rectangle
  (start end regexp to-string &optional delimited)
  "Perform a regexp search and replace on each line of a rectangle
established by START and END (interactively, the marked region),
similar to `replace-regexp'.

Optional arg DELIMITED (prefix arg if interactive), if non-nil, means
replace only matches surrounded by word boundaries.

If `case-replace' is nil, do not alter case of replacement text."
  (interactive (my-replace-regexp-rectangle-read-args t))
  (when delimited
    (setq regexp (concat "\\b" regexp "\\b")))
  (my-search-replace-in-rectangle
   start end regexp to-string 're-search-forward nil))

(defun my-replace-string-rectangle
  (start end from-string to-string &optional delimited)
  "Perform a string search and replace on each line of a rectangle
established by START and END (interactively, the marked region),
similar to `replace-string'.

Optional arg DELIMITED (prefix arg if interactive), if non-nil, means
replace only matches surrounded by word boundaries.

If `case-replace' is nil, do not alter case of replacement text."
  (interactive (my-replace-regexp-rectangle-read-args nil))
  (let ((search-function 'search-forward))
    (when delimited
      (setq search-function 're-search-forward
            from-string (concat "\\b" (regexp-quote from-string) "\\b")))
    (my-search-replace-in-rectangle
     start end from-string to-string search-function t)))


(provide 'my-rectangles)
