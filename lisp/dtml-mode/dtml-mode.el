;;; Author:        Alastair D. Burt (burt@dfki.de)
;;; File:          dtml-mode.el
;;; Purpose:       Major mode for editing files Zope's DTML syntax
;;; Created:       Sep 23, 1999
;;; Version:       $Id: dtml-mode.el,v 1.6 2000/12/15 22:42:51 burt Exp $
;;; Entry Points:  dtml-mode

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version. See
;; http://www.gnu.org/copyleft/gpl.html.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;;  Commentary:

;; This is an extension of the PSGML package to aid in the editing of DTML
;; code.  DTML is a template language for the Zope application server.  The
;; heavy lifting is done by the PSGML package and the associated DTD.  More
;; info can be found on the zope.org members pages.  In particular, there
;; is a HOWTO that explains how to use this file in combination with the
;; relevant DTD.

;;    Howto:          http://www.zope.org/Members/alburt/dtml_mode.html
;;    This file:      http://www.zope.org/Members/alburt/dtml-mode.el
;;    DTD:            http://www.zope.org/Members/alburt/dtml-4l.dtd
;;    DTML Entities:  http://www.zope.org/Members/alburt/dtml.ent

;; Installation

;; Put the associated DTD files (dtml-4l.dtd and dtml.ent mentioned above,
;; for example) where psgml will look for them when it encounters the
;; string dtml-dtd-declaration.  This is explained in the Howto.

;; Add the following lines to your ~/.emacs:

