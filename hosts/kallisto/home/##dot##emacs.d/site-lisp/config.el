;; site-lisp/config.el -*- lexical-binding: t; -*-

;;
;;; UI

;; Set font
(setq zenit-font (font-spec :family "Aporetic Serif Mono" :size 16 :weight 'regular)
      zenit-variable-pitch-font (font-spec :family "Aporetic Serif"))

;;; Set theme
;; (setq zenit-theme 'doom-one)
(setq zenit-theme 'modus-operandi)


;;
;;; Modules

;; :editor evil
;; Switch to the new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; :emacs org
(setq org-directory "~/Projekte/org/")

;; :lang ess
;; Mark flycheck lintr settings as safe
(after! ess
  (put 'flycheck-lintr-linters 'safe-local-variable #'stringp))

;; :checkers grammar
(after! langtool
  (setq langtool-java-classpath
        "/usr/share/languagetool:/usr/share/java/languagetool/*"))
