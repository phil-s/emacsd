;; Require this library for NT Emacs only, using the following:

;;;; Win32 / Cygwin
;;(when (eq system-type 'windows-nt)
;;  (require 'my-win32))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Win32 basics
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; We can't use --daemon with NTEmacs, so start a server here.
(server-start)

;; Use Unix-style line endings.
(setq-default buffer-file-coding-system 'undecided-unix)

;; Disable startup warning when using "system" shells.
;;(setq w32-allow-system-shell nil)

;; Handle windows shortcuts
(setq w32-symlinks-handle-shortcuts t)
(require 'w32-symlinks)

;; Make the emacs source files read-only
(dir-locals-set-class-variables 'read-only '((nil (buffer-read-only . t))))
(dir-locals-set-directory-class (getenv "emacs_dir") 'read-only)

(defadvice server-create-window-system-frame
  (after my-after-server-create-window-system-frame)
  "Attempt to raise new client frames."

  ;; (This doesn't actually help, AFAICT)

  ;; See 3.10 (Window operations) in the GNU Emacs FAQ for MS Windows:
  ;; http://www.gnu.org/software/emacs/windows/
  ;;
  ;; "The function w32-send-sys-command can be used to simulate
  ;; choosing commands from the system menu (in the top left corner of
  ;; the Window) and a few other system wide functions. It takes an
  ;; integer argument, the value of which should be a valid
  ;; WM_SYSCOMMAND message as documented in Microsoft's API
  ;; documentation."

  ;; See the following for WM_SYSCOMMAND values:
  ;; http://msdn.microsoft.com/en-us/library/ms646360%28VS.85%29.aspx

  ;; SC_MAXIMIZE (0xF030)
  ;; Maximizes the window.
  (w32-send-sys-command ?\xf030)
  ;; SC_HOTKEY (0xF150)
  ;; Activates the window associated with the application-specified
  ;; hot key. The lParam parameter identifies the window to activate.
  (w32-send-sys-command ?\xf150)
  )
(ad-activate 'server-create-window-system-frame)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cygwin integration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defcustom my-cygwin-root "c:/cygwin"
  "Cygwin directory"
  :type 'string
  :group 'cygwin-mount)

;; IMPORTANT: This assumes that you have launched Emacs via Cygwin
;; itself, using the following Windows shortcut target. Emacs will
;; then inherit the Cygwin environment, including the exec-path,
;; and any current ssh-agent details (important for using TRAMP;
;; note that your bash profile should initialise ssh-agent in this
;; situation.)
;;
;; C:\cygwin\bin\bash.exe --login -c "env HOME=\"`cygpath '%APPDATA%'`\" /cygdrive/c/emacs/emacs-23.1/bin/runemacs.exe"

(let* ((cygwin-bin (concat my-cygwin-root "/bin"))
       (escaped-cygwin-bin (replace-regexp-in-string "/" "\\\\" cygwin-bin)))

  ;; If my-cygwin-root exists, and we have cygwin-bin in our PATH then
  ;; initialise cygwin support. (The implication is that emacs was
  ;; launched from within cygwin.)
  (when (and (member (downcase escaped-cygwin-bin)
                     (split-string (downcase (getenv "PATH")) ";"))
             (file-readable-p my-cygwin-root))

    ;; Initialise cygwin-mount package
    ;; Set the bin directory (not necessary with it already
    ;; in the exec-path, but it's more efficient to do so)
    (setq cygwin-mount-cygwin-bin-directory cygwin-bin)
    (require 'cygwin-mount)
    (cygwin-mount-activate)

    ;; NT-emacs assumes a Windows shell. Change to bash.
    (setq shell-file-name "bash")
    (setenv "SHELL" shell-file-name)
    (setq explicit-shell-file-name shell-file-name)

    ;; Ediff
    (setq ediff-diff-program (concat cygwin-bin "/diff"))
    (setq ediff-diff3-program (concat cygwin-bin "/diff3"))
    (setq ediff-patch-program (concat cygwin-bin "/patch"))

    ;; Remove C-m () characters that appear in output
    (add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)

    ;; Prevent issues with NUL when rgrepping.
    ;; We use cygwin find, so the null device should be "/dev/null"
    ;; rather than the Windows null device "NUL"
    (defadvice grep-compute-defaults (around grep-compute-defaults-advice-null-device)
      "Use cygwin's /dev/null as the null-device."
      (let ((null-device "/dev/null"))
        ad-do-it))
    (ad-activate 'grep-compute-defaults)

    ;; Prefer woman to man (Cygwin man is a bit funky)
    (defun man ()
      "Convert man to woman"
      (interactive)
      (woman))

    ;; TRAMP mode with Cygwin prefers the sshx method
    (setq tramp-default-method "sshx")
    ;;
    ;; TRAMP works best with ssh-agent handling authentication.
    ;; ssh-agent initialisation can be performed in .bash_profile
    ;; with the following script (n.b. this sets a four-hour (14400
    ;; second) timeout on the agent authentication. This approach
    ;; ties into the above recommendation of launching NT Emacs
    ;; from Cygwin.
    ;;
    ;; # Run ssh-agent, if one is not already running
    ;; function start_agent {
    ;;     echo "Initialising new SSH agent..."
    ;;     /usr/bin/ssh-agent -t 14400 | sed 's/^echo/#echo/' > "${SSH_ENV}"
    ;;     echo succeeded
    ;;     chmod 600 "${SSH_ENV}"
    ;;     . "${SSH_ENV}" >/dev/null
    ;;     /usr/bin/ssh-add;
    ;; }
    ;;
    ;; # Source SSH settings, if applicable
    ;; if [ -f "${SSH_ENV}" ]; then
    ;;     . "${SSH_ENV}" >/dev/null
    ;;     #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ;;     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ >/dev/null || {
    ;;         start_agent;
    ;;     }
    ;;     #if our ssh-added identity has expired (see -t option to ssh-agent)
    ;;     #then we need to re-add it
    ;;     if ! /usr/bin/ssh-add -l >/dev/null; then
    ;;         /usr/bin/ssh-add;
    ;;     fi
    ;; else
    ;;     #no ssh-agent running at the moment
    ;;     start_agent;
    ;; fi

    )) ;; End of Cygwin integration



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Miscellaneous
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; My hacky way of opening temporary files from 7-zip's archive browser...
;; Changes URLs like file:C%3a/foo into c:/foo (such URLs can be generated when
;; dragging and dropping temporary files), and then passes it on to the proper
;; function for handling.
;; See variable dnd-protocol-alist for how this function is called.
;; (Sometime it works, sometimes it doesn't. If you keep trying, it will open
;; eventually. Good enough for now.)
(defun dnd-open-local-file-fix-url (uri action)
  "Open a local windows file with an encoded slash after the drive letter. See var dnd-protocol-alist"
  (dnd-open-local-file
   (replace-regexp-in-string "\([A-Za-z]\)%3a" ",\(concat (downcase \1) ':')" uri)
   action))


;; (load "w32-utl")


;; Anti-Word

(add-to-list 'auto-mode-alist '("\\.doc\\'" . no-word))
(defun no-word ()
  "Run antiword on the entire buffer."
  (interactive)
  (let* ((no-word-coding (completing-read
                          "Select coding: (default iso-8859-1) "
                          no-word-coding-systems
                          nil t nil nil "iso-8859-1"))
         (map-file (cdr (assoc no-word-coding no-word-coding-systems)))
         (coding-system-for-read (intern no-word-coding))
         (new_name (concat "*" (buffer-name) "*")))
    (save-window-excursion
      (shell-command-on-region (point-min) (point-max) (format "antiword -m %s -"  map-file) new_name)
      (kill-buffer (current-buffer)))
    (switch-to-buffer new_name)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'my-win32)



;; Emacs can be used as the editor for Firefox by using the "It's All Text"
;; extension ( https://addons.mozilla.org/en-US/firefox/addon/4125/ ), and
;; the following three scripts:
;;
;; runemacsclient.bat
;; emacsclient.bat
;; emacsclient.sh
;;
;; Point the extension at runemacsclient.bat for the editor. (This may need
;; to be done using the Firefox about:config screen, as the default browser
;; does not enable batch files to be selected.)

;; REM runemacsclient.bat:
;; REM - Call the shell script.
;; REM - Uses Cygwin's run.exe to run a Windows program
;; REM - without leaving the cmd window open.
;;
;; @echo off
;; C:\cygwin\bin\run.exe C:\cygwin\home\Phil\bin\emacsclient.bat %1 %2 %3 %4 %5 %6 %7 %8 %9

;; REM emacsclient.bat:
;; REM - Run the shell script
;;
;; @echo off
;; C:\cygwin\bin\bash.exe -c '/home/Phil/bin/emacsclient.sh %1 %2 %3 %4 %5 %6 %7 %8 %9'

;; # emacsclient.sh:
;; # Either start a new client, or run a new server.
;; # n.b. does not --login, and so bypasses the bash_profile,
;; # to avoid potentially hanging on a hidden ssh-add
;;
;; #!/bin/bash
;; PATH="~/bin:$PATH:/usr/bin"
;; PATH="`ls -1d /cygdrive/c/emacs/emacs-*/bin | tail -1`:$PATH"
;;
;; # Try emacsclient first
;; emacsclient -display --create-frame "$@"
;;
;; # If that failed, start a new server
;; if test $? -eq 1; then
;; 	# Quote the args with escaped double-quotes, for insertion
;; 	# in command string
;; 	args=""
;; 	for arg in "$@"; do
;; 		args="$args \"$arg\"";
;; 	done
;; 	# Execute command
;; 	bash -c " \
;; 		env HOME=\"`cygpath \"$APPDATA\"`\" \
;; 			emacs --eval \"(server-start)\" $args \
;; 	";
;; fi


;; NOTE:
;; The following *may* provide for a simpler approach:
;; Starting Server With Emacs 23 : Easy Way
;; http://www.emacswiki.org/emacs/EmacsClient#toc2
;; It didn't work immediately, however, so I didn't pursue it.

