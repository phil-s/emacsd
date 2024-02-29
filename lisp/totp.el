;;; totp.el --- Time-based One-time Password (TOTP)  -*- lexical-binding:t -*-

;; Authors: Jürgen Hötzel, Mickey Petersen, Phil Sainty.

;;; Commentary:

;; This is derived from the solution described in detail here:
;; https://www.masteringemacs.org/article/securely-generating-totp-tokens-emacs
;; (With custom additions by Phil for window manager integration.)
;;
;; A usage example for gitlab.com:
;;
;; Open your .authinfo.gpg file and add an entry like this:
;;
;; machine TOTP:gitlab.com login gitlab.com:<you>@<domain> password "..."
;;
;; The ... secret should (most likely) NOT contain spaces, and its length
;; in characters must be a multiple of 8.  E.g. gitlab.com will provide a
;; 32-character secret but displays it in blocks of 4, so you will need to
;; remove those spaces.
;;
;; Save .authinfo.gpg and M-x auth-source-forget-all-cached and then you
;; can use M-x totp-display whenever a 2FA verification code is requested,
;; or M-x totp-as-clipboard to put that value into the system clipboard
;; for pasting into another application.
;;
;; See also `totp-x-paste' which can be invoked by a window manager key
;; binding when a TOTP input field in your web browser has focus, to make
;; the TOTP code from Emacs be pasted automatically into that field.
;;
;; To use that, you will need one of the following in your config:
;; (require 'totp)
;; (autoload 'totp-x-paste "totp")

;;; Code:

;; This first part is taken from Jürgen Hötzel's `totp.el':
;; https://github.com/juergenhoetzel/emacs-totp

