;;; windcycle.el --- Window cycling for Emacs

;; This is a modified (reduced) version of:
;; https://raw.github.com/troydm/emacs-stuff/master/windcycle.el
;; as of commit 9f5930d1959538ca1c25a7af02d76f540c65645f
;; edited to remove unrelated functionality, as I only want
;; the buffer cycling/swapping functions.

;; Copyright (C) 2011 Dmitry Geurkov

;; Author: Dmitry Geurkov <dmitry_627@mail.ru>

;; This program is free software: you can redistribute it and/or modify
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
;;; Simple Window cycling for Emacs using C-x arrows or Meta arrows
;;; You can also swap buffers between windows using Meta-Shift arrow

;; Windows Cycling
(defun windcycle-up()
  (interactive)
  (condition-case nil (windmove-up)
    (error (condition-case nil (windmove-down)
              (error (condition-case nil (windmove-right) (error (condition-case nil (windmove-left) (error (windmove-up))))))))))

(defun windcycle-down()
  (interactive)
  (condition-case nil (windmove-down)
    (error (condition-case nil (windmove-up)
              (error (condition-case nil (windmove-left) (error (condition-case nil (windmove-right) (error (windmove-down))))))))))

(defun windcycle-right()
  (interactive)
  (condition-case nil (windmove-right)
    (error (condition-case nil (windmove-left)
              (error (condition-case nil (windmove-up) (error (condition-case nil (windmove-down) (error (windmove-right))))))))))

(defun windcycle-left()
  (interactive)
  (condition-case nil (windmove-left)
    (error (condition-case nil (windmove-right)
              (error (condition-case nil (windmove-down) (error (condition-case nil (windmove-up) (error (windmove-left))))))))))

;; Buffer swapping
(defun buffer-up-swap()
  (interactive)
  (let ((current-window (selected-window))
    (current-buffer (buffer-name))
    (swapped-window nil)
    (swapped-buffer nil))
    (progn (windcycle-up)
     (setq swapped-window (selected-window))
     (setq swapped-buffer (buffer-name))
     (if (and (not (string= swapped-buffer current-buffer)))
         (progn (set-window-buffer swapped-window current-buffer)
            (set-window-buffer current-window swapped-buffer))))))

(defun buffer-down-swap()
  (interactive)
  (let ((current-window (selected-window))
    (current-buffer (buffer-name))
    (swapped-window nil)
    (swapped-buffer nil))
    (progn (windcycle-down)
     (setq swapped-window (selected-window))
     (setq swapped-buffer (buffer-name))
     (if (and (not (string= swapped-buffer current-buffer)))
         (progn (set-window-buffer swapped-window current-buffer)
            (set-window-buffer current-window swapped-buffer))))))

(defun buffer-right-swap()
  (interactive)
  (let ((current-window (selected-window))
    (current-buffer (buffer-name))
    (swapped-window nil)
    (swapped-buffer nil))
    (progn (windcycle-right)
     (setq swapped-window (selected-window))
     (setq swapped-buffer (buffer-name))
     (if (and (not (string= swapped-buffer current-buffer)))
         (progn (set-window-buffer swapped-window current-buffer)
            (set-window-buffer current-window swapped-buffer))))))

(defun buffer-left-swap()
  (interactive)
  (let ((current-window (selected-window))
    (current-buffer (buffer-name))
    (swapped-window nil)
    (swapped-buffer nil))
    (progn (windcycle-left)
     (setq swapped-window (selected-window))
     (setq swapped-buffer (buffer-name))
     (if (and (not (string= swapped-buffer current-buffer)))
         (progn (set-window-buffer swapped-window current-buffer)
            (set-window-buffer current-window swapped-buffer))))))

;; Ew. Definitely calls for some more refactoring.
(defun rotate-windows ()
  "Rotate windows."
  (interactive)
  (let ((numWindows (count-windows)))
    (if (= 1 numWindows)
        (message "You can't rotate a single window!")
      (let ((i 1))
        (while  (< i numWindows)
          (let* (
                 (w1 (elt (window-list) i))
                 (w2 (elt (window-list) (+ (% i numWindows) 1)))

                 (b1 (window-buffer w1))
                 (b2 (window-buffer w2))

                 (s1 (window-start w1))
                 (s2 (window-start w2))
                 )
            (set-window-buffer w1  b2)
            (set-window-buffer w2 b1)
            (set-window-start w1 s2)
            (set-window-start w2 s1)
            (setq i (1+ i))))))))

;; Switch window keybindings
(global-set-key (kbd "S-<prior>") 'windcycle-up)
(global-set-key (kbd "S-<next>") 'windcycle-down)
(global-set-key (kbd "S-<home>") 'windcycle-left)
(global-set-key (kbd "S-<end>") 'windcycle-right)

;; Swap window keybindings
(global-set-key (kbd "S-C-<prior>") 'buffer-up-swap)
(global-set-key (kbd "S-C-<next>") 'buffer-down-swap)
(global-set-key (kbd "S-C-<home>") 'buffer-left-swap)
(global-set-key (kbd "S-C-<end>") 'buffer-right-swap)

(provide 'windcycle)
