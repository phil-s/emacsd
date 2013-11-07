(defvar-local my-image-dimensions nil
  "Buffer-local image dimensions for `my-image-dimensions-minor-mode'")

(define-minor-mode my-image-dimensions-minor-mode
  "Displays the image dimensions in the mode line."
  :init-value nil
  :lighter my-image-dimensions
  (require 'image-mode)
  (when (not my-image-dimensions)
    (let ((image (image-get-display-property)))
      (when image
        (setq my-image-dimensions
              (destructuring-bind (width . height)
                  (image-size image :pixels)
                (format " (%dx%d)" width height)))))))

(defun my-image-mode-hook ()
  (my-image-dimensions-minor-mode 1))

(add-hook 'image-mode-hook 'my-image-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-images)
