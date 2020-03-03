;;; posix-manual.el --- POSIX manual page lookup -*- lexical-binding: t -*-
;;
;; Copyright 2019 Lassi Kortela
;; SPDX-License-Identifier: ISC
;; Author: Lassi Kortela <lassi@lassi.io>
;; URL: https://github.com/lassik/emacs-posix-manual
;; Version: 0.1.0
;; Package-Requires: ((emacs "24"))
;; Keywords: languages util
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; Provides a `posix-manual-entry` command with tab completion. It
;; lets you easily call up POSIX manual pages in your web browser.
;;
;;; Code:

(require 'browse-url)
(require 'thingatpt)

(require 'posix-manual-data)

(defun posix-manual--pages ()
  "Get list of all POSIX manual pages."
  (save-match-data
    (let ((case-fold-search nil) (i 0) (pages '()))
      (while (string-match "^\\(.*?\\)\t" posix-manual-data--as-string i)
        (push (match-string 1 posix-manual-data--as-string) pages)
        (setq i (match-end 0)))
      pages)))

(defun posix-manual--page-url (page)
  "Get URL for POSIX manual PAGE."
  (save-match-data
    (let ((case-fold-search nil))
      (and (string-match (concat "^" (regexp-quote page) "\t\\(.*\\)$")
                         posix-manual-data--as-string)
           (concat posix-manual-data-base-url
                   (match-string 1 posix-manual-data--as-string))))))

;;;###autoload
(defun posix-manual-entry (page)
  "Visit the given POSIX manual page in a web browser.

Interactively, ask which PAGE to visit in the minibuffer with tab
completion. The `browse-url' function is used to open the page."
  (interactive
   (list (completing-read "POSIX manual entry: " (posix-manual--pages)
                          nil t (word-at-point))))
  (browse-url (or (posix-manual--page-url page)
                  (error "No such POSIX manual page"))))

(provide 'posix-manual)

;;; posix-manual.el ends here
