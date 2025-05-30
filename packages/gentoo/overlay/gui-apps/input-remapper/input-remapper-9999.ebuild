# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..13} )
DISTUTILS_USE_PEP517="setuptools"

inherit distutils-r1 systemd git-r3

DESCRIPTION="A tool to change and program the mapping of your input device buttons"
HOMEPAGE="https://github.com/sezanzeb/input-remapper"
EGIT_REPO_URI="https://github.com/sezanzeb/input-remapper.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="x11-libs/gtk+:3
		 x11-apps/xmodmap
		 x11-libs/gtksourceview:4
		 $(python_gen_cond_dep '
			 dev-python/pygobject[${PYTHON_USEDEP}]
			 dev-python/pydbus[${PYTHON_USEDEP}]
			 dev-python/pydantic[${PYTHON_USEDEP}]
			 dev-python/evdev[${PYTHON_USEDEP}]
			 dev-python/setuptools[${PYTHON_USEDEP}]
		 ')"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	# lang_data:
	sed -i "s|f\"/usr/share/input-remapper/lang/|f\"share/input-remapper/lang/|g" setup.py

	# data_files:
	sed -i 's|("/usr/share/input-remapper/",|("share/input-remapper/",|g' setup.py
	sed -i 's|("/usr/share/applications/",|("share/applications/",|g' setup.py
	sed -i 's|"/usr/share/metainfo/",|"share/metainfo/",|g' setup.py
	sed -i 's|("/usr/share/icons/hicolor/scalable/apps/",|("share/icons/hicolor/scalable/apps/",|g' setup.py
	sed -i 's|("/usr/share/polkit-1/actions/",|("share/polkit-1/actions/",|g' setup.py
	sed -i 's|("/usr/lib/systemd/system",|("lib/systemd/system",|g' setup.py
	sed -i 's|("/usr/share/dbus-1/system.d/",|("share/dbus-1/system.d/",|g' setup.py
	sed -i 's|("/usr/lib/udev/rules.d",|("lib/udev/rules.d",|g' setup.py
	sed -i 's|("/usr/bin/",|("bin/",|g' setup.py

	# Remove /etc/xdg/autostart
	sed -i '/("\/etc\/xdg\/autostart\/", \["data\/input-remapper-autoload.desktop"\])/d' setup.py
}

src_install() {
	distutils-r1_src_install

	# Install the /etc file manually
	insinto /etc/xdg/autostart
	doins "${S}/data/input-remapper-autoload.desktop"

}
