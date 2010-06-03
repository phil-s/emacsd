;;; javascript.el --- Major mode for editing JavaScript source code

;; Copyright (C) 2005 Karl Landström

;; Author: Karl Landström <kland at comhem dot se>
;; Maintainer: Karl Landström <kland at comhem dot se>
;; Version: 1.0
;; Keywords: languages, oop

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Installation:
;; 
;; Put this file in a folder where Emacs can find it.  On GNU/Linux
;; it's usually /usr/local/share/emacs/site-lisp/ and on Windows it's
;; something like "C:\Program Files\Emacs<version>\site-lisp".  To
;; make it run slightly faster you can also compile it from Emacs (M-x
;; `emacs-lisp-byte-compile'). Then add
;; 
;;    (add-to-list 'auto-mode-alist (cons  "\\.js\\'" 'javascript-mode))
;;    (autoload 'javascript-mode "javascript" nil t)
;;    
;; to your .emacs initialization file (_emacs on Windows).

;; This mode assumes that block comments are not nested inside block
;; comments and that strings does not contain line breaks.

;;; Code:

(require 'cc-mode)

(defcustom js-indent-level 3 "Number of spaces for each indent step.")


;; KEYMAP

(defvar javascript-mode-map nil "Keymap in JavaScript mode.")

(unless javascript-mode-map (setq javascript-mode-map (make-sparse-keymap)))


;; SYNTAX TABLE AND PARSING

(defvar javascript-mode-syntax-table
  (let ((table (make-syntax-table)))
    (c-populate-syntax-table table)
    (modify-syntax-entry ?_ "w" table)
    table)
  "Syntax table used in JavaScript mode.")


(defun js-re-search-forward-inner (regexp &optional bound count)
  "Used by `js-re-search-forward'."
  (let ((parse)
        (saved-point (point-min)))
    (while (> count 0)
      (re-search-forward regexp bound)
      (setq parse (parse-partial-sexp saved-point (point)))
      (cond ((nth 3 parse)
             (re-search-forward 
              (concat "\\([^\\]\\|^\\)" (string (nth 3 parse))) 
              (save-excursion (end-of-line) (point)) t))
            ((nth 7 parse)
             (forward-line))
            ((or (nth 4 parse)
                 (and (eq (char-before) ?\/) (eq (char-after) ?\*)))
             (re-search-forward "\\*/"))
            (t
             (setq count (1- count))))
      (setq saved-point (point))))
  (point))


