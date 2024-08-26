EAPI=8

DESCRIPTION="editors/emacs module meta package."
HOMEPAGE="https://gitlab.com/DonHugo/dotfiles"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# Emacs
# XXX 2024-07-25: For now, we pin the version to 29.3
RDEPEND="
	=app-editors/emacs-29.3*
"
# Faster greping
RDEPEND="
	${RDEPEND}
	sys-apps/ripgrep
"
# Faster projectile indexing
RDEPEND="
	${RDEPEND}
	sys-apps/fd
"
# Copy to clipboard
RDEPEND="
	${RDEPEND}
	x11-misc/xclip
"

# Module dependencies
# :lang latex & :emacs org
RDEPEND="
	${RDEPEND}
	app-text/texlive
"

# :tools editorconfig
RDEPEND="
	${RDEPEND}
	app-text/editorconfig-core-c
"

# :tools pdf-tools
RDEPEND="
	${RDEPEND}
	app-text/poppler
"
