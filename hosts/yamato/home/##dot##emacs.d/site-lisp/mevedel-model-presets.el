;;; mevedel-model-presets.el --- Mevedel model teams -*- lexical-binding: t; -*-

;;; Commentary:

;; Model teams for mevedel, using the configured Codex and DeepSeek backends.

;;; Code:

;; Make struct setters available when the deferred body is macro-expanded.
(require 'gptel-request)

(after! mevedel

  (mevedel-define-preset mevedel-gpt6
    :description "GPT-6: Sol lead and workers, Astra review, Luna exploration"
    :parents (mevedel-implement)
    :backend "Codex"
    :model 'gpt-6.1-sol
    :reasoning-effort 'high
    :model-tiers
    ((fast :provider "Codex:gpt-6-luna" :effort xhigh)
     (balanced :provider "Codex:gpt-6.1-sol" :effort high)
     (strong :provider "Codex:gpt-6-astra" :effort high))
    :model-workloads
    ((planning :tier balanced :effort xhigh)
     (plan-implementation :tier balanced)
     (goal-review :tier balanced :effort xhigh)
     (worker :tier balanced)
     (explorer :tier fast)
     (verifier :tier balanced)
     (reviewer :tier strong)
     (naming :tier fast :effort none)
     (guardian :tier balanced :effort low)
     (buddy :tier balanced :effort medium)
     (journal :tier balanced :effort medium)
     (memory :tier balanced :effort medium)
     (summarization :tier balanced :effort medium)))

  (mevedel-define-preset mevedel-gpt6-deepseek
    :description "GPT-6 team with DeepSeek verification and journal"
    :parents (mevedel-gpt6)
    :model-workloads
    ((goal-review :provider "DeepSeek:deepseek-flash" :effort max)
     (verifier :provider "DeepSeek:deepseek-flash" :effort max)
     (journal :provider "DeepSeek:deepseek-flash" :effort high)))

  (setq mevedel-default-chat-preset 'implement)
  (setf (alist-get 'implement mevedel-action-preset-alist) 'mevedel-gpt6))

;;; mevedel-model-presets.el ends here
