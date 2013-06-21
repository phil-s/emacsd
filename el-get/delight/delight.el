;;; delight.el - A dimmer switch for your lighter text.

;; Commentary:
;;
;; Enables you to customise the mode names displayed in the mode line.
;;
;; For major modes, the buffer-local `mode-name' variable is modified,
;; with advice around the `format-mode-line' function ensuring that the
;; original value is used in contexts outside of mode line redraws.
;;
;; For minor modes, the associated value in `minor-mode-alist' is set.
;;
;; Example usage:
;;
;; (delight 'abbrev-mode " Abv" "abbrev")
;;
;; (delight '((abbrev-mode " Abv" "abbrev")
;;            (smart-tab-mode " \\t" smart-tab)
;;            (eldoc-mode nil "eldoc")
;;            (rainbow-mode)
;;            (emacs-lisp-mode "Elisp" "lisp-mode")))

;;; Code:

(defvar delighted ()
  "List of specs for modifying the display of mode names in the mode line.")

;;;###autoload
(defun delight (spec &optional value file)
  "Modify the lighter value displayed in the mode line for the given mode SPEC
if and when the mode is loaded.

SPEC can be either a mode symbol, or a list of the form ((MODE VALUE FILE) ...)

For minor modes, VALUE is the replacement lighter value (or nil to disable).
VALUE is typically a string, but may have other values. See `minor-mode-alist'
for details.

For major modes, VALUE is typically a string to which `mode-name' will be set,
but any value suitable for `mode-line-format' may be used.

The optional FILE argument is the file to pass to `eval-after-load'.
If FILE is nil then the mode symbol is passed as the required feature."
  (add-hook 'after-change-major-mode-hook 'delight-major-mode)
  (let ((glum (if (consp spec) spec (list (list spec value file)))))
    (while glum
      (destructuring-bind (mode &optional value file) (pop glum)
        (assq-delete-all mode delighted)
        (add-to-list 'delighted (list mode value file))
        (eval-after-load (or file mode)
          `(let ((minor-delight (assq ',mode minor-mode-alist)))
             (when minor-delight
               (setcar (cdr minor-delight) ',value))))))))

(defun delight-major-mode ()
  "Delight the 'pretty name' of the current buffer's major mode
during mode-line redraws. For other uses of `mode-name', this
delight will be inhibited."
  (let ((major-delight (assq major-mode delighted)))
    (when major-delight
      (set (make-local-variable 'mode-name-glum) mode-name)
      (set (make-local-variable 'mode-name-delighted) (cadr major-delight))
      (setq mode-name '(inhibit-mode-name-delight
                        mode-name-glum
                        mode-name-delighted)))))

(defadvice format-mode-line (around delight-glum-mode-name activate)
  "Delighted major modes must exhibit their original glum `mode-name' when
`format-mode-line' is called. See `delight-major-mode'."
  (let ((inhibit-mode-name-delight t))
    ad-do-it))
