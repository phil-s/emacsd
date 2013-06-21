;;; delight.el - A dimmer switch for your lighter text.

;; Commentary:
;;
;; Enables you to customise the mode names displayed in the mode line.
;;
;; For major modes, the buffer-local `mode-name' variable is set. This
;; is the 'pretty name' of the major mode, so may also be re-used in
;; other contexts if the mode name needs to be displayed.
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
;;
;; (delight) ;; initialise using customised value of `delighted' variable.

;;; Code:

(defvar delighted ()
  "List of specs for modifying the display of mode names in the mode line.")

;; (defcustom delighted ()
;;   "List of specs for modifying the display of mode names in the mode line."
;;   :group 'delight
;;   :link '(variable-link mode-name)
;;   :link '(variable-link minor-mode-alist)
;;   :link '(variable-link mode-line-format)
;;   :type '(repeat
;;           (list (symbol :tag "Mode function"
;;                         :value "")
;;                 (choice :tag "Mode line display"
;;                         (const :tag "Hidden" nil)
;;                         (string :tag "String")
;;                         (symbol :tag "Symbol" :value "")
;;                         (sexp :tag "List" :value ""))
;;                 (choice :tag "After loading"
;;                         :help-echo "The FILE argument for `eval-after-load'."
;;                         (const :tag "Feature matching the function symbol" nil)
;;                         (symbol :tag "Provided feature" :value "")
;;                         (file :tag "Library file" :value "")))))

;;;###autoload
(defun delight (&optional spec value file)
  "Modify the lighter value displayed in the mode line for the given mode SPEC
if and when the mode is loaded.

SPEC can be either a mode symbol, or a list of the form ((MODE VALUE FILE) ...)

If SPEC is nil then no new specifications are added, but if the `delighted'
variable has been customised then its specification will be initialised.

For minor modes, VALUE is the replacement lighter value (or nil to disable).
VALUE is typically a string, but may have other values. See `minor-mode-alist'
for details.

For major modes, VALUE is a string to which `mode-name' will be set.

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
  "Delight the 'pretty name' of the current buffer's major mode."
  (let ((major-delight (assq major-mode delighted)))
    (when major-delight
      (setq mode-name (cadr major-delight)))))
