;; site-lisp/config.local.el -*- lexical-binding: t; -*-

;; Host-specific configuration for kallisto.

;;
;;; UI

(setq zenit-font (font-spec :family "Aporetic Serif Mono" :size 16 :weight 'regular)
      zenit-variable-pitch-font (font-spec :family "Aporetic Serif"))

;; (setq zenit-theme 'doom-one)
(setq zenit-theme 'modus-operandi)

;;
;;; LLM

(after! gptel
  (setq gptel-model 'gpt-6.1-sol
        gptel-backend +gptel-codex-backend))