(require 'bindat)
(require 'gnutls)
(require 'hexl)
(require 'auth-source)

(defun totp--hex-decode-string (string)
  "Hex-decode STRING and return the result as a unibyte string."
  ;; Pad the string with a leading zero if its length is odd.
  (unless (zerop (logand (length string) 1))
    (setq string (concat "0" string)))
  (apply #'unibyte-string
         (seq-map (lambda (s) (hexl-htoi (aref s 0) (aref s 1)))
                  (seq-partition string 2))))

(defun totp (string &optional time digits)
  "Return a TOTP token using the secret hex STRING and current time.
TIME is used as counter value instead of current time, if non-nil.
DIGITS is the number of pin digits and defaults to 6."
  (let* ((key-bytes (totp--hex-decode-string (upcase string)))
         (counter (truncate (/ (or time (time-to-seconds)) 30)))
         (digits (or digits 6))
         (format-string (format "%%0%dd" digits))
         ;; We have to manually split the 64 bit number.
         ;; (u64 not supported in Emacs 27.2)
         (counter-bytes (bindat-pack '((:high u32)
                                       (:low u32))
                                     `((:high . ,(ash counter -32))
                                       (:low . ,(logand counter #xffffffff)))))
         (mac (gnutls-hash-mac 'SHA1 key-bytes counter-bytes))
         (offset (logand (bindat-get-field (bindat-unpack '((:offset u8)) mac 19)
                                           :offset)
                         #xf)))
    (format format-string
            (mod
             (logand (bindat-get-field (bindat-unpack '((:totp-pin u32)) mac offset)
                                       :totp-pin)
                     #x7fffffff)
             (expt 10 digits)))))

;; The next section is from:
;; https://www.masteringemacs.org/article/securely-generating-totp-tokens-emacs

(defconst base32-alphabet
  (let ((tbl (make-char-table nil)))
    (dolist (mapping '(("A" . 0) ("B" . 1) ("C" . 2) ("D" . 3)
                       ("E" . 4) ("F" . 5) ("G" . 6)
                       ("H" . 7) ("I" . 8) ("J" . 9) ("K" . 10)
                       ("L" . 11) ("M" . 12) ("N" . 13)
                       ("O" . 14) ("P" . 15) ("Q" . 16) ("R" . 17)
                       ("S" . 18) ("T" . 19) ("U" . 20)
                       ("V" . 21) ("W" . 22) ("X" . 23) ("Y" . 24)
                       ("Z" . 25) ("2" . 26) ("3" . 27)
                       ("4" . 28) ("5" . 29) ("6" . 30) ("7" . 31)))
      (aset tbl (string-to-char (car mapping)) (cdr mapping)))
    tbl)
  "Base-32 mapping table, as defined in RFC 4648.")

(defun base32-hex-decode (string)
  "The cheats' version of base-32 decode.

This is not a 100% faithful implementation of RFC 4648. The
concept of encoding partial quanta is not implemented fully.

No attempt is made to pad the output either as that is not
required for HMAC-TOTP."
  (unless (eql 0 (mod (length string) 8))
    (error "Padding is incorrect"))
  (setq string (upcase string))
  (let ((trimmed-array (append (string-trim-right string "=+") nil)))
    (format "%X" (seq-reduce
                  (lambda (acc char) (+ (ash acc 5) (aref base32-alphabet char)))
                  trimmed-array 0))))

;;;###autoload
(defun totp-display (auth)
  "Select a TOTP AUTH from `auth-sources' and display and return its TOTP."
  (interactive
   (list (let ((candidates
                (mapcar
                 (lambda (auth)
                   (cons (format "User '%s' on %s"
                                 (propertize (plist-get auth :user)
                                             'face 'font-lock-keyword-face)
                                 (propertize (plist-get auth :host)
                                             'face 'font-lock-string-face))
                         auth))
                 (seq-filter (lambda (auth)
                               (string-prefix-p
                                "TOTP:" (plist-get auth :host)))
                             (auth-source-search :max 10000)))))
           (cdr (assoc (completing-read "Pick a TOTP> " candidates)
                       candidates)))))
  (let ((code (totp (base32-hex-decode (funcall (plist-get auth :secret))))))
    (message "Your TOTP for '%s' is: %s"
             (propertize (plist-get auth :host) 'face font-lock-keyword-face)
             (propertize code 'face 'font-lock-string-face))
    code))

;; This final part is my addition:
;;;###autoload
(defun totp-as-clipboard ()
  "Set the result of `totp-display' as the system clipboard."
  (interactive)
  (gui-backend-set-selection 'CLIPBOARD (call-interactively #'totp-display)))

;;;###autoload
(defun totp-x-paste (wid)
  "Run `totp-as-clipboard' and then send \"C-v\" to the original window.

\(For use with programs where \"C-v\" is paste.)

Requires that \"xdotool\" is installed on your system.  E.g.:

 sudo apt-get install xdotool

To use, trigger the following command via your window manager:

 emacsclient --eval \"(totp-x-paste $(xdotool getactivewindow))\"

Example XMonad key binding (mod-T) for xmonad.hs:

 , ((modMask .|. shiftMask, xK_t), spawn \"emacsclient --eval \\
 \\\"(totp-x-paste $(xdotool getactivewindow))\\\"\")

Also for XMonad, include the following in your manageHook to make the
pop-up frame float over the other windows rather than being tiled:

 appName =? \"EmacsXPaste\" --> doFloat"
  (interactive)
  (with-temp-buffer
    (setq-local header-line-format "Time-based One-time Password (TOTP)")
    (rename-buffer "*TOTP*" :unique)
    (let* ((buf (current-buffer))
           (width 80)
           (height 2)
           (pxwidth (+ 3 (* width (default-font-width))))
           (pxheight (+ 3 (* height (default-font-height))))
           (fparams `((totp-x-paste . t)
                      (name . "EmacsXPaste")
                      (fullscreen . nil)
                      (width . ,width)
                      (height . ,height)
                      (left . ,(- (/ (display-pixel-width) 2) (/ pxwidth 2)))
                      (top . ,(- (/ (display-pixel-height) 2) (/ pxheight 2)))
                      (menu-bar-lines . 0)
                      (tool-bar-lines . 0)
                      (auto-raise . t))))
      (select-frame (make-frame fparams))
      (pop-to-buffer buf)
      (delete-other-windows)
      (unwind-protect
          (let ((hash (totp-as-clipboard)))
            (and hash
                 (integerp wid)
                 (call-process "xdotool" nil nil nil
                               "key"
                               "--clearmodifiers"
                               "--window" (number-to-string wid)
                               "ctrl+v")
                 t))
        ;; We need to give the target window time to talk to the Emacs frame to
        ;; extract the clipboard text before the frame is deleted.  This should
        ;; only take a moment; but as we don't know for sure how long we need, we
        ;; make the frame invisible and then sleep for a full second.  Note that
        ;; we need to redisplay to activate the visibility change.
        (set-frame-parameter (selected-frame) 'visibility nil)
        (redisplay)
        (sleep-for 1)
        (delete-frame)))))

(provide 'totp)
