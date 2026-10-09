;; site-lisp/packages.local.el -*- lexical-binding: t; -*-

;; The place for your local package declaration.

(package! gptel
  :recipe (:local-repo "~/Projekte/gptel"
           ;; :build (:not compile)
           :host github
           :repo "FrauH0lle/gptel")
  :lockfile tools_llm)

(package! mevedel
  :recipe (:host github
           :repo "FrauH0lle/mevedel"
           :files ("*.el"
                   ("native" "native/*.c" "native/*.eld")
                   ("scripts" "scripts/mevedel-mcp-stdio.py")
                   "agents"
                   "prompts"
                   "skills"
                   ("shared-editing"
                    "shared-editing/host.bundle.mjs"
                    "shared-editing/resvg.wasm"
                    "shared-editing/font.ttf"
                    "shared-editing/Excalifont.ttf"
                    "shared-editing/Nunito.ttf"
                    "shared-editing/ComicShanns.ttf"
                    "shared-editing/builtin.excalidrawlib"
                    "shared-editing/FONT-LICENSE"
                    "shared-editing/RESVG-LICENSE"
                    "shared-editing/THIRD-PARTY-NOTICES.txt")
                   "docs/*.md"
                   "docs/adr/*.md"
                   "docs/agents/*.md"
                   "tools")
           :protocol ssh
           :local-repo "~/Projekte/mevedel"
           ;; :local-repo "~/Projekte/mevedel/.scratch/worktrees/claude-code-engine"
           ;; Uncomment to load mevedel from source: edits then take effect on
           ;; reload without a rebuild, at the cost of running interpreted.
           ;; :build (:not compile)
           )
  :lockfile tools_llm)