(defun js-re-search-forward (regexp &optional bound noerror count)
  "Invokes `re-search-forward' but treats the buffer as if strings and
comments have been removed."
  (let ((saved-point (point))
        (search-expr 
         (cond ((null count)
                '(js-re-search-forward-inner regexp bound 1))
               ((< count 0)
                '(js-re-search-backward-inner regexp bound (- count)))
               ((> count 0)
                '(js-re-search-forward-inner regexp bound count)))))
    (condition-case err
        (eval search-expr)
      (search-failed
       (goto-char saved-point)
       (unless noerror
         (error (error-message-string err)))))))


(defun js-re-search-backward-inner (regexp &optional bound count)
  "Used by `js-re-search-backward'."
  (let ((parse)
        (saved-point (point-min)))
    (while (> count 0)
      (re-search-backward regexp bound)
      (setq parse (parse-partial-sexp saved-point (point)))
      (cond ((nth 3 parse)
             (re-search-backward
              (concat "\\([^\\]\\|^\\)" (string (nth 3 parse))) 
              (save-excursion (beginning-of-line) (point)) t))
            ((nth 7 parse) 
             (goto-char (nth 8 parse)))
            ((or (nth 4 parse)
                 (and (eq (char-before) ?/) (eq (char-after) ?*)))
             (re-search-backward "/\\*"))
            (t
             (setq count (1- count))))))
  (point))


(defun js-re-search-backward (regexp &optional bound noerror count)
  "Invokes `re-search-backward' but treats the buffer as if strings
and comments have been removed."
  (let ((saved-point (point))
        (search-expr 
         (cond ((null count)
                '(js-re-search-backward-inner regexp bound 1))
               ((< count 0)
                '(js-re-search-forward-inner regexp bound (- count)))
               ((> count 0)
                '(js-re-search-backward-inner regexp bound count)))))
    (condition-case err
        (eval search-expr)
      (search-failed
       (goto-char saved-point)
       (unless noerror
         (error (error-message-string err)))))))


;; INDENTATION

(defun js-indent-line ()
  (interactive)
  (let ((indent
         (save-excursion
           (back-to-indentation)
           (let ((p (parse-partial-sexp (point-min) (point)))
                 (brace-p (looking-at "[{}]"))
                 (continued-expr-p (looking-at "[[:punct:]]")))
             (cond
              ;; comment
              ((or (nth 8 p) (looking-at "/[/*]"))
               (current-indentation))
              ;; single statement in control statement
              ((save-excursion
                 (and (js-re-search-backward 
                       "^[[:blank:]]*[[:graph:]]" nil t)
                      (looking-at 
                       "^[[:blank:]]*\\<\\(for\\|if\\|else\\|while\\|do\\)\\>")
                      (save-excursion
                        (null (nth 1 (parse-partial-sexp (point) 
                                                         (point-at-eol)))))))
               (save-excursion
                 (goto-char (match-beginning 0))
                 (+ (current-indentation) js-indent-level)))
              ;; parenthesis/braces/brackets
              ((nth 1 p)
               (save-excursion 
                 (goto-char (nth 1 p))
                 (if (looking-at "{")
                     (cond (brace-p 
                            (current-indentation))
                           (continued-expr-p
                            (+ (current-indentation) (* js-indent-level 2)))
                           (t
                            (+ (current-indentation) js-indent-level)))
                   (+ (current-column) 1))))
              (t
               0)))))
        (offset (- (current-column) (current-indentation))))
    (indent-line-to indent)
    (if (> offset 0) (forward-char offset))))


;; FONT LOCK

(defvar js-function-heading-re "^[[:blank:]]*function[[:blank:]]*\\(\\sw+\\)")

(defvar js-keywords-re
  (regexp-opt '("abstract" "break" "case" "catch" "class" "const"
"continue" "debugger" "default" "delete" "do" "else" "enum" "export"
"extends" "final" "finally" "for" "function" "goto" "if" "implements"
"import" "in" "instanceof" "interface" "native" "new" "package"
"private" "protected" "public" "return" "static" "super" "switch"
"synchronized" "this" "throw" "throws" "transient" "try" "typeof"
"var" "void" "volatile" "while" "with") 'words)
  "The reserved words in JavaScript.")

(defvar js-basic-types-re
  (regexp-opt '("boolean" "byte" "char" "double" "float" "int" "long"
"short" "void") 'words)
  "Future reserved words in JavaScript.")

(defvar js-constants-re
  (regexp-opt '("false" "null" "true") 'words)
  "Future reserved words in JavaScript.")


(defvar js-font-lock-keywords-1
  (list 
   "\\<import\\>" 
   (list js-function-heading-re 1 font-lock-function-name-face)
   (list "[[:punct:]][[:blank:]]*\\(/.*?/[[:word:]]*\\)" 1 
         font-lock-string-face))
  "Level one font lock.")

(defvar js-font-lock-keywords-2
  (append js-font-lock-keywords-1
          (list js-keywords-re
                (cons js-basic-types-re font-lock-type-face)
                (cons js-constants-re font-lock-constant-face))))

(defvar js-font-lock-keywords-3
  (append js-font-lock-keywords-2
          (list 
           (list
            (concat "\\<var\\>\\|" js-basic-types-re "\\|" 
                    js-function-heading-re)
            (list "\\(\\w+\\)[[:blank:]]*\\(,\\|=[[:blank:]]*\\(\".*?\"\\|'.*?'\\|{.*?}\\|.*?,\\)\\|.*\\)"
             ;; "\\(\\w+\\)[[:blank:]]*\\([,)]\\|/[/*]\\|$\\)"
                  nil
                  nil
                  '(1 font-lock-variable-name-face))))))

(defconst js-font-lock-keywords
  '(js-font-lock-keywords-3 js-font-lock-keywords-1 js-font-lock-keywords-2
                            js-font-lock-keywords-3)
  "See `font-lock-keywords'.")


;; IMENU

(defvar js-imenu-generic-expression 
  (setq js-imenu-generic-expression
        (list
         (list
          nil 
          "function\\s-+\\(\\sw+\\)\\s-*("
          1)))
  "Regular expression matching top level procedures. Used by imenu.")


;;;###autoload
(defun javascript-mode ()
  "Major mode for editing JavaScript source code.

Key bindings:

\\{javascript-mode-map}"
  (interactive)
  (kill-all-local-variables)

  (use-local-map javascript-mode-map)
  (set-syntax-table javascript-mode-syntax-table)
  (set (make-local-variable 'indent-line-function) 'js-indent-line)
  (set (make-local-variable 'font-lock-defaults) (list js-font-lock-keywords))

  ;; Imenu
  (setq imenu-case-fold-search nil)
  (set (make-local-variable 'imenu-generic-expression)
       js-imenu-generic-expression)

  (when (featurep 'newcomment)
    (set (make-local-variable 'comment-start) "/*")
    (set (make-local-variable 'comment-end) "*/")
    (set (make-local-variable 'comment-start-skip) "/\\*+ *")
    (set (make-local-variable 'comment-end-skip) " *\\*+/")
    (require 'advice)

    (defadvice comment-dwim (after inhibit-indent)
      "Indent new comment lines to column zero and insert only one space
before a trailing comment."
      (when (eq major-mode 'javascript-mode)
        (let ((prs (parse-partial-sexp 
                    (save-excursion (beginning-of-line) (point)) 
                    (point))))
          (when (nth 4 prs)
            (save-excursion 
              (goto-char (nth 8 prs))
              (when (looking-at "/\\*[ \t]*\\*/")
                (if (= (current-column) (current-indentation))
                    (indent-line-to 0)
                  (just-one-space))))))))
    
    (ad-activate 'comment-dwim))

  (setq major-mode 'javascript-mode)
  (setq mode-name "JavaScript")
  (run-hooks 'javascript-mode-hook))


(provide 'javascript-mode)
;;; javascript.el ends here
