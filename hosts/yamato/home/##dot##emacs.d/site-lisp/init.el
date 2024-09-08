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
 (ligatures +extra)
 modeline
 nav-flash
 popup
 (vc-gutter +pretty)
 workspaces
 ;; zen

 :checkers
 grammar
 spell
 syntax

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
 undo
 ;; org
 (org
  +dragndrop
  +jupyter
  ;; +pandoc
  +pretty
  +present)
 vc

 :tools
 (eval +overlay)
 (magit +forge)
 direnv
 editorconfig
 ;; pdf

 :os
 gentoo

 :lang
 ;; common-lisp
 data
 emacs-lisp
 (ess +lsp)
 ;; (latex
 ;;  +fold
 ;;  +latexmk)
 markdown
 (python +lsp +tree-sitter +pyright)
 (rust +lsp +tree-sitter)
 (sh +lsp +tree-sitter)

 :config
 (default +bindings +smartparens)
 ;; (:if (not init-file-debug) compile)
 compile
 )


