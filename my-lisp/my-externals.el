(defun my-el-get ()
  "Define custom sources and call el-get."
  (interactive)

  ;; Define external sources
  (setq
   el-get-sources
   '((:name el-get
            :type git
            :url "git://github.com/dimitri/el-get.git")

     ;; ;; support ack as a replacement for rgrep
     ;; (:name ack
     ;;        :type http
     ;;        :url "http://repo.or.cz/w/ShellArchive.git?a=blob_plain&hb=HEAD&f=ack.el"
     ;;        :features ack)

     ;; (:name asciidoc
     ;;        :type elpa)

     (:name browse-kill-ring
            :type http
            :url "http://www.emacswiki.org/emacs/download/browse-kill-ring.el"
            :features browse-kill-ring)

     (:name color-theme)
     (:name color-theme-zenburn)

     (:name deft
            :type git
            :url "git://jblevins.org/git/deft.git")

     ;; (:name dictionary-el
     ;;        :type apt-get)

     (:name dired-details
            :type emacswiki)

     (:name dtrt-indent
            :type git
            :url "git://git.sv.gnu.org/dtrt-indent.git"
            :features dtrt-indent)

     (:name ediff-binary-hexl
            :type http
            :url "file:///home/phil/.emacs.d/local-repository/ediff-binary-hexl.el")

     (:name ediff-trees
            :type emacswiki)

     (:name escreen)

     ;; (:name espect
     ;;        :type http
     ;;        :url "https://github.com/rafl/espect/raw/master/espect.el")

     ;; highlight FIXME TODO BUG and KLUDGE in comments and strings
     (:name fic-mode
            :type http
            :url "http://www.emacswiki.org/emacs/download/fic-mode.el"
            :features fic-mode)

     (:name find-file-in-tags
            :type emacswiki)

     (:name ffip
            :type git
            :url "git://github.com/dburger/find-file-in-project.git"
            :post-init (lambda ()
                         (autoload 'ffip-project-root "find-file-in-project" nil t)))

     ;; (:name find-file-in-project
     ;;        :type git
     ;;        :url "git://github.com/bbatsov/find-file-in-project.git")

     (:name geben
            :type http-tar
            :options ("zxf")
            :url "http://geben-on-emacs.googlecode.com/files/geben-0.26.tar.gz")

     (:name gpicker
            :type http
            :url "http://git.savannah.gnu.org/cgit/gpicker.git/plain/gpicker.el"
            :post-init (lambda ()
                         (autoload 'gpicker-visit-project "gpicker" nil t)
                         (autoload 'gpicker-find-file "gpicker" nil t)))

     (:name htmlr
            :type emacswiki)

     (:name iedit)

     (:name keep-buffers
            :type http
            :url "https://raw.github.com/lewang/le_emacs_libs/master/keep-buffers.el"
            :features keep-buffers)

     (:name magit)

     (:name multiple-cursors
            :type git
            :url "https://github.com/magnars/multiple-cursors.el.git"
            :features multiple-cursors)

     (:name mo-git-blame)

     (:name notify)

     (:name outline-copy-visible
            :type http
            :url "http://gist.github.com/raw/519635/yank-visible.el"
            :loads "outline-copy-visible")

     (:name php-mode
            :type git
            :url "git://github.com/ejmr/php-mode.git")

     (:name psvn
            :type http
            :url "http://www.xsteve.at/prg/emacs/psvn.el")

     (:name rainbow-delimiters)

     (:name rainbow-mode)

     (:name sauron
            :type git
            :url "git://github.com/djcb/sauron.git"
            :features sauron)

     (:name scratch
            :type git
            :url "http://github.com/ieure/scratch-el.git"
            :post-init (lambda () (autoload 'scratch "scratch" nil t)))

     (:name second-sel
            :type emacswiki)

     (:name transpose-frame
            :type emacswiki
            :features transpose-frame)

     (:name windcycle
            :type http
            :url "file:///home/phil/.emacs.d/local-repository/windcycle.el"
            :features windcycle)

     (:name unfill
            :type git
            :url "https://github.com/purcell/unfill.git")

     (:name undo-tree)

     (:name vcl-mode
            :type http
            :url "file:///home/phil/.emacs.d/local-repository/vcl-mode.el")

     (:name web-mode
            :type git
            :url "https://github.com/fxbois/web-mode.git")

     (:name wgrep
            :type git
            :url "https://github.com/mhayashi1120/Emacs-wgrep.git")

     (:name ws-trim
            :type ftp
            :url "ftp://ftp.lysator.liu.se/pub/emacs/ws-trim.el")

     ;; (:name yasnippet
     ;;        :type git-svn
     ;;        :url "http://yasnippet.googlecode.com/svn/trunk/")

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
      (el-get 'wait)))


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
(when (not (functionp 'el-get))
  (let ((el-get (expand-file-name (concat user-emacs-directory
                                          "el-get/el-get/el-get.el"))))
    (if (file-exists-p el-get)
        (load el-get))))

;; Install first if necessary, otherwise just execute.
(if (not (functionp 'el-get))
    (install-el-get) ;; also calls (my-el-get)
  (my-el-get))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-externals)
