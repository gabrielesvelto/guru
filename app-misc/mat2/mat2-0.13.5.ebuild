# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="xml(+)"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature verify-sig

DESCRIPTION="Metadata Anonymisation Toolkit: handy tool to trash your metadata"
HOMEPAGE="https://0xacab.org/jvoisin/mat2"
SIG_UPLOAD_HASH="060efa77668fa7f6d9baeb8a327857af"
SRC_URI="
	https://0xacab.org/jvoisin/${PN}/-/archive/${PV}/${P}.tar.gz
	verify-sig? ( https://0xacab.org/-/project/1139/uploads/${SIG_UPLOAD_HASH}/${P}.tar.gz.asc )
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-text/poppler[introspection,cairo]
	dev-libs/glib:2
	dev-python/pycairo:0[${PYTHON_USEDEP}]
	dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	gnome-base/librsvg[introspection]
	media-libs/mutagen:0[${PYTHON_USEDEP}]
	x11-libs/gdk-pixbuf:2[introspection,jpeg,tiff]
"
BDEPEND="
	verify-sig? ( >sec-keys/openpgp-keys-jvoisin-20200714 )
	test? (
		media-libs/exiftool:*
		media-video/ffmpeg[lame,vorbis]
	)
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/jvoisin.asc

DOCS=( doc {CHANGELOG,CONTRIBUTING,INSTALL,README}.md )

distutils_enable_tests unittest

src_prepare() {
	sed -i '/data_files/d' setup.py || die
	distutils-r1_src_prepare
}

src_test() {
	if has_version -b sys-apps/bubblewrap; then
		# Double sandboxing is not possible
		has usersandbox ${FEATURES} && return 0
	fi

	distutils-r1_src_test
}

src_install() {
	distutils-r1_src_install
	doman doc/mat2.1
}

pkg_postinst() {
	optfeature "misc file format support" media-libs/exiftool
	optfeature "sandboxing" sys-apps/bubblewrap
	optfeature "video support" media-video/ffmpeg
}
