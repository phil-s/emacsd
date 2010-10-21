(require 'el-get)

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

(el-get)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-externals)
