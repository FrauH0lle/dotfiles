;; ~/.emacs.d/site-lisp/packages.el -*- lexical-binding: t; -*-

;; The place for your local package declaration.

(package! gptel
  :recipe (:local-repo "~/Projekte/gptel"
           ;; :build (:not compile)
           )
  :lockfile tools_llm)

(package! mevedel
  :recipe (:host github
           :repo "FrauH0lle/mevedel"
           :files ("*.el")
           :protocol ssh
           :local-repo "~/Projekte/mevedel"
           :build (:not compile)
           )
  :lockfile tools_llm)
