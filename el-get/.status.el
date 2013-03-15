((browse-kill-ring status "installed" recipe
				   (:name browse-kill-ring :type http :url "http://www.emacswiki.org/emacs/download/browse-kill-ring.el" :features browse-kill-ring))
 (deft status "installed" recipe
   (:name deft :type git :url "git://jblevins.org/git/deft.git"))
 (dired-details status "installed" recipe
				(:name dired-details :type emacswiki))
 (dtrt-indent status "installed" recipe
			  (:name dtrt-indent :type git :url "git://git.sv.gnu.org/dtrt-indent.git" :features dtrt-indent))
 (ediff-binary-hexl status "installed" recipe
					(:name ediff-binary-hexl :type http :url "file:///home/phil/.emacs.d/local-repository/ediff-binary-hexl.el"))
 (ediff-trees status "installed" recipe
			  (:name ediff-trees :type emacswiki))
 (el-get status "installed" recipe
		 (:name el-get :type git :url "git://github.com/dimitri/el-get.git"))
 (escreen status "installed" recipe
		  (:name escreen :description "Emacs window session manager" :type http :url "http://www.splode.com/~friedman/software/emacs-lisp/src/escreen.el" :prepare
				 (autoload 'escreen-install "escreen" nil t)))
 (ffip status "installed" recipe
	   (:name ffip :type git :url "git://github.com/dburger/find-file-in-project.git" :post-init
			  (autoload 'ffip-project-root "find-file-in-project" nil t)))
 (fic-mode status "installed" recipe
		   (:name fic-mode :type http :url "http://www.emacswiki.org/emacs/download/fic-mode.el" :features fic-mode))
 (find-file-in-project status "removed" recipe nil)
 (find-file-in-tags status "installed" recipe
					(:name find-file-in-tags :type emacswiki))
 (geben status "installed" recipe
		(:name geben :type http-tar :options
			   ("zxf")
			   :url "http://geben-on-emacs.googlecode.com/files/geben-0.26.tar.gz"))
 (gpicker status "installed" recipe
		  (:name gpicker :type http :url "http://git.savannah.gnu.org/cgit/gpicker.git/plain/gpicker.el" :post-init
				 (progn
				   (autoload 'gpicker-visit-project "gpicker" nil t)
				   (autoload 'gpicker-find-file "gpicker" nil t))))
 (htmlr status "installed" recipe
		(:name htmlr :type emacswiki))
 (iedit status "installed" recipe
		(:name iedit :description "Edit multiple regions with the same content simultaneously." :type emacswiki :features iedit))
 (keep-buffers status "installed" recipe
			   (:name keep-buffers :type http :url "https://raw.github.com/lewang/le_emacs_libs/master/keep-buffers.el" :features keep-buffers))
 (magit status "installed" recipe
		(:name magit :website "https://github.com/magit/magit#readme" :description "It's Magit! An Emacs mode for Git." :type github :pkgname "magit/magit" :info "." :autoloads
			   ("50magit")
			   :build
			   (("make" "all"))
			   :build/darwin
			   `(,(concat "make EMACS=" el-get-emacs " all"))))
 (mo-git-blame status "installed" recipe
			   (:name mo-git-blame :description "An interactive, iterative 'git blame' mode for Emacs" :type github :pkgname "mbunkus/mo-git-blame" :features "mo-git-blame"))
 (multiple-cursors status "installed" recipe
				   (:name multiple-cursors :type git :url "https://github.com/magnars/multiple-cursors.el.git" :features multiple-cursors))
 (notify status "installed" recipe
		 (:name notify :description "Notification front-end" :type emacswiki :features notify))
 (outline-copy-visible status "installed" recipe
					   (:name outline-copy-visible :type http :url "http://gist.github.com/raw/519635/yank-visible.el" :loads "outline-copy-visible"))
 (package status "installed" recipe
		  (:name package :description "ELPA implementation (\"package.el\") from Emacs 24" :builtin 24 :type http :url "http://repo.or.cz/w/emacs.git/blob_plain/1a0a666f941c99882093d7bd08ced15033bc3f0c:/lisp/emacs-lisp/package.el" :shallow nil :features package :post-init
				 (progn
				   (setq package-user-dir
						 (expand-file-name
						  (convert-standard-filename
						   (concat
							(file-name-as-directory default-directory)
							"elpa")))
						 package-directory-list
						 (list
						  (file-name-as-directory package-user-dir)
						  "/usr/share/emacs/site-lisp/elpa/"))
				   (make-directory package-user-dir t)
				   (unless
					   (boundp 'package-subdirectory-regexp)
					 (defconst package-subdirectory-regexp "^\\([^.].*\\)-\\([0-9]+\\(?:[.][0-9]+\\)*\\)$" "Regular expression matching the name of\n a package subdirectory. The first subexpression is the package\n name. The second subexpression is the version string."))
				   (setq package-archives
						 '(("ELPA" . "http://tromey.com/elpa/")
						   ("gnu" . "http://elpa.gnu.org/packages/")
						   ("marmalade" . "http://marmalade-repo.org/packages/")
						   ("SC" . "http://joseito.republika.pl/sunrise-commander/"))))))
 (php-mode status "installed" recipe
		   (:name php-mode :type git :url "git://github.com/ejmr/php-mode.git"))
 (psvn status "installed" recipe
	   (:name psvn :type http :url "http://www.xsteve.at/prg/emacs/psvn.el"))
 (rainbow-delimiters status "installed" recipe
					 (:name rainbow-delimiters :website "https://github.com/jlr/rainbow-delimiters#readme" :description "Color nested parentheses, brackets, and braces according to their depth." :type github :pkgname "jlr/rainbow-delimiters" :features rainbow-delimiters))
 (rainbow-mode status "installed" recipe
			   (:name rainbow-mode :description "Colorize color names in buffers" :type elpa))
 (sauron status "installed" recipe
		 (:name sauron :type git :url "git://github.com/djcb/sauron.git" :features sauron))
 (scratch status "installed" recipe
		  (:name scratch :type git :url "http://github.com/ieure/scratch-el.git" :post-init
				 (autoload 'scratch "scratch" nil t)))
 (second-sel status "installed" recipe
			 (:name second-sel :type emacswiki))
 (transpose-frame status "installed" recipe
				  (:name transpose-frame :type emacswiki :features transpose-frame))
 (unbound status "installed" recipe
		  (:name unbound :type emacswiki))
 (undo-tree status "installed" recipe
			(:name undo-tree :description "Treat undo history as a tree" :type git :url "http://www.dr-qubit.org/git/undo-tree.git" :prepare
				   (progn
					 (autoload 'undo-tree-mode "undo-tree.el" "Undo tree mode; see undo-tree.el for details" t)
					 (autoload 'global-undo-tree-mode "undo-tree.el" "Global undo tree mode" t))))
 (vcl-mode status "installed" recipe
		   (:name vcl-mode :type http :url "file:///home/phil/.emacs.d/local-repository/vcl-mode.el"))
 (web-mode status "installed" recipe
		   (:name web-mode :type git :url "https://github.com/fxbois/web-mode.git"))
 (wgrep status "installed" recipe
		(:name wgrep :type git :url "https://github.com/mhayashi1120/Emacs-wgrep.git"))
 (windcycle status "installed" recipe
			(:name windcycle :type http :url "file:///home/phil/.emacs.d/local-repository/windcycle.el" :features windcycle))
 (ws-trim status "installed" recipe
		  (:name ws-trim :type ftp :url "ftp://ftp.lysator.liu.se/pub/emacs/ws-trim.el"))
 (zenburn-theme status "installed" recipe
				(:name zenburn-theme :type git :url "https://github.com/bbatsov/zenburn-emacs")))
