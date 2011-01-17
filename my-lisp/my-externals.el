;; Copy of the *scratch* Installer
(defun install-el-get ()
  "So the idea is that you copy/paste this code into your *scratch* buffer, hit C-j, and you have a working el-get."
  (let* ((el-get-dir        (expand-file-name "~/.emacs.d/el-get/"))
         (dummy             (unless (file-directory-p el-get-dir)
                              (make-directory el-get-dir t)))
         (package           "el-get")
         (bname             "*el-get bootstrap*") ; both process and buffer name
         (pdir              (concat (file-name-as-directory el-get-dir) package))
         (git               (or (executable-find "git") (error "Unable to find `git'")))
         (url               "git://github.com/dimitri/el-get.git")
         (el-get-sources    `((:name ,package :type "git" :url ,url :features el-get :compile "el-get.el")))
         (default-directory el-get-dir)
         (process-connection-type nil) ; pipe, no pty (--no-progress)
         (clone             (start-process bname bname git "--no-pager" "clone" "-v" url package)))
    (set-window-buffer (selected-window) (process-buffer clone))
    (set-process-sentinel
     clone
     `(lambda (proc change)
        (when (eq (process-status proc) 'exit)
          (setq default-directory (file-name-as-directory ,pdir))
          (setq el-get-sources ',el-get-sources)
          (load (concat (file-name-as-directory ,pdir) ,package ".el"))
          (el-get-init "el-get")
          (with-current-buffer (process-buffer proc)
            (goto-char (point-max))
            (insert "\nCongrats, el-get is installed and ready to serve!"))))))
  )

;;;;(require 'el-get)
(if (not (functionp 'el-get))
    (let ((el-get
           (expand-file-name (concat
                              user-emacs-directory
                              "el-get/el-get/el-get.el"))))
      (if (file-exists-p el-get)
          (load el-get))))

;; Install, if necessary
(if (not (functionp 'el-get))
    (install-el-get))

;; Define external sources
(setq
 el-get-sources
 '(
   (:name el-get
          :type git
          :url "git://github.com/dimitri/el-get.git")

   (:name browse-kill-ring
          :type http
          :url "http://www.emacswiki.org/emacs/download/browse-kill-ring.el"
          :features browse-kill-ring)

   (:name outline-copy-visible
          :type http
          :url "http://gist.github.com/raw/519635/yank-visible.el"
          :loads "outline-copy-visible")

   (:name scratch
          :type http
          ;;:url "git@github.com:cbbrowne/scratch-el.git/master/scratch.el")
          :url "http://github.com/ieure/scratch-el/raw/master/scratch.el"
          :features scratch)

   (:name dtrt-indent
          :type git
          :url "git://git.sv.gnu.org/dtrt-indent.git"
          :features dtrt-indent)

   ;; highlight FIXME TODO BUG and KLUDGE in comments and strings
   (:name fic-mode
          :type http
          :url "http://www.emacswiki.org/emacs/download/fic-mode.el"
          :features fic-mode)

   ;; (:name ws-trim
   ;;        :type http
   ;;        :url "ftp://ftp.lysator.liu.se/pub/emacs/ws-trim.el")

   ;; (:name color-theme
   ;;        :type http
   ;;        :url "http://download.savannah.nongnu.org/releases/color-theme/"
   ;;        :features color-theme)

   ;; (:name magit
   ;;        :type git
   ;;        :url "http://github.com/philjackson/magit.git"
   ;;        :info "."
   ;;        :build ("./autogen.sh" "./configure" "make"))

   ;; (:name yasnippet
   ;;        :type git-svn
   ;;        :url "http://yasnippet.googlecode.com/svn/trunk/")

   ;; (:name asciidoc         :type elpa)
   ;; (:name dictionary-el    :type apt-get)
   ))

;; Execute el-get
(if (functionp 'el-get)
    (el-get))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-externals)
