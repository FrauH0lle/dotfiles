;;; mevedel-model-presets.el --- Mevedel model teams -*- lexical-binding: t; -*-

;;; Commentary:

;; Model teams for mevedel, using the configured Codex and DeepSeek backends
;; and mevedel's Claude Code subscription backend.

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

  ;; Mirrors `mevedel-gpt6' on the Claude Code subscription.  The aliases
  ;; resolve to Opus/Sonnet/Haiku 5.5 (Haiku 5.5 needs CLI 2.1.293+).
  ;; Artificial Analysis Intelligence Index v4.3.2 (score / USD per evaluation
  ;; task): Opus 5.5 medium 51 / 1.34, high 54 / 1.82; Sonnet 5.5 high
  ;; 47 / 0.88; Haiku 5.5 medium 34 / 0.05.  mevedel's alias table declares no
  ;; efforts for `haiku' until ACP reports them, so the fast tier uses the
  ;; model default, which is `medium' on Haiku 5.5.
  ;; Claude Code models are uninterned backend-owned symbols, so resolve the
  ;; root model object instead of naming it with a literal symbol.
  (mevedel-define-preset mevedel-claude55
    :description "Claude Code: Opus lead, Sonnet workers, Haiku exploration"
    :parents (mevedel-implement)
    :backend "Claude Code"
    :model (plist-get (mevedel-model-resolve-provider "Claude Code:opus") :model)
    :reasoning-effort 'medium
    :model-tiers
    ((fast :provider "Claude Code:haiku" :effort nil)
     (balanced :provider "Claude Code:sonnet" :effort high)
     (strong :provider "Claude Code:opus" :effort high))
    :model-workloads
    ((planning :tier strong)
     (plan-implementation :tier balanced)
     (goal-review :tier strong)
     (worker :tier balanced)
     (explorer :tier fast)
     (verifier :tier balanced)
     (reviewer :tier strong)
     (naming :tier fast)
     (guardian :tier balanced :effort low)
     (buddy :tier balanced :effort medium)
     (journal :tier strong :effort low)
     (memory :tier balanced :effort medium)
     (summarization :tier balanced :effort medium)))

  (setq mevedel-default-chat-preset 'implement)
  (setf (alist-get 'implement mevedel-action-preset-alist) 'mevedel-gpt6))

;;; mevedel-model-presets.el ends here
