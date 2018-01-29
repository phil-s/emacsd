;; Silence compiler warnings
(eval-when-compile
  (defvar el-get-sources)
  )

(defun my-local-repository-url-for (library)
  "Provide a URL for a library in the local-repository directory."
  (concat "file://" (expand-file-name user-emacs-directory)
          "local-repository/" library ".el"))

(defun my-el-get ()
  "Define custom sources and call el-get."
  (interactive)

  ;; Define external sources
  (setq
   el-get-sources
   `((:name async
            :type git
            :url "git@github.com:jwiegley/emacs-async.git")

     (:name el-get
            :type git
            :url "git://github.com/dimitri/el-get.git")

     (:name ace-link
            :depends (ace-jump-mode noflet)
            :type git
            :url "https://github.com/abo-abo/ace-link.git"
            :post-init (ace-link-setup-default))

     (:name ace-jump-mode
            :type git
            :url "https://github.com/winterTTr/ace-jump-mode/")

     ;; ;; support ack as a replacement for rgrep
     ;; (:name ack
     ;;        :type http
     ;;        :url "http://repo.or.cz/w/ShellArchive.git?a=blob_plain&hb=HEAD&f=ack.el"
     ;;        :features ack)

     ;; (:name asciidoc
     ;;        :type elpa)

     (:name auto-compile
            :depends packed
            :type git
            :url "https://github.com/tarsius/auto-compile")

     (:name avy
            :type git
            :url "https://github.com/abo-abo/avy.git")

     (:name browse-kill-ring
            :type http
            :url "https://www.emacswiki.org/emacs/download/browse-kill-ring.el"
            :features browse-kill-ring)

     (:name dash
            :type git
            :url "git://github.com/magnars/dash.el.git")

     (:name deft
            :type git
            :url "git://jblevins.org/git/deft.git")

     (:name delight
            :type git
            :url "git://git.savannah.nongnu.org/delight.git")

     ;; (:name dictionary-el
     ;;        :type apt-get)

     (:name diff-hl
            :type git
            :url "git@github.com:dgutov/diff-hl.git")

     (:name dired-details
            :type emacswiki)

     (:name dtrt-indent
            :type git
            :url "git://git.sv.gnu.org/dtrt-indent.git"
            :features dtrt-indent)

     (:name ediff-binary-hexl
            :type http
            :url ,(my-local-repository-url-for "ediff-binary-hexl"))

     (:name ediff-trees
            :type emacswiki)

     (:name elisp-slime-nav
            :type git
            :url "https://github.com/purcell/elisp-slime-nav.git")

     (:name escreen)

     ;; (:name espect
     ;;        :type http
     ;;        :url "https://github.com/rafl/espect/raw/master/espect.el")

     ;; highlight FIXME TODO BUG and KLUDGE in comments and strings
     (:name fic-mode
            :type http
            :url ,(my-local-repository-url-for "fic-mode")
            :features fic-mode)

     (:name find-file-in-tags
            :type emacswiki)

     (:name ffip
            :type git
            :url "git://github.com/technomancy/find-file-in-project.git")

     (:name font-lock-studio
            :type git
            :url "git@github.com:Lindydancer/font-lock-studio.git")

     (:name geben
            :type git
            :url "https://github.com/ahungry/geben.git")

     (:name git-modes
            :type git
            :branch "master"
            :url "git://github.com/magit/git-modes.git")

     (:name gpicker
            :type http
            :url "http://git.savannah.gnu.org/cgit/gpicker.git/plain/gpicker.el"
            :post-init (lambda ()
                         (autoload 'gpicker-visit-project "gpicker" nil t)
                         (autoload 'gpicker-find-file "gpicker" nil t)))

     (:name htmlr
            :type emacswiki)

     (:name ibuffer-vc
            :type git
            :url "git://github.com/purcell/ibuffer-vc.git")

     (:name idle-highlight-mode
            :type git
            :url "https://github.com/nonsequitur/idle-highlight-mode.git")

     (:name iedit)

     (:name image-dimensions-minor-mode
            :type http
            :url ,(my-local-repository-url-for "image-dimensions-minor-mode"))

     (:name jump-char
            :type git
            :url "https://github.com/lewang/jump-char")

     (:name keep-buffers
            :type http
            :url "https://raw.github.com/lewang/le_emacs_libs/master/keep-buffers.el"
            :features keep-buffers)

     (:name key-chord)

     (:name lexbind-mode
            :type git
            :url "git://github.com/spacebat/lexbind-mode.git")

     (:name macrostep
            :type git
            :url "https://github.com/joddie/macrostep.git")

     (:name magit
            :type git
            :url "git://github.com/magit/magit.git"
            :branch "master" ;; bleeding edge
            ;; :branch "2.6.2" ;; install a specific release
            :load-path ("lisp")
            :build ("make") ;; builds documentation.
            ;; :build ("make lisp") ;; just the code; fewer dependencies.
            :depends (async dash git-modes))

     (:name mo-git-blame)

     (:name multiple-cursors
            :type git
            :url "https://github.com/magnars/multiple-cursors.el.git"
            :features multiple-cursors)

     (:name noflet
            :type git
            :url "https://github.com/nicferrier/emacs-noflet.git")

     (:name notify)

     (:name outline-copy-visible
            :type http
            :url "http://gist.github.com/raw/519635/yank-visible.el"
            :loads "outline-copy-visible")

     (:name packed
            :type git
            :url "https://github.com/tarsius/packed")

     (:name php-mode
            :type git
            :url "git://github.com/ejmr/php-mode.git")

     (:name php-eldoc
            :type git
            :url "git://github.com/zenozeng/php-eldoc.git")

     (:name psvn
            :type http
            :url "http://www.xsteve.at/prg/emacs/psvn.el")

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

     (:name smart-tabs-mode
            :type git
            :url "git@github.com:jcsalomon/smarttabs.git")

     (:name transpose-frame
            :type emacswiki
            :features transpose-frame)

     (:name windcycle
            :type http
            :url ,(my-local-repository-url-for "windcycle")
            :features windcycle)

     (:name unbound
            :type emacswiki)

     (:name undo-tree)

     (:name vcl-mode
            :type http
            :url ,(my-local-repository-url-for "vcl-mode"))

     (:name web-mode
            :type git
            :url "https://github.com/fxbois/web-mode.git")

     (:name wgrep
            :type git
            :url "https://github.com/mhayashi1120/Emacs-wgrep.git")

     (:name which-key
            :type git
            :url "https://github.com/justbur/emacs-which-key")

     (:name winnow
            :type git
            :url "https://github.com/dgtized/winnow.el.git")

     (:name with-editor
            :type git
            :url "https://github.com/magit/with-editor.git")

     (:name ws-trim
            :type ftp
            :url "ftp://ftp.lysator.liu.se/pub/emacs/ws-trim.el")

     ;; (:name yasnippet
     ;;        :type git-svn
     ;;        :url "http://yasnippet.googlecode.com/svn/trunk/")

     (:name zenburn-theme
            :type git
            :url "https://github.com/bbatsov/zenburn-emacs")

     (:name ztree-diff
            :type git
            :url "https://github.com/fourier/ztree.git")

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
     (let ((el-get-install-branch "3.stable"))
       (end-of-buffer)
       (eval-print-last-sexp)
       ;; Now configure my custom sources. We need to do this here in the
       ;; lambda expression callback, because it is called asynchronously
       ;; whenever the url-retrieve completes, and we need to ensure that
       ;; has happened.
       (my-el-get)))))


;;;;(require 'el-get)
(unless (functionp 'el-get)
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
