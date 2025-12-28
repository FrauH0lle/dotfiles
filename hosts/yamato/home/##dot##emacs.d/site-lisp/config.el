;; site-lisp/config.el -*- lexical-binding: t; -*-

;;
;;; UI

;;;; Set font

(setq zenit-font (font-spec :family "Aporetic Serif Mono" :size 18 :weight 'regular)
      ;; zenit-font (font-spec :family "Iosevka Comfy" :size 18 :weight 'regular)
      zenit-serif-font "Aporetic Serif"
      zenit-variable-pitch-font "Aporetic Sans")

;;;; Set theme

(setq zenit-theme 'doom-one)


;;
;;; Modules

;;;; :editor evil

;; Switch to the new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;;;; :emacs org

(setq org-directory "~/Projekte/org/")

;;;; :lang ess

;; Mark flycheck lintr settings as safe
(after! ess
  (put 'flycheck-lintr-linters 'safe-local-variable #'stringp))

;;;; :checkers grammar

(after! langtool
  (setq langtool-java-classpath
        "/usr/share/languagetool:/usr/share/java/languagetool/*"))

;;;; :checkers spell

(after! jinx
  (setq! jinx-languages "en_US de_DE"))

;;;; :tools gptel

(after! gptel
  ;; Set model for 'commit-summary preset
  (setf (alist-get 'commit-summary gptel--known-presets)
        (zenit-plist-merge '(:backend "GLM" :model 'glm-4.5-air) (alist-get 'commit-summary gptel--known-presets))))
