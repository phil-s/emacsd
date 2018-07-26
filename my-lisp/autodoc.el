;;; autodoc.el --- Extend eldoc to automatically update help buffers

;; Author: Phil S.
;; URL:
;; Keywords: help, lisp
;; Created: 9 May 2016
;; Package-Requires: ((emacs "24.3"))
;; Version: 0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


;;; Commentary:

;; Installation and usage
;; ----------------------
;; To enable autodoc by default, add the following to your init file:
;;
;; (when (require 'autodoc nil :noerror)
;;   (autodoc-mode 1))
;;
;; Use the `autodoc-dwim' command to enable or disable `autodoc-mode'.

;; Configuration
;; -------------
;; TODO: options for...
;; * using a separate help buffer, instead of *Help*
;; * using a separate frame specifically for this
;; * requiring a visible help window, or enforcing the help buffer display
;; * eagerness (global vs buffer-local memory)
;; * supporting other languages (indirection for doc generation, etc)
;; * acting on the current eldoc function, or just the symbol-at-point


;; Implementation notes
;; --------------------
;; This library advises `eldoc-print-current-symbol-info', in order to
;; piggy-back our updates on eldoc's updates. We use 'before' advice so
;; that we don't clobber eldoc's own display.


;;; Change Log:
;;
;; 0.1 - Initial release.


;;; Code:

(defcustom autodoc-help-buffer-name "*Help*"
  "The name of the help buffer that autodoc will use.")

(defvar-local autodoc-last-symbol nil
  ;; Using a buffer-local variable for this means that we can't
  ;; trigger changes to the help buffer simply by switching windows,
  ;; which seems generally preferable to the alternative.
  "The last symbol processed by `autodoc-update' in this buffer.")

(defun autodoc-help-buffer-symbol ()
  "The symbol which the help buffer is currently describing."
  (with-current-buffer (autodoc-help-buffer)
    (and (boundp 'help-xref-stack-item)
         (consp help-xref-stack-item)
         (cadr help-xref-stack-item))))

(defun autodoc-help-buffer ()
  "Like `help-buffer', but without a hard-coded buffer name."
  (if help-xref-following
      (help-buffer)
    (buffer-name (get-buffer-create autodoc-help-buffer-name))))

(defun autodoc-update (&optional force)
  "Describe function, variable, or face at point, if *Help* buffer is visible."
  (let ((help-visible-p (get-buffer-window (autodoc-help-buffer))))
    (when (or help-visible-p force)
      (let ((sym (eldoc-current-symbol)))
        ;; If something else changes the help buffer contents, ensure we
        ;; don't immediately revert back to the current symbol's help.
        (and sym ; do nothing if no symbol is found
             ;; FIXME: but sometimes we want the buffer-local value
             ;; to be set to nil, which is why I previously had the
             ;; test for sym after the setq...
             (or force
                 (and (not (keywordp sym)) ; keyword help is redundant
                      (not (eq sym autodoc-last-symbol))
                      (setq autodoc-last-symbol sym)))
             ;; Don't update if help for sym is already displayed
             (not (eq (autodoc-help-buffer-symbol) sym))
             ;; Update the help buffer
             (save-selected-window
               (with-help-window (autodoc-help-buffer)
                 (with-current-buffer (autodoc-help-buffer)
                   ;; (let ((help-xref-following t))
                   (help-xref-interned sym))))))))) ;; )

;;;###autoload
(define-minor-mode autodoc-mode
  "Show help for the elisp symbol at point in the current *Help* buffer.

Advises `eldoc-print-current-symbol-info'."
  ;; The advice is just to piggy-back on top of the eldoc idle timer,
  ;; and to avoid doing anything in cases which eldoc itself has
  ;; elected to ignore. Note that eldoc may respond to symbols which
  ;; are NOT at point, whereas we restric ourselves to what is at
  ;; point. This could be configurable behaviour.
  :lighter " C-h"
  :global t
  (require 'help-mode) ;; for `help-xref-interned'
  (message "Contextual help is %s" (if autodoc-mode "on" "off"))
  (and autodoc-mode
       (eldoc-mode 1)
       (eldoc-current-symbol)
       (autodoc-update :force)))

;;;###autoload
(defun autodoc-dwim (&optional arg)
  "Intelligently enable or disable `autodoc-mode'.

With a numeric prefix argument, enable for ARG >= 1, and
disable for ARG <= 0.

When called repeatedly, toggle the mode.

When the help currently displayed is the same as the help that
autodoc wants to display, toggle the mode (typically disabling it).

In all other cases, enable the mode and display the help for the
symbol at point (if any)."
  (interactive "P")
  (if arg
      (autodoc-mode (prefix-numeric-value arg))
    (let ((last-symbol autodoc-last-symbol))
      ;; Repeating the command must always toggle the mode.
      (if (eq last-command 'autodoc-dwim)
          (autodoc-mode 'toggle)
        ;; Otherwise, if the help buffer is visible...
        (if (and (get-buffer-window (autodoc-help-buffer))
                 ;; ...and is displaying the help for last-symbol
                 (eq (autodoc-help-buffer-symbol) last-symbol)
                 ;; ...which is also the symbol at point (if any)
                 (or (eq (eldoc-current-symbol) last-symbol)
                     (not (eldoc-current-symbol))))
            ;; The visible help matches the symbol at point, so toggle the mode.
            (autodoc-mode 'toggle)
          ;; In all other cases, display/update the help for the current symbol,
          ;; with the mode enabled.
          (autodoc-mode 1))))))

(defadvice eldoc-print-current-symbol-info (before autodoc-update activate)
  "Triggers contextual elisp *Help*. Enabled by `autodoc-mode'."
  (and autodoc-mode
       (derived-mode-p 'emacs-lisp-mode)
       (autodoc-update)))

(provide 'autodoc)
;;; autodoc.el ends here





;; (define-minor-mode my-contextual-help-mode
;;   "Show help for the elisp symbol at point in the current *Help* buffer.
;;
;; Advises `eldoc-print-current-symbol-info'."
;;   :lighter " C-h"
;;   :global t
;;   (require 'help-mode) ;; for `help-xref-interned'
;;   (when (eq this-command 'my-contextual-help-mode)
;;     (message "Contextual help is %s" (if my-contextual-help-mode "on" "off")))
;;   (and my-contextual-help-mode
;;        (eldoc-mode 1)
;;        (eldoc-current-symbol)
;;        (my-contextual-help :force)))
;;
;; (defadvice eldoc-print-current-symbol-info (before my-contextual-help activate)
;;   "Triggers contextual elisp *Help*. Enabled by `my-contextual-help-mode'."
;;   (and my-contextual-help-mode
;;        (derived-mode-p 'emacs-lisp-mode)
;;        (my-contextual-help)))
;;
;; (defvar-local my-contextual-help-last-symbol nil
;;   ;; Using a buffer-local variable for this means that we can't
;;   ;; trigger changes to the help buffer simply by switching windows,
;;   ;; which seems generally preferable to the alternative.
;;   "The last symbol processed by `my-contextual-help' in this buffer.")
;;
;; (defun my-contextual-help (&optional force)
;;   "Describe function, variable, or face at point, if *Help* buffer is visible."
;;   (let ((help-visible-p (get-buffer-window (help-buffer))))
;;     (when (or help-visible-p force)
;;       (let ((sym (eldoc-current-symbol)))
;;         ;; We ignore keyword symbols, as their help is redundant.
;;         ;; If something else changes the help buffer contents, ensure we
;;         ;; don't immediately revert back to the current symbol's help.
;;         (and (not (keywordp sym))
;;              (or (not (eq sym my-contextual-help-last-symbol))
;;                  (and force (not help-visible-p)))
;;              (setq my-contextual-help-last-symbol sym)
;;              sym
;;              (save-selected-window
;;                (help-xref-interned sym)))))))
;;
;; (defun my-contextual-help-toggle ()
;;   "Intelligently enable or disable `my-contextual-help-mode'."
;;   (interactive)
;;   (if (get-buffer-window (help-buffer))
;;       (my-contextual-help-mode 'toggle)
;;     (my-contextual-help-mode 1)))
;;
;; (my-contextual-help-mode 1)
