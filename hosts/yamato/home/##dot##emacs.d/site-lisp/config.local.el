;; site-lisp/config.local.el -*- lexical-binding: t; -*-

;; Host-specific configuration for yamato.

;;
;;; UI

(setq zenit-font (font-spec :family "Aporetic Serif Mono" :size 16 :weight 'regular)
      ;; zenit-font (font-spec :family "Iosevka Comfy" :size 18 :weight 'regular)
      zenit-serif-font "Aporetic Serif"
      zenit-variable-pitch-font "Aporetic Sans")

(setq zenit-theme 'doom-one)

;;
;;; LLM

(after! gptel
  (setq gptel-model 'gpt-6.1-sol
        gptel-backend +gptel-codex-backend))
