;;-*- mode: lisp-interaction; -*-
;;(redshift--indentation-rest (point-min) (point-max))
;;(redshift--indentation-shift (point-min) (point-max))
;;(redshift--indentation-rest (region-beginning) (region-end))
;;(redshift--indentation-shift (region-beginning) (region-end))
;;(let ((tab-width 1)) (redshift--indentation-shift (point-min) (point-max)))
;;(let ((tab-width (* 2 tab-width))) (redshift--indentation-shift (point-min) (point-max)))
;;(current-column)

;; :relative-width
(defface hl-sexp-face
  '((((type tty))
     (:bold t))
    (((class color) (background light))
 	 (:background "lightgray"))
    (((class color) (background dark))
     (:background "gray10"))
    (t (:bold t)))
  "Face used to fontify the sexp you're looking at."
  :group 'faces)

;; :relative-width
(defface hl-sexp-face
  '((((type tty))
     (:bold t))
    (((class color) (background light))
     (:background "lightgray"))
    (((class color) (background dark))
     (:background "gray10"))
    (t (:bold t)))
  "Face used to fontify the sexp you're looking at."
  :group 'faces)

;; :relative-width
(defface hl-sexp-face
  '((((type tty))
	 (:bold t))
    (((class color) (background light))
 	 (:background "lightgray"))
    (((class color) (background dark))
     (:background "gray10"))
    (t (:bold t)))
  "Face used to fontify the sexp you're looking at."
  :group 'faces)


(let ((tab-width (* 1 tab-width)))
  (progn (insert (propertize " " 'display '(space :relative-width 2)))
         (insert (propertize " " 'display '(space :relative-width 2)))
         (insert (propertize "	" 'display '(space :relative-width 2)))
         (insert (propertize " " 'display '(space :relative-width 2)))
         (current-column)))
  	 5

(let ((tab-width (* 2 tab-width)))
  (progn (insert (propertize " " 'display '(space :relative-width 2)))
         (insert (propertize " " 'display '(space :relative-width 2)))
         (insert (propertize "	" 'display '(space :relative-width 2)))
         (insert (propertize " " 'display '(space :relative-width 2)))
         (current-column)))
  	 9



(let ((tab-width (* 1 tab-width)))
  (progn (insert (propertize " " 'display '(space :relative-width 2)))
         (insert (propertize " " 'display '(space :relative-width 2)))
         (insert (propertize "	" 'display '(space :relative-width 2)))
         (insert (propertize " " 'display '(space :relative-width 2)))
         (current-column)))
  	 5

 	 5

 	4


;; :width
(defface hl-sexp-face
  '((((type tty))
	 (:bold t))
    (((class color) (background light))
  	 (:background "lightgray"))
    (((class color) (background dark))
     (:background "gray10"))
    (t (:bold t)))
  "Face used to fontify the sexp you're looking at."
  :group 'faces)


(progn (insert (propertize " " 'display '(space :width 2)))
       (current-column))
 2

(progn (insert (propertize " " 'display '(space :relative-width 2)))
       (current-column))
 1




(let ((tab-width (* 2 tab-width)))
  (progn (insert (propertize " " 'display '(space :relative-width 2)))
	 (insert (propertize " " 'display '(space :relative-width 2)))
	 (insert (propertize " " 'display '(space :relative-width 2)))
	 (insert (propertize " " 'display '(space :relative-width 2)))
	 (insert (propertize "	" 'display '(space :relative-width 2)))
	 (current-column)))
