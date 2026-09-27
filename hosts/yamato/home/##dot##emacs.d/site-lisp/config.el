;; site-lisp/config.el -*- lexical-binding: t; -*-

;;
;;; UI

;;;; Set font

(setq zenit-font (font-spec :family "Aporetic Serif Mono" :size 16 :weight 'regular)
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
        (zenit-plist-merge '(:backend "GLM" :model 'glm-4.5-air) (alist-get 'commit-summary gptel--known-presets)))

  (setq gptel-model 'deepseek-v4-flash
        gptel-backend (gptel-make-deepseek "DeepSeek"
                        :stream t
                        :key 'gptel-api-key)))

(after! mevedel
  (setq mevedel-collaboration-relay-url "wss://mevedel.skadonk.me"
        mevedel-collaboration-relay-host-token "cpQ65V7FGkiOVG8hagpM3YC6E5je2dqf")
  ;; KDE's notification server refuses a notification identical to the one
  ;; it accepted less than a second earlier, answering
  ;; `ExcessNotificationGeneration'.  Parallel tool calls with identical
  ;; arguments -- two `Glob' or `Grep' calls on the same path -- collide
  ;; that way, and `notifications-notify' reports the refusal with
  ;; `message', so it lands in *Messages* rather than being demoted by
  ;; mevedel.  The repeated bubble tells you nothing new, so skip an exact
  ;; repeat of the last body inside a window wider than the server's.
  (defvar my/mevedel-permission-notify-last nil
    "Cons of the last notification body sent and its `float-time'.")
  (setq mevedel-permission-notify-function
        (lambda (entry)
          (require 'notifications)
          (let* ((body (format "%s %s"
                               (or (plist-get entry :tool-name)
                                   (plist-get entry :kind))
                               (or (plist-get entry :command)
                                   (plist-get entry :expression)
                                   (plist-get entry :specifier-value)
                                   "")))
                 (now (float-time))
                 (last my/mevedel-permission-notify-last))
            (unless (and last
                         (equal (car last) body)
                         (< (- now (cdr last)) 1.5))
              (setq my/mevedel-permission-notify-last (cons body now))
              (notifications-notify
               :title "mevedel needs permission"
               :body body))))))

;; Projectile advises `delete-file' to prune its cache, and the advice calls
;; `projectile-project-root', which resolves a truename.  On a remote file
;; that is a TRAMP round trip -- and `delete-file' is reached from process
;; filters that run inside `tramp-accept-process-output', i.e. from the wait
;; loop of a command already in flight.  The nested command then takes the
;; reply the outer one was waiting for, and TRAMP busy-waits forever for a
;; prompt that has already gone elsewhere.
;;
;; Skip the cache update only in that window.  A delete outside a TRAMP
;; operation still maintains the cache as before; one during it leaves that
;; entry stale until the next `projectile-invalidate-cache'.
;;
;; The test is the transport, never whether FILENAME looks remote.  The file
;; deleted from a filter is usually a local temp file -- it is projectile's
;; *project root* that is remote, so `projectile-project-root' resolves a
;; truename on the target no matter how FILENAME is spelled.
(after! projectile
  (define-advice delete-file-projectile-remove-from-cache
      (:around (fn filename &optional trash) skip-inside-remote-operation)
    (if (and (bound-and-true-p mevedel-transport--depth)
             (> mevedel-transport--depth 0))
        nil
      (funcall fn filename trash))))


;; Keep model presets separate from the personal configuration.
(load (expand-file-name
       "mevedel-model-presets.el"
       (file-name-directory (file-truename (or load-file-name buffer-file-name))))
      nil t)
