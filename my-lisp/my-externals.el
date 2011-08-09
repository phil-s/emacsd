(defun my-el-get ()
  "Define custom sources and call el-get."
  (interactive)

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

     (:name ediff-trees
            :type emacswiki)

     (:name rainbow-mode)

     (:name transpose-frame
            :type emacswiki
            :features transpose-frame)

     ;; ;; support ack as a replacement for rgrep
     ;; (:name ack
     ;;        :type http
     ;;        :url "http://repo.or.cz/w/ShellArchive.git?a=blob_plain&hb=HEAD&f=ack.el"
     ;;        :features ack)

     ;; (:name espect
     ;;        :type http
     ;;        :url "https://github.com/rafl/espect/raw/master/espect.el")

     ;; (:name ws-trim
     ;;        :type ftp
     ;;        :url "ftp://ftp.lysator.liu.se/pub/emacs/ws-trim.el")

     (:name color-theme)
     (:name color-theme-zenburn)

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


     ;; Colour readability tool.
     ;; Available by default in Emacs 24, so would need to restrict
     ;; this to versions less than that.
     ;; http://git.gnus.org/cgit/gnus.git/plain/lisp/color.el
     ;; http://git.gnus.org/cgit/gnus.git/plain/lisp/shr-color.el
     ;; (shr-color-visible "#ff0000" "#ff0000")
     ;; ("#ff603a" "#ba0000")
     ;; (shr-color-visible "#ff0000" "#ff0000" t)
     ;; ("#ff0000" "#7c0000")
     ))

  ;; Execute el-get
  (if (functionp 'el-get)
      (el-get)))


;; Modification of the *scratch* Installer from
;; https://github.com/dimitri/el-get/
(defun install-el-get ()
  "So the idea is that you copy/paste this code into your
*scratch* buffer, hit C-j, and you have a working el-get."
  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp)
     ;; Now configure my custom sources. We need to do this here in the
     ;; lambda expression callback, because it is called asynchronously
     ;; whenever the url-retrieve completes, and we need to ensure that
     ;; has happened.
     (my-el-get))))


;;;;(require 'el-get)
(if (not (functionp 'el-get))
    (let ((el-get
           (expand-file-name (concat
                              user-emacs-directory
                              "el-get/el-get/el-get.el"))))
      (if (file-exists-p el-get)
          (load el-get))))


;; Install first if necessary, otherwise just execute.
(if (not (functionp 'el-get))
    (install-el-get) ;; also calls (my-el-get)
  (my-el-get))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-externals)
