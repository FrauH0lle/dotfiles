;; site-lisp/config.el -*- lexical-binding: t; -*-

;;
;;; UI

;; Set font
(setq zenit-font (font-spec :family "PragmataPro Liga" :size 18 :weight 'regular)
      ;; zenit-font (font-spec :family "Iosevka Comfy" :size 18 :weight 'regular)
      zenit-serif-font "Iosevka Comfy Motion"
      zenit-variable-pitch-font "Iosevka Comfy Wide Duo")

;;; Set theme
(setq zenit-theme 'doom-one)
;; (setq zenit-theme 'modus-vivendi)


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

;; :checkers spell
(after! jinx
  (setq! jinx-languages "en_US de_DE"))

;; (remove-hook! 'python-mode-local-vars-hook #'tree-sitter!)
;; (remove-hook! 'python-mode-local-vars-hook #'tree-sitter!)
;; (after! lsp-mode
;;   (setq! lsp-disabled-clients '(python-mode . (ruff-lsp))))