;; (autoload 'dtml-mode "dtml-mode" "" t)
;; (autoload 'dtml-edit-via-ftp "dtml-mode" "" t)
;; (autoload 'dtml-browse-via-http "dtml-mode" "" t)

;; The first time you edit a DTML file you will have to type M-x dtml-mode
;; by hand.  By default, this will immediately insert a declaration on the
;; first line of the file so that on subsequent visits dtml-mode is invoked
;; automatically.
 
(require 'psgml)
(require 'psgml-parse)
(condition-case nil
    (require 'tempo)
  (error nil))
(condition-case nil
    (require 'url)
  (error nil))

(defvar dtml-dtd-declaration
  "<!doctype html public \"-//ZOPE//DTD DTML//EN\">"
  "*The string we use to define the doctype.
This is only used in the temporary files we create.  It is not written to
the files on the Zope server.")

(defvar dtml-top-element "body"
  "*The HTML element within which the current DTML/HTML is contained.")

(defvar dtml-auto-insert-mode-declaration t
  "*Whether to insert the initial -*- line so that Emacs always recognises
the file as DTML.")

(defvar dtml-browse-managing-http-function 'w3-fetch
  "*Which function to call to display the managing URL.  Good values might
  be 'w3-fetch or 'browse-url.  It must be a function that takes one
  argument, the string for the URL.")

(defvar dtml-browse-http-function 'browse-url
  "*Which function to call to display the URL.  Good values might
  be 'w3-fetch or 'browse-url.  It must be a function that takes one
  argument, the string for the URL.")

(defvar dtml-base-mode 
  (if (string-match "XEmacs" emacs-version)
      'html-mode
    'sgml-mode)
  "*Mode on which to base the dtml-mode. XEmacs has the file 'psgml-html',
which defines an html-mode based on psgml.  If you want to use this file
set dtml-base-mode to 'html-mode, otherwise set it to 'sgml-mode")

(defconst dtml-version "$Revision: 1.6 $")

(defun dtml-base-mode-fun ()
  (funcall dtml-base-mode))

(when (fboundp 'tempo-define-template)
  (tempo-define-template "DTML" '("&dtml-" (p "DTML variable: ") ";"))
  (tempo-define-template "DVAR" '("<dtml-var " (p "DTML variable: ") ">")))

(define-derived-mode dtml-mode dtml-base-mode-fun "DTML"
  "An extension of PSGML for editing Zope's DTML files.

Key bindings:

\\{dtml-mode-map}
"
  (when (fboundp  'tempo-template-DTML)
    (define-key dtml-mode-map '[(control &)] 'tempo-template-DTML)
    (define-key dtml-mode-map '[(control z) v] 'tempo-template-DVAR))
  (define-key dtml-mode-map '[(control c) (control b)] 'dtml-browse-via-http)
  (when (and dtml-auto-insert-mode-declaration
	     (not (dtml-mode-declaration-exists-p))
	     (dtml-insert-mode-declaration)))
  (set (make-local-variable 'x-symbol-language) 'sgml))

(defun dtml-mode-declaration-exists-p ()
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (looking-at ".*-\\*-.*-\\*-"))))

(defun dtml-insert-mode-declaration ()
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      ;; We use DTML comments so that they do not clutter up the HTML code
      ;; that is eventually generated.

      ;; We use a different comment style if we are in a file with a
      ;; doctype declaration; sgml-mode does not want us to add any
      ;; entities before such a declaration, but <!-- --> comments are OK. 
      (cond ((dtml-in-prolog-p)
	     (insert "<!--<dtml-comment> -*- mode: dtml; "
		     "dtml-top-element: \"\" -*- </dtml-comment>"
		     " DTML Generated -->\n"))
	    (t
	     (let ((top (read-string "Enclosing HTML element (BODY): ")))
	       (if (equal top "") (setq top "body"))
	       (insert "<dtml-comment> -*- mode: dtml; dtml-top-element: \""
		       top
		       "\" -*- </dtml-comment>\n")))))))

(defun dtml-in-prolog-p ()
  (save-excursion
    ;; What is the exact allowable syntax for declarations?  We allow white
    ;; space just in case
    (let ((case-fold-search t))
      (search-forward "<[ \t]*![ \t]*doctype" 1000 t))))
		   
(defadvice sgml-load-doctype (around dtml activate)
  (if (eq major-mode 'dtml-mode)
      (let* ((orig-syntax sgml-parser-syntax)
	     (dtd
	      (save-excursion		; get DTD from parent document
	       (set-buffer (get-buffer-create " **dtml-doctype**"))
	       (erase-buffer)
	       (insert dtml-dtd-declaration)
	       ;; Use XML syntax because it allows underscores in attributes
	       ;; EG: <dtml-xvar name="foo" newline_to_br="newline_to_br">
	       (unwind-protect
		   (progn
		     (setq sgml-parser-syntax xml-parser-syntax)
		     (sgml-need-dtd)
		     (sgml-pstate-dtd sgml-buffer-parse-state))
		 (setq sgml-parser-syntax orig-syntax)))))
	(sgml-set-initial-state dtd)
	(setq tmp dtd)
	;; Here it seems that case is significant -- the DTD I use has
	;; element names in upper case
	(sgml-modify-dtd (list "HTML" (upcase dtml-top-element) '())))
    ad-do-it))
    
(put 'dtml-mode 'font-lock-defaults '(html-font-lock-keywords nil t))

(defun dtml-browse-via-http (&optional use-managing-url)
  "Go go the HTTP URL for the object that contains the one in this buffer. 
With prefix arg go to the \"manage_main\" URL for the containing object.
See variables dtml-browse-http-function and
dtml-browse-managing-http-function for customisation." 
  (interactive "P")
  (let ((file default-directory))
    (when (or (null file)
	      (not (string-match "\\`/[^/:]+:" file)))
      (error "No FTP file associated with buffer."))
    (let* ((parsed (efs-ftp-path file))
	   (user (nth 1 parsed))
	   (path (nth 2 parsed))
	   (h (split-string (nth 0 parsed) "#"))
	   (host (nth 0 h))
	   (port (number-to-string (+ (string-to-number (nth 1 h)) 59))))
      (if use-managing-url
	  (apply dtml-browse-managing-http-function
		 (list (concat "http://" user "@" host ":" port path
			       "manage_main")))
	(apply dtml-browse-http-function
	       (list (concat "http://" user "@" host ":" port path)))))))

(defun dtml-edit-via-ftp (http)
  "Find the FTP file corresponding to the HTTP URL"
  (interactive "sHTTP URL: ")
  (let* ((urlobj (url-generic-parse-url http))
	 (http-port (url-port urlobj))
	 (ftp-port (if (not (equal http-port "80"))
		       (number-to-string
			(- (string-to-number http-port) 59)))))  
    (when (not (equal (url-type urlobj) "http"))
      (error "Expected HTTP URL"))
    (find-file (concat "/"
		       (if (url-user urlobj)
			   (concat (url-user urlobj) "@")
			 "")
		       (url-host urlobj)
		       (if ftp-port (concat "#" ftp-port) "")
		       ":" (url-filename urlobj)))))
	
;;; end of dtml-mode.el
