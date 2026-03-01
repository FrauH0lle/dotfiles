;; ~/.emacs.d/site-lisp/packages.el -*- lexical-binding: t; -*-

;; The place for your local package declaration.

(package! mevedel
  :recipe (:host github :repo "FrauH0lle/mevedel" :files ("*.el") :protocol ssh)
  :lockfile local)
