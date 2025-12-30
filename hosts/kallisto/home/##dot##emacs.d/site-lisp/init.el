;; site-lisp/init.el -*- lexical-binding: t; no-byte-compile: t; -*-

(modules!

 :completion
 vertico
 (corfu +icons)

 :ui
 doom-dashboard
 doom-theming
 hl-todo
 indent-guides
 modeline
 nav-flash
 popup
 transient-state
 vc-gutter
 workspaces
 ;; zen

 :checkers
 grammar
 spell
 syntax

 :editor
 evil
 format
 word-wrap
 multiple-cursors
 fold
 rotate-text
 file-templates
 snippets

 :emacs
 eshell
 ibuffer
 (org +pretty)
 tramp
 undo
 vc

 :os
 gentoo

 :tools
 eval
 llm
 lookup
 magit
 direnv
 editorconfig
 ;; pdf

 :lang
 data
 emacs-lisp
 (ess +lsp +tree-sitter)
 ;; (latex
 ;;  +fold
 ;;  +latexmk)
 markdown
 (python +pyright +tree-sitter)
 (rust +lsp +tree-sitter)
 (sh +lsp +tree-sitter)

 :config
 (default +bindings +smartparens)
 compile)
