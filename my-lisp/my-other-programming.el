;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Cold Fusion stuff (includes general mark-up functions)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Wrap region with <cfoutput> tags
;; ;;
;; (defun cf-output (&optional hash) "<cfoutput>region</cfoutput>"
;;   (interactive "P")
;;   (save-excursion
;;     (if (< (point) (mark))
;;         (exchange-point-and-mark))
;;     (if (string= hash "#") (insert "#"))
;;     (insert "</cfoutput>")
;;     (exchange-point-and-mark)
;;     (insert "<cfoutput>")
;;     (if (string= hash "#") (insert "#"))))

;; (defun cf-output-hash () "<cfoutput>#region#</cfoutput>"
;;   (interactive)(cf-output "#"))


;; ;; Wrap region with specified tag
;; ;;
;; (defun cf-tag-region (tag)
;;   (interactive "sTag: ")
;;   (if (< (point) (mark))
;;       (exchange-point-and-mark))
;;   (insert (concat "</" tag ">"))
;;   (exchange-point-and-mark)
;;   (insert (concat "<" tag ">"))
;;   (backward-char))


;; ;; Function to wrap Cold Fusion code around a bare SQL query
;; ;;
;; (defun cf-sql-query-wrapper (&optional name db attr)
;;   "Wrap CF SQL Query code around the current paragraph"
;;   (if (string= db "") (setq db "vuw")) ; default database
;;   (interactive "sQuery Name: \nsDatabase: \nsFor CF_Module? ")
;;   (forward-word -1)
;;   (beginning-of-line)
;;   (re-search-backward "^[ \t]*$" nil t) ; 'backward-paragraph'
;; ; (set-marker start (point-marker))
;; ; (insert "[start]")
;;   (insert (concat
;;            "\n<cfquery\n NAME=\"" name "\" DATASOURCE=\"" db "\"\n"
;;            " USERNAME=\"#"))
;;   (if (string-match "[yY]" attr)
;;       (insert "attributes.usr#")
;;     (progn
;;       (insert db)
;;       (insert "_usr#\"")))
;;   (insert " PASSWORD=\"#")
;;   (if (string-match "[yY]" attr)
;;       (insert "attributes.pwd#")
;;     (progn
;;       (insert db)
;;       (insert "_pwd#\">")))
;;   (push-mark)
;;   (forward-word 1)
;;   (re-search-forward "^[ \t]*$" nil t) ; 'forward-paragraph'
;; ; (insert "[end]")
;;   (save-restriction
;;     (narrow-to-region (mark) (point))


;; ;   (point-min)
;; ;   (while (re-search-forward "\\(^\\|[ \t\n]+\\)\\(from\\|where\\|and\\|or\\|order by\\|values\\|set\\|join\\|on\\)\\( \\|$\\)" nil t)
;; ;
;; ; match-beginning
;; ; match-end
;; ;
;; ;     (replace))

;; ;(setq keywords (list "from" "where" "and" "or" "order by" "values" "set" "join" "on"))
;; ;   (point-min)
;; ;   (while (re-search-forward "" nil t)
;; ;
;; ; match-beginning
;; ; match-end
;; ;
;; ;     (replace))


;;     (exchange-point-and-mark);(insert "[min]")
;;     (push-mark)
;;     (while (re-search-forward "\\(^\\|[ \t\n]+\\)\\(from\\|where\\|and\\|or\\|order\\|values\\|set\\|join\\|on\\)\\( \\|$\\)" nil t)
;; ; (insert (concat "[found: '" (match-string 0) "']"))
;;       (setq found (match-data))
;; ;(insert (concat "'" found "'"))
;;       (if (string-match "\\(where\\|order\\)" (match-string 2))
;;           (progn
;;             (set-match-data found)
;;             (replace-match "\n \\2\\3"))

;;         (if (string-match "\\(from\\)" (match-string 2))
;;             (progn
;;               (set-match-data found)
;;               (replace-match "\n  \\2\\3"))

;;           (if (string-match "\\(and\\|set\\)" (match-string 2))
;;               (progn
;;                 (set-match-data found)
;;                 (replace-match "\n   \\2\\3"))

;;             (if (string-match "\\(or\\)" (match-string 2))
;;                 (progn
;;                   (set-match-data found)
;;                   (replace-match "\n    \\2\\3"))

;;               (if (string-match "\\(on\\)" (match-string 2))
;;                   (progn
;;                     (set-match-data found)
;;                     (replace-match "\n        \\2\\3")))))))))

;;   (re-search-forward "^[ \t]*$" nil t) ; 'forward-paragraph'
;;   (indent-rigidly (mark) (point) 2)
;;   (pop-mark)
;;   (pop-mark)
;;   (insert "</cfquery>\n"))


;; (defun cf-if ()
;;   (interactive)
;;   (let ((indent (current-column)))
;;     (insert "<cfif >")
;;     (insert-char " " indent)
;;     (insert "<cfelse>\n")
;;     (insert-char " " indent)
;;     (insert "</cfif>\n")
;;     (re-search-backward "<cfif " nil t)
;;     (end-of-line)
;;     (backward-char)))



;; ;; Cold Fusion key-bindings (with C-c C-f prefix)
;; ;;
;; (define-prefix-command 'ColdFusion-Prefix nil "Cold Fusion")
;; (global-set-key "\C-c\C-f" 'ColdFusion-Prefix)
;; (define-key ColdFusion-Prefix "q" 'cf-sql-query-wrapper)
;; (define-key ColdFusion-Prefix "o" 'cf-output)
;; (define-key ColdFusion-Prefix "\C-o" 'cf-output-hash)
;; (define-key ColdFusion-Prefix "t" 'cf-tag-region)
;; (define-key ColdFusion-Prefix "if" 'cf-if)




;; ;; MindRover ICE key-bindings (with C-x m prefix)
;; ;
;; ;(define-prefix-command 'ICE-Prefix nil "MindRover ICE")
;; ;(global-set-key "\C-xm" 'ICE-Prefix)
;; ;(define-key ICE-Prefix "c" 'ice-compile)
;; ;(define-key ICE-Prefix "f" 'ice-format)

;; (defun require-ice-mode ()
;;   (if (string-match ".ice$" buffer-file-name)
;;       (progn (require 'ice "ice-mode") (ice-mode))))
;; (add-hook 'find-file-hook 'require-ice-mode)


;; (provide 'my-other-programming)
