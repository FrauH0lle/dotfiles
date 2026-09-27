;;; mevedel-model-presets.el --- Mevedel model teams -*- lexical-binding: t; -*-

;;; Commentary:

;; Model teams for mevedel, using the configured Codex and DeepSeek backends.

;;; Code:

;; Make struct setters available when the deferred body is macro-expanded.
(require 'gptel-request)

(after! mevedel
  ;; Extend the existing OAuth backend, preserving its authentication headers.
  ;; Keep the same conservative context budget as the configured Codex models.
  (let ((backend (gptel-get-backend "Codex")))
    (dolist (model
             (gptel--process-models
              '((gpt-6-sol
                 :description "GPT-6 model for coding and agentic workflows"
                 :capabilities (media tool-use json url responses-api)
                 :reasoning-effort (member none low medium high xhigh max)
                 :mime-types ("image/jpeg" "image/png" "image/gif" "image/webp")
                 :context-window 258
                 :input-cost 2
                 :output-cost 10
                 :cutoff-date "2026-04")
                (gpt-6-luna
                 :description "Efficient GPT-6 model for focused tasks"
                 :capabilities (media tool-use json url responses-api)
                 :reasoning-effort (member none low medium high xhigh max)
                 :mime-types ("image/jpeg" "image/png" "image/gif" "image/webp")
                 :context-window 258
                 :input-cost 0.1
                 :output-cost 0.5
                 :cutoff-date "2026-05"))))
      (cl-pushnew model (gptel-backend-models backend))))

  (mevedel-define-preset mevedel-gpt6
    :description "GPT-6: Astra lead, Sol workers, Luna exploration"
    :parents (mevedel-implement)
    :backend "Codex"
    :model 'gpt-6-astra
    :reasoning-effort 'medium
    :model-tiers
    ((fast :provider "Codex:gpt-6-luna" :effort medium)
     (balanced :provider "Codex:gpt-6-sol" :effort high)
     (strong :provider "Codex:gpt-6-astra" :effort high))
    :model-workloads
    ((planning :tier strong)
     (plan-implementation :tier balanced)
     (goal-review :tier strong)
     (worker :tier balanced)
     (explorer :tier fast)
     (verifier :tier balanced)
     (reviewer :tier strong)
     (naming :tier fast :effort none)
     (guardian :tier balanced :effort low)
     (buddy :tier balanced :effort medium)
     (journal :tier strong :effort low)
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
