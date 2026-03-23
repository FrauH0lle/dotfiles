;; site-lisp/init.el -*- lexical-binding: t; no-byte-compile: t; -*-

(modules!

 :completion
 vertico
 (corfu +icons)

 :ui
 dashboard
 doom-theming
 hl-todo
 indent-guides
 (ligatures +extra)
 modeline
 nav-flash
 popup
 transient-state
 (vc-gutter +pretty)
 workspaces
 ;; zen

 :checkers
 grammar
 spell
 syntax
 ;; (syntax +flymake)

 :editor
 evil
 file-templates
 fold
 (format +lsp)
 multiple-cursors
 rotate-text
 snippets
 word-wrap

 :emacs
 electric
 eshell
 ibuffer
 (org
  +dragndrop
  +jupyter
  ;; +pandoc
  +pretty
  +present)
 undo
 vc

 :tools
 (eval +overlay)
 magit
 debugger
 direnv
 editorconfig
 llm
 (lookup +dictionary +docsets)
 ;; (lsp +eglot +lsp-flymake)
 lsp
 ;; (lsp +lsp-flymake)
 ;; pdf

 :os
 arch-linux

 :lang
 ;; common-lisp
 (data +tree-sitter +lsp)
 emacs-lisp
 (ess +lsp +tree-sitter)
 ;; (latex
 ;;  +fold
 ;;  +latexmk)
 markdown
 (python +lsp +tree-sitter)
 (rust +lsp +tree-sitter)
 (sh +lsp +tree-sitter)

 :config
 (default +bindings +smartparens)
 ;; (:if (not init-file-debug) compile)
 compile
 )


