;; http://stackoverflow.com/questions/2601120/do-overlays-tooltips-work-correctly-in-emacs-for-windows

;; Reforms a single-line string ARG to a multi-line string with a max
;; of LIMIT chars on a line.
;;
;; This is intended to solve a problem with the display of tooltip text
;; in emacs on Win32 - which is that the tooltip is extended to eb very very
;; long, and the final line is clipped.
;;
;; The solution is to split the text into multiple lines, and to add a
;; trailing newline to trick the tooltip logic into doing the right thing.
;;
(defun cheeso-reform-string (limit arg)
  (let ((orig arg) (modified "") (curline "") word
        (words (split-string arg " ")))
    (while words
      (progn
        (setq curline "")
        (while (and words (< (length curline) limit))
          (progn
            (setq word (car words))
            (setq words (cdr words))
            (setq curline (concat curline " " word))))
        (setq modified (concat modified curline "\n"))))
    (setq modified (concat modified " \n")))
  )

(defadvice tooltip-show (before
                         flymake-csharp-fixup-tooltip
                         (arg &optional use-echo-area)
                         activate compile)
  (progn
    (if (and (not use-echo-area)
             (eq major-mode 'csharp-mode))
        (let ((orig (ad-get-arg 0)))
          (ad-set-arg 0 (cheeso-reform-string 72 orig))
          ))))
