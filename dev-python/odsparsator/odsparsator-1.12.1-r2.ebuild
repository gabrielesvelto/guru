# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

DESCRIPTION="Generate a JSON file from an OpenDocument Format .ods file."
HOMEPAGE="
	https://github.com/jdum/odsparsator
	https://pypi.org/project/odsparsator/
"
SRC_URI="https://github.com/jdum/odsparsator/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/odfdo[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
